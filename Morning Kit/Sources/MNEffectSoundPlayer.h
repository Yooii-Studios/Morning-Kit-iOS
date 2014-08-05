//
//  MNEffectSoundPlayer.h
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 24..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface MNEffectSoundPlayer : NSObject

@property (strong, nonatomic) AVAudioPlayer *effectSoundPlayer;

+ (MNEffectSoundPlayer *)sharedEffectSoundPlayer;
+ (void)initAllEffectSounds;
+ (void)playEffectSoundWithName:(NSString *)soundName;

@end
