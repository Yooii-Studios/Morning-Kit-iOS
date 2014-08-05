//
//  MNDefaultDateMaker.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 7. 3..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNDefaultDateMaker.h"

@implementation MNDefaultDateMaker

+ (NSDate *)getDefaultDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *newYearDateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    
    newYearDateComponents.year += 1;
    newYearDateComponents.month = 1;
    newYearDateComponents.day = 1;
    
    NSDate *newYearDate = [calendar dateFromComponents:newYearDateComponents];
//    NSLog(@"%@", newYearDate);
    
    return newYearDate;
}

@end
