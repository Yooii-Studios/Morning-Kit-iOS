//
//  SKImageCroppingProecessor.h
//  SKPhotoPicker
//
//  Created by 김우성 on 13. 4. 9..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKPhotoCropFrameView;
@class SKPhotoScaleView;

// Model - get cropped image from views
@interface SKImageCroppingProecessor : NSObject

+ (UIImage *)getCroppedImageFromPhotoCropFrameView:(SKPhotoCropFrameView *)photoCropFrameView withPhotoScaleView:(SKPhotoScaleView *)photoScaleView;

@end
