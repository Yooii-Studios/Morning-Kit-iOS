//
//  MNAlarmDateFormat.h
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 18..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <Foundation/Foundation.h>

// 알람 리스트 테이블에서 스트링 처리를 할 때 사용하는 메서드를 클래스로 묶음.
@interface MNAlarmDateFormat : NSObject

@property (strong, nonatomic) NSDate *alarmDate;
@property (strong, nonatomic) NSCalendar *gregorianCalendar;

// hour
@property (nonatomic) NSInteger hour;
@property (nonatomic) NSInteger hourForString;
@property (strong, nonatomic) NSString *hourString;

// minute
@property (nonatomic) NSInteger minute;
@property (strong, nonatomic) NSString *minuteString;

// common
@property (strong, nonatomic) NSString *ampmString;
@property (strong, nonatomic) NSString *alarmTimeString;
@property (nonatomic) BOOL isUsing24hours;

// constructor
+ (MNAlarmDateFormat *)alarmDateFormatWithDate:(NSDate *)date;

// methods
- (NSInteger)hour;
- (NSInteger)hourForString;        // 한 자리 숫자를 처리한 숫자.
- (NSString *)hourString;

- (NSInteger)minute;
- (NSString *)minuteString;

- (NSString *)ampmString;

@end
