//
//  MNAlarm.h
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 8..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MNAlarmSound;

typedef NS_ENUM(NSInteger, MNAlarmSoundType) {
    MNAlarmSoundTypeSong = 0,
    MNAlarmSoundTypeRingtone,
    MNAlarmSoundTypeVibrate,
    MNAlarmSoundTypeNone,
};

@interface MNAlarm : NSObject <NSCoding>

@property (nonatomic)           BOOL                isAlarmOn;

@property (strong, nonatomic)   NSMutableArray      *alarmRepeatDayOfWeek;
@property (strong, nonatomic)   MNAlarmSound        *alarmSound;

@property (nonatomic)           BOOL                isSnoozeOn;
//@property (nonatomic)           BOOL                isSnoozeScheduled;

@property (strong, nonatomic)   NSString*           alarmLabel;

@property (nonatomic)           NSDate              *alarmDate;

@property (nonatomic)           NSInteger           alarmID;    // 한 알람당 8개 할당. n+0번 ~ n+6번: 미반복/월(0번이 월이거나 미반복) ~ 일, n+7번: 스누즈

// 안드로이드 소스 보고 추가
@property (nonatomic)           BOOL                isRepeatOn;

// Alarm Initializer - 빈껍데기 알람 생성
+ (id)alarm;

// Alarm Start & Stop & Snooze
- (void)startAlarm;
- (void)startAlarmWithDelay:(NSNumber *)delayNumber;
- (void)startAlarmAndIsAlarmToastNeeded:(BOOL)isAlarmToastNeeded withDelay:(CGFloat)delay;
- (void)stopAlarm;
- (void)snoozeAlarm;

@end
