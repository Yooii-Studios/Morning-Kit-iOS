//
//  MNWidgetIconLoader.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 7. 3..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetIconLoader.h"
#import "MNDefinitions.h"
#import "MNTheme.h"
#import "MNTranslucentFont.h"

@implementation MNWidgetIconLoader

// empty 가 0임
+ (UIImage *)getWidgetIconWithIndex:(NSInteger)index {
    UIImage *widgetIconImage = nil;
    
    switch (index) {
        case WEATHER-1:
            widgetIconImage = [UIImage imageNamed:@"configure_widget_weather"];
            break;
            
        case CALENDAR-1:
            widgetIconImage = [UIImage imageNamed:@"configure_widget_calendar"];
            break;
            
        case DATE_COUNTDOWN-1:
            widgetIconImage = [UIImage imageNamed:@"configure_widget_dday"];
            break;
            
        case WORLDCLOCK-1:
            switch ([MNTheme getCurrentlySelectedTheme]) {
                case MNThemeTypeClassicGray:
                    widgetIconImage = [UIImage imageNamed:@"configure_widget_wclock_classic_gray"];
                    break;
                    
                case MNThemeTypeSkyBlue:
                    widgetIconImage = [UIImage imageNamed:@"configure_widget_wclock_skyblue"];
                    break;
                    
                case MNThemeTypeMirror:
                case MNThemeTypeScenery:
                case MNThemeTypePhoto:
                case MNThemeTypeWaterLily:
                case MNThemeTypeClassicWhite:
                    widgetIconImage = [UIImage imageNamed:@"configure_widget_wclock_classic_white"];
                    break;
            }
//            widgetIconImage = [UIImage imageNamed:@"btn_wclock_transparent"];
            break;
            
        case QUOTES-1:
            widgetIconImage = [UIImage imageNamed:@"configure_widget_maxim"];
            break;
            
        case FLICKR-1:
            switch ([MNTheme getCurrentlySelectedTheme]) {
                case MNThemeTypeClassicGray:
                case MNThemeTypeSkyBlue:
                    widgetIconImage = [UIImage imageNamed:@"configure_widget_flickr_classic_gray"];
                    break;
                    
                case MNThemeTypeMirror:
                case MNThemeTypeScenery:
                case MNThemeTypePhoto:
                case MNThemeTypeWaterLily:
                case MNThemeTypeClassicWhite:
                    widgetIconImage = [UIImage imageNamed:@"configure_widget_flickr_classic_white"];
                    break;
            }
//            widgetIconImage = [UIImage imageNamed:@"btn_flickr_transparent"];
            break;
            
        case MEMO-1:
            widgetIconImage = [UIImage imageNamed:@"configure_widget_note"];
            break;
            
        case EXCHANGE_RATE-1:
            switch ([MNTheme getCurrentlySelectedTheme]) {
                case MNThemeTypeClassicGray:
                    widgetIconImage = [UIImage imageNamed:@"configure_widget_currency_classic_grey"];
                    break;
                    
                case MNThemeTypeSkyBlue:
                    widgetIconImage = [UIImage imageNamed:@"configure_widget_currency_skyblue"];
                    break;
                    
                case MNThemeTypeMirror:
                case MNThemeTypeScenery:
                case MNThemeTypePhoto:
                case MNThemeTypeWaterLily:
                case MNThemeTypeClassicWhite:
                    widgetIconImage = [UIImage imageNamed:@"configure_widget_currency_classic_white"];
                    break;
            }
            break;
            
        case REMINDER-1:
            widgetIconImage = [UIImage imageNamed:@"configure_widget_reminder"];
            break;
    }
    
    switch (index) {
        case WEATHER-1:
        case CALENDAR-1:
        case DATE_COUNTDOWN-1:
        case QUOTES-1:
        case MEMO-1:
        case REMINDER-1:
            widgetIconImage = [MNWidgetIconLoader makeConvertedImage:widgetIconImage];
            break;
    }
    
    return widgetIconImage;
}

+ (UIImage *)makeConvertedImage:(UIImage *)image {
    if (image) {
        // 이미지에 필터를 씌워 보자
        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClipToMask(context, rect, image.CGImage);
        
        switch ([MNTheme getCurrentlySelectedTheme]) {
            case MNThemeTypeClassicGray:
            case MNThemeTypeSkyBlue:
                CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
                break;
                
            case MNThemeTypeMirror:
            case MNThemeTypeScenery:
            case MNThemeTypePhoto:
            case MNThemeTypeWaterLily:
            case MNThemeTypeClassicWhite:
                CGContextSetFillColorWithColor(context, [[MNTheme getMainFontUIColor] CGColor]);
                break;
        }
        CGContextFillRect(context, rect);
        UIImage *convertedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImage *flippedImage = [UIImage imageWithCGImage:convertedImage.CGImage scale:1.0 orientation: UIImageOrientationDownMirrored];
        
        return flippedImage;
    }
    return nil;
}

@end
