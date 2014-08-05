//
//  MNWidgetWeatherView.m
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNWidgetWeatherView.h"
#import "MNTheme.h"
#import "MNWeatherImageFactory.h"
#import "MNWeatherParser.h"
#import "MNWeatherTimeGetter.h"
#import "MNWorldWeatherOnlineParser.h"
#import "JLToast.h"
#import <QuartzCore/QuartzCore.h>
#import "MNTranslucentFont.h"
#import "Flurry.h"
#import "MNDefinitions.h"

//#define WEATHER_DEBUG 1
#define WEATHER_DEBUG 0

#define WEATHER_REFRESH_LIMIT_DISTANCE (35 * 1000) // meter -> 3.5km = 2마일, 이사님께서 정하심
#define WEATHER_REFRESH_LIMIT_TIME (60 * 60 * 4) // second -> 4 hours
//#define WEATHER_REFRESH_LIMIT_TIME (20) // second -> 4 hours

//#define WEATHER_CACHE_DEBUG 1
#define WEATHER_CACHE_DEBUG 0

// test
//#define WEATHER_REFRESH_LIMIT_DISTANCE (1000) // meter
//#define WEATHER_REFRESH_LIMIT_TIME (15) // second -> 4 hours
//#define WEATHER_REFRESH_LIMIT_TIME (5) // second -> 4 hours

#define NUMBER_OF_WEATHER_CACHE_DATA 10
#define NUMBER_OF_WEATHER_CACHE_DATA_LOCAL 10

// iPad Alignment - X Offsets
#define OFFSET_X_IMAGEVIEW 132
#define OFFSET_X_CURRENT -8
#define OFFSET_X_TODAY -8
#define OFFSET_X_LOCATION 132
#define OFFSET_X_LOCALTIME 132
// Y Offsets
#define OFFSET_Y_IMAGEVIEW 97
#define OFFSET_Y_CURRENT 75
#define OFFSET_Y_TODAY 22
#define OFFSET_Y_LOCATION -58
#define OFFSET_Y_LOCALTIME -81
// Sizes
#define SIZE_IMAGEVIEW (CGSizeMake(140, 140))
#define SIZE_CURRENT (CGSizeMake(130, 46))
#define SIZE_TODAY (CGSizeMake(130, 31))
#define SIZE_LOCATION (CGSizeMake(263, 30))
#define SIZE_LOCALTIME (CGSizeMake(263, 30))
// Font Sizes
#define FONTSIZE_CURRENT 58
#define FONTSIZE_TODAY 30
#define FONTSIZE_LOCATION 20
#define FONTSIZE_LOCALTIME 20

// iPad LandScape Alignment - X Offsets
#define OFFSET_X_IMAGEVIEW_LAND 164
#define OFFSET_X_CURRENT_LAND -12
#define OFFSET_X_TODAY_LAND -12
#define OFFSET_X_LOCATION_LAND 164
#define OFFSET_X_LOCALTIME_LAND 164
// Y Offsets
#define OFFSET_Y_IMAGEVIEW_LAND 117
#define OFFSET_Y_CURRENT_LAND 85
#define OFFSET_Y_TODAY_LAND 19
#define OFFSET_Y_LOCATION_LAND -75
#define OFFSET_Y_LOCALTIME_LAND -104
// Sizes
#define SIZE_IMAGEVIEW_LAND (CGSizeMake(160, 160))
#define SIZE_CURRENT_LAND (CGSizeMake(160, 60))
#define SIZE_TODAY_LAND (CGSizeMake(160, 60))
#define SIZE_LOCATION_LAND (CGSizeMake(322, 35))
#define SIZE_LOCALTIME_LAND (CGSizeMake(322, 35))
// Font Sizes
#define FONTSIZE_CURRENT_LAND 75
#define FONTSIZE_TODAY_LAND 40
#define FONTSIZE_LOCATION_LAND 25
#define FONTSIZE_LOCALTIME_LAND 25


@implementation MNWidgetWeatherView

static MNWeatherData* InvalidLocationWeatherData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)loadView
{
}

#pragma mark override methods

- (void)initLocationManager
{
    //self.targetLocation = [[MNLocationInfo alloc] init];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 1000; // kCLDistanceFilterNone;//kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer; // kCLLocationAccuracyBest;//kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
}

- (void)loadWeatherDataFromDictionary
{
    // [self setWeatherData:(MNWeatherData*)[self.widgetDictionary objectForKey:DictKey_WeatherSetting]];
    NSData *tData;
    tData = [self.widgetDictionary objectForKey:DictKey_TargetLocation];
    [self setTargetLocation:(MNLocationInfo *)((tData!=nil)?[NSKeyedUnarchiver unarchiveObjectWithData:tData]:nil)];
    tData = [self.widgetDictionary objectForKey:DictKey_WeatherSetting];
    [self setWeatherSetting:(MNWeatherSetting*)((tData!=nil)?[NSKeyedUnarchiver unarchiveObjectWithData:tData]:nil)];
}

// 각 위젯별 커스텀 생성자
- (void)initWidgetView
{
    self.previousTranslucentFontColor = -1;
    [self loadWeatherDataFromDictionary];
    
    // 수정: 이사님께서 중국에서 안된다고 하셔서 수정해봄 - 최초에는 로딩하지 않게 변경. didUpdateLocations 에서 처리하게
    //    MNLocationInfo *currentLocationInfo = [[MNLocationInfo alloc] init];
    //    currentLocationInfo.latitude = _locationManager.location.coordinate.latitude;
    //    currentLocationInfo.longitude = _locationManager.location.coordinate.longitude;
    //    [self setCurrentLocation:currentLocationInfo];
    
    _localTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLocalTime) userInfo:nil repeats:YES];
    
    // 날씨 캐시 데이터 읽어오기
    self.isWeatherDataNeedToCached = NO; // 필요한 경우 YES로 만들기
    NSData *weatherCacheData = [self.widgetDictionary objectForKey:DictKey_WeatherCacheDataList];
    // 기존 값이 없을 경우 빈 Array 생성
    self.weatherCacheDataList = (weatherCacheData != nil) ? [NSKeyedUnarchiver unarchiveObjectWithData:weatherCacheData] : [NSMutableArray array];
    
    // 날씨 로컬 캐시 데이터
    self.isLocalWeatherDataNeedToCached = NO;
    NSData *weatherLocalCacheData = [self.widgetDictionary objectForKey:DictKey_WeatherLocalCacheDataList];
    self.weatherLocalCacheDataList = (weatherLocalCacheData != nil) ? [NSKeyedUnarchiver unarchiveObjectWithData:weatherLocalCacheData] : [NSMutableArray array];
    
    // 테스트로 무조건 캐시 지우기 - 나중에 꼭 주석이나 삭제 필요
    if (WEATHER_CACHE_DEBUG) {
        [self.weatherCacheDataList removeAllObjects];
        [self.weatherLocalCacheDataList removeAllObjects];
    }
}

// 백그라운드 처리 구현부 - 현재 로직에서, 현재 위치를 사용할 때만 locationManager를 켜 주는 로직이 필요할 것으로 보인다.
- (void)doWidgetLoadingInBackground
{
    NSNumber *isTutorialAlreadyShown = [[NSUserDefaults standardUserDefaults] objectForKey:THEME_TUTORIAL_USED];
    
    // 튜토리얼이 끝났을 때만 날씨를 불러오자.
    if (isTutorialAlreadyShown && isTutorialAlreadyShown.boolValue == YES) {
        //[self setWeatherData:(MNWeatherData*)[self.widgetDictionary objectForKey:DictKey_WeatherData]];
        BOOL previouslyUseCurrentLocation = YES; // 이것이 있는 이유는, 새 위치를 얻음에 따라서 cache를 찾는데, 무한루프에 빠지는 경우가 존재해서 이렇게 예외처리를 하였다.
        if (_weatherSetting) {
            previouslyUseCurrentLocation = [_weatherSetting useCurrentLocation];
        }
        
        [self loadWeatherDataFromDictionary];
        
        // 파싱 수정: 현재 위치를 사용할 경우 새 WWO(World Weather Online)을 이용해 날씨 정보 파싱하게 변경 - 모두 WWO 이용
        MNWeatherData* parseData;
        if( [_weatherSetting useCurrentLocation] ) {
            
            // 이 함수가 호출되는 최근 시간을 계속 기록하자
//            NSLog(@"%f", [self.doWidgetLoadingDate timeIntervalSinceDate:[NSDate date]]);
//            NSLog(@"%f", [[NSDate date] timeIntervalSinceDate:self.doWidgetLoadingDate]);
            if (self.doWidgetLoadingDate == nil || [[NSDate date] timeIntervalSinceDate:self.doWidgetLoadingDate] > WEATHER_REFRESH_LIMIT_TIME) {
                // 위젯 로딩 시간을 체크해서 limit 시간이 지났으면 새로 무조건 한 번 캐쉬를 살펴주기(앱을 계속 켜 두었을 때 해당되는 사항)
                if (self.doWidgetLoadingDate) {
//                    NSLog(@"over doWidgetLoadingDate, findCache");
                    [self findCacheWeatherDataFromList];
                }
                
                // 새로 위젯 로딩을 한 시간으로 갱신
                self.doWidgetLoadingDate = [NSDate date];
            }
            
            // 이전에 현재 위치를 사용하기 않고 있었다면 캐쉬를 훓기
            if (previouslyUseCurrentLocation == NO) {
                //            NSLog(@"not useCurrentLoction to useCurrentLocation");
                [self findCacheWeatherDataFromList];
            }
            // 캐시에서 검색이 되어 woeid 가 있는 경우, Yahoo 에서 날씨를 가져오게 구현한다 -> 모든 검색을 WWO에서 하게 변경
            //            if (_weatherData && _weatherData.locationInfo.woeid != 0) {
            //                NSLog(@"get Yahoo weather(current location)");
            //                parseData = [MNWeatherParser parseWithLocation: _weatherData.locationInfo OfTemperatureUnit:[_weatherSetting temperatureUnit]];
            //                parseData.locationInfo = _weatherData.locationInfo;
            //            }
            // 유효한 현재위치 값이 있고, 캐쉬에서 받은 날씨 데이터가 없을 때만 로딩
            if (_currentLocation && _weatherData == nil) {
                _parsingLocation = _currentLocation;
                //            NSLog(@"get WWO weather(current location)");
                parseData = [MNWorldWeatherOnlineParser getWeatherDataFromWorldWeatherOnlineWithLocation:_parsingLocation withTemperatureUnit:[_weatherSetting temperatureUnit]];
            }
        } else {
            //        NSLog(@"parse yahoo weather(select city");
            _parsingLocation = _targetLocation;
            
            // Yahoo 에서 임시적으로 WWO로 변경 - 앞으로 계속 쓸듯
            //        parseData = [MNWeatherParser parseWithLocation: _parsingLocation OfTemperatureUnit:[_weatherSetting temperatureUnit]];
            
            // 날씨를 검색하기 전에 캐시 리스트에서 같은 위경도의 도시가 있는지 판단, 있다면 유효한지 판단
            [self findLocalCacheWeatherDataFromList];
            
            // 유효하다면 그 정보를 가져오기
            // 유효하지 않다면 날씨를 가져오면서 캐시를 교체하기
            if (self.isLocalCacheInvalid) {
                //                NSLog(@"get new wwo data");
                parseData = [MNWorldWeatherOnlineParser getOnlyWeatherDataFromWorldWeatherOnlineWithLocation:_parsingLocation withTemperatureUnit:[_weatherSetting temperatureUnit]];
            }else{
                //                NSLog(@"get cache data");
                parseData = nil;
            }
        }
        
        //    if( [_weatherSetting useCurrentLocation] == NO )
        //        parseData.locationInfo.name = _targetLocation.name;
        
        /* 현재 제대로 활용이 안되고 있음
         if( [_weatherSetting useCurrentLocation] && [parseData isValid] == NO )
         {
         parseData = [self getInvalidGPSWeatherData];
         }
         */
        
        if (parseData) {
            [self setWeatherData:parseData];
        }
    }
}

// UI 스레드 업데이트 구현부
- (void)updateUI
{
    // Location Manager - 최초 한 번만 위치값에 대한 로딩을 하고 싶어서 initWidgetView가 아닌 이곳에 넣음
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSNumber *isTutorialAlreadyShown = [[NSUserDefaults standardUserDefaults] objectForKey:THEME_TUTORIAL_USED];
        
        // 튜토리얼 진행중이라면 위치 정보를 사용하지 말자
        if (isTutorialAlreadyShown && isTutorialAlreadyShown.boolValue == YES) {
            if (!_locationManager && [_weatherSetting useCurrentLocation]) {
                [self initLocationManager];
                [self.loadingDelegate startAnimation];
            }
        }else{
            // 도시 선택 메시지를 보여 주고 더이상의 UI 변경 하지 않음
            [self showLocationFailAndChooseCityMessage:YES];
            return;
        }
    });
    
    if (WEATHER_DEBUG) {
        //    // 테스트 코드: 위도 경도 체크
        self.latitudeLabel.alpha = 0;
        self.longitudeLabel.alpha = 0;
        self.latitudeLabel.text = [NSString stringWithFormat:@"위도: %f/%f", _parsingLocation.latitude, _weatherData.locationInfo.latitude];
        self.longitudeLabel.text = [NSString stringWithFormat:@"경도: %f/%f", _parsingLocation.longitude, _weatherData.locationInfo.longitude];
        
        if (_parsingLocation.latitude != 0 && _parsingLocation.longitude != 0) {
            //            [[[UIAlertView alloc] initWithTitle:@"Weather GPS OK" message:[NSString stringWithFormat:@"위도: %f\n경도: %f", _parsingLocation.latitude, _parsingLocation.longitude] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
    }else{
        self.latitudeLabel.alpha = 0;
        self.longitudeLabel.alpha = 0;
    }
    
    // 파싱 실패
    if( [_weatherData isValid] == NO )
    {
        if (WEATHER_DEBUG) {
            // 테스트 코드
            /*
            if( _weatherData.locationInfo == nil ) {
                [[[UIAlertView alloc] initWithTitle:@"Weather Error" message:@"parsingLocation is nil" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            
            if( _weatherData.locationInfo != nil && _weatherData.locationInfo.latitude == 0 && _weatherData.locationInfo.longitude == 0 ) {
                [[[UIAlertView alloc] initWithTitle:@"Weather Error" message:@"latitude & longitude is 0" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            
            if( [[_weatherData currentTemp] length] == 0 ) {
                [[[UIAlertView alloc] initWithTitle:@"Weather Error" message:@"Can't get currentTemp" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            
            if( [[_weatherData todayTemp] length] == 0 ) {
                [[[UIAlertView alloc] initWithTitle:@"Weather Error" message:@"Can't get todayTemp" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
             */
        }
        
        // 네트워크 불가 이미지
        if (WEATHER_DEBUG) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[[UIAlertView alloc] initWithTitle:@"Weather Error" message:@"Can't load weather" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//            });
            
            // 기존의 로케이션 fail 대신에 다른 동작을 해 준다 - 위치값을 못 얻을 경우는 도시를 고르게
            //            NSLog(@"showLocationFail");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loadingDelegate stopAnimation];
                [self showLocationFailAndChooseCityMessage:YES];
            });
            //            [self.loadingDelegate showLocationFail];
            
        }else{
            // 기존의 로케이션 fail 대신에 다른 동작을 해 준다 - 위치값을 못 얻을 경우는 도시를 고르게
            //            NSLog(@"showLocationFail");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loadingDelegate stopAnimation];
                [self showLocationFailAndChooseCityMessage:YES];
            });
            //            [self.loadingDelegate showLocationFail];
        }
        [self processOnNoNetwork];
    }else{
        // 파싱 성공
        [self showLocationFailAndChooseCityMessage:NO];
        
        // 날씨 컨디션 이미지 세팅
        self.convertedWeatherImage = [self getConvertedWeatherConditionImage:_weatherImage];
        [_image_weatherCondition setImage:self.convertedWeatherImage];
//        [_image_weatherCondition setImage:_weatherImage];
        //        [self makeWeatherConditionImageTheme:_weatherImage];
        
        // 날씨 온도 적용
        if (self.weatherSetting.temperatureUnit == eWTU_Celcius) {
            //            NSLog(@"celcius");
            // 날씨를 잘못 받아올 경우는 바로 네트워크 패일 띄우자.
            if ([_weatherData.todayTemp_c rangeOfString:@"null"].location != NSNotFound ||
                [_weatherData.currentTemp_c rangeOfString:@"null"].location != NSNotFound) {
                [self setWeatherData:nil];
                [self.loadingDelegate showNetworkFail];
                return;
            }
            
            [_label_currentTemperature setText:[_weatherData currentTemp_c]];
            [_label_todayTemperature setText:[_weatherData todayTemp_c]];
        }else{
            //            NSLog(@"fahrenheit");
            // 날씨를 잘못 받아올 경우는 바로 네트워크 패일 띄우자.
            if ([_weatherData.todayTemp_f rangeOfString:@"null"].location != NSNotFound ||
                [_weatherData.currentTemp_f rangeOfString:@"null"].location != NSNotFound) {
                [self setWeatherData:nil];
                [self.loadingDelegate showNetworkFail];
                return;
            }
            [_label_currentTemperature setText:[_weatherData currentTemp_f]];
            [_label_todayTemperature setText:[_weatherData todayTemp_f]];
        }
        //        [_label_currentTemperature setText:[_weatherData currentTemp]];
        //        [_label_todayTemperature setText:[_weatherData todayTemp]];
        
        // 지원되는 다국어 언어가 있다면 그것을 표시
        if (_weatherData.locationInfo.name) {
            [_label_currentLocation setText:[_weatherData.locationInfo.name capitalizedString]];
        }else{
            [_label_currentLocation setText:[[_weatherData getLocationName] capitalizedString]];
        }
        
        [self checkWeatherDataCaching];
        [self checkLocalWeatherDataCaching];
        
        if (_weatherSetting.displayLocalTime) {
            [self stopTimer];
            _localTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLocalTime) userInfo:nil repeats:YES];
            self.label_currentLocation.alpha = 1;
            self.label_localTime.alpha = 1;
            [self updateLocalTime];
        }else{
            [self stopTimer];
            self.label_currentLocation.alpha = 0;
            //            self.label_localTime.alpha = 0;
            self.label_localTime.text = self.label_currentLocation.text;
        }
        //        [_locationManager stopUpdatingLocation];
    }
}

- (void)showLocationFailAndChooseCityMessage:(BOOL)isLocationFail
{
    if (isLocationFail) {
        self.label_currentTemperature.alpha = 0;
        self.label_todayTemperature.alpha = 0;
        self.label_localTime.alpha = 0;
        self.image_weatherCondition.alpha = 0;
        self.label_currentLocation.alpha = 0;
        self.error_weatherLabel.alpha = 1;
        self.error_weatherLabel.text = MNLocalizedString(@"weather", nil);
        self.error_chooseYourCityLabel.alpha = 1;
        self.error_chooseYourCityLabel.text = MNLocalizedString(@"weather_choose_your_city", nil) ;
    }else{
        self.label_currentTemperature.alpha = 1;
        self.label_todayTemperature.alpha = 1;
        self.label_localTime.alpha = 1;
        self.image_weatherCondition.alpha = 1;
        self.label_currentLocation.alpha = 1;
        self.error_weatherLabel.alpha = 0;
        self.error_chooseYourCityLabel.alpha = 0;
    }
}

- (void)initThemeColor
{
    [super initThemeColor];
    //    NSLog(@"weather initThemeColor");
    //    NSLog(@"theme: %d", [MNTheme getCurrentlySelectedTheme]);
    
    //    [self setBackgroundColor:[MNTheme getForwardBackgroundUIColor]];
    
    self.label_currentTemperature.textColor = [MNTheme getMainFontUIColor];
    self.label_todayTemperature.textColor = [MNTheme getMainFontUIColor];
    self.label_currentLocation.textColor = [MNTheme getWidgetSubFontUIColor];
    self.label_localTime.textColor = [MNTheme getWidgetSubFontUIColor];
    
    self.error_weatherLabel.textColor = [MNTheme getMainFontUIColor];
    self.error_chooseYourCityLabel.textColor = [MNTheme getWidgetSubFontUIColor];
    //    NSLog(@"%@", NSStringFromCGRect(self.error_chooseYourCityLabel.frame));
    //    NSLog(@"%@", NSStringFromCGRect(self.frame));
    
    // 수정: 컨버전한 아트를 위젯에서 가지고 있게 구현
//    UIImage *convertedWeatherConditionImage = [self getConvertedWeatherConditionImage:_weatherImage];
    self.convertedWeatherImage = [self getConvertedWeatherConditionImage:_weatherImage];
    self.image_weatherCondition.image = self.convertedWeatherImage;
    //    [self makeWeatherConditionImageTheme:self.image_weatherCondition.image];
}

- (void)widgetClicked {
    // 아래 표기는 새로운 NSNumber 리터럴 표기법
    //    NSLog(@"%@", @(self.isLunarCalendarOn));
    //[self.widgetDictionary setObject:self.weatherData forKey:DictKey_WeatherData];
    
    [self.widgetDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:self.targetLocation] forKey:DictKey_TargetLocation];
    [self.widgetDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:self.weatherSetting] forKey:DictKey_WeatherSetting];
}

#pragma mark private methods

- (void)setWeatherData:(MNWeatherData*)_info
{
    if( _info ) {
        _weatherData = _info;
        if (_currentLocation) {
            _weatherData.locationInfo.timestamp = _currentLocation.timestamp;
        }
    }
    
    if( _weatherData == nil )
        _weatherData = [[MNWeatherData alloc]init];
    
    if (_info.weatherCondition == eWC_noData && _info.wwoWeatherCondition != e_WWO_WC_noData) {
        //        NSLog(@"get image from WWO weatherCondition");
        _weatherImage = [MNWeatherImageFactory getWWOImage:_weatherData.wwoWeatherCondition];
        
    }else if(_info.weatherCondition != eWC_noData && _info.wwoWeatherCondition == e_WWO_WC_noData){
        //        NSLog(@"get image from Yahoo weatherCondition");
        _weatherImage = [MNWeatherImageFactory getImage:[_weatherData weatherCondition]];
    }
}

- (void) setWeatherSetting:(MNWeatherSetting *) _setting
{
    if( _setting )
        _weatherSetting = _setting;
    
    if( _weatherSetting == nil )
        _weatherSetting = [[MNWeatherSetting alloc]init];
    
}

- (void) setCurrentLocation:(MNLocationInfo *)_location
{
    
    if( _location )
        _currentLocation = _location;
    
    if( _currentLocation == nil )
    {
        _currentLocation = [[MNLocationInfo alloc] init];
    }
    
    //[self.widgetDictionary setObject:_currentLocation forKey:DictKey_CurrentLocation];
    
}

- (void) setTargetLocation:(MNLocationInfo *)_location
{
    if( _location )
        _targetLocation = _location;
    
    if( _targetLocation == nil )
    {
        // 언어 설정 체크
        NSArray *languageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        //NSLog(@"%@", [languageArray objectAtIndex:0]);
        NSString* languageCode = [languageArray objectAtIndex:0];
        
        _targetLocation = [[MNLocationInfo alloc] initByLanguageCode:languageCode];
    }
}

- (NSString*) getTimeOfTimezone : (NSString*) _timezoneCode
{
    if( _weatherSetting.displayLocalTime )
        return [MNWeatherTimeGetter getTimeStringOfTimeZone:_timezoneCode];
    else
        return @"";
}

- (MNWeatherData*) getInvalidGPSWeatherData
{
    if( InvalidLocationWeatherData == nil )
    {
        InvalidLocationWeatherData = [[MNWeatherData alloc] init];
        
        [InvalidLocationWeatherData setCurrentTemp:@"Invalid"];
        [InvalidLocationWeatherData setTodayTemp:@"Location"];
    }
    return InvalidLocationWeatherData;
}

// 매초 한번씩 실행한다.
- (void) updateLocalTime
{
    if (_weatherData) {
        if (_weatherData.locationInfo.timeOffset != 0) {
            // 최초 초기화 확인
            self.localDate = [NSDate dateWithTimeIntervalSinceNow:_weatherData.locationInfo.timeOffset];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            
            // 둘다 UTC 기준이라고 가정하고 offset만을 구함
            dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
            _label_localTime.text = [dateFormatter stringFromDate:self.localDate];
        }else{
            if (_label_localTime) {
                _label_localTime.text = @"00:00:00";
            }
        }
    }
    //    [_label_localTime setText: [self getTimeOfTimezone:[_weatherData getLocationTimezoneCode]]];
}


#pragma LocationDelegate

// iOS 5 용 메서드는 이제 필요없어서 지워버림
// iOS 6 and later: 소스 애플에서 가져 옴
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //    NSLog(@"iOS6: didUpdateLocations");
    
    //    NSLog(@"didUpdateLocations");
    
    // 현재 위치가 켜져 있을 때만 적용하기
    if ([_weatherSetting useCurrentLocation]) {
        // If it's a relatively recent event, turn off updates to save power
        
        CLLocation* currentLocation = [locations lastObject];
        
        // 위치 정보를 여러 번 받을 경우가 있는데, 세부적인 값이 받아지지 않더라도 최초 한번만 제대로 받으면 됨. 만약 크게 바뀐다면 여러번 날씨를 읽어와야 하기는 함
        if (self.currentCLLocation && [self.currentCLLocation distanceFromLocation:currentLocation] < WEATHER_REFRESH_LIMIT_DISTANCE) {
            return;
        }
        self.currentCLLocation = currentLocation;
        
        // 유효한 위치일경우만 진행
        if (currentLocation.coordinate.latitude != 0 && currentLocation.coordinate.longitude != 0) {
            
            //// 새로 리팩토링 및 구현할 코드 ////
            // 캐시 데이터에서 위/경도와 timestamp로 CLLocation을 조립해 모두 비교해 유효한 값이 없을 때 새로 날씨를 가져오게 하는 것
            BOOL isCurrentLocationInCachedLocationBoundary = NO;
            for (int i=0; i<self.weatherCacheDataList.count; i++) {
                MNWeatherData *cachedWeatherData = [self.weatherCacheDataList objectAtIndex:i];
                CLLocation *cachedLocation = [[CLLocation alloc] initWithLatitude:cachedWeatherData.locationInfo.latitude longitude:cachedWeatherData.locationInfo.longitude];
                
                // 캐시된 위치의 지정 반경 안에 들어온다면 시간을 체크해서 이 날씨 데이터를 사용하거나 새로 날씨를 가져오기
                // 새로 날씨를 가져오는 경우에는 값이 바뀌므로, 이 캐시 데이터를 미리 지워주고, 새로 얻은 값을 다시 캐시 리스트에 넣어 준다.
                if ([cachedLocation distanceFromLocation:currentLocation] <= WEATHER_REFRESH_LIMIT_DISTANCE) {
                    //                    NSLog(@"current location is in %@, which is in cache data", cachedWeatherData.locationInfo.englishName);
                    isCurrentLocationInCachedLocationBoundary = YES;
                    
                    if (currentLocation.timestamp && cachedWeatherData.locationInfo.timestamp) {
                        NSTimeInterval timeInterval = [currentLocation.timestamp timeIntervalSinceDate:cachedWeatherData.locationInfo.timestamp];
                        if (timeInterval > WEATHER_REFRESH_LIMIT_TIME) {
                            //                            NSLog(@"over weather refresh time limit, need to refresh");
                            // 기존 캐시 삭제 후 새로운 캐시를 넣음
                            //                            NSLog(@" city woeid: %d", cachedWeatherData.locationInfo.woeid);
                            
                            // woeid 체크
                            //                            if (cachedWeatherData.locationInfo.woeid != 0) {
                            //                                // woeid가 미리 검색이 되었으면 woeid로 Yahoo 날씨를 받아오기
                            //                                NSLog(@"get new Yahoo Weather");
                            //                                [[JLToast makeText:@"Found in cache data, so get a new Yahoo Weather from woeid code"] show];
                            //                                _weatherData = cachedWeatherData;
                            //                                self.isWeatherDataNeedToCached = YES;
                            //                                [self refreshWidgetView];
                            //                            }else{
                            // woeid = 0이라면 검색이 안되었으므로, WWO 날씨를 받아오기
                            if (WEATHER_DEBUG) {
                                [[JLToast makeText:@"Found in cache data but no woeid, so get a new Weather from 'World Weather Online'"] show];
                            }
                            //                                NSLog(@"get new WWO Weather");
                            [self refreshWeatherDataWithLatitude:currentLocation.coordinate.latitude withLongitude:currentLocation.coordinate.longitude withTimestamp:currentLocation.timestamp];
                            //                            }
                            
                            // 기존 캐쉬 삭제
                            [self.weatherCacheDataList removeObject:cachedWeatherData];
                            [self.widgetDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:self.weatherCacheDataList] forKey:DictKey_WeatherCacheDataList];
                        }else{
                            //                            NSLog(@"not over weather refresh time limit, just show previous weather data");
                            if (WEATHER_DEBUG) {
                                [[JLToast makeText:@"Current location is in cache and show previous weather data because data is got within 4 hours"] show];
                            }
                            // weatherdata를 캐시 데이터로 변경
                            [self setWeatherData:cachedWeatherData];
                            [self refreshWidgetView];
                        }
                    }
                    break;
                }
            }
            // Fast Enumeration 및 Collection was mutated while being enumerated error in objective C 크래쉬 때문에 변경
            //            for (MNWeatherData *cachedWeatherData in self.weatherCacheDataList) {
            //
            //            }
            // 현재 위치가 어느 캐시된 위치 반경에도 속하지 않는다면 새로 WWO 날씨를 얻고 캐시로 저장한다.
            if (isCurrentLocationInCachedLocationBoundary == NO) {
                //                NSLog(@"current location is not in cache data, get new weather data");
                if (WEATHER_DEBUG) {
                    [[JLToast makeText:@"Current location is not in cache, so get a new Weather from 'World Weather Online'"] show];
                }
                [self refreshWeatherDataWithLatitude:currentLocation.coordinate.latitude withLongitude:currentLocation.coordinate.longitude withTimestamp:currentLocation.timestamp];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
//    NSLog(@"%@", error.localizedDescription);
    
    /*
     [[[UIAlertView alloc] initWithTitle:@"Weather Location Manager"
     message:error.description
     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     */
}

- (void)refreshWeatherDataWithLatitude:(CLLocationDegrees)latitude withLongitude:(CLLocationDegrees)longitude withTimestamp:(NSDate *)timestamp{
    MNLocationInfo *newCurrentLocation = [[MNLocationInfo alloc] init];
    
    newCurrentLocation.latitude = latitude;
    newCurrentLocation.longitude = longitude;
    newCurrentLocation.timestamp = timestamp;
    _currentLocation = newCurrentLocation;
    
    // refresh 가 비동기로 처리되기 때문에 여기에서 리프레시가 된 뒤에는 캐시를 저장해야 하는데, 타이밍을 어떻게 캐치할지 고민 - 아마 BOOL로 해결을 할 수도 있을 듯한데.
    self.isWeatherDataNeedToCached = YES;
    _weatherData = nil; // 캐시가 없다는 뜻으로 사용
    [self refreshWidgetView];
}


#pragma mark - on ratation

- (void)onRotationWithOrientation:(UIInterfaceOrientation)orientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight))
        {
            CGRect widgetFrame = self.frame;
            
            CGRect newCurrentLocation = self.label_currentLocation.frame;
            CGRect newCurrent = self.label_currentTemperature.frame;
            CGRect newLocalTime = self.label_localTime.frame;
            CGRect newToday = self.label_todayTemperature.frame;
            CGRect newImage = self.image_weatherCondition.frame;
            
            // Set size
            newImage.size = SIZE_IMAGEVIEW_LAND;
            newCurrent.size = SIZE_CURRENT_LAND;
            newToday.size = SIZE_TODAY_LAND;
            newCurrentLocation.size = SIZE_LOCATION_LAND;
            newLocalTime.size = SIZE_LOCALTIME_LAND;
            
            newImage.origin = CGPointMake(widgetFrame.size.width/2 - OFFSET_X_IMAGEVIEW_LAND, widgetFrame.size.height/2 - OFFSET_Y_IMAGEVIEW_LAND);
            newCurrent.origin = CGPointMake(widgetFrame.size.width/2 - OFFSET_X_CURRENT_LAND, widgetFrame.size.height/2 - OFFSET_Y_CURRENT_LAND);
            newToday.origin = CGPointMake(widgetFrame.size.width/2 - OFFSET_X_TODAY_LAND, widgetFrame.size.height/2 - OFFSET_Y_TODAY_LAND);
            newCurrentLocation.origin = CGPointMake(widgetFrame.size.width/2 - OFFSET_X_LOCATION_LAND, widgetFrame.size.height/2 - OFFSET_Y_LOCATION_LAND);
            newLocalTime.origin = CGPointMake(widgetFrame.size.width/2 - OFFSET_X_LOCALTIME_LAND, widgetFrame.size.height/2 - OFFSET_Y_LOCALTIME_LAND);
            
            self.image_weatherCondition.frame = newImage;
            self.label_currentTemperature.frame = newCurrent;
            self.label_todayTemperature.frame = newToday;
            self.label_currentLocation.frame = newCurrentLocation;
            self.label_localTime.frame = newLocalTime;
            
            self.label_currentTemperature.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_CURRENT_LAND];
            self.label_todayTemperature.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_TODAY_LAND];
            self.label_currentLocation.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LOCATION_LAND];
            self.label_localTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LOCALTIME_LAND];
        }
        else
        {
            CGRect widgetFrame = self.frame;
            
            CGRect newCurrentLocation = self.label_currentLocation.frame;
            CGRect newCurrent = self.label_currentTemperature.frame;
            CGRect newLocalTime = self.label_localTime.frame;
            CGRect newToday = self.label_todayTemperature.frame;
            CGRect newImage = self.image_weatherCondition.frame;
            
            // Set size
            newImage.size = SIZE_IMAGEVIEW;
            newCurrent.size = SIZE_CURRENT;
            newToday.size = SIZE_TODAY;
            newCurrentLocation.size = SIZE_LOCATION;
            newLocalTime.size = SIZE_LOCALTIME;
            
            newImage.origin = CGPointMake(widgetFrame.size.width/2 - OFFSET_X_IMAGEVIEW, widgetFrame.size.height/2 - OFFSET_Y_IMAGEVIEW);
            newCurrent.origin = CGPointMake(widgetFrame.size.width/2 - OFFSET_X_CURRENT, widgetFrame.size.height/2 - OFFSET_Y_CURRENT);
            newToday.origin = CGPointMake(widgetFrame.size.width/2 - OFFSET_X_TODAY, widgetFrame.size.height/2 - OFFSET_Y_TODAY);
            newCurrentLocation.origin = CGPointMake(widgetFrame.size.width/2 - OFFSET_X_LOCATION, widgetFrame.size.height/2 - OFFSET_Y_LOCATION);
            newLocalTime.origin = CGPointMake(widgetFrame.size.width/2 - OFFSET_X_LOCALTIME, widgetFrame.size.height/2 - OFFSET_Y_LOCALTIME);
            
            self.image_weatherCondition.frame = newImage;
            self.label_currentTemperature.frame = newCurrent;
            self.label_todayTemperature.frame = newToday;
            self.label_currentLocation.frame = newCurrentLocation;
            self.label_localTime.frame = newLocalTime;
            
            self.label_currentTemperature.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_CURRENT];
            self.label_todayTemperature.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_TODAY];
            self.label_currentLocation.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LOCATION];
            self.label_localTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LOCALTIME];
        }
    }
}


#pragma mark - caching

- (void)findCacheWeatherDataFromList {
    // 유효한 위치일경우만 진행
    if (self.currentCLLocation) {
        if (self.currentCLLocation.coordinate.latitude != 0 && self.currentCLLocation.coordinate.longitude != 0) {
            
            //// 새로 리팩토링 및 구현할 코드 ////
            // 캐시 데이터에서 위/경도와 timestamp로 CLLocation을 조립해 모두 비교해 유효한 값이 없을 때 새로 날씨를 가져오게 하는 것
            BOOL isCurrentLocationInCachedLocationBoundary = NO;
            for (int i=0; i<self.weatherCacheDataList.count; i++) {
                MNWeatherData *cachedWeatherData = [self.weatherCacheDataList objectAtIndex:i];
                CLLocation *cachedLocation = [[CLLocation alloc] initWithLatitude:cachedWeatherData.locationInfo.latitude longitude:cachedWeatherData.locationInfo.longitude];
                
                // 캐시된 위치의 지정 반경 안에 들어온다면 시간을 체크해서 이 날씨 데이터를 사용하거나 새로 날씨를 가져오기
                // 새로 날씨를 가져오는 경우에는 값이 바뀌므로, 이 캐시 데이터를 미리 지워주고, 새로 얻은 값을 다시 캐시 리스트에 넣어 준다.
                if ([cachedLocation distanceFromLocation:self.currentCLLocation] <= WEATHER_REFRESH_LIMIT_DISTANCE) {
                    //                    NSLog(@"current location is in %@, which is in cache data", cachedWeatherData.locationInfo.englishName);
                    isCurrentLocationInCachedLocationBoundary = YES;
                    
//                    NSLog(@"%@", self.currentCLLocation.timestamp);
//                    NSLog(@"%@", cachedWeatherData.locationInfo.timestamp);
//                    NSLog(@"%@", [NSDate date]);
                    if (self.currentCLLocation.timestamp && cachedWeatherData.locationInfo.timestamp) {
                        //                        NSLog(@"currentCLLocation: %@", self.currentCLLocation.timestamp);
                        //                        NSLog(@"cachedWeatherData: %@", cachedWeatherData.locationInfo.timestamp);
                        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:cachedWeatherData.locationInfo.timestamp];
                        if (timeInterval > WEATHER_REFRESH_LIMIT_TIME) {
                            //                            NSLog(@"over weather refresh time limit, need to refresh");
                            // 기존 캐시 삭제 후 새로운 캐시를 넣음
                            //                            NSLog(@"cache city woeid: %d", cachedWeatherData.locationInfo.woeid);
                            
                            //                            // woeid 체크
                            //                            if (cachedWeatherData.locationInfo.woeid != 0) {
                            //                                // woeid가 미리 검색이 되었으면 woeid로 Yahoo 날씨를 받아오기
                            //                                //                                NSLog(@"get new Yahoo Weather");
                            //                                dispatch_async(dispatch_get_main_queue(), ^{
                            //                                    [[JLToast makeText:@"Found in cache data, so get a new Yahoo Weather from woeid code"] show];
                            //                                });
                            //                                _weatherData = cachedWeatherData;
                            //                                self.isWeatherDataNeedToCached = YES;
                            //                                [self refreshWidgetView];
                            //                            }else{
                            // woeid = 0이라면 검색이 안되었으므로, WWO 날씨를 받아오기
                            if (WEATHER_DEBUG) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[JLToast makeText:@"Found in cache data but no woeid, so get a new Weather from 'World Weather Online'"] show];
                                });
                            }
                            //                                NSLog(@"get new WWO Weather");
                            [self refreshWeatherDataWithLatitude:self.currentCLLocation.coordinate.latitude withLongitude:self.currentCLLocation.coordinate.longitude withTimestamp:self.currentCLLocation.timestamp];
                            //                            }
                            
                            // 기존 캐쉬 삭제
                            [self.weatherCacheDataList removeObject:cachedWeatherData];
                            [self.widgetDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:self.weatherCacheDataList] forKey:DictKey_WeatherCacheDataList];
                        }else{
                            //                            NSLog(@"not over weather refresh time limit, just show previous weather data");
                            if (WEATHER_DEBUG) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[JLToast makeText:@"Current location is in cache and show previous weather data because data is got within 4 hours"] show];
                                });
                            }
                            // weatherdata를 캐시 데이터로 변경
                            [self setWeatherData:cachedWeatherData];
                            //                            [self refreshWidgetView];
                        }
                    }
                    break;
                }
            }
            //            for (MNWeatherData *cachedWeatherData in self.weatherCacheDataList) {
            //
            //            }
            // 현재 위치가 어느 캐시된 위치 반경에도 속하지 않는다면 새로 WWO 날씨를 얻고 캐시로 저장한다.
            if (isCurrentLocationInCachedLocationBoundary == NO) {
                //                NSLog(@"current location is not in cache data, get new weather data");
                if (WEATHER_DEBUG) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[JLToast makeText:@"Current location is not in cache, so get a new Weather from 'World Weather Online'"] show];
                    });
                }
                [self refreshWeatherDataWithLatitude:self.currentCLLocation.coordinate.latitude withLongitude:self.currentCLLocation.coordinate.longitude withTimestamp:self.currentCLLocation.timestamp];
            }
        }
    }
}

- (void)findLocalCacheWeatherDataFromList {
    
    self.isLocalWeatherDataNeedToCached = YES;
    self.isLocalCacheInvalid = YES;
    
    //    NSLog(@"target: %@", self.targetLocation.name);
    
    // target의 위경도와, 캐쉬의 위경도를 비교, 만약 같다면 해당 target도시는 캐쉬에 존재하는 것
    for (int i=0; i<self.weatherLocalCacheDataList.count; i++) {
        //        NSLog(@"%@", cachedLocalWeatherData.locationInfo.englishName);
        MNWeatherData *cachedLocalWeatherData = [self.weatherLocalCacheDataList objectAtIndex:i];
        if (self.targetLocation.latitude == cachedLocalWeatherData.locationInfo.latitude &&
            self.targetLocation.longitude == cachedLocalWeatherData.locationInfo.longitude) {
            // 같은 도시
            
            // 검색이 된다면, timestamp 를 비교, timestamp가 4시간 안이라면 그냥 보여주기,
            if (cachedLocalWeatherData.locationInfo.timestamp) {
                
                NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:cachedLocalWeatherData.locationInfo.timestamp];
                //                NSLog(@"%lf", timeInterval);
                
                if (timeInterval > WEATHER_REFRESH_LIMIT_TIME) {
                    // 4시간 이상이라면 새로 날씨를 얻어오기(기존 캐시 삭제 후 새로 저장)
                    // 기존 캐쉬 삭제
                    if (WEATHER_DEBUG) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[JLToast makeText:@"Getting new valid weather from WWO"] show];
                        });
                    }
                    [self.weatherLocalCacheDataList removeObject:cachedLocalWeatherData];
                    [self.widgetDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:self.weatherLocalCacheDataList] forKey:DictKey_WeatherLocalCacheDataList];
                    
                }else{
                    if (WEATHER_DEBUG) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[JLToast makeText:@"Target location is in cache and show previous weather data because data is got within 4 hours"] show];
                        });
                    }
                    [self setWeatherData:cachedLocalWeatherData];
                    self.isLocalWeatherDataNeedToCached = NO;
                    self.isLocalCacheInvalid = NO;
                }
            }
        }
    }
    //    for (MNWeatherData *cachedLocalWeatherData in self.weatherLocalCacheDataList) {
    //
    //    }
}

- (void)checkWeatherDataCaching
{
    // 캐싱 체크
    if (self.isWeatherDataNeedToCached) {
        self.isWeatherDataNeedToCached = NO;
        // 제한을 넘으면 예전 것 삭제하고 추가, 아니면 그냥 추가.
        //        NSLog(@"count: %d", self.weatherCacheDataList.count);
        if (self.weatherCacheDataList.count >= NUMBER_OF_WEATHER_CACHE_DATA) {
            [self.weatherCacheDataList removeObjectAtIndex:0];
        }
        // 따로 캐시 자료 구조를 생각할 필요 없이 weatherData를 저장하면 되는 것이었다 - timestamp는 추가
        [self.weatherCacheDataList addObject:self.weatherData];
        
        // 저장한 캐시 아카이빙
        [self.widgetDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:self.weatherCacheDataList] forKey:DictKey_WeatherCacheDataList];
    }
}

- (void)checkLocalWeatherDataCaching
{
    // 캐싱 체크
    if (self.isLocalWeatherDataNeedToCached) {
        self.isLocalWeatherDataNeedToCached = NO;
        // 제한을 넘으면 예전 것 삭제하고 추가, 아니면 그냥 추가.
        //        NSLog(@"count: %d", self.weatherCacheDataList.count);
        if (self.weatherLocalCacheDataList.count >= NUMBER_OF_WEATHER_CACHE_DATA_LOCAL) {
            [self.weatherLocalCacheDataList removeObjectAtIndex:0];
        }
        // 따로 캐시 자료 구조를 생각할 필요 없이 weatherData를 저장하면 되는 것이었다 - timestamp는 추가
        [self.weatherLocalCacheDataList addObject:self.weatherData];
        
        // 저장한 캐시 아카이빙
        [self.widgetDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:self.weatherLocalCacheDataList] forKey:DictKey_WeatherLocalCacheDataList];
    }
}


#pragma mark - image processing

- (UIImage *)getConvertedWeatherConditionImage:(UIImage *)image {
    if (image) {
        // 이미지에 필터를 씌워 보자
        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClipToMask(context, rect, image.CGImage);
        
        switch ([MNTheme getCurrentlySelectedTheme]) {
            case MNThemeTypeMirror:
            case MNThemeTypeScenery:
            case MNThemeTypePhoto:
                if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeBlack) {
                    CGContextSetFillColorWithColor(context, [[MNTheme getMainFontUIColor] CGColor]);
                }else{
                    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
                }
                break;
                
            case MNThemeTypeWaterLily:
                CGContextSetFillColorWithColor(context, [[MNTheme getMainFontUIColor] CGColor]);
                break;
                
            case MNThemeTypeClassicGray:
            case MNThemeTypeSkyBlue:
                CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
                break;
                
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

- (void)logEventOnFlurry
{
    [super logEventOnFlurry];
    
    NSDictionary *param;
    
    if (self.weatherSetting.useCurrentLocation)
        param = [NSDictionary dictionaryWithObject:@"Auto" forKey:@"Location Mode"];
    else
        param = [NSDictionary dictionaryWithObject:@"Manual" forKey:@"Location Mode"];
    
    [Flurry logEvent:@"Weather" withParameters:param];
}

/*
- (void)makeWeatherConditionImageTheme:(UIImage *)image {
    
    if (image) {
        // 이미지에 필터를 씌워 보자
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
            UIGraphicsBeginImageContext(rect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextClipToMask(context, rect, image.CGImage);
            
            switch ([MNTheme getCurrentlySelectedTheme]) {
                case MNThemeTypeMirror:
                case MNThemeTypeScenery:
                case MNThemeTypePhoto:
                    if (self.previousTranslucentFontColor == -1 || self.previousTranslucentFontColor != [MNTranslucentFont getCurrentFontType]) {
                        self.previousTranslucentFontColor = [MNTranslucentFont getCurrentFontType];
                        
                        if ([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeBlack) {
                            CGContextSetFillColorWithColor(context, [[MNTheme getMainFontUIColor] CGColor]);
                        }else{
                            CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
                        }
                    }
                    break;
                    
                case MNThemeTypeClassicGray:
                case MNThemeTypeSkyBlue:
                    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
                    break;
                    
                case MNThemeTypeClassicWhite:
                    CGContextSetFillColorWithColor(context, [[MNTheme getMainFontUIColor] CGColor]);
                    break;
            }
            CGContextFillRect(context, rect);
            UIImage *convertedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIImage *flippedImage = [UIImage imageWithCGImage:convertedImage.CGImage scale:1.0 orientation: UIImageOrientationDownMirrored];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image_weatherCondition.image = flippedImage;
            });
        });
    }
}
*/

#pragma mark - stop timer

- (void)stopTimer {
    [_localTimeTimer invalidate];
    _localTimeTimer = nil;
}

- (void)removeFromSuperview
{
    //    NSLog(@"weather: stop timer in removeFromSuperView");
	[self stopTimer];
	[super removeFromSuperview];
}

@end
