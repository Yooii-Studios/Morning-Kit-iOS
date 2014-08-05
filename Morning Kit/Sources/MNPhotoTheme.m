//
//  MNPhotoTheme.m
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 17..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNPhotoTheme.h"

#define PORTRAIT_IMAGE_PATH @"portraitImage"
#define LANDSCAPE_IMAGE_PATH @"landscapeImage"

@implementation MNPhotoTheme

+ (UIImage *)getArchivedPortraitImage {
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:PORTRAIT_IMAGE_PATH];
    if (imageData != nil) {
        UIImage *archivedPortraitImage = [UIImage imageWithData:imageData];
        return archivedPortraitImage;
    }
    return nil;
}

+ (UIImage *)getArchivedLandscapeImage {
    
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:LANDSCAPE_IMAGE_PATH];
    if (imageData != nil) {
        UIImage *archivedLandscapeImage = [UIImage imageWithData:imageData];
        return archivedLandscapeImage;
    }
    return nil;
}

+ (void)archivePortraitImage:(UIImage *)portraitImageToArchive {
    NSData *imageData = UIImagePNGRepresentation(portraitImageToArchive);
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:PORTRAIT_IMAGE_PATH];
}

+ (void)archiveLandscapeImage:(UIImage *)landscapeImageToArchive {
    NSData *imageData = UIImagePNGRepresentation(landscapeImageToArchive);
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:LANDSCAPE_IMAGE_PATH];
}

@end
