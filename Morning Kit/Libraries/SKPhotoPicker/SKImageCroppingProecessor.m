//
//  SKImageCroppingProecessor.m
//  SKPhotoPicker
//
//  Created by 김우성 on 13. 4. 9..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import "SKImageCroppingProecessor.h"
#import "SKPhotoCropFrameView.h"
#import "SKPhotoScaleView.h"

@implementation SKImageCroppingProecessor

+ (UIImage *)getCroppedImageFromPhotoCropFrameView:(SKPhotoCropFrameView *)photoCropFrameView withPhotoScaleView:(SKPhotoScaleView *)photoScaleView {
    UIImage *croppedImage = nil;
    
    float scale = 1.0f/photoScaleView.zoomScale;
    
    // get visibleRect in photoScaleView
    CGRect visibleRect;
    visibleRect.origin.x = photoScaleView.contentOffset.x * scale;
    visibleRect.origin.y = photoScaleView.contentOffset.y * scale;
    visibleRect.size.width = photoScaleView.bounds.size.width * scale;
    visibleRect.size.height = photoScaleView.bounds.size.height * scale;
//    NSLog(@"visibleRect: %@", NSStringFromCGRect(visibleRect));
    
    // get transformed cropRect from visibleRect
    CGRect transformedCropRect;
    transformedCropRect.origin.x = visibleRect.origin.x + photoCropFrameView.cropRect.origin.x * scale;
    transformedCropRect.origin.y = visibleRect.origin.y + photoCropFrameView.cropRect.origin.y * scale;
    transformedCropRect.size.width = photoCropFrameView.cropRect.size.width * scale;
    transformedCropRect.size.height = photoCropFrameView.cropRect.size.height * scale;
//    NSLog(@"transformedCropRect: %@", NSStringFromCGRect(transformedCropRect));
    
    // get final cropRect
    CGRect cropRect;
    CGFloat widthScale = photoScaleView.selectedImageView.bounds.size.width / photoScaleView.selectedImageView.image.size.width;
    CGFloat heightScale = photoScaleView.selectedImageView.bounds.size.height / photoScaleView.selectedImageView.image.size.height;
//    NSLog(@"widthScale: %f / heightScale: %f", widthScale, heightScale);
    
    float x, y, w, h, offset;
    if (widthScale<heightScale) {
//        NSLog(@"widthScale < heightScale");
        offset = (photoScaleView.selectedImageView.bounds.size.height - (photoScaleView.selectedImageView.image.size.height*widthScale))/2;
        x = transformedCropRect.origin.x / widthScale;
        y = (transformedCropRect.origin.y-offset) / widthScale;
        w = transformedCropRect.size.width / widthScale;
        h = transformedCropRect.size.height / widthScale;
//        w = round(transformedCropRect.size.width / widthScale);
//        h = round(transformedCropRect.size.height / widthScale);
    } else {
//        NSLog(@"widthScale >= heightScale");
        offset = (photoScaleView.selectedImageView.bounds.size.width - (photoScaleView.selectedImageView.image.size.width*heightScale))/2;
        x = (transformedCropRect.origin.x-offset) / heightScale;
        y = transformedCropRect.origin.y / heightScale;
        w = transformedCropRect.size.width / heightScale;
        h = transformedCropRect.size.height / heightScale;
//        w = round(transformedCropRect.size.width / heightScale);
//        h = round(transformedCropRect.size.height / heightScale);
    }
    cropRect = CGRectMake(x, y, w, h);
//    NSLog(@"cropRect: %@", NSStringFromCGRect(cropRect));
//    NSLog(@"image: %@", photoScaleView.selectedImageView.image);
    
    // crop
    croppedImage = [self cropImage:photoScaleView.selectedImageView.image withRect:cropRect];
    
    // 새 crop 함수
//    croppedImage = [self imageByCropping:photoScaleView.selectedImageView.image toRect:cropRect];
//    NSLog(@"copped image size: %@", NSStringFromCGSize(croppedImage.size));
//    NSLog(@"%f %f", croppedImage.size.width, croppedImage.size.height);
    
    return croppedImage;
}

+ (UIImage *)cropImage:(UIImage *)srcImage withRect:(CGRect)rect {
//    CGFloat deviceScale = [UIScreen mainScreen].scale;    
//    UIInterfaceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
//    NSLog(@"srcImage CGImage size: %lu, %lu", CGImageGetWidth([srcImage CGImage]), CGImageGetHeight([srcImage CGImage]));
//    NSLog(@"image size: %@", NSStringFromCGSize(srcImage.size));
//    NSLog(@"image orientation: %d", srcImage.imageOrientation);
//    CGImageRef cr = CGImageCreateWithImageInRect([srcImage CGImage], rect);
    CGImageRef cr = CGImageCreateWithImageInRect([self getCGImageRefWithUpOrientation:srcImage], rect);

//    UIImage* cropped = [[UIImage alloc] initWithCGImage:cr];

    UIImage* cropped = [[UIImage alloc] initWithCGImage:cr scale:srcImage.scale orientation:UIImageOrientationUp];
//    NSLog(@"copped image size: %@", NSStringFromCGSize(cropped.size));
    
    CGImageRelease(cr);
    return cropped;
}

// 새 crop 함수
+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(currentContext, 0.0, rect.size.height);
	CGContextScaleCTM(currentContext, 1.0, -1.0);
	
	CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
	CGContextClipToRect( currentContext, clippedRect);
	CGRect drawRect = CGRectMake(rect.origin.x * -1,rect.origin.y * -1,imageToCrop.size.width,imageToCrop.size.height);
	CGContextDrawImage(currentContext, drawRect, [self getCGImageRefWithUpOrientation:imageToCrop]); // imageToCrop.CGImage);
	CGContextScaleCTM(currentContext, 1.0, -1.0);
	
	UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return cropped;
}

#pragma mark - fix image orientation to UIImageOrientationUp

+ (CGImageRef)getCGImageRefWithUpOrientation:(UIImage *)sourceImage {
    // No-op if the orientation is already correct
    if (sourceImage.imageOrientation == UIImageOrientationUp) return [sourceImage CGImage];
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (sourceImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.width, sourceImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, sourceImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (sourceImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, sourceImage.size.width, sourceImage.size.height,
                                             CGImageGetBitsPerComponent(sourceImage.CGImage), 0,
                                             CGImageGetColorSpace(sourceImage.CGImage),
                                             CGImageGetBitmapInfo(sourceImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (sourceImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,sourceImage.size.height,sourceImage.size.width), sourceImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,sourceImage.size.width,sourceImage.size.height), sourceImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
//    CGImageRelease(cgimg);
    if (cgimg) {
        return cgimg;
    }else{
        return nil;
    }
}


@end
