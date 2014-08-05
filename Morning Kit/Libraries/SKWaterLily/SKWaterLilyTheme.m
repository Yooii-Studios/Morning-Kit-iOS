//
//  SKWaterLilyTheme.m
//  SKWaterLilyTest
//
//  Created by Wooseong Kim on 13. 10. 5..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import "SKWaterLilyTheme.h"

@implementation SKWaterLilyTheme

- (id)init{
    self = [super init];
    if (self) {
        // Initialize
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGRect bounds = [[UIScreen mainScreen] bounds];
        
        UIImage *originalPortraitImage;
        UIImage *originalLandscapeImage;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (scale == 2.0f) {
                // Retina
                if (bounds.size.height != 480) {
                    // iPhone 5 (1136 -> 568)
//                    NSLog(@"iPhone 5 (4 inch retina)");
                    originalPortraitImage = [UIImage imageNamed:@"Water_Lily_1136x640"];
                }else{
                    // iPhone 4 (960 -> 480)
//                    NSLog(@"iPhone 3.5 inch retina");
                    originalPortraitImage = [UIImage imageNamed:@"Water_Lily_960x640"];
                }
            }else{
//                NSLog(@"iPhone 3GS (3.5 inch non-retina)");
                originalPortraitImage = [UIImage imageNamed:@"Water_Lily_960x640"];
            }
        }else{
            if (scale == 2.0f) {
                originalPortraitImage = [UIImage imageNamed:@"Water_Lily_2048x1536"];
            }else{
                originalPortraitImage = [UIImage imageNamed:@"Water_Lily_2048x1536"];
            }
        }
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            // 전체 아트를 사용해도 무방할듯
            self.portraitWaterLilyImage = originalPortraitImage;
            self.landscapeWaterLilyImage = [UIImage imageWithCGImage:[self CGImageRotatedByAngle:self.portraitWaterLilyImage.CGImage angle:90]];
        }else{
            // status bar 20 잘라야함 -
            self.portraitWaterLilyImage = [self getCropedImageWithImage:originalPortraitImage withScale:2.0f];
            
            originalLandscapeImage = [UIImage imageWithCGImage:[self CGImageRotatedByAngle:originalPortraitImage.CGImage angle:90]];
            self.landscapeWaterLilyImage = [self getCropedImageWithImage:originalLandscapeImage withScale:2.0f];
        }
    }
    
    return self;
}

- (UIImage *)getCropedImageWithImage:(UIImage *)originalImage withScale:(CGFloat)scale {
//    CGImageRef imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height * scale, originalImage.size.width, originalImage.size.height));

    CGImageRef imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, 20.0f * scale, originalImage.size.width, originalImage.size.height));
    
    UIImage *cropedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropedImage;
}


- (CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle

{
    
    CGFloat angleInRadians = angle * (M_PI / 180);
    
    CGFloat width = CGImageGetWidth(imgRef);
    
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGRect imgRect = CGRectMake(0, 0, width, height);
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
    
    CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                   
                                                   rotatedRect.size.width,
                                                   
                                                   rotatedRect.size.height,
                                                   
                                                   8,
                                                   
                                                   0,
                                                   
                                                   colorSpace,
                                                   
                                                   kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedFirst);
    
    CGContextSetAllowsAntialiasing(bmContext, YES);
    
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextTranslateCTM(bmContext,
                          
                          +(rotatedRect.size.width/2),
                          
                          +(rotatedRect.size.height/2));
    
    CGContextRotateCTM(bmContext, angleInRadians);
    
    CGContextDrawImage(bmContext, CGRectMake(-width/2, -height/2, width, height),
                       
                       imgRef);
    
    
    CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
    
    CFRelease(bmContext);
    
    return rotatedImage;
}

@end
