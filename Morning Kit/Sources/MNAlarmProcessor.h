//
//  MNAlarmProcessor.h
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 20..
//  Copyright (c) 2013년 Yooii. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MNAlarm;

// 알람 처리에 대한 공통적인 로직을 관리
@interface MNAlarmProcessor : NSObject

// 제대로 처리가 된 알람을 만들어준다. (ID 등)
+ (MNAlarm *)makeAlarm;

// 첫 앱 실행시 특정 시간으로 맞춰진 알람 생성 (24 hour)
+ (MNAlarm *)makeAlarmWithHour:(int)hour withMinute:(int)minute;

// 알람 on/off 를 처리하고, archive를 해 준다.
+ (void)processAlarmSwitchButtonTouchAction:(NSMutableArray *)alarmList atIndex:(int)index;

// alarmDate에서 현지 Calendar를 적용해 hh:mm을 int형 4자리 숫자 hhmm로 변환해줌
+ (int)getComparatorFromAlarmDate:(NSDate *)alarmDate;

// 첫 알람 추가시 알람 메시지 띄우기
+ (void)resetAlarmGuideMessage; // 테스트용
+ (void)checkAlarmGuideMessage;
@end
