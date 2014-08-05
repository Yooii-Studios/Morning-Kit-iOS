//
//  MNAlarm.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 8..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNAlarm.h"
#import "MNAlarmToast.h"
#import "MNDefinitions.h"
#import "MNAlarmSound.h"
#import "MNAlarmProcessor.h"

@implementation MNAlarm

#pragma mark - Alarm Initialize

#define LOCAL_NOTIF_SOUND_NAME @"alarm_ocean_short.caf"
#define LOCAL_NOTIF_BLANK_SOUND_NAME @"blank_0_5.caf"
#define LOCAL_NOTIF_SOUND_INTERVAL 26
#define LOCAL_NOTIF_VIBRATE_INTERVAL 3
//#define LOCAL_NOTIF_SOUND_NAME @"ItWillRain.m4r"

+ (id)alarm {
    MNAlarm *alarm = [[MNAlarm alloc] init];
    
    [alarm initAlarmRepeatDayOfWeek];
    
    alarm.isAlarmOn = NO;
    
//    alarm.alarmSong = nil;
//    alarm.alarmRingtone = nil;
//    alarm.alarmSoundType = MNAlarmSoundTypeNone;
    alarm.alarmSound = nil;
    
    alarm.isSnoozeOn = YES;
//    alarm.isSnoozeScheduled = NO;
    
    // 수정 기본 알람 보여주기 관련
//    alarm.alarmLabel = MNLocalizedString(@"alarm_default_label", @"Alarm"); // @"Alarm";
    alarm.alarmLabel = @"Alarm";
    
    alarm.alarmDate = [NSDate dateWithTimeIntervalSinceNow:60];
    
    alarm.alarmID = -1;
    
    return alarm;
}

- (void)initAlarmRepeatDayOfWeek {
    self.alarmRepeatDayOfWeek = [NSMutableArray arrayWithObjects:
                                 [NSNumber numberWithBool:NO],          // Mon
                                 [NSNumber numberWithBool:NO],          // Tue
                                 [NSNumber numberWithBool:NO],          // Wed
                                 [NSNumber numberWithBool:NO],          // Thu
                                 [NSNumber numberWithBool:NO],          // Fri
                                 [NSNumber numberWithBool:NO],          // Sat
                                 [NSNumber numberWithBool:NO], nil];    // Sun
}


#pragma mark - Alarm Start & Stop

// AlarmToast 를 실행하지 않을 수도 있음
- (void)startAlarmAndIsAlarmToastNeeded:(BOOL)isAlarmToastNeeded withDelay:(CGFloat)delay {
//    NSLog(@"startAlarm");
    
    self.isAlarmOn = YES;
    
    // 1. 알람은 오늘을 기준으로 시작이므로, 기존 알람의 년/월/일을 오늘로 맞춘다. 시간/분은 유지
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayDateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
    
    NSDateComponents *alarmDateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:self.alarmDate];
    
    [alarmDateComponents setYear:todayDateComponents.year];
    [alarmDateComponents setMonth:todayDateComponents.month];
    [alarmDateComponents setDay:todayDateComponents.day];
    
    // 2. 현재 시간과 비교해서 알람 시간이 빠르면 내일로, 느리면 오늘 그대로 둔다. 그리고 alarmDate를 새로 생성한다.
    //    NSLog(@"%@", [todayDateComponents description]);
    //    NSLog(@"%@", [alarmDateComponents description]);
    
    self.alarmDate = [calendar dateFromComponents:alarmDateComponents];
    if ([self.alarmDate timeIntervalSinceNow] <= 0) {
        self.alarmDate = [self.alarmDate dateByAddingTimeInterval:24 * 60 * 60];
    }
//    NSLog(@"%@", self.alarmDate);
    
    // 3. 반복 여부에 따라 다른 방법으로 알람 예약
    if (self.isRepeatOn == NO) {
        // 3-1. 반복이 없다면 id: n+0 을 세팅한다 - JLToast로 예정시각 알림
        [self startNonRepeatAlarmAndIsAlarmToastNeeded:isAlarmToastNeeded withDelay:delay];
    }else{
        // 3-2. 반복이 있다면 id: n+0 ~ n+6 까지 체크해서 알람을 예약한다 - 제일 첫 알람만 JLToast로 예정시각 알림
        [self startRepeatAlarmsAndIsAlarmToastNeeded:isAlarmToastNeeded withDelay:delay];
    }
}

// 아무 조건 없이 실행하면 AlarmToast를 실행
- (void)startAlarm {
    [MNAlarmProcessor checkAlarmGuideMessage];
    [self startAlarmAndIsAlarmToastNeeded:YES withDelay:0];
}

- (void)startAlarmWithDelay:(NSNumber *)delayNumber {
    [self startAlarmAndIsAlarmToastNeeded:YES withDelay:delayNumber.floatValue];
}

- (void)startNonRepeatAlarmAndIsAlarmToastNeeded:(BOOL)isAlarmToastNeeded withDelay:(CGFloat)delay {
    
    // 알람을 반복해 1분을 채우고, 1분 동안 알람 계속 재생
    for (int i=0; i<5; i++) {
        // Init LocalNotification
        UILocalNotification *alarmNotification = [UILocalNotification new];
        if (self.alarmSound.alarmSoundType == MNAlarmSoundTypeVibrate) {
            alarmNotification.fireDate = [self.alarmDate dateByAddingTimeInterval:LOCAL_NOTIF_VIBRATE_INTERVAL * i];
        }else{
            alarmNotification.fireDate = [self.alarmDate dateByAddingTimeInterval:LOCAL_NOTIF_SOUND_INTERVAL * i];
        }
        alarmNotification.hasAction = YES;
        if ([self.alarmLabel isEqualToString:@"Alarm"]) {
            alarmNotification.alertBody = MNLocalizedString(@"alarm_default_label", nil);
        }else{
            alarmNotification.alertBody = self.alarmLabel;
        }
//        alarmNotification.alertBody = self.alarmLabel;
        alarmNotification.alertAction = MNLocalizedString(@"open", nil);
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//            alarmNotification.soundName = UILocalNotificationDefaultSoundName;
            alarmNotification.soundName = LOCAL_NOTIF_SOUND_NAME;
        }else{
            alarmNotification.soundName = LOCAL_NOTIF_SOUND_NAME;
        }
        if (self.alarmSound.alarmSoundType == MNAlarmSoundTypeVibrate) {
            alarmNotification.soundName = LOCAL_NOTIF_BLANK_SOUND_NAME;
        }
        alarmNotification.repeatInterval = NSYearCalendarUnit; // 이것이 있으면 한번 알림이 온뒤 없어지지는 않는데, 없으면 바로 삭제된다.
        
        NSNumber *alarmID = [NSNumber numberWithInteger:self.alarmID + i];
//        NSLog(@"alarmID: %d", alarmID.integerValue);
        NSDictionary *alarmInfoDict = [NSDictionary dictionaryWithObject:alarmID forKey:@"alarmID"];
        alarmNotification.userInfo = alarmInfoDict;
        
        // Register Local Notification
        [[UIApplication sharedApplication] scheduleLocalNotification:alarmNotification];
    }
    
    // AlarmToast
    if (isAlarmToastNeeded) {
        [MNAlarmToast showAlarmToast:self.alarmDate withDelay:delay];
    }
}

- (void)startRepeatAlarmsAndIsAlarmToastNeeded:(BOOL)isAlarmToastNeeded withDelay:(CGFloat)delay {
    
    // 제일 가까운 시간만 알림 AlarmToast
    BOOL wasFirstAlarmSet = NO;
    
    // 오늘 요일을 구한다
    NSDateComponents *alarmDateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self.alarmDate];
    // 일 = 1  ~  토 = 7
//    NSLog(@"%d", alarmDateComponents.weekday);
    
    // alarmID + 0 ~ alarmID + 6 까지 설정해줌. alarmID + 7은 스누즈용
    for (int i=0; i<=6; i++) {
        
        // 오늘 weekday 숫자를 가지고 같은 요일의 알람 반복 설정 여부를 alarmRepeatDayOfWeek 에서 얻어냄
        // 월 = 0 ~ 일 = 6으로 환산하기위해 index에 2를 빼 주고, -값이면 7을 더해준다.
        int translatedRepeatDayOfWeekIndex = alarmDateComponents.weekday - 2 + i;
        if (translatedRepeatDayOfWeekIndex < 0) {
            translatedRepeatDayOfWeekIndex += 7;
        }else if(translatedRepeatDayOfWeekIndex >= 7) {
            translatedRepeatDayOfWeekIndex -= 7;
        }
        NSNumber *alarmRepeatDayOfWeekOn = [self.alarmRepeatDayOfWeek objectAtIndex:translatedRepeatDayOfWeekIndex];
        
        if ([alarmRepeatDayOfWeekOn boolValue] == YES) {
            UILocalNotification *alarmNotification = [UILocalNotification new];

            // 반복 알람도 마찬가지로 무한으로 노티피케이션 울릴 수 있게 구현. 12초 * 5번을 무한반복
            for (int j=0; j<5; j++) {
                // 첫 울림 날짜부터 하루씩 더해준다 + 1분을 5개로 나누어 무한반복 노티피케이션 만든다.
                NSTimeInterval addingTimeInterval;
                if (self.alarmSound.alarmSoundType == MNAlarmSoundTypeVibrate) {
                    addingTimeInterval = (ALARM_REPEAT_OFFSET * i) + (LOCAL_NOTIF_VIBRATE_INTERVAL * j);
                }else{
                    addingTimeInterval = (ALARM_REPEAT_OFFSET * i) + (LOCAL_NOTIF_SOUND_INTERVAL * j);
                }
                alarmNotification.fireDate = [NSDate dateWithTimeInterval:addingTimeInterval sinceDate:self.alarmDate];
//                NSLog(@"%@", [alarmNotification.fireDate descriptionWithLocale:[NSLocale systemLocale]]);
                
                // AlarmToast 실행
                if (wasFirstAlarmSet == NO && isAlarmToastNeeded) {
                    [MNAlarmToast showAlarmToast:alarmNotification.fireDate withDelay:delay];
                    wasFirstAlarmSet = YES;
                }
                
                alarmNotification.hasAction = YES;

                if ([self.alarmLabel isEqualToString:@"Alarm"]) {
                    alarmNotification.alertBody = MNLocalizedString(@"alarm_default_label", nil);
                }else{
                    alarmNotification.alertBody = self.alarmLabel;
                }
//                alarmNotification.alertBody = self.alarmLabel;
                alarmNotification.alertAction = MNLocalizedString(@"open", nil);
                
                // Sound
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//                    alarmNotification.soundName = UILocalNotificationDefaultSoundName;
                    alarmNotification.soundName = LOCAL_NOTIF_SOUND_NAME;
                }else{
                    alarmNotification.soundName = LOCAL_NOTIF_SOUND_NAME;
                }
                if (self.alarmSound.alarmSoundType == MNAlarmSoundTypeVibrate) {
                    alarmNotification.soundName = LOCAL_NOTIF_BLANK_SOUND_NAME;
                }
                
                alarmNotification.repeatInterval = NSYearCalendarUnit;
                
                NSNumber *alarmID = [NSNumber numberWithInteger:self.alarmID + i];
//                NSLog(@"alarmID: %d", alarmID.integerValue);
                NSDictionary *alarmInfoDict = [NSDictionary dictionaryWithObject:alarmID forKey:@"alarmID"];
                alarmNotification.userInfo = alarmInfoDict;
                
                // Register Local Notification
                [[UIApplication sharedApplication] scheduleLocalNotification:alarmNotification];
            }
        }
    }
}

- (void)stopAlarm {
    // 테스트
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ALARM_GUIDE_MESSAGE_USED];
    
//    NSLog(@"stopAlarm");
    
    // 알람도 끄고 스누즈도 같이 끈다.
    self.isAlarmOn = NO;
//    self.isSnoozeScheduled = NO;
    
    // 현재 알람의 id로 notification 을 체크할 수 있는 방법을 찾아낸다.
    // alarmID+0 ~ alarmID+7(스누즈용) notification 을 다 찾아서 전부 꺼 준다.
    for (int i=0; i<=7; i++) {
        UILocalNotification *notificationToCancel = nil;
        for(UILocalNotification *alarmNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            if([[alarmNotification.userInfo objectForKey:@"alarmID"] isEqualToNumber:[NSNumber numberWithInteger:self.alarmID + i]]) {
//                NSLog(@"alarmID to cancel notification: %d", self.alarmID + i);
                notificationToCancel = alarmNotification;
                [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
            }
        }
    }
    
    // 테스트 시에는 꺼져있는 것이 확실한지 테스트한다.
}

- (void)snoozeAlarm {
//    NSLog(@"snoozeAlarm");
//    self.isSnoozeScheduled = YES;
    
    // alarmID + 7 을 세팅한다
    
    // Init LocalNotification
    UILocalNotification *alarmNotification = [UILocalNotification new];
    // 누른 직후로 부터 9분 후
    alarmNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:ALARM_SNOOZE_SECOND];
    alarmNotification.hasAction = YES;
    if ([self.alarmLabel isEqualToString:@"Alarm"]) {
        alarmNotification.alertBody = MNLocalizedString(@"alarm_default_label", nil);
    }else{
        alarmNotification.alertBody = self.alarmLabel;
    }
    alarmNotification.alertAction = MNLocalizedString(@"open", nil);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        alarmNotification.soundName = UILocalNotificationDefaultSoundName;
        alarmNotification.soundName = LOCAL_NOTIF_SOUND_NAME;
    }else{
        alarmNotification.soundName = LOCAL_NOTIF_SOUND_NAME;
    }
    if (self.alarmSound.alarmSoundType == MNAlarmSoundTypeVibrate) {
        alarmNotification.soundName = LOCAL_NOTIF_BLANK_SOUND_NAME;
    }
    alarmNotification.repeatInterval = NSYearCalendarUnit;
    
    NSNumber *alarmID = [NSNumber numberWithInteger:self.alarmID + 7];
    NSDictionary *alarmInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:alarmID, @"alarmID", @YES, @"isSnoozeAlarm", nil];
    alarmNotification.userInfo = alarmInfoDict;
    
    // Register Local Notification
    [[UIApplication sharedApplication] scheduleLocalNotification:alarmNotification];
    
    // AlarmToast
    [MNAlarmToast showAlarmToast:alarmNotification.fireDate withDelay:0.5];
//    [MNAlarmToast showAlarmToastWithNoBlock:alarmNotification.fireDate];
}

#pragma mark - NSCoding Delegate Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.isAlarmOn                      = [aDecoder decodeBoolForKey:@"isAlarmOn"];
        self.alarmRepeatDayOfWeek           = [aDecoder decodeObjectForKey:@"alarmRepeatDayOfWeek"];
        self.alarmSound                     = [aDecoder decodeObjectForKey:@"alarmSound"];
        self.isSnoozeOn                     = [aDecoder decodeBoolForKey:@"alarmSnoozeOn"];
//        self.isSnoozeScheduled              = [aDecoder decodeBoolForKey:@"alarmSnoozeSchedulded"];
        self.alarmLabel                     = [aDecoder decodeObjectForKey:@"alarmLabel"];
        self.alarmDate                      = [aDecoder decodeObjectForKey:@"alarmDate"];
        self.alarmID                        = [aDecoder decodeIntegerForKey:@"alarmID"];
        self.isRepeatOn                     = [aDecoder decodeBoolForKey:@"isRepeatOn"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:     self.isAlarmOn              forKey:@"isAlarmOn"];
    [aCoder encodeObject:   self.alarmRepeatDayOfWeek   forKey:@"alarmRepeatDayOfWeek"];
    [aCoder encodeObject:   self.alarmSound             forKey:@"alarmSound"];
    [aCoder encodeBool:     self.isSnoozeOn             forKey:@"alarmSnoozeOn"];
//    [aCoder encodeBool:     self.isSnoozeScheduled      forKey:@"alarmSnoozeSchedulded"];
    [aCoder encodeObject:   self.alarmLabel             forKey:@"alarmLabel"];
    [aCoder encodeObject:   self.alarmDate              forKey:@"alarmDate"];
    [aCoder encodeInteger:  self.alarmID                forKey:@"alarmID"];
    [aCoder encodeBool:     self.isRepeatOn             forKey:@"isRepeatOn"];
}

@end
