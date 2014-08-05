//
//  MNPhotoTheme.h
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 17..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNPhotoTheme : NSObject

+ (UIImage *)getArchivedPortraitImage;
+ (UIImage *)getArchivedLandscapeImage;

+ (void)archivePortraitImage:(UIImage *)portraitImageToArchive;
+ (void)archiveLandscapeImage:(UIImage *)landscapeImageToArchive;

@end
