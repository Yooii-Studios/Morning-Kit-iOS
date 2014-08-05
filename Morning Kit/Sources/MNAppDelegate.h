//
//  MNAppDelegate.h
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 11..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNAlarmNotificationProcessor;
@class MNAlarm;

@protocol MNAlarmListControllerDelegate <NSObject>

- (void)MNAlarmListShouldBeReloaded;

@end

@interface MNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// custom
@property (nonatomic, strong) id<MNAlarmListControllerDelegate> alarmDelegate;
@property (nonatomic, strong) MNAlarmNotificationProcessor *alarmNotificationProcessor;
@property (nonatomic, strong) MNAlarm *alarmToNotify;

//- (void)resetAppToFirstController;

@end
