//
//  MNConfigureSettingsThemeController.h
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 16..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNPhotoThemeDetailController.h"

@interface MNConfigureSettingsThemeController : UITableViewController <MNPhotoThemeDetailControllerDelegate>

@property (nonatomic) NSInteger frontCameraOffset; // 화면쪽 카메라
@property (nonatomic) NSInteger backCameraOffset; // 화면뒤쪽 카메라

@end
