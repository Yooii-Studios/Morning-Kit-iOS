//
//  MNAlarmRingtonesLoadSaver.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 10..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNAlarmRingtonesLoadSaver.h"
#import "MNAlarmRingtone.h"

//#define TEST_CASE 1
 #define TEST_CASE 0

@implementation MNAlarmRingtonesLoadSaver

+ (NSMutableArray *)loadRingtonesList {
    NSMutableArray *ringtonesList = [NSMutableArray array];
    
    // 현재는 테스트로 이름만 넣은 상태이지만, 나중에는 노래 정보를 가진 클래스로 변경하여야 할 듯.
    if (TEST_CASE) {
        [ringtonesList addObject:@"Marimba"];
        [ringtonesList addObject:@"Tumba"];
        [ringtonesList addObject:@"Marine"];
        [ringtonesList addObject:@"Heart"];
        [ringtonesList addObject:@"Seasaw"];
    }else{
        
        // 일단 테스트로 3개 넣어봄.
//        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Marimba" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"alarm_ocean_short" withExtensionType:@"caf"]];
//        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"alarm_ride" withExtensionType:@"mp3"]];
        // 용량 줄이기 위해서 모두 삭제
        /*
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Alarm" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Ascending" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Bark" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Bell Tower" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Blues" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Boing" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Crickets" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Digital" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Doorbell" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Duck" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Harp" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Motorcycle" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Old Car Horn" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Old Phone" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Piano Riff" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Pinball" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Robot" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Sci-Fi" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Sonar" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Strum" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Timba" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Time Passing" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Trill" withExtensionType:@"mp3"]];
        [ringtonesList addObject:[MNAlarmRingtone alarmRingtoneWithTitle:@"Xylophone" withExtensionType:@"mp3"]];
         */
    }
    
    return ringtonesList;
}

@end
