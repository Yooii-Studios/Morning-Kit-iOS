//
//  MNAlarmSound.h
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 14..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNAlarm.h"

@class MNAlarmRingtone;
@class MNAlarmSong;

// MNAlarmSong과 MNAlarmRingtone, Mute 를 처리할 수 있는 클래스
@interface MNAlarmSound : NSObject <NSCoding>

@property (nonatomic, strong)   MNAlarmSong *alarmSong;
@property (nonatomic, strong)   MNAlarmRingtone *alarmRingtone;
@property (nonatomic)           MNAlarmSoundType alarmSoundType;
@property (nonatomic, strong)   NSString *title;

// constructor
+(MNAlarmSound *)alarmSoundWithAlarmType:(MNAlarmSoundType)alarmSoundType withAlarmSong:(MNAlarmSong *)alarmSong withAlarmRingtone:(MNAlarmRingtone *)alarmRingtone;

@end
