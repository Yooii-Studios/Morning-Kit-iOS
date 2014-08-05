//
//  MNConfigureAlarmController.h
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 30..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNAlarmPreferenceController.h"
#import "MNAlarm.h"
#import "MNAppDelegate.h"
//#import "MNConfigureAlarmTableView.h"
#import "MNMainAlarmTableView.h"

@protocol MNConfigureAlarmControllerDelegate <NSObject>

- (void)doneButtonClicked;

@end

@interface MNConfigureAlarmController : UITableViewController <MNAlarmPreferenceControllerDelegate, MNAlarmListControllerDelegate, MNMainAlarmTableViewDelegate>

@property (strong, nonatomic) IBOutlet MNMainAlarmTableView *alarmTableView;
@property (strong, nonatomic) NSMutableArray *alarmList;
@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) id<MNConfigureAlarmControllerDelegate> delegate;

- (IBAction)doneButtonClicked:(id)sender;

@end
