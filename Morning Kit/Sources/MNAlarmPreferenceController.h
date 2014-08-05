//
//  MNAlarmPreferenceController.h
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 3..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNAlarm.h"
#import "MNAlarmSound.h"
#import "MNAlarmPreferenceLabelController.h"
#import "MNAlarmPreferenceRepeatController.h"
#import "MNAlarmPreferenceSoundController.h"

@class MNAlarmPreferenceController;

@protocol MNAlarmPreferenceControllerDelegate <NSObject>

- (void)MNAlarmPreferenceControllerDidSaveAlarm:(MNAlarmPreferenceController *)controller;

@end

// Alarm 의 세팅을 저장하는 컨트롤러.
@interface MNAlarmPreferenceController : UIViewController <UITableViewDataSource, UITableViewDelegate, MNAlarmPreferenceLabelControllerDelegate, MNAlarmPreferenceRepeatControllerDelegate, MNAlarmPreferenceSoundControllerDelegate>

@property (strong, nonatomic) IBOutlet UIDatePicker *alarmTimePicker;
@property (strong, nonatomic) IBOutlet UITableView *alarmPreferenceTableView;
@property (strong, nonatomic) UISwitch *alarmSnoozeSwitch;

@property (strong, nonatomic) UITableViewCell *repeatCell;
@property (strong, nonatomic) UITableViewCell *soundCell;
@property (strong, nonatomic) UITableViewCell *snoozeCell;
@property (strong, nonatomic) UITableViewCell *labelCell;

@property (strong, nonatomic) MNAlarm *alarmInPreference;

@property (nonatomic) BOOL isAlarmNew;
@property (strong, nonatomic) MNAlarmSound *latestSelectedAlarmSound;   // 최근에 선택했던 소리

@property (strong, nonatomic) id<MNAlarmPreferenceControllerDelegate> MNDelegate;

- (IBAction)cancelButtonTouched:(id)sender;
- (IBAction)doneButtonTouched:(id)sender;

@end
