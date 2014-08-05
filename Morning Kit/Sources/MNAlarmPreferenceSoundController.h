//
//  MNAlarmPreferenceSoundController.h
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 10..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMediaPickerController.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <AVFoundation/AVFoundation.h>
#import "MNAlarm.h"
#import "MNAlarmSong.h"
#import "MNAlarmRingtone.h"

@class MNAlarmPreferenceSoundController;

@protocol MNAlarmPreferenceSoundControllerDelegate <NSObject>

//- (void)MNAlarmPreferenceSoundControllerDidDisappear:(MNAlarmPreferenceSoundController *)controller;
- (void)MNAlarmPreferenceSoundControllerDidPickSong:(MNAlarmPreferenceSoundController *)controller;
- (void)MNAlarmPreferenceSoundControllerDidPickRingtone:(MNAlarmPreferenceSoundController *)controller;
- (void)MNAlarmPreferenceSoundControllerDidPickMute:(MNAlarmPreferenceSoundController *)controller;

@end


@interface MNAlarmPreferenceSoundController : UITableViewController <MPMediaPickerControllerDelegate>

// Common
@property (strong, nonatomic)   id<MNAlarmPreferenceSoundControllerDelegate>    delegate;
@property (strong, nonatomic)   NSIndexPath                 *checkedIndexPath;
@property (nonatomic)           BOOL                        soundPlayerShouldStop;
@property (nonatomic)           MNAlarmSoundType            alarmSoundType;

// Songs
@property (strong, nonatomic)   NSMutableArray              *songsHistoryList;
@property (strong, nonatomic)   MPMusicPlayerController     *musicPlayer;
@property (strong, nonatomic)   MPMediaItemCollection       *selectedMediaItemCollection;
@property (strong, nonatomic)   MNAlarmSong                 *previousAlarmSong;     // PreferenceController 에서 prepareForSegue 에서 이전에 선택한 노래로 설정해 주는 용도로 사용 

// Ringtones
@property (strong, nonatomic)   NSMutableArray              *ringtonesList;
@property (strong, nonatomic)   AVAudioPlayer               *ringtonePlayer;
@property (strong, nonatomic)   MNAlarmRingtone             *previousAlarmRingtone;

@end
