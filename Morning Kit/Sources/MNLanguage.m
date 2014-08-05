//
//  MNLanguage.m
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 19..
//  Copyright (c) 2013년 Yooii. All rights reserved.
//

#import "MNLanguage.h"

@implementation MNLanguage

#define DEVICE_LANGUAGE @"deviceLanguage"

+ (NSString *)getCurrentLanguage {
    // 받기 전에 체크를 한 번 해줌
    [MNLanguage checkCurrentLanguage];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger languageType = [userDefaults integerForKey:@"languageType"];

    return [MNLanguage languageCodeStringAtIndex:languageType];
}

+ (void)checkCurrentLanguage {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:DEVICE_LANGUAGE] == nil) {
        // 이전에 디바이스 언어를 저장해두지 않았다면 백업
        NSString* deviceLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
//        NSLog(@"deviceLanguage: %@", deviceLanguage);
        
        // 기기의 언어가 앱에서 지원하는 언어가 아니라면 디바이스 & 앱 언어를 영어(en)으로 설정
        if ([self isThisLanguageSupportedInThisApp:deviceLanguage] == NO)
            deviceLanguage = @"en";

        // 기기 언어 코드 백업
        [userDefaults setObject:deviceLanguage forKey:DEVICE_LANGUAGE];
    
        // 앱 언어 코드 설정
        NSArray *languages = [NSArray arrayWithObject:deviceLanguage];
        [userDefaults setObject:languages forKey:@"AppleLanguages"];
        
        // 앱 언어 타입(NSInteger) 설정
        NSInteger languageType = [MNLanguage getLanguageIndexFromCodeString:deviceLanguage];
        [userDefaults setInteger:languageType forKey:@"languageType"];
        
        [userDefaults synchronize];
    }
//    NSInteger languageType = [userDefaults integerForKey:@"languageType"];
//    NSLog(@"languageType: %d", languageType);
    
    /*
    if (languageType == MNLanguageTypeDefault) {
        // 기본 언어 설정일 때는 기기에 설정된 언어로 치환
        NSString* deviceLanguage = [userDefaults objectForKey:DEVICE_LANGUAGE];
        NSArray *languages = [NSArray arrayWithObject:deviceLanguage];
        [userDefaults setObject:languages forKey:@"AppleLanguages"];
        [userDefaults synchronize];
    }
     */
}

+ (BOOL)isThisLanguageSupportedInThisApp:(NSString *)deviceLanugage {
    if ([deviceLanugage isEqualToString:@"en"] || [deviceLanugage isEqualToString:@"ko"] || [deviceLanugage isEqualToString:@"ja"] || [deviceLanugage isEqualToString:@"zh-Hans"] || [deviceLanugage isEqualToString:@"zh-Hant"] || [deviceLanugage isEqualToString:@"ru"]) {
        return YES;
    }
    return NO;
}

# pragma mark - for MNConfigureSettingsLanguageController 

+ (NSString *)languageCodeStringAtIndex:(int)index {
    NSString *languageCodeString = @"";
    
    switch (index) {
        case 0:
            languageCodeString = @"en";
            break;
            
        case 1:
            languageCodeString = @"ko";
            break;
            
        case 2:
            languageCodeString = @"ja";
            break;
            
        case 3:
            languageCodeString = @"zh-Hans";
            break;
            
        case 4:
            languageCodeString = @"zh-Hant";
            break;
            
        case 5:
            languageCodeString = @"ru";
            break;
            
        default: {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString* deviceLanguage = [userDefaults objectForKey:DEVICE_LANGUAGE];
            languageCodeString = deviceLanguage;
            break;
        }
    }
    return languageCodeString;
}

+ (NSInteger)getLanguageIndexFromCodeString:(NSString *)codeString {
    if ([codeString isEqualToString:@"en"]) {
        return 0;
    }else if([codeString isEqualToString:@"ko"]) {
        return 1;
    }else if([codeString isEqualToString:@"ja"]) {
        return 2;
    }else if([codeString isEqualToString:@"zh-Hans"]) {
        return 3;
    }else if([codeString isEqualToString:@"zh-Hant"]) {
        return 4;
    }else if([codeString isEqualToString:@"ru"]) {
        return 5;
    }else{
        return 0;
    }
}

+ (NSString *)languageStringFromCodeString:(NSString *)codeString {
    NSString *localizedLanguageName = @"";
    if ([codeString isEqualToString:@"en"]) {
        localizedLanguageName = MNLocalizedString(@"setting_language_english", "English");
    }else if([codeString isEqualToString:@"ko"]) {
        localizedLanguageName = MNLocalizedString(@"setting_language_korean", "Korean");
    }else if([codeString isEqualToString:@"ja"]) {
        localizedLanguageName = MNLocalizedString(@"setting_language_japanese", "Japan");
    }else if([codeString isEqualToString:@"zh-Hans"]) {
        localizedLanguageName = MNLocalizedString(@"setting_language_simplified_chinese", "Simplified Chinese, 간체");
    }else if([codeString isEqualToString:@"zh-Hant"]) {
        localizedLanguageName = MNLocalizedString(@"setting_language_traditional_chinese", "Traditional Chinese, 번체");
    }else if([codeString isEqualToString:@"ru"]) {
        localizedLanguageName = MNLocalizedString(@"setting_language_russian", "Russian, 러시아어");
    }else{
        localizedLanguageName = MNLocalizedString(@"setting_language_default_language", "Default Language");
    }
    
    return localizedLanguageName;
}

+ (void)setLocalizedTitleLabel:(UILabel *)titleLabel withSummaryLabel:(UILabel *)summaryLabel AtIndex:(int)index {
    switch (index) {
        case 0:
            titleLabel.text = MNLocalizedString(@"setting_language_english", @"영어");
            summaryLabel.text = @"English";
            break;
            
        case 1:
            titleLabel.text = MNLocalizedString(@"setting_language_korean", @"한국어");
            summaryLabel.text = @"Korean";
            break;
            
        case 2:
            titleLabel.text = MNLocalizedString(@"setting_language_japanese", @"일본어");
            summaryLabel.text = @"Japanese";
            break;
            
        case 3:
            titleLabel.text = MNLocalizedString(@"setting_language_simplified_chinese", @"중국어(간체)");
            summaryLabel.text = @"Chinese (Simplified)";
            break;
            
        case 4:
            titleLabel.text = MNLocalizedString(@"setting_language_traditional_chinese", @"중국어(번체)");
            summaryLabel.text = @"Chinese (Traditional)";
            break;
            
        case 5:
            titleLabel.text = MNLocalizedString(@"setting_language_russian", "Russian, 러시아어");
            summaryLabel.text = @"Russian";
            break;
            
        default:
            titleLabel.text = MNLocalizedString(@"setting_language_default_language", @"기본 언어");
            summaryLabel.text = @"Default Language";
            break;   
    }
}

@end
