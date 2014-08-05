//
//  MNFlickrImageProcessor.h
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 9..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNFlickrImageProcessor : NSObject

// 회전시 바로 사진을 자르는 로직을 연구
+ (UIImage *)getCroppedImageFromOriginalImage:(UIImage *)originalImage withFrame:(CGRect)frame;

+ (UIImage *)getGrayscaledImageFromOriginalImage:(UIImage *)originalImage;

@end
