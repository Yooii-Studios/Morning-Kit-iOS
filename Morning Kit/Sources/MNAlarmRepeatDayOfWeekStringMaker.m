//
//  MNAlarmRepeatDayOfWeekStringMaker.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 9..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNAlarmRepeatDayOfWeekStringMaker.h"

@implementation MNAlarmRepeatDayOfWeekStringMaker

+ (NSString *)makeStringWithAlarmRepeatDayOfWeekArray:(NSMutableArray *)alarmRepeatDayOfWeek {
    int count = 0;
    NSString *dayChecker = @"";
    NSString *repeatString = @"";
    
    for (NSNumber* repeatDayOfWeek in alarmRepeatDayOfWeek) {
        if (repeatDayOfWeek.boolValue) {
            dayChecker = [dayChecker stringByAppendingString:[NSString stringWithFormat:@"%d", count]];
            repeatString = [repeatString stringByAppendingString:[self stringWithCount:count]];
        }
        count++;
    }
    
    // 월 ~ 금만 체크된 경우 Weekdays
    if ([dayChecker isEqualToString:@"01234"]) {
        repeatString = MNLocalizedString(@"alarm_pref_repeat_weekdays", nil); // @"Weekdays";
    }
    // 토 + 일일 경우 Weekends
    else if([dayChecker isEqualToString:@"56"]) {
        repeatString = MNLocalizedString(@"alarm_pref_repeat_weekends", nil); // @"Weekends";
    }
    // 모두일 경우 Everyday
    else if([dayChecker isEqualToString:@"0123456"]) {
        repeatString = MNLocalizedString(@"alarm_pref_repeat_everyday", nil); // @"Everyday";
    }
    // 전체 체크 해지할 경우 Never
    else if([dayChecker isEqualToString:@""]) {
        repeatString = MNLocalizedString(@"alarm_pref_repeat_never", nil); // @"Never";
    }
    

//    NSLog(@"%@", repeatString);
    
    return repeatString;
}

+ (NSString *)stringWithCount:(int)count {
    switch(count) {
        case 0:
            return [NSString stringWithFormat:@"%@ ", MNLocalizedString(@"monday", nil)];
        case 1:
            return [NSString stringWithFormat:@"%@ ", MNLocalizedString(@"tuesday", nil)];
        case 2:
            return [NSString stringWithFormat:@"%@ ", MNLocalizedString(@"wednesday", nil)];
        case 3:
            return [NSString stringWithFormat:@"%@ ", MNLocalizedString(@"thursday", nil)];
        case 4:
            return [NSString stringWithFormat:@"%@ ", MNLocalizedString(@"friday", nil)];
        case 5:
            return [NSString stringWithFormat:@"%@ ", MNLocalizedString(@"saturday", nil)];
        case 6:
            return [NSString stringWithFormat:@"%@ ", MNLocalizedString(@"sunday", nil)];
    }
    return @"";
}

+ (NSString *)makeEveryRepeatStringWithRow:(NSInteger)row {
    switch(row) {
        case 0:
            return MNLocalizedString(@"every_monday", nil);
            
        case 1:
            return MNLocalizedString(@"every_tuesday", nil);
            
        case 2:
            return MNLocalizedString(@"every_wednesday", nil);
            
        case 3:
            return MNLocalizedString(@"every_thursday", nil);
            
        case 4:
            return MNLocalizedString(@"every_friday", nil);
            
        case 5:
            return MNLocalizedString(@"every_saturday", nil);
            
        case 6:
            return MNLocalizedString(@"every_sunday", nil);
    }
    return @"";
}

@end
