//
//  MNConfigureTabBarController.h
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 19..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNConfigureSettingController.h"
#import "MNConfigureWidgetController.h"
#import "MNConfigureInfoController.h"
#import "MNConfigureAlarmController.h"
#import "MNStoreController.h"

@protocol MNConfigureTabBarControllerDelegate <NSObject>

- (void)languageDidChanged;

@end

@interface MNConfigureTabBarController : UITabBarController <UITabBarControllerDelegate, MNConfigureTabBarControllerDelegate, MNConfigureSettingControllerDelegate, MNConfigureInfoControllerDelegate, MNConfigureAlarmControllerDelegate, MNStoreControllerDelegate>

// 메인에서 정해줄 수 있는 인덱스로서 이를 참조해 첫 화면 탭을 정한다.
@property (nonatomic) NSInteger tabBarIndexShouldBeSelected;
@property (nonatomic) NSInteger previouslySelectedIndex;

@property (nonatomic, strong) MNConfigureSettingController *settingController;
@property (nonatomic, strong) MNConfigureWidgetController *widgetController;

@end
