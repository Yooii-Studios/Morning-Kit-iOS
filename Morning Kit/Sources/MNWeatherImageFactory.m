//
//  MNWeatherImageFactory.m
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 4. 25..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWeatherImageFactory.h"

@implementation MNWeatherImageFactory

+ (UIImage*) getImage:(enum MNWeatherCondition) _condition
{
    switch (_condition) {
        case eWC_noData:
        case eWC_not_available:
            return nil;
        case eWC_snow_flurries:
        case eWC_light_sno_showers:
        case eWC_blowing_snow:
        case eWC_snow:
        case eWC_heavy_snow:
        case eWC_heavy_snow2:
        case eWC_snow_showers:
            return [UIImage imageNamed:@"m_icon_weather_01_snow"];
        case eWC_mixed_rain_and_snow:
        case eWC_mixed_rain_and_sleet:
        case eWC_mixed_snow_and_sleet:
        case eWC_sleet:
        case eWC_scattered_snow_showers:
            return [UIImage imageNamed:@"m_icon_weather_02_mixed_rain_and_snow"];
        case eWC_freezing_drizzle:
        case eWC_drizzle:
        case eWC_freezing_rain:
        case eWC_showers:
        case eWC_showers2:
        case eWC_scattered_showers:
        case eWC_thundershowers:
            return [UIImage imageNamed:@"m_icon_weather_04_showers"];
        case eWC_hail:
            return [UIImage imageNamed:@"m_icon_weather_05_hail"];
        case eWC_tropical_storm:
        case eWC_hurricane:
        case eWC_severe_thunderstorms:
        case eWC_thunderstorms:
        case eWC_isolated_thunderstorms:
        case eWC_scattered_thunderstorms:
        case eWC_scattered_thunderstorms2:
            return [UIImage imageNamed:@"m_icon_weather_06_hurricane"];
        case eWC_tornado:
            return [UIImage imageNamed:@"m_icon_weather_07_tornado"];
        case eWC_dust:
        case eWC_foggy:
        case eWC_haze:
        case eWC_smoky:
            return [UIImage imageNamed:@"m_icon_weather_08_foggy"];
        case eWC_partly_cloudy_night:
        case eWC_partly_cloudy_day:
        case eWC_partly_cloudy:
            return [UIImage imageNamed:@"m_icon_weather_09_partly_cloudy"];
        case eWC_blustery:
        case eWC_windy:
            return [UIImage imageNamed:@"m_icon_weather_10_windy"];
        case eWC_cold:
        case eWC_clear_night:
        case eWC_sunny:
        case eWC_fair_night:
        case eWC_fair_day:
        case eWC_hot:
            return [UIImage imageNamed:@"m_icon_weather_11_sunny"];
        case eWC_cloudy:
        case eWC_mostly_cloudy_night:
        case eWC_mostly_cloudy_day:
            return [UIImage imageNamed:@"m_icon_weather_12_mostly_cloudy_night"];
        case eWC_mixed_rain_and_hail:
            return [UIImage imageNamed:@"m_icon_weather_13_mixed_rain_and_hail"];
        case eWC_isolated_thundershowers:
            return [UIImage imageNamed:@"m_icon_weather_14_isolated_thundershowers"];
        default:
            return [UIImage imageNamed:@"m_icon_weather_11_sunny"];
    }
}

+ (UIImage*) getWWOImage:(enum MNWWOWeatherCondition) _condition {
//    NSLog(@"%d", _condition);
    
    switch (_condition) {
        case e_WWO_WC_noData:
        case e_WWO_WC_not_available:
            return nil;
        case e_WWO_WC_heavy_snow_showers:
        case e_WWO_WC_thundery_showers:
        case e_WWO_WC_moderate_or_heavy_snow_showers:
        case e_WWO_WC_light_snow_showers:
        case e_WWO_WC_heavy_snow:
        case e_WWO_WC_patchy_heavy_snow:
        case e_WWO_WC_moderate_snow:
        case e_WWO_WC_patchy_moderate_snow:
        case e_WWO_WC_light_snow:
        case e_WWO_WC_patchy_light_snow:
        case e_WWO_WC_blizzard:
        case e_WWO_WC_blowing_snow:
        case e_WWO_WC_patchy_snow_nearby:
            return [UIImage imageNamed:@"m_icon_weather_01_snow"];
        case e_WWO_WC_moderate_or_heavy_sleet_showers:
        case e_WWO_WC_light_sleet_showers:
        case e_WWO_WC_cloudy_with_heavy_rain:
        case e_WWO_WC_heavy_rain_showers:
        case e_WWO_WC_light_rain_showers:
        case e_WWO_WC_moderate_or_heavy_sleet:
        case e_WWO_WC_light_sleet:
            return [UIImage imageNamed:@"m_icon_weather_02_mixed_rain_and_snow"];
        case e_WWO_WC_thunderstorms:
        case e_WWO_WC_patchy_light_rain_in_area_with_thunder:
        case e_WWO_WC_moderate_or_heavy_freezing_rain:
        case e_WWO_WC_light_freezing_rain:
        case e_WWO_WC_heavy_rain:
        case e_WWO_WC_heavy_rain_at_times:
        case e_WWO_WC_moderate_rain:
        case e_WWO_WC_moderate_rain_at_times:
        case e_WWO_WC_light_rains:
        case e_WWO_WC_patchy_light_rain:
        case e_WWO_WC_heavy_freezing_drizzle:
        case e_WWO_WC_freezing_drizzle:
        case e_WWO_WC_light_drizzle:
        case e_WWO_WC_patchy_light_drizzle:
        case e_WWO_WC_patchy_freezing_drizzle_nearby:
        case e_WWO_WC_patchy_sleet_nearby:
        case e_WWO_WC_patchy_rain_nearby:
            return [UIImage imageNamed:@"m_icon_weather_04_showers"];
        case e_WWO_WC_moderate_or_heavy_showers_of_ice_pellets:
        case e_WWO_WC_light_showers_of_ice_pellets:
        case e_WWO_WC_ice_pellets:
            return [UIImage imageNamed:@"m_icon_weather_05_hail"];
        case e_WWO_WC_freezing_fog:
        case e_WWO_WC_fog:
        case e_WWO_WC_mist:
            return [UIImage imageNamed:@"m_icon_weather_08_foggy"];
        case e_WWO_WC_partly_cloudy:
            return [UIImage imageNamed:@"m_icon_weather_09_partly_cloudy"];
        case e_WWO_WC_clear_sunny:
            return [UIImage imageNamed:@"m_icon_weather_11_sunny"];
        case e_WWO_WC_overcast:
        case e_WWO_WC_cloudy:
            return [UIImage imageNamed:@"m_icon_weather_12_mostly_cloudy_night"];
        case e_WWO_WC_thundery_outbreaks_in_nearby:
            return [UIImage imageNamed:@"m_icon_weather_14_isolated_thundershowers"];
        default:
            return [UIImage imageNamed:@"m_icon_weather_11_sunny"];
    }
}


@end
