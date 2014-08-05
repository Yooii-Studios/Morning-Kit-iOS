//
//  YBWidgetReminderView.m
//  YBTableViewWidget
//
//  Created by Yongbin Bae on 13. 10. 5..
//  Copyright (c) 2013년 Morning Team. All rights reserved.
//

#import "MNWidgetReminderView.h"
#import "MNReminderCell.h"
#import "MNTheme.h"
#import "MNLanguage.h"

#define NUM_OF_MAX_REMINDER ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 7 : 6)
#define CELL_IDENTIFIER ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNReminderCell_iPad" : @"MNReminderCell")
#define TABLEVIEW_CONTENT_SCALE_FACTOR 0.5f

@implementation MNWidgetReminderView

#pragma mark - MNWidgetView Methods

- (void)initWidgetView
{
    MNCalendarEventLoader *loader = [[MNCalendarEventLoader alloc] init];
    loader.delegate = self;
    [loader loadEvents];
}

// 여기서 노 스케쥴을 보여주지 않고, 콜백이 와서 체크될 때에만 보여주기로 한다. 
- (void)updateUI
{
//    if (self.todayEvents.count + self.tomorrowEvents.count == 0) {
//        [self.loadingDelegate showWidgetErrorMessage:MNLocalizedString(@"reminder_no_schedule", nil)];
//    }
}

- (void)initThemeColor
{
//    self.tableView.backgroundColor = [UIColor redColor];
    [self doWidgetLoadingInBackground];
//    [self.tableView reloadData];
}

- (void)doWidgetLoadingInBackground
{
    // UI개선을 위해서 디스패치를 사용해본다
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MNCalendarEventLoader *loader = [[MNCalendarEventLoader alloc] init];
        loader.delegate = self;
        [loader loadEvents];
    });
//    MNCalendarEventLoader *loader = [[MNCalendarEventLoader alloc] init];
//    loader.delegate = self;
//    [loader loadEvents];
}

- (void)onRotationWithOrientation:(UIInterfaceOrientation)orientation
{
//    [self.tableView reloadData];
    [self doWidgetLoadingInBackground];
}

#pragma mark - Reminder widget Methods

- (void)groupEvents
{
//    BOOL showBirthday, showSchedule;
    
    if (self.widgetDictionary[WIDGETKEY_SHOW_SCHEDULE] && self.widgetDictionary[WIDGETKEY_SHOW_BIRTHDAY])
    {
        self.showScheduleOn = [self.widgetDictionary[WIDGETKEY_SHOW_SCHEDULE] boolValue];
        self.showBirthdayOn = [self.widgetDictionary[WIDGETKEY_SHOW_BIRTHDAY] boolValue];
    }
    else
    {
        // 없다면 마지막 설정 값이 있는지 체크
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *latestSettings = [defaults objectForKey:@"reminder_lastsettings"];
        
        if (latestSettings)
        {
            self.showScheduleOn = [latestSettings[SHARED_WIDGETKEY_SHOW_SCHEDULE] boolValue];
            self.showBirthdayOn = [latestSettings[SHARED_WIDGETKEY_SHOW_BIRTHDAY] boolValue];
            
            [self.widgetDictionary setObject:[NSNumber numberWithBool:self.showScheduleOn] forKey:WIDGETKEY_SHOW_SCHEDULE];
            [self.widgetDictionary setObject:[NSNumber numberWithBool:self.showBirthdayOn] forKey:WIDGETKEY_SHOW_BIRTHDAY];
        }
        // 마지막 설정 값이 없다면 전부 켜주기
        else
        {
            self.showScheduleOn = YES;
            self.showBirthdayOn = YES;
            
            [self.widgetDictionary setObject:[NSNumber numberWithBool:self.showScheduleOn] forKey:WIDGETKEY_SHOW_SCHEDULE];
            [self.widgetDictionary setObject:[NSNumber numberWithBool:self.showBirthdayOn] forKey:WIDGETKEY_SHOW_BIRTHDAY];
        }
    }
    
    self.allDayEvents = [NSMutableArray array];
    self.birthDayEvents = [NSMutableArray array];
    self.scheduleEvents = [NSMutableArray array];
    
    // 각 이벤트 별 어트리뷰티드 스트링 메이킹
    // 로직에 문제있어서 수정(우성)
    for (MNCalendarEvent *event in self.todayEvents)
    {
        if (event.isAllday)
        {
            // 기존 로직
//            if (event.isBirthDayEvent && showBirthday)
//            {
//                [self.birthDayEvents addObject:event];
//            }
//            else
//            {
//                if (showSchedule)
//                    [self.allDayEvents addObject:event];
//            }
            
            // 우성이 수정한 로직
            if (event.isBirthDayEvent)
            {
                if (self.showBirthdayOn) {
                    [self.birthDayEvents addObject:event];
                }
            }
            else if(self.showScheduleOn)
            {
                [self.allDayEvents addObject:event];
            }
        }
        else
        {
            if (self.showScheduleOn)
                [self.scheduleEvents addObject:event];
        }
    }
    
    self.tomorrowAllDayEvents = [NSMutableArray array];
    self.tomorrowBirthDayEvents = [NSMutableArray array];
    self.tomorrowScheduleEvents = [NSMutableArray array];
    
    for (MNCalendarEvent *event in self.tomorrowEvents)
    {
        if (event.isAllday)
        {
            // 로직에 문제 있어서 수정
//            if (event.isBirthDayEvent && showBirthday)
//            {
//                [self.tomorrowBirthDayEvents addObject:event];
//            }
//            else
//            {
//                if (showSchedule)
//                    [self.tomorrowAllDayEvents addObject:event];
//            }
            
            // 우성이 수정한 로직
            if (event.isBirthDayEvent)
            {
                if (self.showBirthdayOn) {
                    [self.self.tomorrowBirthDayEvents addObject:event];
                }
            }
            else if(self.showScheduleOn)
            {
                [self.tomorrowAllDayEvents addObject:event];
            }
        }
        else
        {
            if (self.showScheduleOn)
                [self.tomorrowScheduleEvents addObject:event];
        }
    }
    
    if (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count +
        self.tomorrowAllDayEvents.count + self.tomorrowBirthDayEvents.count + self.tomorrowScheduleEvents.count == 0)
    {
        [self.loadingDelegate showWidgetErrorMessage:MNLocalizedString(@"reminder_no_schedule", nil)];
    }
    
    // 우성 추가: grouping하고 나서 각 옵션이 꺼져있다면 차라리 해당 이벤트들을 지우기(그것이 처리하기 깔끔할듯)
    // 확인해보니 넣을때 빼고 넣는듯
//    NSLog(@"all days: %d", self.allDayEvents.count);
//    NSLog(@"birthdays: %d", self.birthDayEvents.count);
    /*
    if (showBirthday == NO) {
        [self.birthDayEvents removeAllObjects];
        [self.tomorrowBirthDayEvents removeAllObjects];
    }
    if (showSchedule == NO) {
        [self.allDayEvents removeAllObjects];
        [self.scheduleEvents removeAllObjects];
        
        [self.tomorrowAllDayEvents removeAllObjects];
        [self.tomorrowScheduleEvents removeAllObjects];
    }
     */
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    
//    NUM_OF_MAX_SCHDULE 수에 맞게 계산 해줘야함
    
    switch (section) {
        case kReminderSectionAllday:
        {
            num = self.allDayEvents.count;
            if (num > NUM_OF_MAX_REMINDER)
                num = NUM_OF_MAX_REMINDER;
            
            break;
        }
        case kReminderSectionBirthDay:
        {
            num = self.birthDayEvents.count;
            if (self.allDayEvents.count + num > NUM_OF_MAX_REMINDER)
                num = NUM_OF_MAX_REMINDER - self.allDayEvents.count;
            break;
        }
        case kReminderSectionEvents:
        {
            num = self.scheduleEvents.count;
            if (self.allDayEvents.count + self.birthDayEvents.count + num > NUM_OF_MAX_REMINDER)
                num = NUM_OF_MAX_REMINDER - self.allDayEvents.count - self.birthDayEvents.count;
            break;
        }
        case kReminderSectionSeparatorTomorrow:
        {
            if (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count < NUM_OF_MAX_REMINDER-1 &&
                self.tomorrowAllDayEvents.count + self.tomorrowBirthDayEvents.count + self.tomorrowScheduleEvents.count != 0)
                num = 1;
            
            // 추가: 생일만 쓸때, 이벤트만 쓸때를 체크해서, 갯수체크해서 0개이면 표시하지 말자.
            if ((self.showBirthdayOn && !self.showScheduleOn && self.tomorrowBirthDayEvents.count == 0) ||
                ( self.showScheduleOn && !self.showBirthdayOn && self.tomorrowAllDayEvents.count == 0 && self.tomorrowEvents.count == 0)) {
                num = 0;
            }
            
            break;
        }
        case kReminderSectionTommorowAllday:
        {
            if (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count < NUM_OF_MAX_REMINDER-1)
            {
                num = self.tomorrowAllDayEvents.count;
                if (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count + num + 1 > NUM_OF_MAX_REMINDER)
                    num = NUM_OF_MAX_REMINDER - (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count) - 1;
            }
            break;
        }
        case kReminderSectionTommorowBirthDay:
        {
            if (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count < NUM_OF_MAX_REMINDER-1)
            {
                num = self.tomorrowBirthDayEvents.count;
                if (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count + self.tomorrowAllDayEvents.count + num > NUM_OF_MAX_REMINDER)
                    num = NUM_OF_MAX_REMINDER - (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count) - self.tomorrowAllDayEvents.count -1;
            }
            break;
        }
        case kReminderSectionTommorowEvents:
        {
            if (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count < NUM_OF_MAX_REMINDER-1)
            {
                num = self.tomorrowScheduleEvents.count;
                if (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count + self.tomorrowAllDayEvents.count + self.tomorrowBirthDayEvents.count + num + 1 > NUM_OF_MAX_REMINDER)
                    num = NUM_OF_MAX_REMINDER - (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count) - self.tomorrowAllDayEvents.count - self.tomorrowBirthDayEvents.count - 1;
            }
            break;
        }
    }
    
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MNReminderCell";
    MNReminderCell *cell = (MNReminderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:CELL_IDENTIFIER owner:self options:nil] objectAtIndex:0];
    
    NSString *dateString;
    NSString *titleString;
    
    switch (indexPath.section) {
        case kReminderSectionAllday:
        {
            MNCalendarEvent *event = self.allDayEvents[indexPath.row];
            titleString = event.title;
            
            if (event == self.allDayEvents.firstObject)
                dateString = MNLocalizedString(@"reminder_all_day", nil);
            else
                dateString = @"";
            
            int a = 0;
            if (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count > NUM_OF_MAX_REMINDER)
            {
                a = indexPath.row + 1;
            }
            if (event != self.allDayEvents.lastObject || (self.birthDayEvents.count == 0 && self.scheduleEvents.count == 0 && self.tomorrowEvents.count == 0) || (a == NUM_OF_MAX_REMINDER) || (self.allDayEvents.count == NUM_OF_MAX_REMINDER-1)) {
                cell.separator.alpha = 0;
            }
            
            cell.dateLabel.text = dateString;
            cell.titleLabel.text = titleString;
            
            cell.dateLabel.textColor = [MNTheme getMainFontUIColor];
            cell.titleLabel.textColor = [MNTheme getMainFontUIColor];
            
            break;
        }
        
        case kReminderSectionBirthDay:
        {
            MNCalendarEvent *event = self.birthDayEvents[indexPath.row];
            titleString = event.title;
            
            if (event == self.birthDayEvents.firstObject)
                dateString = MNLocalizedString(@"reminder_birthday", nil);
            else
                dateString = @"";
            
            int a = 0;
            if (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count > NUM_OF_MAX_REMINDER)
            {
                a = self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count + indexPath.row + 1;
            }
            
            if (event != self.birthDayEvents.lastObject || (self.scheduleEvents.count == 0) || (a == NUM_OF_MAX_REMINDER) || (self.tomorrowEvents.count == 0) || (self.allDayEvents.count + self.birthDayEvents.count == NUM_OF_MAX_REMINDER-1))
            {
                cell.separator.alpha = 0;
            }
            
            if (event == self.birthDayEvents.lastObject) {
                // 우성 추가: 일정이 켜져 있고, 오늘 스케쥴이 있으면 선을 그어주기
                // 오늘 스케쥴이 없고, 내일 스케쥴이 있더라도 선을 그어주기
                if (self.showScheduleOn && (self.scheduleEvents.count > 0 || self.tomorrowAllDayEvents.count > 0 || self.tomorrowScheduleEvents.count > 0)) {
                    cell.separator.alpha = 1;
                }
                
                if (self.showBirthdayOn && self.tomorrowBirthDayEvents.count > 0) {
                    cell.separator.alpha = 1;
                }
                
                // 우성 추가: 하지만 생일만 켜져있고 내일 생일 일정이 없거나, 일정이 켜저 있고 내일 일정이 없을 때는 선을 긋지 않기
                if ((self.showBirthdayOn && !self.showScheduleOn && self.tomorrowBirthDayEvents.count == 0) ||
                    (!self.showBirthdayOn && self.showScheduleOn && self.tomorrowAllDayEvents.count == 0 && self.tomorrowEvents.count == 0)) {
                    cell.separator.alpha = 0;
                }
                
            }
            
            cell.dateLabel.text = dateString;
            cell.titleLabel.text = titleString;
            
            cell.dateLabel.textColor = [MNTheme getMainFontUIColor];
            cell.titleLabel.textColor = [MNTheme getMainFontUIColor];
            
            break;
        }
            
        case kReminderSectionEvents:
        {
            MNCalendarEvent *event = self.scheduleEvents[indexPath.row];
            
            NSDateFormatter *formatterFor24hour = [[NSDateFormatter alloc] init];
            [formatterFor24hour setLocale:[NSLocale currentLocale]];
            [formatterFor24hour setDateStyle:NSDateFormatterNoStyle];
            [formatterFor24hour setTimeStyle:NSDateFormatterShortStyle];
            dateString = [formatterFor24hour stringFromDate:[NSDate date]];
            NSRange amRange = [dateString rangeOfString:[formatterFor24hour AMSymbol]];
            NSRange pmRange = [dateString rangeOfString:[formatterFor24hour PMSymbol]];
            BOOL isUsing24hour = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
            NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
            
            if (isUsing24hour)
                formmater.dateFormat = @"HH:mm";
            else
                formmater.dateFormat = @"hh:mm";
            
            [formatterFor24hour setDateFormat:@"HH"];
            NSInteger hour = [[formatterFor24hour stringFromDate:event.startDate] integerValue];
            NSString *ampmString;
            
            if (isUsing24hour)
            {
                ampmString = @"";
                dateString = [formmater stringFromDate:event.startDate];
            }
            else
            {
                if ([[MNLanguage getCurrentLanguage] isEqualToString:@"en"])
                {
                    ampmString = @" ";
                    if (hour >= 12)
                        ampmString = [ampmString stringByAppendingString:MNLocalizedString(@"alarm_pm", @"PM")];
                    else
                        ampmString = [ampmString stringByAppendingString:MNLocalizedString(@"alarm_am", @"AM")];
                    
                    dateString = [formmater stringFromDate:event.startDate];
                    dateString = [dateString stringByAppendingString:ampmString];
                }
                else
                {
                    if (hour >= 12)
                        ampmString = MNLocalizedString(@"alarm_pm", @"PM");
                    else
                        ampmString = MNLocalizedString(@"alarm_am", @"AM");
                    
                    ampmString = [ampmString stringByAppendingString:@" "];
                    
                    dateString = [formmater stringFromDate:event.startDate];
                    dateString = [ampmString stringByAppendingString:dateString];
                }
            }
            
            titleString = event.title;
            
            int a = 0;
            if (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count > NUM_OF_MAX_REMINDER)
            {
                a = self.allDayEvents.count + self.birthDayEvents.count + indexPath.row + 1;
            }
            
            if ((event == self.scheduleEvents.lastObject || a >= NUM_OF_MAX_REMINDER) && ((self.tomorrowAllDayEvents.count + self.tomorrowBirthDayEvents.count + self.tomorrowScheduleEvents.count == 0) || (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count >= NUM_OF_MAX_REMINDER-1)))
                cell.separator.alpha = 0.0f;

            cell.dateLabel.text = dateString;
            cell.titleLabel.text = titleString;
            
            cell.dateLabel.textColor = [MNTheme getMainFontUIColor];
            cell.titleLabel.textColor = [MNTheme getMainFontUIColor];
            
            break;
        }
            
        case kReminderSectionSeparatorTomorrow:
        {
//            NSLog(@"tomorrowBirthDayEvents: %d", self.tomorrowBirthDayEvents.count);
//            NSLog(@"tomorrowAllDayEvents: %d", self.tomorrowAllDayEvents.count);
//            NSLog(@"tomorrowEvents: %d", self.tomorrowEvents.count);
            
            cell.tomorrowSeparator.text = MNLocalizedString(@"world_clock_tomorrow", @"내일");
            cell.tomorrowSeparator.textColor = [MNTheme getWidgetSubFontUIColor];
            cell.tomorrowSeparator.alpha = 1.0f;
            cell.dateLabel.text = @"";
            cell.titleLabel.text = @"";
//            cell.separator.alpha = 0;
            break;
        }
            
        case kReminderSectionTommorowAllday:
        {
            MNCalendarEvent *event = self.tomorrowAllDayEvents[indexPath.row];
            titleString = event.title;
            
            if (event == self.tomorrowAllDayEvents.firstObject)
                dateString = MNLocalizedString(@"reminder_all_day", nil);
            else
                dateString = @"";
            
            int a = 0;
            if (self.todayEvents.count + self.tomorrowEvents.count > NUM_OF_MAX_REMINDER - 1)
            {
                a = self.todayEvents.count + indexPath.row + 1 + 1;
            }
            if (event != self.tomorrowAllDayEvents.lastObject || (self.tomorrowBirthDayEvents.count == 0 && self.tomorrowScheduleEvents.count == 0) || (a == NUM_OF_MAX_REMINDER)) {
                cell.separator.alpha = 0;
            }
            
            cell.dateLabel.text = dateString;
            cell.titleLabel.text = titleString;
            
            cell.dateLabel.textColor = [MNTheme getWidgetSubFontUIColor];
            cell.titleLabel.textColor = [MNTheme getWidgetSubFontUIColor];
            
            break;
        }
            
        case kReminderSectionTommorowBirthDay:
        {
            MNCalendarEvent *event = self.tomorrowBirthDayEvents[indexPath.row];
            titleString = event.title;
            
            if (event == self.tomorrowBirthDayEvents.firstObject)
                dateString = MNLocalizedString(@"reminder_birthday", nil);
            else
                dateString = @"";
            
            int a = 0;
            if (self.todayEvents.count + self.tomorrowEvents.count> NUM_OF_MAX_REMINDER - 1)
            {
                a = self.todayEvents.count + self.tomorrowAllDayEvents.count + indexPath.row + 1 + 1;
            }
            
            if (event != self.tomorrowBirthDayEvents.lastObject || (self.tomorrowScheduleEvents.count==0) || (a == NUM_OF_MAX_REMINDER)) {
                cell.separator.alpha = 0;
            }
            
            cell.dateLabel.text = dateString;
            cell.titleLabel.text = titleString;
            
            cell.dateLabel.textColor = [MNTheme getWidgetSubFontUIColor];
            cell.titleLabel.textColor = [MNTheme getWidgetSubFontUIColor];
            break;
        }
            
        case kReminderSectionTommorowEvents:
        {
            MNCalendarEvent *event = self.tomorrowScheduleEvents[indexPath.row];
            
            NSDateFormatter *formatterFor24hour = [[NSDateFormatter alloc] init];
            [formatterFor24hour setLocale:[NSLocale currentLocale]];
            [formatterFor24hour setDateStyle:NSDateFormatterNoStyle];
            [formatterFor24hour setTimeStyle:NSDateFormatterShortStyle];
            dateString = [formatterFor24hour stringFromDate:[NSDate date]];
            NSRange amRange = [dateString rangeOfString:[formatterFor24hour AMSymbol]];
            NSRange pmRange = [dateString rangeOfString:[formatterFor24hour PMSymbol]];
            BOOL isUsing24hour = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
            NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
            
            if (isUsing24hour)
                formmater.dateFormat = @"HH:mm";
            else
                formmater.dateFormat = @"hh:mm";
            
            [formatterFor24hour setDateFormat:@"HH"];
            NSInteger hour = [[formatterFor24hour stringFromDate:event.startDate] integerValue];
            NSString *ampmString;
            
            if (isUsing24hour)
            {
                ampmString = @"";
                dateString = [formmater stringFromDate:event.startDate];
            }
            else
            {
                if ([[MNLanguage getCurrentLanguage] isEqualToString:@"en"])
                {
                    ampmString = @" ";
                    if (hour >= 12)
                        ampmString = [ampmString stringByAppendingString:MNLocalizedString(@"alarm_pm", @"PM")];
                    else
                        ampmString = [ampmString stringByAppendingString:MNLocalizedString(@"alarm_am", @"AM")];
                    
                    dateString = [formmater stringFromDate:event.startDate];
                    dateString = [dateString stringByAppendingString:ampmString];
                }
                else
                {
                    if (hour >= 12)
                        ampmString = MNLocalizedString(@"alarm_pm", @"PM");
                    else
                        ampmString = MNLocalizedString(@"alarm_am", @"AM");
                    
                    ampmString = [ampmString stringByAppendingString:@" "];
                    
                    dateString = [formmater stringFromDate:event.startDate];
                    dateString = [ampmString stringByAppendingString:dateString];
                }
            }
            
            titleString = event.title;
            
            int a = 0;
            if (self.todayEvents.count + self.tomorrowEvents.count > NUM_OF_MAX_REMINDER - 1)
            {
                a = self.todayEvents.count + self.tomorrowAllDayEvents.count + self.tomorrowBirthDayEvents.count + indexPath.row + 1 + 1;
            }
            
            if (event == self.tomorrowScheduleEvents.lastObject || a == NUM_OF_MAX_REMINDER)
                cell.separator.alpha = 0.0f;
            
            cell.dateLabel.text = dateString;
            cell.titleLabel.text = titleString;
            
            cell.dateLabel.textColor = [MNTheme getWidgetSubFontUIColor];
            cell.titleLabel.textColor = [MNTheme getWidgetSubFontUIColor];
            
            break;
        }
    }
    
//    cell.dateLabel.text = dateString;
//    cell.titleLabel.text = titleString;
    
//    CGRect cellFrame = cell.frame;
//    cellFrame.size.width = self.tableView.contentSize.width;
//    if (self.tomorrowEvents.count > 0) {
//        ;
//    }
//    cellFrame.size.height = self.tableView.frame.size.height/(self.todayEvents.count + self.tomorrowEvents.count);
//    
//    cell.frame = cellFrame;
    [cell.dateLabel adjustsFontSizeToFitWidth];
    [cell.titleLabel adjustsFontSizeToFitWidth];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height;
    
//    if (self.todayEvents.count + self.tomorrowEvents.count > NUM_OF_MAX_REMINDER)
//        height = self.tableView.contentSize.height/NUM_OF_MAX_REMINDER;
//    else
//    {
//        if (self.tomorrowEvents.count > 0)
//        {
//            height = self.tableView.contentSize.height/(self.todayEvents.count + self.tomorrowEvents.count + 1);
//        }
//        else
//        {
//            height = self.tableView.contentSize.height/self.todayEvents.count;
//        }
//    }

    // 일정 갯수가 적더라도 일정 간격 이상으로는 보여주게 구현.
    if (self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count +
        self.tomorrowAllDayEvents.count + self.tomorrowBirthDayEvents.count + self.tomorrowScheduleEvents.count > NUM_OF_MAX_REMINDER)
        height = self.tableView.contentSize.height/NUM_OF_MAX_REMINDER;
    else
    {
        if (self.tomorrowAllDayEvents.count + self.tomorrowBirthDayEvents.count + self.tomorrowScheduleEvents.count > 0)
        {
            NSInteger limit = self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count +
            self.tomorrowAllDayEvents.count + self.tomorrowBirthDayEvents.count + self.tomorrowScheduleEvents.count + 1;
            
            if (limit > NUM_OF_MAX_REMINDER) {
                limit = NUM_OF_MAX_REMINDER;
            }else if(limit < NUM_OF_MAX_REMINDER) {
                limit = NUM_OF_MAX_REMINDER;
            }
            
            height = self.tableView.contentSize.height / limit;
        }
        else
        {
            NSInteger limit = self.allDayEvents.count + self.birthDayEvents.count + self.scheduleEvents.count;
            if (limit > NUM_OF_MAX_REMINDER) {
                limit = NUM_OF_MAX_REMINDER;
            }else if(limit < NUM_OF_MAX_REMINDER) {
                limit = NUM_OF_MAX_REMINDER;
            }
            
            height = self.tableView.contentSize.height / limit; //self.todayEvents.count;
        }
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleString;
    
    switch (section) {
        case kReminderSectionAllday:
            titleString = @"All-Day";
            break;
            
        case kReminderSectionBirthDay:
            titleString = @"BirthDay";
            break;
            
        case kReminderSectionEvents:
            titleString = @"Events";
            break;
    }
    
    return titleString;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - MNEventLoader delegate

- (void)requestGranted:(NSMutableArray *)events
{
    self.tableView.contentSize = self.tableView.frame.size;
    
    self.todayEvents = events;
    
    if (self.todayEvents.count > 0)
    {
        [self.loadingDelegate stopAnimation];
        [self groupEvents];
        [self.tableView reloadData];
    }
    else
    {
        [self.loadingDelegate showWidgetErrorMessage:MNLocalizedString(@"reminder_no_schedule", nil)];
    }
}

- (void)requestGrantedWithTodayEvents:(NSMutableArray *)todayEvents withTomorrowEvents:(NSMutableArray *)tomorrowEvents {
    
    if (todayEvents.count + tomorrowEvents.count > 0)
    {
        self.tableView.contentSize = self.tableView.frame.size;
        //    self.tableView.contentInset = UIEdgeInsetsZero;
        
        self.todayEvents = todayEvents;
        self.tomorrowEvents = tomorrowEvents;
        
//        if (self.todayEvents.count + self.tomorrowEvents.count < 4)
//        {
//            CGRect contentFrame = self.tableView.frame;
//            contentFrame.size.height *= TABLEVIEW_CONTENT_SCALE_FACTOR;
//            
//            self.tableView.contentSize = contentFrame.size;
//        }
        
        [self.loadingDelegate stopAnimation];
        [self groupEvents];
//        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        [self.tableView reloadData];
    }
    else
    {
        [self.loadingDelegate showWidgetErrorMessage:MNLocalizedString(@"reminder_no_schedule", nil)];
    }
}

@end
