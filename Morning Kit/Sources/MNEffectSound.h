//
//  MNEffectSound.h
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 7. 1..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MNEffectSoundStatus) {
    MNEffectSoundStatusDefault = 0, // 최초 생성시
    MNEffectSoundStatusOn = 1,
    MNEffectSoundStatusOff = 2,
};

@interface MNEffectSound : NSObject

+ (NSString *)getMNEffectSoundFromIndex:(NSInteger)index;
+ (MNEffectSoundStatus)getCurrentEffectSoundStatus;
+ (void)setEffectSoundStatus:(MNEffectSoundStatus)effectSoundStatus;

@end
