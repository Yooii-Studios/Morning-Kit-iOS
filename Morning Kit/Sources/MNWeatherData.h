//
//  MNWeatherInfo.h
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 4. 25..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNLocationInfo.h"

@interface MNWeatherData : NSObject < NSCoding >

@property (nonatomic) MNLocationInfo *locationInfo;

@property (nonatomic) NSString *currentTemp;
@property (nonatomic) NSString *todayTemp;

@property (nonatomic) NSString *currentTemp_c;
@property (nonatomic) NSString *todayTemp_c;

@property (nonatomic) NSString *currentTemp_f;
@property (nonatomic) NSString *todayTemp_f;

@property (nonatomic) enum MNWeatherCondition weatherCondition;
@property (nonatomic) enum MNWWOWeatherCondition wwoWeatherCondition;


@property (nonatomic) NSString* timeString;

- (NSString*)getLocationName;
- (NSString*)getLocationCountryCode;
- (NSString*)getLocationTimezoneCode;
- (BOOL)isValid;

@end


enum MNWeatherCondition {
    eWC_noData = 0,
    eWC_tornado,
    eWC_tropical_storm,
    eWC_hurricane,
    eWC_severe_thunderstorms,
    eWC_thunderstorms = 5,
    eWC_mixed_rain_and_snow,
    eWC_mixed_rain_and_sleet,
    eWC_mixed_snow_and_sleet,
    eWC_freezing_drizzle,
    eWC_drizzle = 10,
    eWC_freezing_rain,
    eWC_showers,
    eWC_showers2,
    eWC_snow_flurries,
    eWC_light_sno_showers = 15,
    eWC_blowing_snow,
    eWC_snow,
    eWC_hail,
    eWC_sleet,
    eWC_dust = 20,
    eWC_foggy,
    eWC_haze,
    eWC_smoky,
    eWC_blustery,
    eWC_windy = 25,
    eWC_cold,
    eWC_cloudy,
    eWC_mostly_cloudy_night,
    eWC_mostly_cloudy_day,
    eWC_partly_cloudy_night = 30,
    eWC_partly_cloudy_day,
    eWC_clear_night,
    eWC_sunny,
    eWC_fair_night,
    eWC_fair_day = 35,
    eWC_mixed_rain_and_hail,
    eWC_hot,
    eWC_isolated_thunderstorms,
    eWC_scattered_thunderstorms,
    eWC_scattered_thunderstorms2 = 40,
    eWC_scattered_showers,
    eWC_heavy_snow,
    eWC_scattered_snow_showers,
    eWC_heavy_snow2,
    eWC_partly_cloudy = 45,
    eWC_thundershowers,
    eWC_snow_showers,
    eWC_isolated_thundershowers,
    eWC_not_available = 3200
};

enum MNWWOWeatherCondition {
    e_WWO_WC_noData = 0,
    e_WWO_WC_heavy_snow_showers = 395, // 1
    e_WWO_WC_thundery_showers = 392, // 1
    e_WWO_WC_thunderstorms = 389, // 4
    e_WWO_WC_patchy_light_rain_in_area_with_thunder = 386, // 4
    e_WWO_WC_moderate_or_heavy_showers_of_ice_pellets = 377, // 5
    e_WWO_WC_light_showers_of_ice_pellets = 374, // 5
    e_WWO_WC_moderate_or_heavy_snow_showers = 371, // 1
    e_WWO_WC_light_snow_showers = 368, // 1
    e_WWO_WC_moderate_or_heavy_sleet_showers = 365, // 2
    e_WWO_WC_light_sleet_showers = 362, // 2
    e_WWO_WC_cloudy_with_heavy_rain = 359, // 2
    e_WWO_WC_heavy_rain_showers = 356, // 2
    e_WWO_WC_light_rain_showers = 353, // 2
    e_WWO_WC_ice_pellets = 350, // 5
    e_WWO_WC_heavy_snow = 338, // 1
    e_WWO_WC_patchy_heavy_snow = 335, // 1
    e_WWO_WC_moderate_snow = 332, // 1
    e_WWO_WC_patchy_moderate_snow = 329, // 1
    e_WWO_WC_light_snow = 326, // 1
    e_WWO_WC_patchy_light_snow = 323, // 1
    e_WWO_WC_moderate_or_heavy_sleet = 320, // 2
    e_WWO_WC_light_sleet = 317, // 2
    e_WWO_WC_moderate_or_heavy_freezing_rain = 314, // 4
    e_WWO_WC_light_freezing_rain = 311, // 4
    e_WWO_WC_heavy_rain = 308, // 4
    e_WWO_WC_heavy_rain_at_times = 305, // 4
    e_WWO_WC_moderate_rain = 302, // 4
    e_WWO_WC_moderate_rain_at_times = 299, // 4
    e_WWO_WC_light_rains = 296, // 4
    e_WWO_WC_patchy_light_rain = 293, // 4
    e_WWO_WC_heavy_freezing_drizzle = 284, // 4
    e_WWO_WC_freezing_drizzle = 281, // 4
    e_WWO_WC_light_drizzle = 266, // 4
    e_WWO_WC_patchy_light_drizzle = 263, // 4
    e_WWO_WC_freezing_fog = 260, // 8
    e_WWO_WC_fog = 248, // 8
    e_WWO_WC_blizzard = 230, // 1
    e_WWO_WC_blowing_snow = 227, // 1
    e_WWO_WC_thundery_outbreaks_in_nearby = 200, // 14
    e_WWO_WC_patchy_freezing_drizzle_nearby = 185, // 4
    e_WWO_WC_patchy_sleet_nearby = 182, // 4
    e_WWO_WC_patchy_snow_nearby = 179, // 1
    e_WWO_WC_patchy_rain_nearby = 176, // 4
    e_WWO_WC_mist = 143, // 8
    e_WWO_WC_overcast = 122, // 12
    e_WWO_WC_cloudy = 119, // 12
    e_WWO_WC_partly_cloudy = 116, // 9
    e_WWO_WC_clear_sunny = 113, // 11
    e_WWO_WC_not_available = 3200
};




