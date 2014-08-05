//
//  MNAlarmListLoadSaver.h
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 17..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MNAlarm;

@interface MNAlarmListProcessor : NSObject

@property (strong, atomic) NSUserDefaults *userDefaults;

+ (MNAlarmListProcessor *)sharedAlarmListProcessor;

+ (NSMutableArray *)loadAlarmList;
+ (void)saveAlarmList:(NSMutableArray *)alarmList;

// 시간과 분으로 숫자를 4자리 숫자를 만들어서 비교
+ (NSMutableArray *)sortAlarmList:(NSMutableArray *)alarmList;

// 특정 ID의 알람을 찾아서 반환
+ (MNAlarm *)alarmWithAlamrID:(int)alarmID inAlarmList:(NSMutableArray *)alarmList;

// 특정 ID의 알람을 찾아서 알람을 꺼 주고 삭제해줌 - 있다면 YES 반환
+ (void)addAlarm:(MNAlarm *)alarm intoAlarmList:(NSMutableArray *)alarmList;
+ (BOOL)replaceAlarm:(MNAlarm *)alarm atIndex:(int)index inAlarmList:(NSMutableArray *)alarmList;
+ (BOOL)removeAlarmWithAlarmID:(int)alarmID fromAlarmList:(NSMutableArray *)alarmList;
+ (BOOL)removeAlarmAtIndex:(int)index fromAlarmList:(NSMutableArray *)alarmList;

@end
