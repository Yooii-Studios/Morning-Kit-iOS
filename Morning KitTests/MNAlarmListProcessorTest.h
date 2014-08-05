//
//  MNAlarmListLoadSaverTest.h
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 21..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class MNAlarm;

@interface MNAlarmListProcessorTest : SenTestCase

@property (nonatomic, strong) MNAlarm* alarm1;
@property (nonatomic, strong) MNAlarm* alarm2;
@property (nonatomic, strong) MNAlarm* alarm3;

@property (nonatomic, strong) NSMutableArray* alarmList;

@end
