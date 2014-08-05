//
//  MNAlarmPreferenceRepeatController.h
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 8..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNAlarmPreferenceRepeatController;

// protocol
@protocol MNAlarmPreferenceRepeatControllerDelegate <NSObject>

- (void)MNAlarmPreferenceRepeatControllerDidSelectingRepeat:(MNAlarmPreferenceRepeatController *)controller;

@end

// interface
@interface MNAlarmPreferenceRepeatController : UITableViewController

@property (strong, nonatomic) id<MNAlarmPreferenceRepeatControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *alarmRepeatDayOfWeek;

@end
