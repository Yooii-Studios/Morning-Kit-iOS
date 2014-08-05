//
//  MNAlarmToastMaker.m
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 23..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNAlarmToast.h"
#import "JLToast.h"

@implementation MNAlarmToast

+ (void)showAlarmToast:(NSDate *)alarmDate {
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 1. 알람 예정 시간을 일/시/분 으로 나눔
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *todayDateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
        [todayDateComponents setSecond:0];
        
        NSTimeInterval timeIntervalSinceToday = [alarmDate timeIntervalSinceDate:[calendar dateFromComponents:todayDateComponents]];
        
        //    NSLog(@"timeInterValSinceToday: %f", [self.alarmDate timeIntervalSinceDate:[NSDate date]]);
        //    NSLog(@"alarmDate: %@", [self.alarmDate description]);
        
        NSInteger dayInterval = timeIntervalSinceToday / 60 / 60 / 24;
        NSInteger hourInterval = (int)timeIntervalSinceToday / 60 / 60 % 24;
        NSInteger minuteInterval = (int)timeIntervalSinceToday / 60 % 60;
        
        //    NSLog(@"dayInterval: %d", dayInterval);
        //    NSLog(@"hourInterval: %d", hourInterval);
        //    NSLog(@"minuteInterval: %d", minuteInterval);
        
        // 2. 시간 부분 조립
        NSString *timeString = @"";
        if (dayInterval > 0) {
            if (dayInterval == 1) {
                timeString = [timeString stringByAppendingFormat:@"%d%@", dayInterval, MNLocalizedString(@"alarm_day", nil)];
            }else{
                timeString = [timeString stringByAppendingFormat:@"%d%@", dayInterval, MNLocalizedString(@"alarm_days", nil)];
            }
        }
        if (hourInterval > 0) {
            if (hourInterval == 1) {
                timeString = [timeString stringByAppendingFormat:@"%d%@", hourInterval, MNLocalizedString(@"alarm_hour", nil)];
            }else{
                timeString = [timeString stringByAppendingFormat:@"%d%@", hourInterval, MNLocalizedString(@"alarm_hours", nil)];
            }
        }
        if (minuteInterval > 0) {
            if (minuteInterval == 1) {
                timeString = [timeString stringByAppendingFormat:@"%d%@", minuteInterval, MNLocalizedString(@"alarm_minute", nil)];
            }else{
                timeString = [timeString stringByAppendingFormat:@"%d%@", minuteInterval, MNLocalizedString(@"alarm_minutes", nil)];
            }
        }else{
            timeString = [timeString stringByAppendingFormat:@"1%@", MNLocalizedString(@"alarm_minute", nil)];
        }
        
        // 3. JLToast 를 이용해 남은 시간을 적절한 표현으로 출력할 수 있게 구현
        //    NSString *alarmNotificationString = [NSString stringWithFormat:@"Alarm set for %d days %d hours %d minutes from now.", dayInterval, hourInterval, minuteInterval];
        NSString *alarmNotificationString = [NSString stringWithFormat:@"%@%@%@", MNLocalizedString(@"alarm_set_toast_part1", nil), timeString, MNLocalizedString(@"alarm_set_toast_part2", nil)];
        
        // UI관련은 메인 큐에서 돌려줌
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JLToast makeText:alarmNotificationString] show];
        });
    });
}

+ (void)showAlarmToast2:(NSDate *)alarmDate {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 1. 알람 예정 시간을 일/시/분 으로 나눔
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *todayDateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
        [todayDateComponents setSecond:0];
        
        NSTimeInterval timeIntervalSinceToday = [alarmDate timeIntervalSinceDate:[calendar dateFromComponents:todayDateComponents]];
        
        //    NSLog(@"timeInterValSinceToday: %f", [self.alarmDate timeIntervalSinceDate:[NSDate date]]);
        //    NSLog(@"alarmDate: %@", [self.alarmDate description]);
        
        NSInteger dayInterval = timeIntervalSinceToday / 60 / 60 / 24;
        NSInteger hourInterval = (int)timeIntervalSinceToday / 60 / 60 % 24;
        NSInteger minuteInterval = (int)timeIntervalSinceToday / 60 % 60;
        
        //    NSLog(@"dayInterval: %d", dayInterval);
        //    NSLog(@"hourInterval: %d", hourInterval);
        //    NSLog(@"minuteInterval: %d", minuteInterval);
        
        // 2. 시간 부분 조립
        NSString *timeString = @"";
        if (dayInterval > 0) {
            if (dayInterval == 1) {
                timeString = [timeString stringByAppendingFormat:@"%d%@", dayInterval, MNLocalizedString(@"alarm_day", nil)];
            }else{
                timeString = [timeString stringByAppendingFormat:@"%d%@", dayInterval, MNLocalizedString(@"alarm_days", nil)];
            }
        }
        if (hourInterval > 0) {
            if (hourInterval == 1) {
                timeString = [timeString stringByAppendingFormat:@"%d%@", hourInterval, MNLocalizedString(@"alarm_hour", nil)];
            }else{
                timeString = [timeString stringByAppendingFormat:@"%d%@", hourInterval, MNLocalizedString(@"alarm_hours", nil)];
            }
        }
        if (minuteInterval > 0) {
            if (minuteInterval == 1) {
                timeString = [timeString stringByAppendingFormat:@"%d%@", minuteInterval, MNLocalizedString(@"alarm_minute", nil)];
            }else{
                timeString = [timeString stringByAppendingFormat:@"%d%@", minuteInterval, MNLocalizedString(@"alarm_minutes", nil)];
            }
        }else{
            timeString = [timeString stringByAppendingFormat:@"1%@", MNLocalizedString(@"alarm_minute", nil)];
        }
        
        // 3. JLToast 를 이용해 남은 시간을 적절한 표현으로 출력할 수 있게 구현
        //    NSString *alarmNotificationString = [NSString stringWithFormat:@"Alarm set for %d days %d hours %d minutes from now.", dayInterval, hourInterval, minuteInterval];
        NSString *alarmNotificationString = [NSString stringWithFormat:@"%@%@%@", MNLocalizedString(@"alarm_set_toast_part1", nil), timeString, MNLocalizedString(@"alarm_set_toast_part2", nil)];
        
        // UI관련은 메인 큐에서 돌려줌
        [NSThread sleepForTimeInterval:0.2f];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JLToast makeText:alarmNotificationString] show];
        });
    });
}

+ (void)showAlarmToast:(NSDate *)alarmDate withDelay:(CGFloat)delay {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 1. 알람 예정 시간을 일/시/분 으로 나눔
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *todayDateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
        [todayDateComponents setSecond:0];
        
        NSTimeInterval timeIntervalSinceToday = [alarmDate timeIntervalSinceDate:[calendar dateFromComponents:todayDateComponents]];
        
        //    NSLog(@"timeInterValSinceToday: %f", [self.alarmDate timeIntervalSinceDate:[NSDate date]]);
        //    NSLog(@"alarmDate: %@", [self.alarmDate description]);
        
        NSInteger dayInterval = timeIntervalSinceToday / 60 / 60 / 24;
        NSInteger hourInterval = (int)timeIntervalSinceToday / 60 / 60 % 24;
        NSInteger minuteInterval = (int)timeIntervalSinceToday / 60 % 60;
        
        //    NSLog(@"dayInterval: %d", dayInterval);
        //    NSLog(@"hourInterval: %d", hourInterval);
        //    NSLog(@"minuteInterval: %d", minuteInterval);
        
        // 2. 시간 부분 조립
        NSString *timeString = @"";
        if (dayInterval > 0) {
            if (dayInterval == 1) {
                timeString = [timeString stringByAppendingFormat:@"%d%@", dayInterval, MNLocalizedString(@"alarm_day", nil)];
            }else{
                timeString = [timeString stringByAppendingFormat:@"%d%@", dayInterval, MNLocalizedString(@"alarm_days", nil)];
            }
        }
        if (hourInterval > 0) {
            if (hourInterval == 1) {
                timeString = [timeString stringByAppendingFormat:@"%d%@", hourInterval, MNLocalizedString(@"alarm_hour", nil)];
            }else{
                timeString = [timeString stringByAppendingFormat:@"%d%@", hourInterval, MNLocalizedString(@"alarm_hours", nil)];
            }
        }
        if (minuteInterval > 0) {
            if (minuteInterval == 1) {
                timeString = [timeString stringByAppendingFormat:@"%d%@", minuteInterval, MNLocalizedString(@"alarm_minute", nil)];
            }else{
                timeString = [timeString stringByAppendingFormat:@"%d%@", minuteInterval, MNLocalizedString(@"alarm_minutes", nil)];
            }
        }else{
            timeString = [timeString stringByAppendingFormat:@"1%@", MNLocalizedString(@"alarm_minute", nil)];
        }
        
        // 3. JLToast 를 이용해 남은 시간을 적절한 표현으로 출력할 수 있게 구현
        //    NSString *alarmNotificationString = [NSString stringWithFormat:@"Alarm set for %d days %d hours %d minutes from now.", dayInterval, hourInterval, minuteInterval];
        NSString *alarmNotificationString = [NSString stringWithFormat:@"%@%@%@", MNLocalizedString(@"alarm_set_toast_part1", nil), timeString, MNLocalizedString(@"alarm_set_toast_part2", nil)];
        
        // UI관련은 메인 큐에서 돌려줌
        [NSThread sleepForTimeInterval:delay];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JLToast makeText:alarmNotificationString] show];
        });
    });
}

@end
