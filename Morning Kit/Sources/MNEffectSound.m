//
//  MNEffectSound.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 7. 1..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNEffectSound.h"

#define EFFECT_SOUND_STATUS_KEY @"effect_sound_status_key"

@implementation MNEffectSound

+ (NSString *)getMNEffectSoundFromIndex:(NSInteger)index {
    switch (index) {
        case MNEffectSoundStatusOn  :
            return MNLocalizedString(@"setting_effect_sound_on", @"on");
            
        case MNEffectSoundStatusOff:
            return MNLocalizedString(@"setting_effect_sound_off", @"off");
    }
    return nil;
}

+ (MNEffectSoundStatus)getCurrentEffectSoundStatus {
    int status = [[NSUserDefaults standardUserDefaults] integerForKey:EFFECT_SOUND_STATUS_KEY];
    
    if (status == MNEffectSoundStatusDefault)
        status = MNEffectSoundStatusOff;
    else if (status != MNEffectSoundStatusOff && status != MNEffectSoundStatusOn)
        status = MNEffectSoundStatusOff;
    
    return status;
}

+ (void)setEffectSoundStatus:(MNEffectSoundStatus)effectSoundStatus {
    if (effectSoundStatus != MNEffectSoundStatusOn && effectSoundStatus != MNEffectSoundStatusOff )
        effectSoundStatus = MNEffectSoundStatusOff;
    
    [[NSUserDefaults standardUserDefaults] setInteger:effectSoundStatus forKey:EFFECT_SOUND_STATUS_KEY];
}

@end
