//
//  MNAlarmSoundProcessorTest.m
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 28..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNAlarmSoundProcessorTest.h"
#import "MNAlarmSoundProcessor.h"
#import "MNAlarmProcessor.h"
#import "MNAlarm.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation MNAlarmSoundProcessorTest

- (void)setUp {
    
    // 벨소리 테스트용 알람 초기화
    self.testAlarmForRingtone = [MNAlarmProcessor makeAlarmWithHour:23 withMinute:55];
    self.testAlarmForRingtone.alarmSound = [MNAlarmSoundProcessor loadDefaultAlarmSound];
    
    // 음악 테스트용 알람 초기화
    self.testAlarmForMusic = [MNAlarmProcessor makeAlarmWithHour:22 withMinute:55];
    self.testAlarmForMusic.alarmSound = [MNAlarmSoundProcessor loadAlarmSoundFromHistory];
    
    [super setUp];
}

- (void)tearDown {
    
    self.testAlarmForRingtone = nil;
    self.testAlarmForMusic = nil;
    self.ringtonePlayer = nil;
    self.musicPlayer = nil;
    
    [super tearDown];
}

#pragma mark - play & stop alarm sounds

- (void)testStartAlarmRingtone {
    
    self.ringtonePlayer = [MNAlarmSoundProcessor playAlarmRingtone:self.testAlarmForRingtone.alarmSound];
    
    STAssertEquals(self.testAlarmForMusic.alarmSound.alarmSoundType, MNAlarmSoundTypeRingtone, nil);
    STAssertNotNil(self.testAlarmForRingtone.alarmSound, nil);
    STAssertNotNil(self.testAlarmForRingtone.alarmSound.alarmRingtone, nil);
    STAssertNotNil(self.ringtonePlayer, nil);
    STAssertTrue(self.ringtonePlayer.isPlaying, nil);
}

- (void)testStartAlarmSong {
    
    // 시뮬레이터에서는 MPMusicPlayerController 관련 테스트가 힘들다.
    /*
    self.musicPlayer = [MNAlarmSoundProcessor playAlarmSong:self.testAlarmForMusic.alarmSound];
    
    STAssertEquals(self.testAlarmForMusic.alarmSound.alarmSoundType, MNAlarmSoundTypeSong, nil);
    STAssertNotNil(self.testAlarmForMusic.alarmSound, nil);
    STAssertNotNil(self.testAlarmForMusic.alarmSound.alarmSong, nil);
    STAssertNotNil(self.musicPlayer, nil);
    STAssertEquals([self.musicPlayer playbackState], MPMusicPlaybackStatePlaying, nil);
    */
}

- (void)testStopPlayingAlarmRingtone {
    
    [MNAlarmSoundProcessor stopPlayingAlarmRingtoneWithPlayer:self.ringtonePlayer];
    STAssertTrue(!self.ringtonePlayer.isPlaying, nil);
}

- (void)testStopPlayingAlarmSong {
    
}

@end
