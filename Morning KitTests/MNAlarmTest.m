//
//  MNAlarmTest.m
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 21..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNAlarmTest.h"
#import "MNAlarm.h"
#import "MNAlarmProcessor.h"
#import "MNDefinitions.h"

@implementation MNAlarmTest

// NSCoding 이 제대로 되었는지 테스트
- (void)testArchving {
    MNAlarm *testAlarm = [MNAlarm alarm];
    NSData *testAlarmData = [NSKeyedArchiver archivedDataWithRootObject:testAlarm];
    [[NSUserDefaults standardUserDefaults] setObject:testAlarmData forKey:@"alarmDataTest"];
    
    NSData *rebornAlarmData = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarmDataTest"];
    MNAlarm *rebornAlarm = [NSKeyedUnarchiver unarchiveObjectWithData:rebornAlarmData];
    
    STAssertNotNil(rebornAlarm.alarmRepeatDayOfWeek, nil);
    STAssertFalse(rebornAlarm.isAlarmOn, nil);
    STAssertNil(rebornAlarm.alarmSound, nil);
//    STAssertNil(rebornAlarm.alarmSong, nil);
//    STAssertNil(rebornAlarm.alarmRingtone, nil);
    STAssertTrue(rebornAlarm.isSnoozeOn, nil);
    STAssertEqualObjects(rebornAlarm.alarmLabel, @"Alarm", nil);
    STAssertNotNil(rebornAlarm.alarmDate, nil);
}

- (void)testStartAlarm {
    
    //// 1. 무반복 알람 테스트. ID도 체크 ////
    // 13시 41분으로 테스트
    // 현재 시간이 13시 41분 전이라면 오늘, 후라면 내일로 맞춰져야 한다. 이점이 가장 중요
    MNAlarm *testAlarm = [MNAlarmProcessor makeAlarmWithHour:18 withMinute:0];
    testAlarm.isRepeatOn = NO;
    [testAlarm startAlarm];
    
    UILocalNotification *nonRepeatAlarmLocalNotification = nil;
    for (UILocalNotification *alarmNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([[alarmNotification.userInfo objectForKey:@"alarmID"] isEqualToNumber:[NSNumber numberWithInteger:testAlarm.alarmID]]) {
            nonRepeatAlarmLocalNotification = alarmNotification;
        }
    }
    // alarmID로 등록된 LocalNotification이 존재해야함
    STAssertNotNil(nonRepeatAlarmLocalNotification, nil);
    
    
    //// 2. 반복 알람 테스트. ID도 같이 체크 ////
    MNAlarm *testAlarmForRepeat = [MNAlarmProcessor makeAlarmWithHour:18 withMinute:00];
    testAlarmForRepeat.isRepeatOn = YES;
    
    // 오늘이 수요일이니까 0 15 20 25 이렇게 네 개가 켜져야 한다.
    testAlarmForRepeat.alarmRepeatDayOfWeek = [NSMutableArray arrayWithObjects:
                                 [NSNumber numberWithBool:YES],         // Mon
                                 [NSNumber numberWithBool:YES],          // Tue
                                 [NSNumber numberWithBool:YES],         // Wed
                                 [NSNumber numberWithBool:YES],          // Thu
                                 [NSNumber numberWithBool:YES],          // Fri
                                 [NSNumber numberWithBool:YES],         // Sat
                                 [NSNumber numberWithBool:YES], nil];   // Sun
    [testAlarmForRepeat startAlarm];
    
    // alarmID + 0 ~ alarmID + 6를 id로 가지고 LocalNotification이 전부 존재해야함
    for (int i = 0; i < 7; i++) {
        UILocalNotification *repeatAlarmLocalNotification = nil;
        for (UILocalNotification *alarmNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            if([[alarmNotification.userInfo objectForKey:@"alarmID"] isEqualToNumber:[NSNumber numberWithInteger:testAlarmForRepeat.alarmID + i]]) {
                repeatAlarmLocalNotification = alarmNotification;
            }
        }
//        STAssertNotNil(repeatAlarmLocalNotification, nil);
    }
    
    // 현재 시간이 13시 41분 전이라면 오늘, 후라면 내일부터 반복 알람이 시작되어야 한다.
}

- (void)testStopAlarm {
    // 1. 알람을 켰다가 끈다.
    
    // 2. 켰던 알람 설정이 기기에 남아있는지 테스트 한다.
    
    // 3. 알람이 off 되어 있는지 체크한다
}

- (void)testSnoozeAlarm {
    // 특정 시간으로 알람을 하나 만들어 스누즈를 한다.
    MNAlarm *testAlarm = [MNAlarmProcessor makeAlarmWithHour:11 withMinute:11];
    testAlarm.alarmID = 100;
    
    // 검색해 alarmID + 7번으로 설정된 LocalNotification이 있는지 확인한다.
    [testAlarm snoozeAlarm];

    UILocalNotification *snoozeAlarmLocalNotification = nil;
    
    for(UILocalNotification *alarmNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([[alarmNotification.userInfo objectForKey:@"alarmID"] isEqualToNumber:[NSNumber numberWithInteger:testAlarm.alarmID + 7]]) {
            snoozeAlarmLocalNotification = alarmNotification;
        }
    }
    STAssertNotNil(snoozeAlarmLocalNotification, nil);
    
    // 있다면 시간이 NSDate 에서 ALARM_SNOOZE_SECOND 차이 만큼 나는지 확인한다. 실제로는 다음 루프때 돌아가서 1초 차이가 난다.
    STAssertEquals((int)[snoozeAlarmLocalNotification.fireDate timeIntervalSinceDate:[NSDate date]], ALARM_SNOOZE_SECOND-1, nil);
}

@end
