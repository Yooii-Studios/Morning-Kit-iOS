//
//  MNCameraChecker.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 8. 14..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNCameraChecker.h"
#import <AVFoundation/AVFoundation.h>

@implementation MNCameraChecker

// AVCaptureDevicePositionFront
+ (BOOL)isDeviceHasFrontCamera {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        for (AVCaptureDevice *captureDevice in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
            // check if there is a camera on desiredPosition
            if ([captureDevice position] == AVCaptureDevicePositionFront) {
                return YES;
            }
        }
    }
    return NO;
}

// AVCaptureDevicePositionBack
+ (BOOL)isDeviceHasBackCamera {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        for (AVCaptureDevice *captureDevice in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
            // check if there is a camera on desiredPosition
            if ([captureDevice position] == AVCaptureDevicePositionBack) {
                return YES;
            }
        }
    }
    return NO;
}

@end
