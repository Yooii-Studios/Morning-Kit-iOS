//
//  SKMirrorSceneryView.m
//  SKMirrorScenery
//
//  Created by 김우성 on 13. 4. 16..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import "SKMirrorSceneryView.h"
#import <AssertMacros.h>

@implementation SKMirrorSceneryView

#define TRANSFORM_SCALE_IPHONE5 1.05
#define TRANSFORM_SCALE_IPHONE_3_5_Inch 1.1
#define TRANSFORM_SCALE_IPHONE_3_5_Inch_Landscape 1.13

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// invoked when initiated from storyboard
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initializeAfterViewDidLoad {
    // Do any additional setup after loading the view.
    //    self.isUsingFrontFacingCamera = YES;
    
    // check the device is `iPad 1` because there is no camera on it.
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
//        NSLog(@"There're cameras on this device");
        
        // If there is a one, initialize previewView - dispatch queue 취소
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        self.backgroundColor = [UIColor blueColor];
        [self setupAVCapture];
        //        });
        
    }else{
//        NSLog(@"There is no camera on this device");
        [self setBackgroundColor:[UIColor blackColor]];
    }
}

- (void)destroyView {
    [self teardownAVCapture];
}


#pragma mark - AVCaptureSession

// source codes from Apple Project SquareCam
- (void)setupAVCapture {
    
    // check whether it's iphone 5 to adjust scale
    self.effectiveScale = 1.0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.effectiveScale = 1.1;
    }
    
    AVCaptureSession *session = [AVCaptureSession new];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGRect bounds = [[UIScreen mainScreen] bounds];
        if (scale == 2.0f) {
            // Retina
            if (bounds.size.height == 480) {
                // iPhone 4 (960 -> 480)
//                NSLog(@"iPhone 4");
                [session setSessionPreset:AVCaptureSessionPreset640x480];
                self.effectiveScale = TRANSFORM_SCALE_IPHONE_3_5_Inch;
            }else{
                // iPhone 5 (1136 -> 568)
//                NSLog(@"iPhone 5");
                // I think the way adjusting effectiveScale and setAffineTransform, but I just set presetHigh
                [session setSessionPreset:AVCaptureSessionPresetHigh];
                //                [session setSessionPreset:AVCaptureSessionPreset640x480];
                //                [session setSessionPreset:AVCaptureSessionPreset1280x720];
                //                [session setSessionPreset:AVCaptureSessionPresetPhoto];
                
                self.effectiveScale = TRANSFORM_SCALE_IPHONE5;
            }
        }else{
//            NSLog(@"non retina, maybe iPhone 3GS");
            // 3GS can't use AVCaptureSessionPreset640x480 resolusion, AVCaptureSessionPresetPhoto is that auto resulusion provided.
            [session setSessionPreset:AVCaptureSessionPresetPhoto];
            self.effectiveScale = TRANSFORM_SCALE_IPHONE_3_5_Inch;
        }
    }else{
//        NSLog(@"iPad series");
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    
    //    rootLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    // Select a video device, make an input
    NSError *error = nil;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    //	require( error == nil, bail ); // 에러 체크 goto 문 일단 삭제 - dispatch 기능 확인 위해
    
    if ( [session canAddInput:deviceInput] )
        [session addInput:deviceInput];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [self.previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    //    self.previewLayer.backgroundColor = [UIColor redColor].CGColor;
    
    // 이 부분은 필수적으로 메인 큐에서 돌려야 제대로 보임 - 속도 향상을 위해 여기만 메인 큐에서 처리하게 구현
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //    });
    
    // 메인 큐에서 돌리던 부분
    ////////////////////
    CALayer *rootLayer;
    rootLayer = [self layer];
    //    rootLayer.frame = self.bounds;
    //    rootLayer.backgroundColor = [UIColor redColor].CGColor;
    [rootLayer setMasksToBounds:YES];
    [self.previewLayer setFrame:rootLayer.bounds];
    [rootLayer addSublayer:self.previewLayer];
    ////////////////////
    
    
    [session startRunning];
    
    // set scale of PreviewLayer, this is especially useful to iPhone 5
    [self setPreviewLayerAffineTransformToScale:self.effectiveScale];
    
    // initially set to front position
    if (self.isUsingFrontFacingCamera) {
        [self changeCameraOrientationToPosition:AVCaptureDevicePositionFront];
    }else{
        [self changeCameraOrientationToPosition:AVCaptureDevicePositionBack];
    }
    
    
    //    self.isUsingFrontFacingCamera = YES;
    
    // into
bail:
    session = nil;
	if (error) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
															message:[error localizedDescription]
														   delegate:nil
												  cancelButtonTitle:@"Dismiss"
												  otherButtonTitles:nil];
		[alertView show];
		[self teardownAVCapture];
	}
}

- (void)adjustLayerFrame {
    if (self.previewLayer) {
        CALayer *rootLayer;
        rootLayer = [self layer];
        //    rootLayer.frame = self.bounds;
        self.frame = self.superview.frame;
        self.layer.frame = self.frame;
//        rootLayer.backgroundColor = [UIColor redColor].CGColor;
        [self.previewLayer setFrame:rootLayer.frame];
        
        // set scale of PreviewLayer, this is especially useful to iPhone 5
        [self setPreviewLayerAffineTransformToScale:self.effectiveScale];
        
        [self layoutSubviews];
    }
}

// clean up capture setup
- (void)teardownAVCapture
{
	[self.previewLayer removeFromSuperlayer];
    self.previewLayer = nil;
}

- (void)setPreviewLayerAffineTransformToScale:(CGFloat)scale {
    self.effectiveScale = scale;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
    [CATransaction commit];
}


#pragma mark - switch camera

- (void)switchCameraOrientation {
    AVCaptureDevicePosition desiredPosition;
    
    // switch position
    if (self.isUsingFrontFacingCamera) {
        desiredPosition = AVCaptureDevicePositionBack;
    }else{
        desiredPosition = AVCaptureDevicePositionFront;
    }
    
    // reset AVCapture
    [self changeCameraOrientationToPosition:desiredPosition];
    self.isUsingFrontFacingCamera = !self.isUsingFrontFacingCamera;
}

- (void)changeCameraOrientationToPosition:(AVCaptureDevicePosition)desiredPosition {
    // check available cameras on device
    for (AVCaptureDevice *captureDevice in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        // check if there is a camera on desiredPosition
		if ([captureDevice position] == desiredPosition) {
            // switch camera if there is one
			[[self.previewLayer session] beginConfiguration];
			AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
			for (AVCaptureInput *oldInput in [[self.previewLayer session] inputs]) {
				[[self.previewLayer session] removeInput:oldInput];
			}
			[[self.previewLayer session] addInput:input];
			[[self.previewLayer session] commitConfiguration];
			break;
		}
	}
}

#pragma mark - rotation

- (void)layoutSubviews {
    //    NSLog(@"SKMirrorSceneryView layoutSubviews");
    
    //    NSLog(@"%d", [UIApplication sharedApplication].statusBarOrientation);
    //    [self viewWillRotateToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation withParentView:[self superview]];
    [self adjustViewFrameWithOrientation:[UIApplication sharedApplication].statusBarOrientation withParentView:[self superview]];
    
    // width, height는 건들지 않더라도 적어도 layer의 중앙을 self.bounds의 중앙으로는 맞추어 주자.
    CGRect newLayerFrame = self.previewLayer.frame;
    newLayerFrame.origin.x = (self.bounds.size.width - newLayerFrame.size.width) / 2;
    newLayerFrame.origin.y = (self.bounds.size.height - newLayerFrame.size.height) / 2;
    //    NSLog(@"superview frame: %@", NSStringFromCGRect([self superview].frame));
    //    NSLog(@"previous previewLayer: %@", NSStringFromCGRect(self.previewLayer.frame));
    //    NSLog(@"new previewLayer: %@", NSStringFromCGRect(self.previewLayer.frame));
    
    self.previewLayer.bounds = newLayerFrame;
    
    
    //    NSLog(@"view frame: %@", NSStringFromCGRect(self.frame));
    //    NSLog(@"%@", NSStringFromCGRect(self.previewLayer.frame));
    //    NSLog(@"new previewLayer: %@", NSStringFromCGRect(self.previewLayer.frame));
    
    // 0이 Portrait
    //    NSLog(@"orientation: %d", [UIApplication sharedApplication].statusBarOrientation);
}

- (void)adjustViewFrameWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation withParentView:(UIView *)parentView {
    
    //    self.frame = parentView.frame;
    //    self.layer.frame = parentView.frame;
    
    //    NSLog(@"rootLayer.bounds:%@", NSStringFromCGRect(rootLayer.bounds));
    //    NSLog(@"rootLayer.frame:%@", NSStringFromCGRect(rootLayer.frame));
    //    NSLog(@"self.bounds:%@", NSStringFromCGRect(self.bounds));
    //    NSLog(@"self.frame:%@", NSStringFromCGRect(self.frame));
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        //        NSLog(@"UIInterfaceOrientationPortrait");
        CGFloat transformScale = 1;
        self.transform = CGAffineTransformMakeRotation(0);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            // Phone
            CGFloat scale = [[UIScreen mainScreen] scale];
            CGRect bounds = [[UIScreen mainScreen] bounds];
            transformScale = TRANSFORM_SCALE_IPHONE_3_5_Inch;
            if (scale == 2.0f) {
                // Retina
                if (bounds.size.height != 480) {
                    // iPhone 5
                    transformScale = TRANSFORM_SCALE_IPHONE5;
                }
            }
        }else{
            // Pad
            transformScale = 1.1;
        }
        [self setPreviewLayerAffineTransformToScale:transformScale];
    } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        //        NSLog(@"UIInterfaceOrientationLandscapeLeft");
        self.transform = CGAffineTransformMakeRotation(M_PI/2);
        CGFloat transformScale = 1.1;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            // Phone
            //            CGFloat scale = [[UIScreen mainScreen] scale];
            CGRect bounds = [[UIScreen mainScreen] bounds];
            
            if (bounds.size.height == 480) {
                // 3.5inch
                transformScale = TRANSFORM_SCALE_IPHONE_3_5_Inch_Landscape;
            }
        }
        [self setPreviewLayerAffineTransformToScale:transformScale];
        
    } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        //        NSLog(@"UIInterfaceOrientationLandscapeRight");
        self.transform = CGAffineTransformMakeRotation(-M_PI/2);
        CGFloat transformScale = 1.1;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            // Phone
            //            CGFloat scale = [[UIScreen mainScreen] scale];
            CGRect bounds = [[UIScreen mainScreen] bounds];
            if (bounds.size.height == 480) {
                // 3.5inch
                transformScale = TRANSFORM_SCALE_IPHONE_3_5_Inch_Landscape;
            }
        }
        [self setPreviewLayerAffineTransformToScale:transformScale];
        
    } else {
        CGFloat transformScale = 1;
        self.transform = CGAffineTransformMakeRotation(M_PI);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            // Phone
            CGFloat scale = [[UIScreen mainScreen] scale];
            CGRect bounds = [[UIScreen mainScreen] bounds];
            transformScale = TRANSFORM_SCALE_IPHONE_3_5_Inch;
            if (scale == 2.0f) {
                // Retina
                if (bounds.size.height != 480) {
                    // iPhone 5
                    transformScale = TRANSFORM_SCALE_IPHONE5;
                }
            }
        }else{
            // Pad
            transformScale = 1.1;
        }
        [self setPreviewLayerAffineTransformToScale:transformScale];
    }
    
    self.frame = parentView.bounds;
    //    self.layer.frame = parentView.bounds;
    //    self.previewLayer.frame = parentView.bounds;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
