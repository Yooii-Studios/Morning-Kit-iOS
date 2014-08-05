//
//  MNAlarmRepeatDayOfWeekStringMaker.h
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 9..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNAlarmRepeatDayOfWeekStringMaker : NSObject

+ (NSString *)makeStringWithAlarmRepeatDayOfWeekArray:(NSMutableArray *)alarmRepeatDayOfWeek;
+ (NSString *)makeEveryRepeatStringWithRow:(NSInteger)row;

@end
