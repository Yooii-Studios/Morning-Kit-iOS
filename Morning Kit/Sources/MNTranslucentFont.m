//
//  MNTranslucentFont.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 7. 2..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNTranslucentFont.h"

#define TRANCELUCENT_FONT_TYPE @"translucentFontType"

@implementation MNTranslucentFont

+ (MNTranslucentFontType)getCurrentFontType {
    NSInteger fontType = [[NSUserDefaults standardUserDefaults] integerForKey:TRANCELUCENT_FONT_TYPE];
    
    // 기본 설정은 추후 수정이 용이하게 해둠. 화이트가 기본
    if (fontType == MNTranslucentFontTypeDefault) {
        fontType = MNTranslucentFontTypeWhite;
        [[NSUserDefaults standardUserDefaults] setInteger:fontType forKey:TRANCELUCENT_FONT_TYPE];
    }
    
    return fontType;
}

// 검은색 -> 흰색, 흰색 -> 검은색으로 변경
+ (void)toggleFontType {
    // 이 메서드가 호출되기 전에는 무조건 폰트 타입은 화이트 아니면 블랙임. 앱이 시작되면 위 체크를 항상 먼저 해주기 때문.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger fontType = [userDefaults integerForKey:TRANCELUCENT_FONT_TYPE];
    
    if (fontType == MNTranslucentFontTypeWhite) {
        fontType = MNTranslucentFontTypeBlack;
    }else{
        fontType = MNTranslucentFontTypeWhite;
    }
    
    [userDefaults setInteger:fontType forKey:TRANCELUCENT_FONT_TYPE];
}

@end
