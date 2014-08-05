//
//  MNAlarmSoundHistoryLoadSaver.h
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 14..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNAlarm.h"
#import "MNAlarmSound.h"

@class MPMusicPlayerController;
@class AVAudioPlayer;

@interface MNAlarmSoundProcessor : NSObject

+ (void)saveAlarmSoundToHistoryWithAlarmSound:(MNAlarmSound *)alarmSound;
+ (MNAlarmSound *)loadAlarmSoundFromHistory;
+ (MNAlarmSound *)loadDefaultAlarmSound;
+ (BOOL)checkValidateAlarmSound:(MNAlarmSound *)alarmSound;

// play & stop alarm sound
+ (MPMusicPlayerController *)playAlarmSong:(MNAlarmSound *)alarmSound;
+ (AVAudioPlayer *)playAlarmRingtone:(MNAlarmSound *)alarmSound;

+ (void)stopPlayingAlarmSongWithPlayer:(MPMusicPlayerController *)musicPlayer;
+ (void)stopPlayingAlarmRingtoneWithPlayer:(AVAudioPlayer *)ringtonePlayer;

@end
