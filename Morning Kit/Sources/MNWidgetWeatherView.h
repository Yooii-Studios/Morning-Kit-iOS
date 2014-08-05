//
//  MNWidgetWeatherView.h
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//
#pragma once

#import <CoreLocation/CoreLocation.h>

#import "MNWidgetView.h"
#import "MNWeatherData.h"
#import "MNWeatherSetting.h"

#define DictKey_CurrentLocation @"Weather_DictKey_CurrentLocation"
#define DictKey_TargetLocation @"Weather_DictKey_TargetLocation"
#define DictKey_WeatherSetting @"Weather_DictKey_WeatherSetting"

// 추가: 이전 위치 저장을 위함
#define DictKey_PreviousLocation @"Weather_DictKey_PreviousLocation"
#define DictKey_PreviousTimestamp @"Weather_DictKey_PreviousTimestamp"

// 추가: 캐시 데이터
#define DictKey_WeatherCacheDataList @"Weather_DictKey_WeatherCacheDataArray"
#define DictKey_WeatherLocalCacheDataList @"Weather_DictKey_WeatherLocalCacheDataArray"

@interface MNWidgetWeatherView : MNWidgetView <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel      *label_currentTemperature;
@property (strong, nonatomic) IBOutlet UILabel      *label_todayTemperature;
@property (strong, nonatomic) IBOutlet UILabel      *label_currentLocation;
@property (strong, nonatomic) IBOutlet UILabel      *label_localTime;
@property (strong, nonatomic) IBOutlet UIImageView  *image_weatherCondition;

@property (strong, nonatomic) CLLocationManager     *locationManager;
@property (strong, nonatomic) NSTimer               *localTimeTimer;

@property (strong, nonatomic) MNWeatherData         *weatherData;

@property (strong, nonatomic) MNWeatherSetting      *weatherSetting;

@property (strong, nonatomic) MNLocationInfo        *currentLocation;
@property (strong, nonatomic) MNLocationInfo        *targetLocation;
@property (strong, nonatomic) MNLocationInfo        *parsingLocation;

@property (strong, nonatomic) UIImage               *weatherImage;
@property (strong, nonatomic) UIImage               *convertedWeatherImage;

// 테스트: 위도 경도
@property (strong, nonatomic) IBOutlet UILabel      *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel      *longitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel      *error_weatherLabel;
@property (strong, nonatomic) IBOutlet UILabel      *error_chooseYourCityLabel;

// 날씨 캐시 리스트
@property (strong, nonatomic) NSMutableArray        *weatherCacheDataList;
@property (nonatomic) BOOL                          isWeatherDataNeedToCached;

// 날씨 캐시 리스트-로컬
@property (strong, nonatomic) NSMutableArray        *weatherLocalCacheDataList;
@property (nonatomic) BOOL                          isLocalWeatherDataNeedToCached;
@property (nonatomic) BOOL                          isLocalCacheInvalid;

// 현재 시간
@property (strong, nonatomic) NSDate                *localDate;

// 버그 수정
@property (strong, nonatomic) CLLocation            *currentCLLocation;

// 테마색 관련
@property (nonatomic) NSInteger                     previousTranslucentFontColor;

// 리프레시 시간 관련
@property (strong, nonatomic) NSDate                *doWidgetLoadingDate;

- (void) setWeatherData:(MNWeatherData*) _info;
- (void) setWeatherSetting:(MNWeatherSetting *) _setting;
- (void) setCurrentLocation:(MNLocationInfo *)_location;
- (void) setTargetLocation:(MNLocationInfo *)_location;

@end












