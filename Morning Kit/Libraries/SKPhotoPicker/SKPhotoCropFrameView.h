//
//  SKPhotoCropFrameView.h
//  SKPhotoPicker
//
//  Created by 김우성 on 13. 4. 6..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SKPhotoCropOrientation) {
    SKPhotoCropOrientationPortrait = 0,
    SKPhotoCropOrientationLandscape,
};

// View - indicating crop zone
@interface SKPhotoCropFrameView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic) SKPhotoCropOrientation photoCropOrientation;
@property (nonatomic) CGRect cropRect;

- (void)drawCropRect:(SKPhotoCropOrientation)photoCropOrientation;
+ (CGRect)getCropRectFromOrientation:(SKPhotoCropOrientation)photoCropOrientation;

@end
