//
//  MNDefinitions.h
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 30..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#ifndef Morning_Kit_MNDefinitions_h
#define Morning_Kit_MNDefinitions_h

#define ADMOB_KEY @"a151fc9b50d8360"
#define FLURRY_APPLICATION_KEY "KGQ6NXRKXXVGVJBKC273"
#define FLICKR_API_KEY @"ccc5c75e5380273b78d246a71353fab9"
#define WWO_KEY @"k2zbbj8yamvc2rjfpfs6yxhn" // WWO Premium LIVE Key
//#define WWO_KEY @"5nz2zqymjhewyhusjsfqw6nu" // WWO Free Key

// DEBUG LOG - 개발 완료 후에는 0으로 정의
//#define MN_DEBUG 1
#define MN_DEBUG 0


///////////////////////////
//// Main Definitions ////
///////////////////////////
#define BUTTON_VIEW_HEIGHT_PORTRAIT 43
#define BUTTON_VIEW_HEIGHT_PORTRAIT_UNIVERSIAL ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 57 : 43)
#define BUTTON_VIEW_HEIGHT_LANDSCAPE 62
#define BUTTON_VIEW_HEIGHT_LANDSCAPE_UNIVERSIAL ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 62 : 62)
#define GAD_VIEW_HEIGHT_UNIVERSIAL ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0 : 50)

#define ROUNDED_CORNER_RADIUS 8

#define PADDING_BOUNDARY ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 9.0f : 4.0f)
#define PADDING_INNER ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 5.0f : 2.0f)

#define BUTTON_OFFSET 3

#define THEME_TUTORIAL_USED @"themeTutorialUsed"

#define WIDGET_COVER_REFRESH_LIMIT 1

#define IS_FACE_SENSOR_USING @"faceSensor"

///////////////////////////
//// Widget Definitions ////
///////////////////////////

#define NUM_OF_WIDGET 9

//#define WIDGET_WIDTH_BOUNDARY 320/2
//#define WIDGET_HEIGHT_BOUNDARY 214/2

//#define WIDGET_WINDOW_HEIGHT_iPhone 214
#define WIDGET_WINDOW_WIDTH_UNIVERSIAL ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 768 : 320)
#define WIDGET_WINDOW_HEIGHT_UNIVERSIAL ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 524 : 214)

#define WIDGET_WIDTH_BOUNDARY_UNIVERSIAL ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 768/2 : 320/2)
#define WIDGET_HEIGHT_BOUNDARY_UNIVERSIAL ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 524/2 : 214/2)

#define WIDGET_WIDTH (WIDGET_WINDOW_WIDTH_UNIVERSIAL - (PADDING_BOUNDARY*2 + PADDING_INNER*2))/2 // 154
#define WIDGET_HEIGHT (WIDGET_WINDOW_HEIGHT_UNIVERSIAL - PADDING_BOUNDARY - PADDING_INNER*3)/2 // 102


#define WIDGET_SELECTOR_TOTAL_HEIGHT ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 350 : 150)
#define WIDGET_SELECTOR_CONTENTS_WIDTH ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 768 : 320)
#define WIDGET_SELECTOR_CONTENTS_HEIGHT ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 318 : 130)

#define NAVIGATION_BAR_iPhone 44

#define KEYBOARD_UP_DURATION SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 0.25f : 0.25f

enum widgetID {
    EMPTY = 0,
    WEATHER,
    CALENDAR,
    REMINDER,
    WORLDCLOCK,
    QUOTES,
    FLICKR,
    EXCHANGE_RATE,
    MEMO,
    DATE_COUNTDOWN,
    WIDGET_STORE,
};

enum widgetLocation {
    LEFTTOP = 0,
    RIGHTTOP,
    LEFTBOT,
    RIGHTBOT
};

enum {
    PREVIEW0 = 100,
    PREVIEW1,
    PREVIEW2,
    PREVIEW3,
    
    SELECTWEATHER,
    SELECTWORLDCLOCK,
    SELECTMEMO,
    SELECTANNIVERSARY,
    SELECTFLICKR,
    SELECTCALENDAR
}widgetConfigueTags;

enum {
    NETWORK_ANIMATION_MODE_PROTOTYPE,
    NETWORK_ANIMATION_MODE_NEW1,
    NETWORK_ANIMATION_MODE_NEW2
}networkAnimationMode;

#define SPINNER_X 67
#define SPINNER_Y 28

#define LOADING_LABEL_X 42
#define LOADING_LABEL_Y 74

#define NO_NETWORK_IMAGEVIEW_Y 17
#define NO_NETWORK_LABEL_Y 64

#define WIDGET_LOADING_ANIMATION_TIME 0.75
#define WIDGET_NO_NETWORK_WAITING_TIME 0.75

#define DEFAULT_IN_APP_ALARM_SOUND_NAME "thunder_strike"

// World Clock
#define ROUNDED_CORNER_RADIUS_WORLD_CLOCK_AMPM 6
#define WORLD_CLOCK_TYPE @"worldClockType"
#define WORLD_CLOCK_SELECTED_TIMEZONE @"selectedTimeZone"
#define WORLD_CLOCK_TYPE_ANALOG 0
#define WORLD_CLOCK_TYPE_DIGITAL 1
#define WORLD_CLOCK_TIMEZONE_CELL_HEIGHT 53
#define WORLD_CLOCK_USING_24HOURS @"isUsing24Hours"

// Flickr
#define FLICKR_KEYWORD @"keyword"
#define FLICKR_IMAGE_DATA @"imageData"
#define FLICKR_GRAY_SCALE_ON @"isGrayscaleOn"
#define FLICKR_TOTAL_NUMBER_OF_PHOTOS @"totalNumberOfPhotos"

// Memo
#define MEMO_STRING @"memoString"
#define MEMO_ARCHIVED_STRING @"memoArchivedString"

// Date Countdown
#define DATE_COUNTDOWN_TITLE @"countdownTitle"
#define DATE_COUNTDOWN_DATE @"countdownDate"
#define DATE_COUNTDOWN_IS_TITLE_NEW_YEAR @"countdownIsTitleNewYear"

///////////////////////////
//// Alarm Definitions ////
///////////////////////////
#define SNOOZE_BUTTON 0
#define DISMISS_BUTTON 1

// AlarmCell
#define ALARM_SWITCH_TAG_OFFSET 1000

// Alarm Add
typedef NSInteger ConfigueAlarmState;

enum ConfigueAlarmState {
    ConfigueAlarmStateAdd = 0,
    ConfigueAlarmStateModify = 1
};

enum AlarmAddControllerCell {
    REPEAT = 0,
    SOUND,
    SNOOZE,
    LABEL
};

#define ALARM_NUMBER_UNLOCK_LIMIT 3

// Alarm Snooze
#define ALARM_SNOOZE_SECOND 60 * 9
//#define ALARM_SNOOZE_SECOND 8 // 테스트

// Alarm Start - 첫 알람으로부터 하루씩 더해줘야 함
#define ALARM_REPEAT_OFFSET 60 * 60 * 24
//#define ALARM_REPEAT_OFFSET 5 // 테스트

#define ALARM_ITEM_HEIGHT ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 86 : 58)
//#define ALARM_ITEM_WIDTH 320
#define ALARM_ITEM_WIDTH ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 768 : 320)
#define ALARM_SEPERATOR_HEIGHT 3

#define CELL_HEIGHT ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 86 : 58)
#define CELL_SEPERATOR_HEIGHT 2

#define CONFIGURE_ALARM_OBSERVER_NAME @"configureAlarmReloadData"

///////////////////////////////
//// Configure Definitions ////
///////////////////////////////
#define LAST_SELECTED_TAB_INDEX @"last_selected_tab_index"

#define CONTENT_INSET_TOP ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 4.0f : 1.0f) 

// Effect Sounds
#define EFFECT_SOUND_ALARM_ON_OFF @"morning_on_off"
#define EFFECT_SOUND_VIEW_CLICK @"effect_open"
#define EFFECT_SOUND_VIEW_CLICK_CLOSE @"effect_close"
#define EFFECT_SOUND_REFRESH @"morning_refresh"
#define EFFECT_SOUND_SETTING @"effect_setting"
#define EFFECT_SOUND_ALARM_SWIPE_REMOVE @"woosh"

#define WIDGET_MATRIX @"widget_matrix"

#define iOS7_NAV_TITLE_FONT_SIZE 20

#endif
