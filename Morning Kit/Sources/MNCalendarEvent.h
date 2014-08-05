//
//  MNCalendarEvent.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 9. 28..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNCalendarEvent : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *startDate;
@property (nonatomic) BOOL isBirthDayEvent;
@property (nonatomic) BOOL isAllday;

@end
