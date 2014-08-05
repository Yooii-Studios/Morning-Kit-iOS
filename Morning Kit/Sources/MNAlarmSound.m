//
//  MNAlarmSound.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 14..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNAlarmSound.h"
#import "MNAlarmSong.h"
#import "MNAlarmRingtone.h"

@implementation MNAlarmSound

#pragma mark - constructor

+ (MNAlarmSound *)alarmSoundWithAlarmType:(MNAlarmSoundType)alarmSoundType withAlarmSong:(MNAlarmSong *)alarmSong withAlarmRingtone:(MNAlarmRingtone *)alarmRingtone {
    MNAlarmSound *alarmSound = [[MNAlarmSound alloc] init];
    alarmSound.alarmSoundType = alarmSoundType;
    alarmSound.alarmSong = alarmSong;
    alarmSound.alarmRingtone = alarmRingtone;
    
    switch (alarmSound.alarmSoundType) {
        case MNAlarmSoundTypeSong:
            alarmSound.title = alarmSong.title;
            break;
            
        case MNAlarmSoundTypeRingtone:
            alarmSound.title = alarmRingtone.title;
            break;
            
        case MNAlarmSoundTypeVibrate:
            alarmSound.title = MNLocalizedString(@"alarm_sound_string_vibrate", @"진동"); // @"Mute";
            break;
            
        // 발생하면 안되는 조건
        case MNAlarmSoundTypeNone:
            break;
    }
    return alarmSound;
}

#pragma mark - NSCoding Delegate Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.alarmSong                              = [aDecoder decodeObjectForKey:@"alarmSong"];
        self.alarmRingtone                          = [aDecoder decodeObjectForKey:@"alarmRingtone"];
        self.alarmSoundType                         = [aDecoder decodeIntegerForKey:@"alarmSoundType"];
        self.title                                  = [aDecoder decodeObjectForKey:@"title"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:   self.alarmSong                      forKey:@"alarmSong"];
    [aCoder encodeObject:   self.alarmRingtone                  forKey:@"alarmRingtone"];
    [aCoder encodeInteger:  self.alarmSoundType                 forKey:@"alarmSoundType"];
    [aCoder encodeObject:   self.title                          forKey:@"title"];
}



@end
