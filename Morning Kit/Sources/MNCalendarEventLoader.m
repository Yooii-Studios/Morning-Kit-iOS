//
//  MNCalendarEventLoader.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 9. 28..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNCalendarEventLoader.h"
#import <EventKit/EventKit.h>

@implementation MNCalendarEventLoader

- (void)loadEvents
{
    __block NSArray *tempEvents;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 참고
    // https://developer.apple.com/library/ios/documentation/DataManagement/Conceptual/EventKitProgGuide/ReadingAndWritingEvents.html#//apple_ref/doc/uid/TP40004775-SW1
    
    // 캘린더 이벤트 리퀘스트
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             // today
             @synchronized(self.todayEvents)
             {
                 self.todayEvents = [NSMutableArray array];
                 // Get the appropriate calendar
                 NSCalendar *calendar = [NSCalendar currentCalendar];
                 // Create the start date components - 하루 동안의 이벤트 검사
                 NSDateComponents *startDateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
                 //    startDateComponents.hour = 0;
                 //    startDateComponents.minute = 0;
                 //    startDateComponents.second = 0;
                 
                 NSDateComponents *endDateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
                 
                 endDateComponents.hour = 23;
                 endDateComponents.minute = 59;
                 endDateComponents.second = 59;
                 
                 NSPredicate *predicate = [store predicateForEventsWithStartDate:[calendar dateFromComponents:startDateComponents]
                                                                         endDate:[calendar dateFromComponents:endDateComponents]
                                                                       calendars:nil];
                 
                 tempEvents = [store eventsMatchingPredicate:predicate];
                 
                 for (EKEvent *event in tempEvents)
                 {
                     NSDateComponents *eventStartDateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:event.startDate];
                     
                     // 어제 시작해서 오늘 끝나는 이벤트는 오늘에서 빼주면 될 것 같다.
                     if (eventStartDateComponents.day == startDateComponents.day) {
                         MNCalendarEvent *calendarEvents = [[MNCalendarEvent alloc] init];
                         calendarEvents.title = event.title;
                         calendarEvents.startDate = event.startDate;
                         calendarEvents.isAllday = event.allDay;
                         
                         if (event.birthdayPersonID == -1)
                             calendarEvents.isBirthDayEvent = NO;
                         else
                             calendarEvents.isBirthDayEvent = YES;
                         
                         [self.todayEvents addObject:calendarEvents];
                     }
                 }
             }
             
             // tomorrow
             @synchronized(self.tomorrowEvents)
             {
                 self.tomorrowEvents = [NSMutableArray array];
                 // Get the appropriate calendar
                 NSCalendar *calendar = [NSCalendar currentCalendar];
                 // Create the start date components - 하루 동안의 이벤트 검사
                 NSDateComponents *startDateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24]];
                startDateComponents.hour = 0;
                startDateComponents.minute = 0;
                startDateComponents.second = 0;
                 
                 NSDateComponents *endDateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24]];
                 
                 endDateComponents.hour = 23;
                 endDateComponents.minute = 59;
                 endDateComponents.second = 59;
                 
                 NSPredicate *predicate = [store predicateForEventsWithStartDate:[calendar dateFromComponents:startDateComponents]
                                                                         endDate:[calendar dateFromComponents:endDateComponents]
                                                                       calendars:nil];
                 
                 tempEvents = [store eventsMatchingPredicate:predicate];
                 
                 for (EKEvent *event in tempEvents)
                 {
                     NSDateComponents *eventStartDateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:event.startDate];

                     // 오늘 시작해서 내일 끝나는 이벤트는 내일에서 빼주면 될 것 같다.
                     if (eventStartDateComponents.day == startDateComponents.day) {
                         MNCalendarEvent *calendarEvents = [[MNCalendarEvent alloc] init];
                         calendarEvents.title = event.title;
                         calendarEvents.startDate = event.startDate;
                         calendarEvents.isAllday = event.allDay;
                         
                         if (event.birthdayPersonID == -1)
                             calendarEvents.isBirthDayEvent = NO;
                         else
                             calendarEvents.isBirthDayEvent = YES;
                         
                         [self.tomorrowEvents addObject:calendarEvents];
                     }
                 }
             }
             
            // handle access here
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (self.delegate) {
//                     [self.delegate requestGranted:self.tomorrowEvents];
                     [self.delegate requestGrantedWithTodayEvents:self.todayEvents withTomorrowEvents:self.tomorrowEvents];
                 }
             });
             if (error) {
                 NSLog(@"%@", error.description);
             }
         }
    }];
         
}

@end
