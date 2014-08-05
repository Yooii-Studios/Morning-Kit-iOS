//
//  MNTheme.h
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 20..
//  Copyright (c) 2013년 Yooii. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MNThemeType) {
    MNThemeTypeScenery = 0,
    MNThemeTypeMirror,
    MNThemeTypePhoto,
    MNThemeTypeClassicWhite,
    MNThemeTypeClassicGray,
    MNThemeTypeSkyBlue,
    MNThemeTypeWaterLily,
};

// 각 테마별 정보를 얻을 수 있는 곳. 싱글톤으로 구현해서 아트 리소스를 얻는 방법으로 접근하자.

@interface MNTheme : NSObject

@property (nonatomic) MNThemeType currentlySelectedThemeType;
@property (nonatomic) MNThemeType archivedOriginalThemeType;
@property (nonatomic) BOOL isThemeForConfigure;

+ (MNTheme *)sharedTheme;
+ (MNThemeType)getCurrentlySelectedTheme;
+ (MNThemeType)getArchivedOriginalThemeType;
+ (void)changeCurrentThemeTo:(MNThemeType)selectedTheme;
+ (void)archiveCurrentTheme:(MNThemeType)selectedTheme;

+ (MNThemeType)getThemeFromIndex:(NSInteger)index;
+ (NSInteger)getIndexFromTheme:(MNThemeType)themeType;

+ (void)setThemeForConfigure;
+ (void)setThemeForMain;

// 이미지 리소스를 얻는 메서드
// Background Color
+ (UIColor *)getBackwardBackgroundUIColor;
+ (UIColor *)getForwardBackgroundUIColor;
+ (UIColor *)getTouchedBackgroundUIColor;

+ (UIColor *)getLockedBackgroundUIColor;

+ (UIColor *)getButtonBackgroundUIColor;
+ (UIColor *)getSelectedWidgetBackgroundUIColor;

+ (UIColor *)getAlarmPrefBackgroundUIColor;
+ (UIColor *)getAlarmPrefSeperateLineUIColor;

+ (UIColor *)getNavigationBarTintBackgroundColor_iOS7;
+ (UIColor *)getNavigationTintColor_iOS7;

+ (UIColor *)getSwitchTintColorInModalController;

/*
+ (UIColor *)getConfigureBackwardBackgroundUIColor;
+ (UIColor *)getConfigureForwardBackgroundUIColor;
+ (UIColor *)getConfigureTouchedBackgroundUIColor;
 */

// Font Color - 가현이가 정리(총 4개로 사용, 위젯(주, 위젯 부, 위젯 포인트 컬러), 알람(주, 부 컬러))
+ (UIColor *)getMainFontUIColor;
+ (UIColor *)getSubFontUIColor;
+ (UIColor *)getStoreFontColor;

+ (UIColor *)getAlarmPrefMainFontUIColor;
+ (UIColor *)getAlarmPrefSubFontUIColor;

// 추후 추가사항 - 알람에서 오프될 경우 메인과 부 폰트 색을 바꿀 수 있으면 좋겠다고 가현이 판단
//+ (UIColor *)getMainFontOffUIColor;
//+ (UIColor *)getSubFontOffUIColor;

+ (UIColor *)getWidgetSubFontUIColor;
+ (UIColor *)getWidgetPointFontUIColor;
+ (UIColor *)getWidgetLockedFontUIColor;

+ (UIColor *)getWidgetCalendarEvnetFontUIColor;

+ (UIColor *)getSecondSubFontUIColor;
//+ (UIColor *)getModalSubFontUIColor;

// Alarm Resources
+ (NSString *)getAlarmSwitchOffResourceName;
+ (NSString *)getAlarmSwitchOnResourceName;
+ (NSString *)getAlarmDividingBarResourceName;
+ (NSString *)getAlarmPlusResourceName;

// 추가: Dividing Bar on/off
+ (NSString *)getAlarmDividingBarOnResourceName;
+ (NSString *)getAlarmDividingBarOffResourceName;

// World Clock Resources
+ (NSString *)getWorldClockAMBaseResourceName;
+ (NSString *)getWorldClockPMBaseResourceName;
+ (NSString *)getWorldClockHourHandResourceName:(NSString *)AMPM;
+ (NSString *)getWorldClockMinuteHandResourceName:(NSString *)AMPM;
+ (NSString *)getWorldClockSecondHandResourceName:(NSString *)AMPM;;

// Main Resoureces
+ (NSString *)getRefreshButtonResourceName;
+ (NSString *)getConfigureButtonResourceName;
+ (NSString *)getKeyboardHideButtonResourceName;

// Setting Resoureces
+ (NSString *)getCheckImageResourceName;

// Lock Resouces
+ (NSString *)getSettingLockerImageResourceName;
+ (NSString *)getWidgetLockerImageResourceName;

// Localized String
+ (NSString *)getLocalizedThemeNameAtIndex:(int)index;

// For Flurry
+ (NSString *)getCurrentThemeNameForFlurry;

@end
