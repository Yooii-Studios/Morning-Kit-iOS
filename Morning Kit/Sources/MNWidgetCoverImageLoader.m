//
//  MNWidgetCoverImageLoader.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 9. 4..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetCoverImageLoader.h"
#import "MNWidgetIconLoader.h"
#import "MNDefinitions.h"
#import "MNTheme.h"
#import "MNTranslucentFont.h"

@implementation MNWidgetCoverImageLoader

+ (UIImage *)getCoverImage:(NSInteger)index {
    UIImage *widgetCoverImage = nil;
    
    switch (index) {
        case WEATHER:
            widgetCoverImage = [UIImage imageNamed:@"widget_cover_weather_white"];
            break;
            
        case CALENDAR:
            widgetCoverImage = [UIImage imageNamed:@"widget_cover_calendar_white"];
            break;
            
        case DATE_COUNTDOWN:
            widgetCoverImage = [UIImage imageNamed:@"widget_cover_datecountdown_white"];
            break;
            
        case WORLDCLOCK:
            switch ([MNTheme getCurrentlySelectedTheme]) {
                case MNThemeTypeClassicGray:
                    widgetCoverImage = [UIImage imageNamed:@"widget_cover_worldclock_white"];
                    break;
                    
                case MNThemeTypeSkyBlue:
                    widgetCoverImage = [UIImage imageNamed:@"widget_cover_worldclock_skyblue"];
                    break;
                    
                case MNThemeTypeClassicWhite:
                    widgetCoverImage = [UIImage imageNamed:@"widget_cover_worldclock_black"];
                    break;
                    
                case MNThemeTypeMirror:
                case MNThemeTypeScenery:
                case MNThemeTypePhoto:
                    if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                        widgetCoverImage = [UIImage imageNamed:@"widget_cover_worldclock_white"];
                    }else{
                        widgetCoverImage = [UIImage imageNamed:@"widget_cover_worldclock_black"];
                    }
                    break;
                    
                case MNThemeTypeWaterLily:
                    widgetCoverImage = [UIImage imageNamed:@"widget_cover_worldclock_black"];
                    break;
                    
            }
            //            widgetIconImage = [UIImage imageNamed:@"btn_wclock_transparent"];
            break;
            
        case QUOTES:
            widgetCoverImage = [UIImage imageNamed:@"widget_cover_quotes_white"];
            break;
            
        case FLICKR:
            switch ([MNTheme getCurrentlySelectedTheme]) {
                case MNThemeTypeClassicGray:
                case MNThemeTypeSkyBlue:
                    widgetCoverImage = [UIImage imageNamed:@"widget_cover_flickr_white"];
                    break;
                    
                case MNThemeTypeClassicWhite:
                    widgetCoverImage = [UIImage imageNamed:@"widget_cover_flickr_black"];
                    break;
                    
                case MNThemeTypeMirror:
                case MNThemeTypeScenery:
                case MNThemeTypePhoto:
                    if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                        widgetCoverImage = [UIImage imageNamed:@"widget_cover_flickr_white"];
                    }else{
                        widgetCoverImage = [UIImage imageNamed:@"widget_cover_flickr_black"];
                    }
                    break;
                    
                case MNThemeTypeWaterLily:
                    widgetCoverImage = [UIImage imageNamed:@"widget_cover_flickr_black"];
                    break;
                    
            }
            //            widgetIconImage = [UIImage imageNamed:@"btn_flickr_transparent"];
            break;
            
        case MEMO:
            widgetCoverImage = [UIImage imageNamed:@"widget_cover_memo_white"];
            break;
            
        case EXCHANGE_RATE:
            switch ([MNTheme getCurrentlySelectedTheme]) {
                case MNThemeTypeClassicGray:
                    widgetCoverImage = [UIImage imageNamed:@"widget_cover_exchangerates_white"];
                    break;
                    
                case MNThemeTypeSkyBlue:
                    widgetCoverImage = [UIImage imageNamed:@"widget_cover_exchangerates_skyblue"];
                    break;
                    
                case MNThemeTypeClassicWhite:
                    widgetCoverImage = [UIImage imageNamed:@"widget_cover_exchangerates_black"];
                    break;
                    
                case MNThemeTypeMirror:
                case MNThemeTypeScenery:
                case MNThemeTypePhoto:
                    if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeWhite) {
                        widgetCoverImage = [UIImage imageNamed:@"widget_cover_exchangerates_white"];
                    }else{
                        widgetCoverImage = [UIImage imageNamed:@"widget_cover_exchangerates_black"];
                    }
                    break;
                    
                case MNThemeTypeWaterLily:
                    widgetCoverImage = [UIImage imageNamed:@"widget_cover_exchangerates_black"];
                    break;
            }
            break;
            
        case REMINDER:
            widgetCoverImage = [UIImage imageNamed:@"widget_cover_reminder_white"];
            break;
    }
    
    switch (index) {
        case WEATHER:
        case CALENDAR:
        case DATE_COUNTDOWN:
        case QUOTES:
        case MEMO:
        case REMINDER:
            widgetCoverImage = [MNWidgetIconLoader makeConvertedImage:widgetCoverImage];
            break;
    }
    
    return widgetCoverImage;
}

@end
