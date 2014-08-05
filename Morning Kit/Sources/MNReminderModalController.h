//
//  MNReminderModalController.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 9. 27..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetModalController.h"
#import "MNCalendarEventLoader.h"

@interface MNReminderModalController : MNWidgetModalController <MNCalendarEventDelegate>

@property (strong, nonatomic) MNCalendarEventLoader *eventLoader;

@property (strong, nonatomic) NSMutableArray *todayEvents;
@property (strong, nonatomic) NSMutableArray *tomorrowEvents;
@property (strong, nonatomic) NSMutableArray *allDayEvents;
@property (strong, nonatomic) NSMutableArray *birthDayEvents;
@property (strong, nonatomic) NSMutableArray *scheduleEvents;

@property (strong, nonatomic) NSMutableArray *tomorrowAllDayEvents;
@property (strong, nonatomic) NSMutableArray *tomorrowBirthDayEvents;
@property (strong, nonatomic) NSMutableArray *tomorrowScheduleEvents;

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UISwitch *scheduleSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *birthDaySwitch;

@property (strong, nonatomic) IBOutlet UILabel *scheduleLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;

@property (nonatomic) BOOL showSchedule;
@property (nonatomic) BOOL showBirthday;

@end
