//
//  MNHalfRoundedRectMaker.m
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 17..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNHalfRoundedRectMaker.h"
#import <QuartzCore/QuartzCore.h>
#import "MNTheme.h"
#import "MNDefinitions.h"

@implementation MNHalfRoundedRectMaker

// 소스는 http://stackoverflow.com/questions/4847163/round-two-corners-in-uiview 이곳에서 퍼옴.
+ (UIView *)makeUpperHalfRoundedView:(UIView *)view {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;

    UIBezierPath *roundedPath =
    [UIBezierPath bezierPathWithRoundedRect:maskLayer.bounds
                          byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                cornerRadii:CGSizeMake(ROUNDED_CORNER_RADIUS, ROUNDED_CORNER_RADIUS)];
    
    switch ([MNTheme getCurrentlySelectedTheme]) {
        case MNThemeTypeSkyBlue:
            maskLayer.fillColor = [[UIColor blackColor] CGColor];
            view.backgroundColor = UIColorFromHexCodeWithAlpha(0x043f4b, 0.9f);
            break;
            
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeClassicGray:
        case MNThemeTypeClassicWhite:
        case MNThemeTypeWaterLily:
            maskLayer.fillColor = RGBA(0, 0, 0, 0.8).CGColor;
            
        default:
            view.backgroundColor = [UIColor blackColor];
            break;
    }

    
//    maskLayer.backgroundColor = [[UIColor clearColor] CGColor];
    maskLayer.path = [roundedPath CGPath];
    
//    maskLayer.masksToBounds = NO;
    
    //Don't add masks to layers already in the hierarchy!
    UIView *superview = [view superview];
    [view removeFromSuperview];
    view.layer.mask = maskLayer;
    [superview addSubview:view];
    
    return view;
}

@end
