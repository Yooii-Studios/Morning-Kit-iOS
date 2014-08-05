//
//  YBWidgetReminderView.h
//  YBTableViewWidget
//
//  Created by Yongbin Bae on 13. 10. 5..
//  Copyright (c) 2013년 Morning Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNCalendarEventLoader.h"
#import "MNWidgetView.h"

@interface MNWidgetReminderView : MNWidgetView <UITableViewDataSource, UITableViewDelegate, MNCalendarEventDelegate>

typedef enum MNWidgetReminderSectionName
{
    kReminderSectionAllday = 0,
    kReminderSectionBirthDay,
    kReminderSectionEvents,
    
    kReminderSectionSeparatorTomorrow,
    kReminderSectionTommorowAllday,
    kReminderSectionTommorowBirthDay,
    kReminderSectionTommorowEvents,
} MNWidgetReminderSectionName;

@property (strong, nonatomic) NSMutableArray *todayEvents;
@property (strong, nonatomic) NSMutableArray *tomorrowEvents;

@property (strong, nonatomic) NSMutableArray *allDayEvents;
@property (strong, nonatomic) NSMutableArray *birthDayEvents;
@property (strong, nonatomic) NSMutableArray *scheduleEvents;

@property (strong, nonatomic) NSMutableArray *tomorrowAllDayEvents;
@property (strong, nonatomic) NSMutableArray *tomorrowBirthDayEvents;
@property (strong, nonatomic) NSMutableArray *tomorrowScheduleEvents;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL showBirthdayOn;
@property (nonatomic) BOOL showScheduleOn;

@end
