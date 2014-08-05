//
//  MNDaylightSavingTimeChecker.m
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 22..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNDaylightSavingTimeChecker.h"

@implementation MNDaylightSavingTimeChecker

+ (BOOL)isTimeZoneInDaylightSavingTime:(MNTimeZone *)targetTimeZone {
    BOOL isTimeZoneInDaylightSavingTime = NO;

    if ([self checkTimeZoneInNorthAmerica:targetTimeZone.timeZoneName]) {
        isTimeZoneInDaylightSavingTime = [self checkDaylightSavingTimeInNorthAmerica:targetTimeZone.worldClockDate];
    }else if([self checkTimeZoneInEurope:targetTimeZone.timeZoneName]) {
        isTimeZoneInDaylightSavingTime = [self checkDaylightSavingTimeInEurope:targetTimeZone.worldClockDate];
    }else if([self checkTimeZoneInAustralia:targetTimeZone.timeZoneName]) {
        isTimeZoneInDaylightSavingTime = [self checkDaylightSavingTimeInAustralia:targetTimeZone.worldClockDate];
    }else if([self checkTimeZoneInSouthAmerica:targetTimeZone.timeZoneName]) {
        isTimeZoneInDaylightSavingTime = [self checkDaylightSavingTimeInSouthAmerica:targetTimeZone.worldClockDate];
    }
    
    // 테스트
//    if (isTimeZoneInDaylightSavingTime) {
//        NSLog(@"isTimeZoneInDaylightSavingTime is YES");
//    }
    return isTimeZoneInDaylightSavingTime;
}


#pragma mark - check time zone in specific area

+ (BOOL)checkTimeZoneInEurope:(NSString *)timeZoneName {
    if (([timeZoneName rangeOfString:@"Europe"].location != NSNotFound) ||
        ([timeZoneName rangeOfString:@"Romance"].location != NSNotFound) ||
        [timeZoneName rangeOfString:@"GMT"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (BOOL)checkTimeZoneInAustralia:(NSString *)timeZoneName {
    if (([timeZoneName rangeOfString:@"Cen. Australia"].location != NSNotFound) ||
        ([timeZoneName rangeOfString:@"AUS Eastern"].location != NSNotFound)) {
        return YES;        
    }
    return NO;
}

+ (BOOL)checkTimeZoneInNorthAmerica:(NSString *)timeZoneName {
    // Mexico contain
    // Pacific Standard Time equal
    // Eastern standard Time equal
    // Canada Central contain
    if ([timeZoneName isEqualToString:@"Pacific Standard Time"] ||
        [timeZoneName isEqualToString:@"Eastern Standard Time"] ||
        [timeZoneName isEqualToString:@"Central Standard Time"] ||
        [timeZoneName isEqualToString:@"Atlantic Standard Time"] ||
        [timeZoneName isEqualToString:@"Mountain Standard Time"] ||
        [timeZoneName isEqualToString:@"Alaskan Standard Time"] ||
        [timeZoneName isEqualToString:@"Hawaii-Aleutian Standard Time"] ||
        [timeZoneName isEqualToString:@"Newfoundland Standard Time"] ||
        ([timeZoneName rangeOfString:@"Canada Central"].location != NSNotFound) ||
        ([timeZoneName rangeOfString:@"Mexico"].location != NSNotFound)) {
        return YES;        
    }
    return NO;
}

+ (BOOL)checkTimeZoneInSouthAmerica:(NSString *)timeZoneName {
    // E. South America contain
    if (([timeZoneName rangeOfString:@"E. South"].location != NSNotFound)) {
         return YES;       
    }
    return NO;
}

#pragma mark - check whether target date is in daylight saving time

+ (BOOL)checkDaylightSavingTimeInEurope:(NSDate *)targetDate {
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *targetDateComponent = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit) fromDate:targetDate];
    
    // 에버노트에 정리한 로직에 따라 만듬
    if (targetDateComponent.year == 2013) {
        return [self checkTargetDate:targetDate isInStartYear:2013 withStartMonth:3 withStartDay:31 withstartHour:1 endYear:2013 endMonth:10 endDay:27 endHour:2 isNorth:YES];
    }else if(targetDateComponent.year == 2014) {
        return [self checkTargetDate:targetDate isInStartYear:2014 withStartMonth:3 withStartDay:30 withstartHour:1 endYear:2014 endMonth:10 endDay:26 endHour:2 isNorth:YES];
    }else if(targetDateComponent.year == 2015) {
        return [self checkTargetDate:targetDate isInStartYear:2015 withStartMonth:3 withStartDay:29 withstartHour:1 endYear:2015 endMonth:10 endDay:25 endHour:2 isNorth:YES];
    }else if(targetDateComponent.year == 2016) {
        return [self checkTargetDate:targetDate isInStartYear:2016 withStartMonth:3 withStartDay:27 withstartHour:1 endYear:2016 endMonth:10 endDay:30 endHour:2 isNorth:YES];
    }else if(targetDateComponent.year == 2017) {
        return [self checkTargetDate:targetDate isInStartYear:2017 withStartMonth:3 withStartDay:26 withstartHour:1 endYear:2017 endMonth:10 endDay:29 endHour:2 isNorth:YES];
    }else if(targetDateComponent.year == 2018) {
        return [self checkTargetDate:targetDate isInStartYear:2018 withStartMonth:3 withStartDay:25 withstartHour:1 endYear:2018 endMonth:10 endDay:28 endHour:2 isNorth:YES];
    }else if(targetDateComponent.year == 2019) {
        return [self checkTargetDate:targetDate isInStartYear:2019 withStartMonth:3 withStartDay:31 withstartHour:1 endYear:2019 endMonth:10 endDay:27 endHour:2 isNorth:YES];
    }

    return NO;
}

+ (BOOL)checkDaylightSavingTimeInAustralia:(NSDate *)targetDate {
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *targetDateComponent = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit) fromDate:targetDate];
    // 에버노트에 정리한 로직에 따라 만듬
    if (targetDateComponent.year == 2013) {
        return [self checkTargetDate:targetDate isInStartYear:2013 withStartMonth:10 withStartDay:6 withstartHour:3 endYear:2013 endMonth:4 endDay:7 endHour:2 isNorth:NO];
    }else if(targetDateComponent.year == 2014) {
        return [self checkTargetDate:targetDate isInStartYear:2014 withStartMonth:10 withStartDay:5 withstartHour:3 endYear:2014 endMonth:4 endDay:6 endHour:2 isNorth:NO];
    }else if(targetDateComponent.year == 2015) {
        return [self checkTargetDate:targetDate isInStartYear:2015 withStartMonth:10 withStartDay:4 withstartHour:3 endYear:2015 endMonth:4 endDay:5 endHour:2 isNorth:NO];
    }else if(targetDateComponent.year == 2016) {
        return [self checkTargetDate:targetDate isInStartYear:2016 withStartMonth:10 withStartDay:2 withstartHour:3 endYear:2016 endMonth:4 endDay:3 endHour:2 isNorth:NO];
    }else if(targetDateComponent.year == 2017) {
        return [self checkTargetDate:targetDate isInStartYear:2017 withStartMonth:10 withStartDay:1 withstartHour:3 endYear:2017 endMonth:4 endDay:2 endHour:2 isNorth:NO];
    }else if(targetDateComponent.year == 2018) {
        return [self checkTargetDate:targetDate isInStartYear:2018 withStartMonth:10 withStartDay:7 withstartHour:3 endYear:2018 endMonth:4 endDay:1 endHour:2 isNorth:NO];
    }else if(targetDateComponent.year == 2019) {
        return [self checkTargetDate:targetDate isInStartYear:2019 withStartMonth:10 withStartDay:6 withstartHour:3 endYear:2019 endMonth:4 endDay:7 endHour:2 isNorth:NO];
    }
    
    return NO;
}

+ (BOOL)checkDaylightSavingTimeInNorthAmerica:(NSDate *)targetDate {
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *targetDateComponent = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit) fromDate:targetDate];
    
    // 에버노트에 정리한 로직에 따라 만듬
    if (targetDateComponent.year == 2013) {
        return [self checkTargetDate:targetDate isInStartYear:2013 withStartMonth:3 withStartDay:10 withstartHour:2 endYear:2013 endMonth:11 endDay:3 endHour:2 isNorth:YES];
    }else if(targetDateComponent.year == 2014) {
        return [self checkTargetDate:targetDate isInStartYear:2014 withStartMonth:3 withStartDay:9 withstartHour:2 endYear:2014 endMonth:11 endDay:2 endHour:2 isNorth:YES];
    }else if(targetDateComponent.year == 2015) {
        return [self checkTargetDate:targetDate isInStartYear:2015 withStartMonth:3 withStartDay:8 withstartHour:2 endYear:2015 endMonth:11 endDay:1 endHour:2 isNorth:YES];
    }else if(targetDateComponent.year == 2016) {
        return [self checkTargetDate:targetDate isInStartYear:2016 withStartMonth:3 withStartDay:13 withstartHour:2 endYear:2016 endMonth:11 endDay:6 endHour:2 isNorth:YES];
    }else if(targetDateComponent.year == 2017) {
        return [self checkTargetDate:targetDate isInStartYear:2017 withStartMonth:3 withStartDay:12 withstartHour:2 endYear:2017 endMonth:11 endDay:5 endHour:2 isNorth:YES];
    }else if(targetDateComponent.year == 2018) {
        return [self checkTargetDate:targetDate isInStartYear:2018 withStartMonth:3 withStartDay:11 withstartHour:2 endYear:2018 endMonth:11 endDay:4 endHour:2 isNorth:YES];
    }else if(targetDateComponent.year == 2019) {
        return [self checkTargetDate:targetDate isInStartYear:2019 withStartMonth:3 withStartDay:10 withstartHour:2 endYear:2019 endMonth:11 endDay:3 endHour:2 isNorth:YES];
    }
    
    return NO;
}

+ (BOOL)checkDaylightSavingTimeInSouthAmerica:(NSDate *)targetDate {
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *targetDateComponent = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit) fromDate:targetDate];
    
    // 에버노트에 정리한 로직에 따라 만듬
    if (targetDateComponent.year == 2013) {
        return [self checkTargetDate:targetDate isInStartYear:2013 withStartMonth:10 withStartDay:20 withstartHour:0 endYear:2013 endMonth:2 endDay:17 endHour:0 isNorth:NO];
    }else if(targetDateComponent.year == 2014) {
        return [self checkTargetDate:targetDate isInStartYear:2014 withStartMonth:10 withStartDay:19 withstartHour:0 endYear:2014 endMonth:2 endDay:16 endHour:0 isNorth:NO];
    }else if(targetDateComponent.year == 2015) {
        return [self checkTargetDate:targetDate isInStartYear:2015 withStartMonth:10 withStartDay:18 withstartHour:0 endYear:2015 endMonth:2 endDay:22 endHour:0 isNorth:NO];
    }else if(targetDateComponent.year == 2016) {
        return [self checkTargetDate:targetDate isInStartYear:2016 withStartMonth:10 withStartDay:16 withstartHour:0 endYear:2016 endMonth:2 endDay:21 endHour:0 isNorth:NO];
    }else if(targetDateComponent.year == 2017) {
        return [self checkTargetDate:targetDate isInStartYear:2017 withStartMonth:10 withStartDay:15 withstartHour:0 endYear:2017 endMonth:2 endDay:19 endHour:0 isNorth:NO];
    }else if(targetDateComponent.year == 2018) {
        return [self checkTargetDate:targetDate isInStartYear:2018 withStartMonth:10 withStartDay:21 withstartHour:0 endYear:2018 endMonth:2 endDay:18 endHour:0 isNorth:NO];
    }else if(targetDateComponent.year == 2019) {
        return [self checkTargetDate:targetDate isInStartYear:2019 withStartMonth:10 withStartDay:20 withstartHour:0 endYear:2019 endMonth:2 endDay:17 endHour:0 isNorth:NO];
    }
    
    return NO;
}


#pragma mark - check target date between two dates

+ (BOOL)checkTargetDate:(NSDate *)targetDate isInStartYear:(NSInteger)startYear withStartMonth:(NSInteger)startMonth withStartDay:(NSInteger)startDay withstartHour:(NSInteger)startHour endYear:(NSInteger)endYear endMonth:(NSInteger)endMonth endDay:(NSInteger)endDay endHour:(NSInteger)endHour isNorth:(BOOL)isNorth {
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents_start = [[NSDateComponents alloc] init];
    dateComponents_start.year = startYear;
    dateComponents_start.month = startMonth;
    dateComponents_start.day = startDay;
    dateComponents_start.hour = startHour;
    NSDate *date_start = [currentCalendar dateFromComponents:dateComponents_start];
    
    NSDateComponents *dateComponents_end = [[NSDateComponents alloc] init];
    dateComponents_end.year = endYear;
    dateComponents_end.month = endMonth;
    dateComponents_end.day = endDay;
    dateComponents_end.hour = endHour;
    NSDate *date_end = [currentCalendar dateFromComponents:dateComponents_end];
    
    // 북쪽이면 시작과 끝기간 사이에 존재해야 하고, 남반구이면 시작기간 뒤이거나, 끝기간보다 일러야 함(그해 3월쯤에 끝, 10월쯤에 다시 시작)
    if (isNorth) {
        if ([targetDate timeIntervalSince1970] > [date_start timeIntervalSince1970] &&
            [targetDate timeIntervalSince1970] < [date_end timeIntervalSince1970]) {
            return YES;
        }
    } else {
        if ([targetDate timeIntervalSince1970] > [date_start timeIntervalSince1970] ||
            [targetDate timeIntervalSince1970] < [date_end timeIntervalSince1970]) {
            return YES;
        }
    }
    return NO;
}
@end
