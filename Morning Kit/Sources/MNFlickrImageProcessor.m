//
//  MNFlickrImageProcessor.m
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 9..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNFlickrImageProcessor.h"

#pragma mark - UIImage Crop Category

@implementation UIImage (Crop)

- (UIImage *)crop:(CGRect)rect {
    
    rect = CGRectMake(rect.origin.x*self.scale,
                      rect.origin.y*self.scale,
                      rect.size.width*self.scale,
                      rect.size.height*self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:self.scale
                                    orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

@end

 
#pragma mark - MNFlickrImageProcessor

@implementation MNFlickrImageProcessor

+ (UIImage *)getCroppedImageFromOriginalImage:(UIImage *)originalImage withFrame:(CGRect)frame {
    UIImage *croppedImage = originalImage;

    CGFloat frameRatio = frame.size.width / frame.size.height;
    
    if (originalImage.size.width >= originalImage.size.height) {
        // 이미지의 가로가 세로보다 같거나 김
//        NSLog(@"image width >= image height");
        
        // frame.width : Image.width (a)와 frame.height : Image.height (b)를 비교
        CGFloat ratioOfWidth;
        if (frame.size.width > originalImage.size.width) {
            ratioOfWidth = originalImage.size.width / frame.size.width;
        }else{
            ratioOfWidth = frame.size.width / originalImage.size.width;
        }

        CGFloat ratioOfHeight;
        if (frame.size.height > originalImage.size.height) {
            ratioOfHeight = originalImage.size.height / frame.size.height;
        }else{
            ratioOfHeight = frame.size.height / originalImage.size.height;
        }
        
        // (a)와 (b)중 작은 쪽으로 이미지를 줄인다
        if (ratioOfWidth < ratioOfHeight) {
//            NSLog(@"ratioOfWidth < ratioOfHeight");
            // (a)가 작다면 Image의 height는 frame.height, width는 frame.height * ratio
            CGSize newImageSize = CGSizeMake(originalImage.size.height*frameRatio, originalImage.size.height);
            
//            NSLog(@"ratioOfWidth: %f", ratioOfWidth);
//            NSLog(@"originalSize: %@", NSStringFromCGSize(originalImage.size));
//            NSLog(@"newImageSize: %@", NSStringFromCGSize(newImageSize));
//            NSLog(@"frameSize: %@", NSStringFromCGSize(frame.size));
            
            // 자를 위치는 Image.width/2 - frame.width/2 에서 frame.width 만큼 자름
//            UIGraphicsBeginImageContext(frame.size);
//            [originalImage drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height)];
//            croppedImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
            croppedImage = [originalImage crop:CGRectMake(originalImage.size.width/2 - newImageSize.width/2, 0, newImageSize.width, newImageSize.height)];
        }else{
//            NSLog(@"ratioOfWidth >= ratioOfHeight");
            // (b)가 작다면 Image의 width는 frame.width, height는 frame.width / ratio
            CGSize newImageSize = CGSizeMake(originalImage.size.width, originalImage.size.width/frameRatio);
            
//            NSLog(@"ratioOfHeight: %f", ratioOfHeight);
//            NSLog(@"originalSize: %@", NSStringFromCGSize(originalImage.size));
//            NSLog(@"newImageSize: %@", NSStringFromCGSize(newImageSize));
//            NSLog(@"frameSize: %@", NSStringFromCGSize(frame.size));
            
            // 자를 위치는 Image.height/2 - frame.height/2 에서 frame.height 만큼 자름
//            UIGraphicsBeginImageContext(frame.size);
//            [originalImage drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height)];
//            croppedImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
            croppedImage = [originalImage crop:CGRectMake(0, originalImage.size.height/2 - newImageSize.height/2, newImageSize.width, newImageSize.height)];
        }
    }else{
        // 이미지의 가로가 세로보다 짧음
//        NSLog(@"image width < image height");
        
        // 이미지 조절. 새 이미지의 width는 frame 의 width로, 이미지와 frame width의 비율만큼 이미지 height 를 조절해서 이미지를 resize한다.
//        CGFloat ratioBetweenImageAndFrame = frame.size.width / originalImage.size.width;
        CGSize newImageSize = CGSizeMake(originalImage.size.width, originalImage.size.width / frameRatio);
        
//        NSLog(@"ratio: %f", ratioBetweenImageAndFrame);
//        NSLog(@"originalImageSize: %@", NSStringFromCGSize(originalImage.size));
//        NSLog(@"frameSize: %@", NSStringFromCGSize(frame.size));
//        NSLog(@"newImageSize: %@", NSStringFromCGSize(newImageSize));
        
        // resize된 이미지에서 최상단을 잘라서 이미지를 제작
//        UIGraphicsBeginImageContext(newImageSize);
//        [originalImage drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height)];
//        croppedImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();

        // 위에서 15% 아래에서 부터 자름
        CGFloat offset_15percent_from_top = newImageSize.height * 0.15;
        croppedImage = [originalImage crop:CGRectMake(0, offset_15percent_from_top, newImageSize.width, newImageSize.height+offset_15percent_from_top)];
//        NSLog(@"croppedImage size: %@", NSStringFromCGSize(croppedImage.size));
    }
    
    return croppedImage;
}

+ (UIImage *)getGrayscaledImageFromOriginalImage:(UIImage *)originalImage {
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, originalImage.size.width, originalImage.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, originalImage.size.width, originalImage.size.height, 8, 0,   colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [originalImage CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *grayscaledImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return grayscaledImage;
}

@end
