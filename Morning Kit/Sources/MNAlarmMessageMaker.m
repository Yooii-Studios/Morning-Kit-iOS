//
//  MNAlarmMessageMaker.m
//  Morning Kit
//
//  Created by 김우성 on 13. 6. 27..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNAlarmMessageMaker.h"

@implementation MNAlarmMessageMaker

+ (NSString *)makeAlarmMessageWithDate:(NSDate *)targetDate withLabel:(NSString *)label {
    
//    NSLog(@"%@", targetDate);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterNoStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.locale = [NSLocale currentLocale];
    NSString *timeString = [dateFormatter stringFromDate:targetDate];
//    NSLog(@"time: %@",timeString);
    
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateFormat = @"EEEE',' MMMM dd";
    NSString *dateString = [dateFormatter stringFromDate:targetDate];
    
    // 적절한 포맷으로 NSDate 변환하기
    return [NSString stringWithFormat:@"%@\n%@\n%@", label, timeString, dateString];
}

@end
