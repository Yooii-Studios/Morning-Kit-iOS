//
//  MNAlarmSoundProcessorTest.h
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 28..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class MNAlarm;
@class AVAudioPlayer;
@class MPMusicPlayerController;

@interface MNAlarmSoundProcessorTest : SenTestCase

@property (nonatomic, strong) MNAlarm *testAlarmForRingtone;
@property (nonatomic, strong) MNAlarm *testAlarmForMusic;
@property (nonatomic, strong) AVAudioPlayer *ringtonePlayer;
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;

@end
