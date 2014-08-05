//
//  MNAlarmProcessorTest.m
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 21..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNAlarmProcessorTest.h"
#import "MNAlarm.h"
#import "MNAlarmSound.h"
#import "MNAlarmProcessor.h"
#import "MNAlarmSongValidator.h"

@implementation MNAlarmProcessorTest

#pragma mark - setUp & tearDown

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

#pragma mark - making alarm

- (void)testMakeAlarm {
    
    MNAlarm *testAlarm = [MNAlarmProcessor makeAlarm];
    
    // 알람 ID를 제대로 할당
    if (testAlarm.alarmID == -1) {
        STFail(@"alarmID is not allocated properly");
    }
    
    // 제대로 된 사운드 타입이 적용되었는지 테스트
    if (testAlarm.alarmSound.alarmSoundType == MNAlarmSoundTypeNone) {
        STFail(@"wrong alarmSoundType");
    }else{
        switch (testAlarm.alarmSound.alarmSoundType) {
            case MNAlarmSoundTypeVibrate:
                NSLog(@"Alarm sound type: Mute");
                break;
                
            case MNAlarmSoundTypeRingtone:
                NSLog(@"Alarm sound type: Ringtone");
            break;
        
            case MNAlarmSoundTypeSong:
                NSLog(@"Alarm sound type: Song");
                break;
                
            default:
                break;
        }
        NSLog(@"Alarm sound title: %@", testAlarm.alarmSound.title);
    }
    
    // 제대로 된 사운드 리소스가 대입되어 있는지 테스트
    if (testAlarm.alarmSound.alarmSoundType == MNAlarmSoundTypeSong) {
        STAssertTrue([MNAlarmSongValidator isAlarmSongValidate:testAlarm.alarmSound.alarmSong], nil);
    }
}

- (void)testMakeAlarmWithHourAndMinute {
    
    // 한국 시간 기준 오후 1시 41분으로 테스트
    MNAlarm *testAlarm = [MNAlarmProcessor makeAlarmWithHour:13 withMinute:41];
    
    // NSDate의 hour 와 minute가 올해/이번달/오늘/ 13:41 으로 제대로 나오는지 테스트
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                    fromDate:[NSDate date]];
    
    NSDateComponents *alarmComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit)
                                                    fromDate:testAlarm.alarmDate];
    
    // 오늘과 일치하는지
    STAssertEquals([alarmComponents year], [todayComponents year], nil);
    STAssertEquals([alarmComponents month], [todayComponents month], nil);
    STAssertEquals([alarmComponents day], [todayComponents day], nil);
    STAssertEquals([alarmComponents hour], 13, nil);
    STAssertEquals([alarmComponents minute], 41, nil);
}

#pragma mark - setUp & tearDown

- (void)testGetComparatorFromAlarmDate {
    // 현지 시간의 calendar에서 hh:mm 을 얻어내어 4자리 숫자로 반들어 반환하는 것을 테스트
    MNAlarm *alarm1 = [MNAlarmProcessor makeAlarmWithHour:03 withMinute:15];
    int alarm1Comparator = [MNAlarmProcessor getComparatorFromAlarmDate:alarm1.alarmDate];
    
    STAssertEquals(alarm1Comparator, 315, nil);
    
    MNAlarm *alarm2 = [MNAlarmProcessor makeAlarmWithHour:11 withMinute:55];
    int alarm2Comparator = [MNAlarmProcessor getComparatorFromAlarmDate:alarm2.alarmDate];
    
    STAssertEquals(alarm2Comparator, 1155, nil);
}

@end
