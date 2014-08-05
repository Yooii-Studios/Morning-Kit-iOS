//
//  MNRefreshDateChecker.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 9. 13..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNRefreshDateChecker.h"

#define TARGET_YEAR 2014
#define TARGET_MOMTH 7
#define TARGET_DAY 9
#define TARGET_HOUR 0
#define TARGET_MINUTE 0

@implementation MNRefreshDateChecker

+ (BOOL)isDateOverThanLimitDate {
    // 오늘 날짜를 구하고,
    NSDate *todayDate = [NSDate date];
    
    // 캘린더에서 2013 09 24 00시 00분 00초를 만들어서,
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *targetComponents = [gregorianCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:todayDate];
    targetComponents.year = TARGET_YEAR;
    targetComponents.month = TARGET_MOMTH;
    targetComponents.day = TARGET_DAY;
    targetComponents.hour = TARGET_HOUR;
    targetComponents.minute = TARGET_MINUTE;
    targetComponents.second = 0;
    
    NSDate *targetDate = [gregorianCalendar dateFromComponents:targetComponents];
//    NSLog(@"today: %@", todayDate);
//    NSLog(@"targetDay: %@", targetDate);
    
    // 오늘과 초 비교를 해서 0 이상이면 YES를 반환
//    NSLog(@"interval: %f", [todayDate timeIntervalSinceDate:targetDate]);
    if ([todayDate timeIntervalSinceDate:targetDate] > 0) {
        return YES;
    }
    
    return NO;
}

@end
