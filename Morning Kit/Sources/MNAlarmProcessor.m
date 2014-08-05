//
//  MNAlarmProcessor.m
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 20..
//  Copyright (c) 2013년 Yooii. All rights reserved.
//

#import "MNAlarmProcessor.h"
#import "MNAlarm.h"
#import "MNAlarmListProcessor.h"
#import "MNAlarmSound.h"
#import "MNAlarmSoundProcessor.h"
#import "MNAlarmSongValidator.h"
#import "MNAlarmRingtone.h"

#define ALARM_GUIDE_MESSAGE_USED @"alarm_guide_message_used"

@implementation MNAlarmProcessor

#pragma mark - making an alarm

+ (MNAlarm *)makeAlarm {
    MNAlarm *newAlarm = [MNAlarm alarm];
    
    // alarmID //
    // 1. alarmID를 뽑아냄. 첫 숫자 0부터 8씩 증가
    NSInteger alarmIDCounter = [self getAlarmIDCounter];
    
    // 2. 제대로된 alarmID 대입
    newAlarm.alarmID = alarmIDCounter;
//    NSLog(@"alarmID : %d", newAlarm.alarmID);
    
    // 3. 기존에 선택되었던 사운드 로딩 - 없다면 기본 사운드 대입함. 이 사운드 검증은 MNAlarmSoundProcessor에서
    newAlarm.alarmSound = [MNAlarmSoundProcessor loadAlarmSoundFromHistory];
    
    return newAlarm;
}

// 첫 앱 실행시 특정 시간으로 맞춰진 알람 생성 (24 hour)
+ (MNAlarm *)makeAlarmWithHour:(int)hour withMinute:(int)minute {
    MNAlarm *newAlarm = [MNAlarmProcessor makeAlarm];
    
    // NSDate 설정 - 오늘 날짜의 특정 hour:minute 에 해당하는 NSDate 생성
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:[NSDate date]];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:0];
    
    newAlarm.alarmDate = [calendar dateFromComponents:components];
    
    return newAlarm;
}

#pragma mark - alarm switch handler

// 알람 on/off 를 처리하고, archive를 해 준다.
+ (void)processAlarmSwitchButtonTouchAction:(NSMutableArray *)alarmList atIndex:(int)index {
    MNAlarm *alarm = [alarmList objectAtIndex:index];
    if (alarm.isAlarmOn == YES) {
        [alarm stopAlarm];
    }else{
        [alarm startAlarm];
    }
    [MNAlarmListProcessor saveAlarmList:alarmList];
}

#pragma mark - alarm counter

+ (NSInteger)getAlarmIDCounter {
    NSInteger alarmIDCounter = 0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults integerForKey:@"AlarmIDCounter"]) {
        [defaults setInteger:0 forKey:@"AlarmIDCounter"];
    }else{
        alarmIDCounter = [defaults integerForKey:@"AlarmIDCounter"];
    }
    alarmIDCounter += 8;
    [defaults setInteger:alarmIDCounter forKey:@"AlarmIDCounter"];
    
    return alarmIDCounter;
}

#pragma mark - alarm comparator from alarmDate

+ (int)getComparatorFromAlarmDate:(NSDate *)alarmDate {
    int alarmComparator = -1;
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *alarmDateComponents = [currentCalendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:alarmDate];
    
    // hhmm 방식으로 표시가 필요
    // 이 방식으로 표기를 할 경우 무조건 높은 숫자가 뒤로 가면 됨
    alarmComparator = 100 * alarmDateComponents.hour + alarmDateComponents.minute;
    
    /*
    NSString *hourString;
    NSString *minuteString;
     
    if (alarmDateComponents.hour < 10) {
        hourString = [NSString stringWithFormat:@"0%d", alarmDateComponents.hour];
    }else{
        hourString = [NSString stringWithFormat:@"%d", alarmDateComponents.hour];
    }
    
    if (alarmDateComponents.minute < 10) {
        minuteString = [NSString stringWithFormat:@"0%d", alarmDateComponents.minute];
    }else{
        minuteString = [NSString stringWithFormat:@"%d", alarmDateComponents.minute];
    }
    alarmComparator = [[NSString stringWithFormat:@"%@%@", hourString, minuteString] intValue];
    */
    
//    NSLog(@"alarmComparator: %d", alarmComparator);
    
    return alarmComparator;
}

#pragma mark - alarm guide message
+ (void)resetAlarmGuideMessage {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ALARM_GUIDE_MESSAGE_USED];
}

+ (void)checkAlarmGuideMessage {
    // 처음으로 알람을 켜는 경우는 안내 메시지를 따로 표시해 준다.
    if ([[NSUserDefaults standardUserDefaults] boolForKey:ALARM_GUIDE_MESSAGE_USED] == NO) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ALARM_GUIDE_MESSAGE_USED];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", nil) message:MNLocalizedString(@"alarm_first_on_notice", nil) delegate:nil cancelButtonTitle:MNLocalizedString(@"ok", nil) otherButtonTitles:nil, nil] show];
        });
    }
}

@end
