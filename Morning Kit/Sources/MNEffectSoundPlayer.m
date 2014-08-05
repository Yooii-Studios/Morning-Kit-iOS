//
//  MNEffectSoundPlayer.m
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 24..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNEffectSoundPlayer.h"
#import "MNEffectSound.h"

@implementation MNEffectSoundPlayer

+ (MNEffectSoundPlayer *)sharedEffectSoundPlayer {
    static MNEffectSoundPlayer *instance;
    
    if (instance == nil) {
        @synchronized(self) {
            if (instance == nil) {
                instance = [[self alloc] init];
            }
        }
    }
    return instance;
}

+ (void)initAllEffectSounds {
    // AVAudioPlayer를 사용하면서 전부 주석 처리함
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([MNEffectSound getCurrentEffectSoundStatus] == MNEffectSoundStatusOn) {
            //Get the filename of the sound file:
            NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"woosh.mp3"];
            
            //declare a system sound id
            SystemSoundID soundID;
            
            //Get a URL for the sound file
            NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
            
            //Use audio sevices to create the sound
            AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(filePath), &soundID);
            
        }
    });
     */
}

+ (void)playEffectSoundWithName:(NSString *)soundName {
    
    [MNEffectSoundPlayer playEffectSoundWithNameUsingAVAudioPlayer:soundName];
    
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if ([MNEffectSound getCurrentEffectSoundStatus] == MNEffectSoundStatusOn) {
            //Get the filename of the sound file:
            NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], soundName];
            
            //declare a system sound id
            SystemSoundID soundID;
            
            //Get a URL for the sound file
            NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
            
            //Use audio sevices to create the sound
            AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(filePath), &soundID);
            
            //Use audio services to play the sound
            AudioServicesPlaySystemSound(soundID);
        }
    });
     */
}

+ (void)playEffectSoundWithNameUsingAVAudioPlayer:(NSString *)soundName {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([MNEffectSound getCurrentEffectSoundStatus] == MNEffectSoundStatusOn) {
            //Get the filename of the sound file:
//            NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], soundName];
            //Get a URL for the sound file
//            NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
            
            // 새로운 방식
//            NSURL *soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:soundName ofType:@"mp3"]];
            NSURL *soundPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:soundName ofType:@"mp3"]];
            
//            NSLog(@"%@", soundPath.description);
//            if ([MNEffectSoundPlayer sharedEffectSoundPlayer].effectSoundPlayer == nil) {
//                [MNEffectSoundPlayer sharedEffectSoundPlayer].effectSoundPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
//            }
            [MNEffectSoundPlayer sharedEffectSoundPlayer].effectSoundPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
            [[MNEffectSoundPlayer sharedEffectSoundPlayer].effectSoundPlayer setDelegate:nil];
            [[MNEffectSoundPlayer sharedEffectSoundPlayer].effectSoundPlayer prepareToPlay];
            [[MNEffectSoundPlayer sharedEffectSoundPlayer].effectSoundPlayer play];
        }
    });
}

@end
