//
//  MNAlarmListLoadSaver.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 17..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNAlarmListProcessor.h"
#import "MNAlarm.h"
#import "MNAlarmProcessor.h"

#define ALARM_LIST_PATH @"alarmList_test"

@implementation MNAlarmListProcessor

// Singleton
+ (MNAlarmListProcessor *)sharedAlarmListProcessor {
    static MNAlarmListProcessor *instance;
    
    if (instance == nil) {
        @synchronized(self) {
            if (instance == nil) {
                instance = [[self alloc] init];
                instance.userDefaults = [NSUserDefaults standardUserDefaults];
            }
        }
    }
    return instance;
}

#pragma mark - archiving

+ (NSMutableArray *)loadAlarmList {
    NSMutableArray *alarmList;
    
    NSUserDefaults *userDefaults = [MNAlarmListProcessor sharedAlarmListProcessor].userDefaults;
    NSData *alarmListData = [userDefaults valueForKey:ALARM_LIST_PATH];
    
    // 저장해둔 알람 리스트가 없다면 빈 Array를 생성해 알람을 두 개 넣어서 반환
    if (alarmListData) {
        alarmList = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
    }else{
        alarmList = [NSMutableArray array];
        
        // 없다면 처음 실행이므로, 06:00 / 06:30 두 시간으로 알람 시간을 맞추어 추가해둔다.
        MNAlarm *alarm0630 = [MNAlarmProcessor makeAlarmWithHour:6 withMinute:30];
        MNAlarm *alarm0700 = [MNAlarmProcessor makeAlarmWithHour:7 withMinute:0];
        
        [alarmList addObject:alarm0630];
        [alarmList addObject:alarm0700];
    }
    
    return alarmList;
}

+ (void)saveAlarmList:(NSMutableArray *)alarmList {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        
//        NSData *alarmListData = [NSKeyedArchiver archivedDataWithRootObject:alarmList];
//        [userDefaults setObject:alarmListData forKey:ALARM_LIST_PATH];
//    });
    
    NSUserDefaults *userDefaults = [MNAlarmListProcessor sharedAlarmListProcessor].userDefaults;
    
    NSData *alarmListData = [NSKeyedArchiver archivedDataWithRootObject:alarmList];
    [userDefaults setObject:alarmListData forKey:ALARM_LIST_PATH];
}

#pragma mark - sorting

+ (NSMutableArray *)sortAlarmList:(NSMutableArray *)alarmList {
    
    // sorting한 것을 새로 대입할 순 없다. 기존의 alarmList에서 처리할 수 있는 수단을 강구해야함
    NSArray *sortedAlarmList = [NSArray arrayWithArray:alarmList];
    
    // sorting - 블록을 사용해 내가 원하는 방식대로 커스터마이징 - 뒤에 오는 값이 크거나 뒤의 값이면 NSOrderedDescending, 반대는 NSOrderedAscending, 같으면 NSOrderedSame
    sortedAlarmList = [sortedAlarmList sortedArrayUsingComparator:^(MNAlarm *alarmLeft, MNAlarm *alarmRight) {
        // hh:ss를 hhss 네자리 숫자로 만든다. 크기를 비교해 오름차순으로 정렬
        int alarmComparatorLeft = [MNAlarmProcessor getComparatorFromAlarmDate:alarmLeft.alarmDate];
        int alarmComparatorRight = [MNAlarmProcessor getComparatorFromAlarmDate:alarmRight.alarmDate];
        
        if (alarmComparatorLeft > alarmComparatorRight) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if(alarmComparatorLeft < alarmComparatorRight) {
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    // 기존 alarmList를 비우고 새로 넣음
    [alarmList removeAllObjects];
    for (MNAlarm* sortedAlarm in sortedAlarmList) {
        [alarmList addObject:sortedAlarm];
    }
    
    // 결과 list 반환
    return alarmList;
}

#pragma mark - finding an alarm with alarmID

+ (MNAlarm *)alarmWithAlamrID:(int)alarmID inAlarmList:(NSMutableArray *)alarmList {
    MNAlarm *specificAlarm = nil;
    
    // 반복 알람의 경우 베이스가 1이면 1~8 까지다. 그렇다면 이 alarmID가 alarm.alarmID 이상 alarm.alarmID+8 이하이면 이 알람인 것이다.
    // 24가 들어가니 32가 튀어나온다. 테스트 케이스를 세움
    for (MNAlarm* alarm in alarmList) {
        if (alarmID >= alarm.alarmID && alarmID <= alarm.alarmID + 7) {
            specificAlarm = alarm;
            break;
        }
    }
    return specificAlarm;
}

#pragma mark - alarm add & replace & remove

+ (void)addAlarm:(MNAlarm *)alarm intoAlarmList:(NSMutableArray *)alarmList {
    [alarm startAlarm];
    
    // 알람을 추가하고 소팅을 새로 해 준다.
    [alarmList addObject:alarm];
    
    alarmList = [MNAlarmListProcessor sortAlarmList:alarmList];
    
//    // 알람 아카이빙
//    [MNAlarmListProcessor saveAlarmList:alarmList];
}

+ (BOOL)replaceAlarm:(MNAlarm *)alarm atIndex:(int)index inAlarmList:(NSMutableArray *)alarmList {
    BOOL isAlarmReplaced = NO;
    
    // 순서가 제대로 삽입되는지 확인할 필요가 있음
    // index가 count를 오버해서는 안됨
    if (alarmList.count >= index) {
        isAlarmReplaced = YES;
        
        // 기존의 알람은 멈추고 새알람은 가동
        MNAlarm *alarmWillBeReplaced = [alarmList objectAtIndex:index];
        [alarmWillBeReplaced stopAlarm];
        [alarm startAlarm];
        [alarmList replaceObjectAtIndex:index withObject:alarm];
        
        // 교체될 알람의 alarmDate가 변경될 가능성이 있기 때문에 교체하고 소팅 다시 해줌
        alarmList = [MNAlarmListProcessor sortAlarmList:alarmList];
        
//        // 알람 아카이빙
//        [MNAlarmListProcessor saveAlarmList:alarmList];
    }
    
    return isAlarmReplaced;
}

+ (BOOL)removeAlarmWithAlarmID:(int)alarmID fromAlarmList:(NSMutableArray *)alarmList {
    BOOL isAlarmInAlarmList = NO;
    
    MNAlarm *alarmToRemove = [MNAlarmListProcessor alarmWithAlamrID:alarmID inAlarmList:alarmList];
    
    // 존재 할 경우에만 삭제해줌
    if (alarmToRemove != nil) {
        isAlarmInAlarmList = YES;
        
        // 모든 알람들을 전부 꺼주고 삭제하고 저장해야함
        [alarmToRemove stopAlarm];
        [alarmList removeObject:alarmToRemove];
//        [MNAlarmListProcessor saveAlarmList:alarmList];
    }
    return isAlarmInAlarmList;
}

+ (BOOL)removeAlarmAtIndex:(int)index fromAlarmList:(NSMutableArray *)alarmList {
    BOOL wasAlarmExist = NO;
    
    // index가 count를 오버해서는 안됨
    if (alarmList.count >= index) {
        wasAlarmExist = YES;
        
        MNAlarm *alarmToRemove = [alarmList objectAtIndex:index];
        [alarmToRemove stopAlarm];
        [alarmList removeObjectAtIndex:index];
//        [MNAlarmListProcessor saveAlarmList:alarmList];
    }
    return wasAlarmExist;
}

@end
