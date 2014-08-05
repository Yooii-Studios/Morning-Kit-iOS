//
//  SKMirrorSceneryView.h
//  SKMirrorScenery
//
//  Created by 김우성 on 13. 4. 16..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

// you need QuartzCore, CoreImage, AVFoundation, CoreGraphics

@interface SKMirrorSceneryView : UIView

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic) BOOL isUsingFrontFacingCamera;
@property (nonatomic) CGFloat effectiveScale;

- (void)initializeAfterViewDidLoad;
- (void)destroyView;
- (void)switchCameraOrientation;
//- (void)viewWillRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation withParentView:(UIView *)parentView;
- (void)adjustViewFrameWithOrientation:(UIInterfaceOrientation)toInterfaceOrientation withParentView:(UIView *)parentView;
- (void)adjustLayerFrame;

@end
