//
//  MNAlarmDateFormat.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 18..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNAlarmDateFormat.h"

@implementation MNAlarmDateFormat

+ (MNAlarmDateFormat *)alarmDateFormatWithDate:(NSDate *)date {
    MNAlarmDateFormat *alarmDateFormat = [[MNAlarmDateFormat alloc] init];
    alarmDateFormat.alarmDate = date;
    alarmDateFormat.gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *hourComponent = [alarmDateFormat.gregorianCalendar components:NSHourCalendarUnit fromDate:alarmDateFormat.alarmDate];
    NSDateComponents *minuteComponent = [alarmDateFormat.gregorianCalendar components:NSMinuteCalendarUnit fromDate:alarmDateFormat.alarmDate];
    
    // locale check - 24 hours / 12 hours
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    alarmDateFormat.isUsing24hours = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    
    // hour - 24시간제 여부를 확인한 후 체크
    alarmDateFormat.hour = [hourComponent hour];
    alarmDateFormat.hourForString = alarmDateFormat.hour;
    if (alarmDateFormat.hour == 0)
        alarmDateFormat.hourForString = 12;
    else if(alarmDateFormat.hour > 12)
        alarmDateFormat.hourForString -= 12;
    if (alarmDateFormat.isUsing24hours)
        alarmDateFormat.hourString = [NSString stringWithFormat:@"%d", alarmDateFormat.hour];
    else
        alarmDateFormat.hourString = [NSString stringWithFormat:@"%d", alarmDateFormat.hourForString];
    
    // minute
    alarmDateFormat.minute = [minuteComponent minute];
    if (alarmDateFormat.minute < 10) {
        alarmDateFormat.minuteString = [NSString stringWithFormat:@"0%d", alarmDateFormat.minute];
    }else{
        alarmDateFormat.minuteString = [NSString stringWithFormat:@"%d", alarmDateFormat.minute];
    }
    
    // common
    if (alarmDateFormat.hour < 12)
        alarmDateFormat.ampmString = MNLocalizedString(@"alarm_am", @"AM"); // @"AM";
    else
        alarmDateFormat.ampmString = MNLocalizedString(@"alarm_pm", @"PM"); // @"PM";
    alarmDateFormat.alarmTimeString = [NSString stringWithFormat:@"%@:%@", alarmDateFormat.hourString, alarmDateFormat.minuteString];
    
    return alarmDateFormat;
}

@end
