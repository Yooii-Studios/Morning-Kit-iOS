//
//  MNAlarmListLoadSaverTest.m
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 21..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNAlarmListProcessorTest.h"
#import "MNAlarmListProcessor.h"
#import "MNAlarmProcessor.h"
#import "MNAlarm.h"

@implementation MNAlarmListProcessorTest

#pragma mark - setUp and tearDown

- (void)setUp
{
    [super setUp];
    
    // Set-up code here
    // 알람이 3개가 들어있는 상태에서 시작함
    self.alarm1 = [MNAlarmProcessor makeAlarmWithHour:03 withMinute:33];
    self.alarm1.alarmID = 1000;
    
    self.alarm2 = [MNAlarmProcessor makeAlarmWithHour:22 withMinute:22];
    self.alarm2.alarmID = 2000;
    
    self.alarm3 = [MNAlarmProcessor makeAlarmWithHour:01 withMinute:11];
    self.alarm3.alarmID = 3000;
    
    self.alarmList = [NSMutableArray array];
    [self.alarmList addObject:self.alarm1];
    [self.alarmList addObject:self.alarm2];
    [self.alarmList addObject:self.alarm3];
}

- (void)tearDown
{
    // Tear-down code here.
    self.alarm1 = nil;
    self.alarm2 = nil;
    self.alarm3 = nil;
    self.alarmList = nil;
    
    [super tearDown];
}

#pragma mark - archiving

// 알람 리스트가 제대로 세이브되는지 테스트한다 - 어떤 것을 테스트 해보아야하는 걸까?
- (void)testAlarmListSave {
    // 빈 알람이 들어 있는 list 를 archive해 본다.
    // userDefault에서 다시 꺼내서 
}

// 알람 리스트가 제대로 로드되는지 테스트한다. 무조건 nil이 아니어야 한다.
- (void)testAlarmListLoad {
    NSMutableArray *alarmList = [MNAlarmListProcessor loadAlarmList];
    STAssertNotNil(alarmList, @"AlarmList must not be nil");
}

#pragma mark - finding an alarm with ID

- (void)testFindingAlarmWithAlamrID {
    // test 1: ID 가 2000인 알람을 무조건 찾을 수 있어야 한다.
    MNAlarm *alarmWithAlarmID2000 = [MNAlarmListProcessor alarmWithAlamrID:2000 inAlarmList:self.alarmList];
    STAssertNotNil(alarmWithAlarmID2000, nil);
    
    // test 2: 아래 상황에 원하지 않는 결과값이 나오길래 테스트 케이스를 추가
    // id가 32인 알람과 24인 알람이 있는데 32를 찾아라고 하면 24인 알람이 튀어나온다. 테스트 필요.
    MNAlarm *alarm1 = [MNAlarmProcessor makeAlarm];
    alarm1.alarmID = 24;
    [self.alarmList addObject:alarm1];
    
    MNAlarm *alarm2 = [MNAlarmProcessor makeAlarm];
    alarm2.alarmID = 32;
    [self.alarmList addObject:alarm2];
    
    MNAlarm *alarmToFind = [MNAlarmListProcessor alarmWithAlamrID:32 inAlarmList:self.alarmList];
    STAssertEqualObjects(alarmToFind, alarm2, nil);
}

#pragma mark - save & replace & remove

- (void)testAddAlarmIntoAlarmList {
    
    // Test
    MNAlarm *alarm4 = [MNAlarmProcessor makeAlarmWithHour:12 withMinute:53];
    alarm4.alarmID = 4000;
    
    [MNAlarmListProcessor addAlarm:alarm4 intoAlarmList:self.alarmList];
    
    // 추가하면 소팅도 자동으로 됨
    MNAlarm *lastAddedAlarm = [self.alarmList objectAtIndex:2];
    STAssertEquals((int)self.alarmList.count, 4, nil);
    STAssertEquals(lastAddedAlarm.alarmID, 4000, nil);
}

- (void)testReplaceAlarmAtIndexInAlarmList {
    
    MNAlarm *alarm4 = [MNAlarmProcessor makeAlarmWithHour:00 withMinute:11];
    alarm4.alarmID = 4000;
    
    // 3개 알람 중에 alarm2와 교체된다
    [MNAlarmListProcessor replaceAlarm:alarm4 atIndex:1 inAlarmList:self.alarmList];
    
    // 제일 빠른 시간이기에 교체하고 소팅되면 첫번째에 위치해야한다
    MNAlarm *alarmToBeReplaced = [self.alarmList objectAtIndex:0];

    STAssertEquals(alarmToBeReplaced.alarmID, 4000, nil);
    STAssertEquals((int)self.alarmList.count, 3, nil);
}

- (void)testRemoveAlarmAtIndexFromAlarmList{
    // 가운데 것을 지우고 id 1000/3000 알람이 남았는지 테스트
    [MNAlarmListProcessor removeAlarmAtIndex:1 fromAlarmList:self.alarmList];
    
    MNAlarm *firstAlarmInAlarmList = [self.alarmList objectAtIndex:0];
    MNAlarm *secondAlarmInAlarmList = [self.alarmList objectAtIndex:1];
    
    STAssertEquals(firstAlarmInAlarmList.alarmID, 1000, nil);
    STAssertEquals(secondAlarmInAlarmList.alarmID, 3000, nil);
}

- (void)testRemoveAlarmWithAlarmIDFromAlarmlist {
    // alarmID 가 2000인 알람만 지울 수 있는지 테스트
    [MNAlarmListProcessor removeAlarmWithAlarmID:2000 fromAlarmList:self.alarmList];
    
    STAssertEquals((int)self.alarmList.count, 2, nil);
}

#pragma mark - sorting

- (void)testSorting {
    
    self.alarmList = [MNAlarmListProcessor sortAlarmList:self.alarmList];
    
    STAssertEqualObjects([self.alarmList objectAtIndex:0], self.alarm3, nil);
    STAssertEqualObjects([self.alarmList objectAtIndex:1], self.alarm1, nil);
    STAssertEqualObjects([self.alarmList objectAtIndex:2], self.alarm2, nil);
}

@end
