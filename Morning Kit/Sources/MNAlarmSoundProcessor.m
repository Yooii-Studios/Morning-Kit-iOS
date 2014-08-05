//
//  MNAlarmSoundHistoryLoadSaver.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 14..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNAlarmSoundProcessor.h"
#import "MNAlarmRingtone.h"
#import "MNAlarmSongValidator.h"
#import <MediaPlayer/MPMusicPlayerController.h>
#import <AVFoundation/AVFoundation.h>
#import "MNAlarmRingtone.h"
#import "MNAlarmSong.h"

#define ALARM_SOUND_HISTORY_PATH @"alarmSoundHistoryPath_test2"

@implementation MNAlarmSoundProcessor

#pragma mark - archiving

+ (void)saveAlarmSoundToHistoryWithAlarmSound:(MNAlarmSound *)alarmSound {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataOfAlarmSound = [NSKeyedArchiver archivedDataWithRootObject:alarmSound];
    [userDefaults setObject:dataOfAlarmSound forKey:ALARM_SOUND_HISTORY_PATH];
}

+ (MNAlarmSound *)loadAlarmSoundFromHistory {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataOfAlarmSound = [userDefaults valueForKey:ALARM_SOUND_HISTORY_PATH];
    MNAlarmSound *alarmSound;
    
    if (dataOfAlarmSound) {
        alarmSound = [NSKeyedUnarchiver unarchiveObjectWithData:dataOfAlarmSound];
        if (alarmSound.alarmSoundType == MNAlarmSoundTypeVibrate) {
            alarmSound.title = MNLocalizedString(@"alarm_sound_string_vibrate", nil);
        }
        // 사운드가 노래일경우 존재하는지 검증하기
        if ([MNAlarmSoundProcessor checkValidateAlarmSound:alarmSound] == NO) {
//            NSLog(@"%@ / The previously selected song is validate", [self class]);
        }
    }else{
        // 만약 첫 생성이면 마림바로 초기화해서 리턴하기
        alarmSound = [MNAlarmSoundProcessor loadDefaultAlarmSound];
    }
    return alarmSound;
}

+ (MNAlarmSound *)loadDefaultAlarmSound {
    // 만약 첫 생성이면 마림바로 초기화해서 리턴하기
    MNAlarmSound *alarmSound;
    
    MNAlarmRingtone *alarmRingtone = [MNAlarmRingtone alarmRingtoneWithTitle:@"alarm_ocean_short" withExtensionType:@"caf"];
    alarmSound = [MNAlarmSound alarmSoundWithAlarmType:MNAlarmSoundTypeRingtone withAlarmSong:nil withAlarmRingtone:alarmRingtone];
    
    return alarmSound;
}

// 알람 사운드가 재생에 유효한지 검증하고 아니라면 기본 알람 사운드 리턴
+ (BOOL)checkValidateAlarmSound:(MNAlarmSound *)alarmSound {
    if (alarmSound.alarmSoundType == MNAlarmSoundTypeSong) {
        if ([MNAlarmSongValidator isAlarmSongValidate:alarmSound.alarmSong] == NO) {
//            alarmSound = nil;
//            alarmSound = [MNAlarmSoundProcessor loadDefaultAlarmSound];
            
            return NO;
        }else {
            return YES;
        }
    }else{
        return YES;
    }
}

#pragma mark - play alarm sounds

+ (MPMusicPlayerController *)playAlarmSong:(MNAlarmSound *)alarmSound {
    MPMusicPlayerController *musicPlayer = nil;
    
#if TARGET_IPHONE_SIMULATOR
//    NSLog(@"playAlarmSong: simulator / no init musicPlayer");
#else
//    NSLog(@"playAlarmSong: device / init musicPlayer");
    if (musicPlayer == nil) {
        musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        musicPlayer.repeatMode = MPMusicRepeatModeOne;
    }
    
    // 기존 음악들 모두 삭제
    MPMediaPropertyPredicate *predicate =
    [MPMediaPropertyPredicate predicateWithValue: @"Non_Existant_Song_Name"
                                     forProperty: MPMediaItemPropertyTitle];
    MPMediaQuery *q = [[MPMediaQuery alloc] init];
    [q addFilterPredicate: predicate];
    [musicPlayer setQueueWithQuery:q];
    musicPlayer.nowPlayingItem = nil;
    
    // 새로 큐 넣고 재생
    [musicPlayer setQueueWithItemCollection:alarmSound.alarmSong.mediaItemCollection];
    musicPlayer.volume = 0.9;
    [musicPlayer play];
#endif
    return musicPlayer;
}

+ (AVAudioPlayer *)playAlarmRingtone:(MNAlarmSound *)alarmSound {
    AVAudioPlayer *ringtonePlayer = nil;
    
    MNAlarmRingtone *ringtoneToPlay = alarmSound.alarmRingtone;
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:ringtoneToPlay.resource ofType:ringtoneToPlay.extensionType]];
    ringtonePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    ringtonePlayer.volume = 0.9;
    ringtonePlayer.numberOfLoops = -1;
    [ringtonePlayer prepareToPlay];
    [ringtonePlayer play];
    
    return ringtonePlayer;
}

+ (void)stopPlayingAlarmSongWithPlayer:(MPMusicPlayerController *)musicPlayer {
    if (musicPlayer == nil) {
        // 혹시나 musicPlayer가 nil일 경우 새로 불러본다. -> 테스트는 제대로 되지 않음.
        musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    }
    
    // http://stackoverflow.com/questions/3059255/how-do-i-clear-the-queue-of-a-mpmusicplayercontroller
    // 여기서 끄는 법 배움
    MPMediaPropertyPredicate *predicate =
    [MPMediaPropertyPredicate predicateWithValue: @"Non_Existant_Song_Name"
                                     forProperty: MPMediaItemPropertyTitle];
    MPMediaQuery *q = [[MPMediaQuery alloc] init];
    [q addFilterPredicate: predicate];
    [musicPlayer setQueueWithQuery:q];
    musicPlayer.nowPlayingItem = nil;
    [musicPlayer stop];
    
//    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
//        MPMediaPropertyPredicate *predicate =
//        [MPMediaPropertyPredicate predicateWithValue: @"Non_Existant_Song_Name"
//                                         forProperty: MPMediaItemPropertyTitle];
//        MPMediaQuery *q = [[MPMediaQuery alloc] init];
//        [q addFilterPredicate: predicate];
//        [musicPlayer setQueueWithQuery:q];
//        musicPlayer.nowPlayingItem = nil;
//        [musicPlayer stop];
//    }else{
//        // http://stackoverflow.com/questions/3059255/how-do-i-clear-the-queue-of-a-mpmusicplayercontroller
//        // 여기서 끄는 법 배움
//        MPMediaPropertyPredicate *predicate =
//        [MPMediaPropertyPredicate predicateWithValue: @"Non_Existant_Song_Name"
//                                         forProperty: MPMediaItemPropertyTitle];
//        MPMediaQuery *q = [[MPMediaQuery alloc] init];
//        [q addFilterPredicate: predicate];
//        [musicPlayer setQueueWithQuery:q];
//        musicPlayer.nowPlayingItem = nil;
//        [musicPlayer stop];
//    }
}

+ (void)stopPlayingAlarmRingtoneWithPlayer:(AVAudioPlayer *)ringtonePlayer {
    if (ringtonePlayer) {
        if (ringtonePlayer.isPlaying) {
            [ringtonePlayer stop];
        }
    }
    
    // 벨소리 조정을 다시 할 수 있기 위해 아래 부분 추가
//    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
//    musicPlayer.volume = 0.7;
//    [musicPlayer play];
}

@end
