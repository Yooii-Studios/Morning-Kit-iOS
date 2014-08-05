//
//  MNConfigureSettingsLanguageController.h
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 13..
//  Copyright (c) 2013년 Yooii. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MNConfigureTabBarControllerDelegate;

@interface MNConfigureSettingsLanguageController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic) int selectedIndex;
@property (strong, nonatomic) id<MNConfigureTabBarControllerDelegate> MNDelegate;

@end
