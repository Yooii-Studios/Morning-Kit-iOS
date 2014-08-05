//
//  MNTheme.m
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 20..
//  Copyright (c) 2013년 Yooii. All rights reserved.
//

#import "MNTheme.h"
#import "MNTranslucentFont.h"
#import "MNDefinitions.h"

@implementation MNTheme

#pragma mark - singleton

+ (MNTheme *)sharedTheme; {
    static MNTheme *instance;
    
    if (instance == nil) {
        @synchronized(self) {
            if (instance == nil) {
                instance = [[self alloc] init];
                [instance loadCurrnetThemeFromBundle];
                instance.archivedOriginalThemeType = instance.currentlySelectedThemeType;
                instance.isThemeForConfigure = NO;
                
                // MNTheme 변경을 감지할 필요가 있음
                [[MNTheme sharedTheme] addObserver:instance forKeyPath:@"currentlySelectedThemeType" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            }
        }
    }
    return instance;
}


#pragma mark - archive/load theme 

- (void)loadCurrnetThemeFromBundle {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 첫 로딩인지 확인하기
    if ([userDefaults boolForKey:@"isThemeInitiated"]) {
        self.currentlySelectedThemeType = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentTheme"];
    }else{
        // 첫 로딩이면 클래식 화이트로 로딩
        [userDefaults setBool:YES forKey:@"isThemeInitiated"];
        self.currentlySelectedThemeType = MNThemeTypeClassicWhite;
        [MNTheme changeCurrentThemeTo:self.currentlySelectedThemeType];
    }
    
//    NSLog(@"%@", self.description);
}

/*
- (void)loadArchivedOriginalThemeFromBundle {
    self.archivedOriginalThemeType = [[NSUserDefaults standardUserDefaults] integerForKey:@"temporarilySelectedThemeType"];
    
//    NSLog(@"%@", self.description);
}
*/

#pragma mark - converting theme for main/configure
+ (void)setThemeForConfigure {
    [MNTheme sharedTheme].isThemeForConfigure = YES;
}

+ (void)setThemeForMain {
    [MNTheme sharedTheme].isThemeForConfigure = NO;
}

#pragma mark - get/set theme

+ (MNThemeType)getCurrentlySelectedTheme {
//    return [MNTheme getIndexFromTheme:[MNTheme sharedTheme].currentlySelectedThemeType];
    return [MNTheme sharedTheme].currentlySelectedThemeType;
}

+ (MNThemeType)getArchivedOriginalThemeType {
//    return [MNTheme getIndexFromTheme:[MNTheme sharedTheme].archivedOriginalThemeType];
    return [MNTheme sharedTheme].archivedOriginalThemeType;
}

// 업데이트 할 경우에도 호환을 지켜주기 위해서 구현
+ (MNThemeType)getThemeFromIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return MNThemeTypeWaterLily;
            
        case 1:
            return MNThemeTypeScenery;
            
        case 2:
            return MNThemeTypeMirror;
            
        case 3:
            return MNThemeTypePhoto;
            
        case 4:
            return MNThemeTypeClassicWhite;
            
        case 5:
            return MNThemeTypeClassicGray;
            
        case 6:
            return MNThemeTypeSkyBlue;
    }
    return MNThemeTypeWaterLily;
}

// 업데이트 할 경우에도 호환을 지켜주기 위해서 구현
+ (NSInteger)getIndexFromTheme:(MNThemeType)themeType {
    switch (themeType) {
        case MNThemeTypeWaterLily:
            return 0;
            
        case MNThemeTypeScenery:
            return 1;
            
        case MNThemeTypeMirror:
            return 2;
            
        case MNThemeTypePhoto:
            return 3;
            
        case MNThemeTypeClassicWhite:
            return 4;
            
        case MNThemeTypeClassicGray:
            return 5;
            
        case MNThemeTypeSkyBlue:
            return 6;
    }
    return 0;
}

+ (void)changeCurrentThemeTo:(MNThemeType)selectedTheme {
    [[NSUserDefaults standardUserDefaults] setInteger:selectedTheme forKey:@"currentTheme"];
    
    // 선택 중, 저장된 테마 타입 일괄적으로 변경해줌
    [MNTheme sharedTheme].currentlySelectedThemeType = selectedTheme;
}

+ (void)archiveCurrentTheme:(MNThemeType)selectedTheme {
    [MNTheme sharedTheme].archivedOriginalThemeType = selectedTheme;
    [[NSUserDefaults standardUserDefaults] setInteger:selectedTheme forKey:@"temporarilySelectedThemeType"];
}


#pragma mark - alarm image resources

// 구현이 안 된 지금은 기본 클래식 테마 리소스 스트링을 반환
+ (NSString *)getAlarmSwitchOffResourceName {

    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                return @"alarm_off_classic_white";
            }
            if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                return @"alarm_off_translucent_white";
            }else{
                return @"alarm_off_translucent_black";
            }
            
        case MNThemeTypeWaterLily:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                return @"alarm_off_classic_white";
            }else{
                return @"alarm_off_translucent_black";
            }
            
        case MNThemeTypeClassicGray:
            return @"alarm_off_classic_gray";
            
        case MNThemeTypeClassicWhite:
            return @"alarm_off_classic_white";
            
        case MNThemeTypeSkyBlue:
            return @"alarm_off_skyblue";
    }
    
    return @"alarm_off_classic_gray";
}

+ (NSString *)getAlarmSwitchOnResourceName {
//    MNTheme *currentTheme = [MNTheme getInstance];
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                return @"alarm_on_classic_white";
            }
            if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                return @"alarm_on_translucent";
            }else{
                return @"alarm_on_translucent_black";
            }
            
        case MNThemeTypeWaterLily:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                return @"alarm_on_classic_white";
            }else{
                return @"alarm_on_translucent_black";
            }
            
        case MNThemeTypeClassicGray:
            return @"alarm_on_classic_gray";
            
        case MNThemeTypeClassicWhite:
            return @"alarm_on_classic_white";
            
        case MNThemeTypeSkyBlue:
            return @"alarm_on_skyblue";
    }
    
    return @"alarm_on_classic_gray";
}

+ (NSString *)getAlarmDividingBarResourceName {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                return @"dividing_bar_on_classic_white";
            }
            if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                return @"dividing_bar_on_translucent";
            }else{
                return @"dividing_bar_on_translucent_black";
            }
            
        case MNThemeTypeWaterLily:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                return @"dividing_bar_on_classic_white";
            }else{
                return @"dividing_bar_on_translucent_black";
            }
            break;
            
        case MNThemeTypeClassicGray:
            return @"dividing_bar_on_skyblue";
            
        case MNThemeTypeClassicWhite:
            return @"dividing_bar_on_classic_white";
            
        case MNThemeTypeSkyBlue:
            return @"dividing_bar_off_skyblue";
    }
    
    return @"dividing_bar_on_skyblue";
}

+ (NSString *)getAlarmDividingBarOnResourceName {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                return @"dividing_bar_on_classic_white";
            }
            if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                return @"dividing_bar_on_translucent";
            }else{
                return @"dividing_bar_on_translucent_black";
            }       
            
            
        case MNThemeTypeWaterLily:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                return @"dividing_bar_on_classic_white";
            }else{
                return @"dividing_bar_on_translucent_black";
            }
            
        case MNThemeTypeClassicGray:
            return @"dividing_bar_on_skyblue";
            
        case MNThemeTypeClassicWhite:
            return @"dividing_bar_on_classic_white";
            
        case MNThemeTypeSkyBlue:
            return @"dividing_bar_on_skyblue";
    }
    
    return @"dividing_bar_on_skyblue";
}

+ (NSString *)getAlarmDividingBarOffResourceName {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                return @"dividing_bar_off_classic_white";
            }
            if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                return @"dividing_bar_off_translucent_white";
            }else{ 
                return @"dividing_bar_off_translucent_black";
            }
            
            
        case MNThemeTypeWaterLily:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                return @"dividing_bar_off_classic_white";
            }else{
                return @"dividing_bar_off_translucent_black";
            }
            
        case MNThemeTypeClassicGray:
            break;
            
        case MNThemeTypeClassicWhite:
            return @"dividing_bar_off_classic_white";
            
        case MNThemeTypeSkyBlue:
            return @"dividing_bar_off_skyblue";
    }
    
    return @"dividing_bar_gray_s3";
}


+ (NSString *)getAlarmPlusResourceName {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                return @"plus_classic_white";
            }
            if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                return @"plus_translucent_white";
            }else{
                return @"plus_translucent_black";
            }
            
        case MNThemeTypeWaterLily:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                return @"plus_classic_white";
            }else{
                return @"plus_translucent_black";
            }
            
        case MNThemeTypeClassicGray:
            break;
            
        case MNThemeTypeClassicWhite:
            return @"plus_classic_white";
            
        case MNThemeTypeSkyBlue:
            return @"plus_skyblue";
    }
    
    return @"icon_plus_s3";
}


#pragma mark - world clock image resouce

+ (NSString *)getWorldClockAMBaseResourceName {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                return @"clock_base_am_classic_grey";
            }else{
                return @"clock_base_pm_classic_white";
            }
            
        case MNThemeTypeWaterLily:
            return @"clock_base_pm_classic_white";
            
        case MNThemeTypeClassicGray:
            return @"clock_base_am_classic_grey";
            
        case MNThemeTypeSkyBlue:
            return @"clock_base_am_skyblue";
            
        case MNThemeTypeClassicWhite:
            return @"clock_base_am_classic_white";
    }
    return @"m_clock_01_base";
}

+ (NSString *)getWorldClockPMBaseResourceName {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                return @"clock_base_am_classic_grey";
            }else{
                return @"clock_base_pm_classic_white";
            }
            
        case MNThemeTypeWaterLily:
            return @"clock_base_pm_classic_white";
            
        case MNThemeTypeClassicGray:
            return @"clock_base_pm_classic_grey";
            
        case MNThemeTypeSkyBlue:
            return @"clock_base_pm_skyblue";
            
        case MNThemeTypeClassicWhite:
            return @"clock_base_pm_classic_white";
    }
    return @"m_clock_01_base_pm";
}

+ (NSString *)getWorldClockHourHandResourceName:(NSString *)AMPM {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite)
                return @"m_clock_02_hour_hand";
            else
            {
//                if ([AMPM isEqualToString:@"PM"])
                    return @"m_clock_02_hour_hand_classic_white";
//                else if([AMPM isEqualToString:@"AM"])
//                    return @"m_clock_02_hour_hand_classic_white_am";
            }
            
        case MNThemeTypeWaterLily:
            return @"m_clock_02_hour_hand_classic_white";
            
        case MNThemeTypeClassicWhite:
            if ([AMPM isEqualToString:@"PM"])
                return @"m_clock_02_hour_hand_classic_white";
            else if([AMPM isEqualToString:@"AM"])
                return @"m_clock_02_hour_hand_classic_white_am";
            
        case MNThemeTypeClassicGray:
        case MNThemeTypeSkyBlue:
            return @"m_clock_02_hour_hand";
    }
    
    return @"m_clock_02_hour_hand";
}

+ (NSString *)getWorldClockMinuteHandResourceName:(NSString *)AMPM {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite)
                return @"m_clock_03_minute_hand";
            else
            {
//                if ([AMPM isEqualToString:@"PM"])
                    return @"m_clock_03_minute_hand_classic_white";
//                else if([AMPM isEqualToString:@"AM"])
//                    return @"m_clock_03_minute_hand_classic_white_am";
            }
            
        case MNThemeTypeWaterLily:
            return @"m_clock_03_minute_hand_classic_white";
            
        case MNThemeTypeClassicWhite:
            if ([AMPM isEqualToString:@"PM"])
                return @"m_clock_03_minute_hand_classic_white";
            else if([AMPM isEqualToString:@"AM"])
                return @"m_clock_03_minute_hand_classic_white_am";
            
        case MNThemeTypeClassicGray:
        case MNThemeTypeSkyBlue:
            return @"m_clock_03_minute_hand";
    }
    
    return @"m_clock_03_minute_hand";
}

+ (NSString *)getWorldClockSecondHandResourceName:(NSString *)AMPM {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite)
                return @"m_clock_04_second_hand";
            else
            {
//                if ([AMPM isEqualToString:@"PM"])
                    return @"m_clock_04_second_hand_classic_white";
//                else if([AMPM isEqualToString:@"AM"])
//                    return @"m_clock_04_second_classic_white_am";
            }
            
        case MNThemeTypeWaterLily:
            return @"m_clock_04_second_hand_classic_white";

        case MNThemeTypeClassicWhite:
            if ([AMPM isEqualToString:@"PM"])
                return @"m_clock_04_second_hand_classic_white";
            else if([AMPM isEqualToString:@"AM"])
                return @"m_clock_04_second_classic_white_am";
            
        case MNThemeTypeClassicGray:
        case MNThemeTypeSkyBlue:
            return @"m_clock_04_second_hand";
    }
    
    return @"m_clock_04_second_hand";
}


#pragma mark - main image resources

+ (NSString *)getRefreshButtonResourceName {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
            return @"refresh_translucent";
            
        case MNThemeTypeClassicGray:
            break;
            
        case MNThemeTypeClassicWhite:
            return @"refresh_classic_white";
            
        case MNThemeTypeSkyBlue:
            return @"refresh_skyblue";
            
    }
    return @"icon_refresh_off_s3";
}

+ (NSString *)getConfigureButtonResourceName {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
            return @"setting_translucent";
            
        case MNThemeTypeClassicGray:
            break;
            
        case MNThemeTypeClassicWhite:
            return @"setting_classic_white";
            
        case MNThemeTypeSkyBlue:
            return @"setting_skyblue";
            
    }
    return @"icon_setting_off_s3";
}

+ (NSString *)getKeyboardHideButtonResourceName {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
        case MNThemeTypeClassicWhite:
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                return @"hide_icon_white";
            }else{
                return @"hide_icon";
            }
            
        case MNThemeTypeClassicGray:
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                return @"hide_icon_grey";
            }else{
                return @"hide_icon";
            }
            
        case MNThemeTypeSkyBlue:
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                return @"hide_icon_skyblue";
            }else{
                return @"hide_icon";
            }
            
    }
    return @"hide_icon";
}


#pragma mark - Setting Resources

+ (NSString *)getCheckImageResourceName {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
        case MNThemeTypeClassicWhite:
            return @"check_classic_white";
            
        case MNThemeTypeClassicGray:
            return @"check_classic_gray";
            
        case MNThemeTypeSkyBlue:
            return @"check_classic_gray";
    }
    return @"check_classic_gray";
}


#pragma mark - Locker Image Resource

+ (NSString *)getSettingLockerImageResourceName {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
        case MNThemeTypeClassicWhite:
            return @"theme_lock_icon_classic_white";
            
        case MNThemeTypeClassicGray:
        case MNThemeTypeSkyBlue:
            return @"theme_lock_icon_classic_gray";
    }
    return @"theme_lock_icon_classic_white";
}

+ (NSString *)getWidgetLockerImageResourceName {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
        case MNThemeTypeClassicWhite:
            return @"widget_lock_icon_classic_white";
            
        case MNThemeTypeClassicGray:
            return @"widget_lock_icon_classic_gray";
            
        case MNThemeTypeSkyBlue:
            return @"widget_lock_icon_skyblue";
    }
    return @"widget_lock_icon_classic_gray";
}


#pragma mark - Background UIColor

+ (UIColor *)getBackwardBackgroundUIColor {
    
    UIColor *backwardBackgroundColor = RGB(51, 51, 51);
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                backwardBackgroundColor = UIColorFromHexCode(0xe8e8e8);
                break;
            }
            backwardBackgroundColor = RGBA(255, 255, 255, 0);
            break;
            
        case MNThemeTypeClassicGray:
            break;
            
        case MNThemeTypeClassicWhite:
            backwardBackgroundColor = UIColorFromHexCode(0xe8e8e8);
            break;
            
        case MNThemeTypeSkyBlue:
            // 초기는 똑같은 색에 그림자만 씌우는 식이었음.
//            backwardBackgroundColor = UIColorFromHexCode(0x01afd2);
            // 지금은 약간 색 바꿔줌
//            backwardBackgroundColor = UIColorFromHexCode(0x0596b3);
            // 포토샵에서 색 약간 맞춰줌
            backwardBackgroundColor = UIColorFromHexCode(0x049ebd);
            break;
    }
    return backwardBackgroundColor;
}

+ (UIColor *)getForwardBackgroundUIColor {
    
    UIColor *forwardBackgroundColor = RGB(67, 67, 67);
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                forwardBackgroundColor = UIColorFromHexCode(0xe8e8e8);
                break;
            }
//            forwardBackgroundColor = RGBA(255, 255, 255, 0.3f);
            forwardBackgroundColor = RGBA(255, 255, 255, 0.1f);
            break;
            
        case MNThemeTypeClassicGray:
            break;
            
        case MNThemeTypeClassicWhite:
            forwardBackgroundColor = UIColorFromHexCode(0xe8e8e8);
            break;
            
        case MNThemeTypeSkyBlue:
            forwardBackgroundColor = UIColorFromHexCode(0x01afd2);
            break;
    }
    return forwardBackgroundColor;
}

+ (UIColor *)getTouchedBackgroundUIColor {
    
    UIColor *touchedbackgroundColor = RGB(161, 161, 161);
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                touchedbackgroundColor = UIColorFromHexCode(0xdcdcdc);
                break;
            }
            touchedbackgroundColor = RGBA(255, 255, 255, 0.5);
            break;
            
        case MNThemeTypeClassicGray:
            break;
            
        case MNThemeTypeClassicWhite:
            touchedbackgroundColor = UIColorFromHexCode(0xdcdcdc);
            break;
            
        case MNThemeTypeSkyBlue:
            // 가현이가 새로 정함
//            TouchedbackgroundColor = UIColorFromHexCode(0x0596b3);
            touchedbackgroundColor = UIColorFromHexCode(0x03a3c3);
            break;
    }
    return touchedbackgroundColor;
}

+ (UIColor *)getLockedBackgroundUIColor {
    UIColor *lockedBackgroundColor = RGB(255, 255, 255);
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
        case MNThemeTypeClassicWhite:
            lockedBackgroundColor = UIColorFromHexCode(0xcfcfcf);
            break;
            
        case MNThemeTypeClassicGray:
            lockedBackgroundColor = UIColorFromHexCode(0x343434);
            break;
            
        case MNThemeTypeSkyBlue:
            lockedBackgroundColor = UIColorFromHexCode(0x0091ae);
            break;
    }
    return lockedBackgroundColor;
}

+ (UIColor *)getButtonBackgroundUIColor {
    UIColor *buttonBackgroundUIColor = RGB(51, 51, 51);
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
        case MNThemeTypeClassicWhite:
        case MNThemeTypeClassicGray:
            return buttonBackgroundUIColor;
            
        case MNThemeTypeSkyBlue:
            buttonBackgroundUIColor = UIColorFromHexCode(0x049ebd);
            break;
    }
    return buttonBackgroundUIColor;
}

+ (UIColor *)getSelectedWidgetBackgroundUIColor
{
    UIColor *color;
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
        case MNThemeTypeClassicWhite:
            color = UIColorFromHexCode(0xffffff);
            break;
            
        case MNThemeTypeClassicGray:
            color = UIColorFromHexCode(0x5b5b5b);
            break;
        case MNThemeTypeSkyBlue:
            color = UIColorFromHexCode(0x21c8ea);
            break;
            
        default:
            break;
    }
    
    return color;
}

+ (UIColor *)getAlarmPrefBackgroundUIColor {
    return UIColorFromHexCode(0xe8e8e8);
}

+ (UIColor *)getAlarmPrefSeperateLineUIColor {
    return UIColorFromHexCode(0xcccccc);
}

+ (UIColor *)getNavigationBarTintBackgroundColor_iOS7 {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
        case MNThemeTypeClassicWhite:
        case MNThemeTypeClassicGray:
            return UIColorFromHexCode(0x252525);
            
        case MNThemeTypeSkyBlue:
            return UIColorFromHexCode(0x016d85);
            
        default:
            return UIColorFromHexCode(0x252525);
    }
}

+ (UIColor *)getNavigationTintColor_iOS7 {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
        case MNThemeTypeClassicWhite:
        case MNThemeTypeClassicGray:
            return nil; // [UIColor clearColor]; // UIColorFromHexCode(0x0180f5);
            
        case MNThemeTypeSkyBlue:
            return UIColorFromHexCode(0x25f1c3);
            
        default:
            return nil; // [UIColor clearColor]; // UIColorFromHexCode(0x0180f5);
    }
}

+ (UIColor *)getSwitchTintColorInModalController {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeSkyBlue:
        case MNThemeTypeClassicGray:
            return [UIColor whiteColor];
            
        case MNThemeTypeClassicWhite:
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
            return UIColorFromHexCode(0xA2A2A2);
            
        default:
            return [UIColor whiteColor];
    }
}

/*
+ (UIColor *)getConfigureBackwardBackgroundUIColor {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeClassicGray:
            return RGB(51, 51, 51);
            
        case MNThemeTypeSkyBlue:
            return [self getBackwardBackgroundUIColor];
            
        case MNThemeTypeClassicWhite:
            return [self getBackwardBackgroundUIColor];
    }
}

+ (UIColor *)getConfigureForwardBackgroundUIColor {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeClassicGray:
            return RGB(67, 67, 67);
            
        case MNThemeTypeSkyBlue:
            return [self getBackwardBackgroundUIColor];
            
        case MNThemeTypeClassicWhite:
            return [self getBackwardBackgroundUIColor];
    }
}

+ (UIColor *)getConfigureTouchedBackgroundUIColor {
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeClassicGray:
            return RGB(161, 161, 161);
            
        case MNThemeTypeSkyBlue:
            return [self getBackwardBackgroundUIColor];
            
        case MNThemeTypeClassicWhite:
            return [self getBackwardBackgroundUIColor];
    }
}
 */

#pragma mark - Font UIColor
+ (UIColor *)getMainFontUIColor {
    UIColor *mainFontColor = RGB(255, 255, 255);
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                mainFontColor = UIColorFromHexCode(0x252525);
                break;
            }else{
                if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                    mainFontColor = RGB(255, 255, 255);
                }else{
                    mainFontColor = UIColorFromHexCode(0x333333);
                }
                break;                
            }
            
        case MNThemeTypeWaterLily:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                mainFontColor = UIColorFromHexCode(0x252525);
                break;
            }else{
                mainFontColor = UIColorFromHexCode(0x333333);
                break;
            }
            
        case MNThemeTypeClassicGray:
            break;
            
        case MNThemeTypeClassicWhite:
            mainFontColor = UIColorFromHexCode(0x252525);
            break;
            
        case MNThemeTypeSkyBlue:
            break;
         
    }
    return mainFontColor;
}

+ (UIColor *)getSubFontUIColor {
    UIColor *subFontColor = UIColorFromHexCode(0x999999);
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                subFontColor = UIColorFromHexCode(0x918f8f);
                break;
            }else{
                if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                    subFontColor = UIColorFromHexCode(0xcccccc);
                }else{
                    subFontColor = UIColorFromHexCode(0x666666);
                }
                break;
            }
            
        case MNThemeTypeWaterLily:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                subFontColor = UIColorFromHexCode(0x918f8f);
                break;
            }else{
                subFontColor = UIColorFromHexCode(0x666666);
                break;
            }
            
        case MNThemeTypeClassicGray:
            subFontColor = UIColorFromHexCode(0x666666);
            break;
            
        case MNThemeTypeClassicWhite:
//            subFontColor = UIColorFromHexCode(0xcccccc);
            subFontColor = UIColorFromHexCode(0xa5a5a5);
            break;
            
        case MNThemeTypeSkyBlue:
//            subFontColor = UIColorFromHexCode(0xe1e2e2);
            subFontColor = UIColorFromHexCode(0xe4e4e4);
            break;
           
    }
    return subFontColor;
}

+ (UIColor *)getWidgetSubFontUIColor {
    UIColor *subFontColor = UIColorFromHexCode(0x999999);
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                subFontColor = UIColorFromHexCode(0x616161);
                break;
            }else{
                if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                    subFontColor = RGB(255, 255, 255);
                }else{
                    subFontColor = UIColorFromHexCode(0x333333);
                }
                break;
            }
            
        case MNThemeTypeWaterLily:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                subFontColor = UIColorFromHexCode(0x616161);
                break;
            }else{
                subFontColor = UIColorFromHexCode(0x333333);
                break;
            }
            
        case MNThemeTypeClassicGray:
            break;
            
        case MNThemeTypeClassicWhite:
            subFontColor = UIColorFromHexCode(0x616161);
            break;
            
        case MNThemeTypeSkyBlue:
//            subFontColor = UIColorFromHexCode(0xcfcfcf);
            subFontColor = UIColorFromHexCode(0xe4e4e4);
            break;
         
    }
    return subFontColor;
}

+ (UIColor *)getWidgetPointFontUIColor {
    UIColor *widgetPointColor = RGB(255, 255, 255); // 기본 흰색
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                widgetPointColor = UIColorFromHexCode(0x252525);
                break;
            }else{
                if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                    widgetPointColor = RGB(255, 255, 255);
                }else{
                    widgetPointColor = UIColorFromHexCode(0x333333);
                }
                break;
            }
            break;
            
        case MNThemeTypeWaterLily:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                widgetPointColor = UIColorFromHexCode(0x252525);
                break;
            }else{
                widgetPointColor = UIColorFromHexCode(0x333333);
                break;
            }
            
        case MNThemeTypeClassicGray:
            break;
            
        case MNThemeTypeClassicWhite:
            widgetPointColor = UIColorFromHexCode(0x252525);
            break;
            
        case MNThemeTypeSkyBlue:
            widgetPointColor = UIColorFromHexCode(0x25f1c3);
            break;
            
    }
    return widgetPointColor;
}

+ (UIColor *)getWidgetLockedFontUIColor {
    UIColor *widgetLockedColor = RGB(255, 255, 255); // 기본 흰색
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
        case MNThemeTypeClassicWhite:
            widgetLockedColor = UIColorFromHexCode(0x797979);
            break;
            
        case MNThemeTypeClassicGray:
            widgetLockedColor = UIColorFromHexCode(0x888888);
            break;
            
        case MNThemeTypeSkyBlue:
            widgetLockedColor = UIColorFromHexCode(0x043f4b);
            break;
            
    }
    return widgetLockedColor;
}

+ (UIColor *)getSecondSubFontUIColor {
    UIColor *secondSubFontColor = UIColorFromHexCode(0xcccccc);
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
        case MNThemeTypeWaterLily:
            break;
            
        case MNThemeTypeClassicGray:
            break;
            
        case MNThemeTypeSkyBlue:
            secondSubFontColor = UIColorFromHexCode(0x25f1c3);
            break;
            
        case MNThemeTypeClassicWhite:
            break;
    }
    return secondSubFontColor;
}

+ (UIColor *)getWidgetCalendarEvnetFontUIColor {
    UIColor *subFontColor = UIColorFromHexCode(0x999999);
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                subFontColor = UIColorFromHexCode(0x616161);
                break;
            }else{
                if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                    subFontColor = RGB(255, 255, 255);
                }else{
                    subFontColor = UIColorFromHexCode(0x333333);
                }
                break;
            }
            
        case MNThemeTypeWaterLily:
            if ([MNTheme sharedTheme].isThemeForConfigure) {
                subFontColor = UIColorFromHexCode(0x616161);
                break;
            }else{
                subFontColor = UIColorFromHexCode(0x333333);
                break;
            }
            
        case MNThemeTypeClassicGray:
            break;
            
        case MNThemeTypeClassicWhite:
            subFontColor = UIColorFromHexCode(0x616161);
            break;
            
        case MNThemeTypeSkyBlue:
            //            subFontColor = UIColorFromHexCode(0xcfcfcf);
            subFontColor = RGB(255, 255, 255);
            break;
            
    }
    return subFontColor;
}

+ (UIColor *)getStoreFontColor
{
    UIColor *storeFontColor;
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypePhoto:
        case MNThemeTypeScenery:
        case MNThemeTypeWaterLily:
        case MNThemeTypeClassicWhite:
        case MNThemeTypeClassicGray:
            storeFontColor = UIColorFromHexCode(0x00cfff);
            break;
            
        case MNThemeTypeSkyBlue:
            storeFontColor = UIColorFromHexCode(0x25f1c3);
    }
    
    return storeFontColor;
}

+ (UIColor *)getAlarmPrefMainFontUIColor {
    return UIColorFromHexCode(0x252525);
}

+ (UIColor *)getAlarmPrefSubFontUIColor {
    return UIColorFromHexCode(0x4276e3);
}

#pragma mark - description

- (NSString *)description {
    switch (self.currentlySelectedThemeType) {
        case MNThemeTypeWaterLily:
            return @"currentThemeType: MNThemeTypeWaterLily";
            
        case MNThemeTypeMirror:
            return @"currentThemeType: MNThemeTypeMirror";
            
        case MNThemeTypeScenery:
            return @"currentThemeType: MNThemeTypeMirror";
            
        case MNThemeTypeClassicGray:
            return @"currentThemeType: MNThemeTypeClassic";
            
        case MNThemeTypeClassicWhite:
            return @"currentThemeType: MNThemeTypeClassicWhite";
            
        case MNThemeTypeSkyBlue:
            return @"currentThemeType: MNThemeTypeSkyBlue";
            
        case MNThemeTypePhoto:
            return @"currentThemeType: MNThemeTypePhoto";
    }
}

+ (NSString *)getCurrentThemeNameForFlurry
{
    NSString *localizedThemeNameString = @"";
    
    switch ([self getCurrentlySelectedTheme]) {
        case MNThemeTypeWaterLily:
            localizedThemeNameString = @"Water Lily";
            break;
        
        case MNThemeTypeMirror:
            localizedThemeNameString = @"Mirror";
            break;
            
        case MNThemeTypeScenery:
            localizedThemeNameString = @"Scenery";
            break;
            
        case MNThemeTypeClassicGray:
            localizedThemeNameString = @"Classic Gray";
            break;
            
        case MNThemeTypeSkyBlue:
            localizedThemeNameString = @"SkyBlue";
            break;
            
        case MNThemeTypeClassicWhite:
            localizedThemeNameString = @"Classic White";
            break;
            
        case MNThemeTypePhoto:
            localizedThemeNameString = @"Photo";
            break;
    }
    return localizedThemeNameString;
}

#pragma mark - Localzied Text

+ (NSString *)getLocalizedThemeNameAtIndex:(int)index {
    NSString *localizedThemeNameString = @"";
    
    switch ([MNTheme getThemeFromIndex:index]) {
        case MNThemeTypeWaterLily:
            localizedThemeNameString = MNLocalizedString(@"store_item_water_lily", @"Water Lily");
            break;
            
        case MNThemeTypeMirror:
            localizedThemeNameString = MNLocalizedString(@"setting_theme_mirror", @"Mirror");
            break;
            
        case MNThemeTypeScenery:
            localizedThemeNameString = MNLocalizedString(@"setting_theme_scenery", @"Scenery");
            break;
            
        case MNThemeTypeClassicGray:
            localizedThemeNameString = MNLocalizedString(@"setting_theme_color_classic_gray", @"Classic Gray");
            break;
            
        case MNThemeTypeSkyBlue:
            localizedThemeNameString = MNLocalizedString(@"setting_theme_color_skyblue", @"SkyBlue");
            break;
            
        case MNThemeTypeClassicWhite:
            localizedThemeNameString = MNLocalizedString(@"setting_theme_color_classic_white", @"Classic White");
            break;
            
        case MNThemeTypePhoto:
            localizedThemeNameString = MNLocalizedString(@"setting_theme_photo", @"Photo");
            break;
    }
    return localizedThemeNameString;
}

#pragma mark - KVO method

// handler3ㅈ2
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
//    NSLog(@"%@ is changed from %p", keyPath, object);
//    NSLog(@"%@ changed from %@.",
//          [change objectForKey:NSKeyValueChangeNewKey],
//          [change objectForKey:NSKeyValueChangeOldKey]);
    
    // 키 변경에 따라 Appearance를 수정해주기
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        //        [[UINavigationBar appearance] setTranslucent:NO];
        [[UINavigationBar appearance] setBarTintColor:[MNTheme getNavigationBarTintBackgroundColor_iOS7]];
        [[UIBarButtonItem appearance] setTintColor:[MNTheme getNavigationTintColor_iOS7]];
    }
}

@end
