//
//  MNAlarmSongsLoadSaver.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 10..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNAlarmSongsLoadSaver.h"
#import "MNAlarmSong.h"

//#define TEST_CASE 1
 #define TEST_CASE 0

#define ALARM_SONG_LIST_FILE_PATH @"songlist_test9"

@implementation MNAlarmSongsLoadSaver

// 최대 5개까지만 저장되고, 제일 이전의 것을 밀어내는 식으로 유지만 함 - 압축을 풀어 NSMutableArray로 변환
+ (NSMutableArray *)loadSongsList {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataOfSongsList = [userDefaults valueForKey:ALARM_SONG_LIST_FILE_PATH];
    NSMutableArray *songsList;
    
    // 제대로 데이터를 얻어내면 바로 리턴
    if (dataOfSongsList != nil) {
        songsList = [NSKeyedUnarchiver unarchiveObjectWithData:dataOfSongsList];
        
        if (songsList != nil) {
            return songsList;
        }
        
        return songsList;
    }
    
    // 얻지 못하면 새로 생성해서 전달
    songsList = [NSMutableArray array];
    
    // 현재는 테스트로 이름만 넣은 상태이지만, 나중에는 노래 정보를 가진 클래스로 변경하여야 할 듯.
    if (TEST_CASE) {
        MNAlarmSong *song1 = [MNAlarmSong alarmSongWithTitle:@"Lady Killer" withMediaItemCollection:nil];
        MNAlarmSong *song2 = [MNAlarmSong alarmSongWithTitle:@"I'm yours" withMediaItemCollection:nil];
        MNAlarmSong *song3 = [MNAlarmSong alarmSongWithTitle:@"Chick" withMediaItemCollection:nil];
        MNAlarmSong *song4 = [MNAlarmSong alarmSongWithTitle:@"Rice" withMediaItemCollection:nil];
        MNAlarmSong *song5 = [MNAlarmSong alarmSongWithTitle:@"Man" withMediaItemCollection:nil];
        
        [songsList addObject:song1];
        [songsList addObject:song2];
        [songsList addObject:song3];
        [songsList addObject:song4];
        [songsList addObject:song5];
    }
    
    return songsList;
}

// saveSongsList To Local - NSKeyedArchiver 를 사용해 NSData로 변환
+ (void)saveSongsListWithSongsList:(NSMutableArray *)songsList {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataOfSongsList = [NSKeyedArchiver archivedDataWithRootObject:songsList];
    [userDefaults setObject:dataOfSongsList forKey:ALARM_SONG_LIST_FILE_PATH];
}

@end
