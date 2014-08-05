//
//  SKPhotoCropFrameView.m
//  SKPhotoPicker
//
//  Created by 김우성 on 13. 4. 6..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import "SKPhotoCropFrameView.h"

@implementation SKPhotoCropFrameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - crop rect methods

- (void)drawCropRect:(SKPhotoCropOrientation)photoCropOrientation {
    
//    NSLog(@"drawCropRect");
    
    // get cropRect
    self.cropRect = [SKPhotoCropFrameView getCropRectFromOrientation:photoCropOrientation];
    
    // draw frame with cropSize
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setFill];
    UIRectFill(self.bounds);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.7f].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextStrokeRect(context, self.cropRect);
    [[UIColor clearColor] setFill];
    UIRectFill(CGRectInset(self.cropRect, 1, 1));
}

+ (CGRect)getCropRectFromOrientation:(SKPhotoCropOrientation)photoCropOrientation {
    // check Crop orientation
    CGSize cropSize;
    CGRect fullscreenRect = [[UIScreen mainScreen] bounds]; // iPhone width:320 / height: 480
    
//    NSLog(@"fullscreenRect: %@", NSStringFromCGRect(fullscreenRect));
    
    // get Crop Size from mode //
    if (photoCropOrientation == SKPhotoCropOrientationPortrait) {
        // picture for portrait mode
        cropSize = fullscreenRect.size;
    }else{
        // picture for landscape mode
        CGFloat deviceWidth = fullscreenRect.size.width;
        CGFloat deviceHeight = fullscreenRect.size.height;
        
        // set width into height, height into width
        cropSize = CGSizeMake(deviceHeight, deviceWidth);
    }
    
    // check statusBarHidden state and adjust size
    BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    if (statusBarHidden == NO) {
        CGFloat statusBarHeight = 20;
        cropSize.height -= statusBarHeight;
    }
    
//    NSLog(@"original cropSize width: %f, height: %f", cropSize.width, cropSize.height);
    
    // in iOS 7, status bar height has to be considered for calculating height or width via ratio.
    // only for under iOS 7.0
    CGFloat statusBarOffset = 0;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        statusBarOffset = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    // transform cropSize to Device
    if (photoCropOrientation == SKPhotoCropOrientationPortrait) {
//        NSLog(@"%f", statusBarOffset);
        
        // 44 = toolBar height, no toolBar in iPad version
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            CGFloat ratio = (cropSize.height - 44) / (cropSize.height + statusBarOffset);
            //        NSLog(@"%f", ratio);
            cropSize.width *= ratio;
            cropSize.height -= 44;
        }else{
            CGFloat ratio = (cropSize.height + statusBarOffset) / cropSize.width;
            cropSize.width = 320;
            cropSize.height = cropSize.width * ratio;
        }
    }else{
        CGFloat ratio = (cropSize.height + statusBarOffset) / cropSize.width;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            //        NSLog(@"%f", ratio);
            cropSize.width = fullscreenRect.size.width;
            cropSize.height = cropSize.width * ratio;
        }else{
            // view frame width is 320, height is 480
            cropSize.width = 320;
            cropSize.height = cropSize.width * ratio;
        }
    }
    
//    NSLog(@"transformed cropSize width: %f, height: %f", cropSize.width, cropSize.height);
    
    // get X and Y which draw this rect to center of the view
    CGRect cropRect;
    CGFloat x = 0;
    CGFloat y = 0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (photoCropOrientation == SKPhotoCropOrientationPortrait) {
            x = (fullscreenRect.size.width / 2) - (cropSize.width / 2);
            y = 20;
        }else{
            y = ((fullscreenRect.size.height - 44) / 2) - (cropSize.height / 2);
        }
    }else{
        if (photoCropOrientation == SKPhotoCropOrientationPortrait) {
            y = (443 / 2) - (cropSize.height / 2);
        }else{
            y = (443 / 2) - (cropSize.height / 2);
        }
    }
    
    cropRect = CGRectMake(x, y, cropSize.width, cropSize.height);
//    NSLog(@"cropRect: %@", NSStringFromCGRect(cropRect));
    return cropRect;
}

- (void)drawRect:(CGRect)rect {
//    NSLog(@"drawRect");
    
//    NSLog(@"view frame: %@", NSStringFromCGRect(self.frame));
    [self drawCropRect:self.photoCropOrientation];
}


#pragma mark - hit test

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
//    NSLog(@"%@ hitTest", [self class]);
    return nil;
}

@end
