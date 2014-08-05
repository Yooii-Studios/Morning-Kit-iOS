//
//  MNWorldWeatherOnlineParser.m
//  Morning Kit
//
//  Created by 김우성 on 13. 6. 17..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWorldWeatherOnlineParser.h"
#import "JSONKit.h"
#import "MNReverseGeocodeParser.h"
#import "MNLanguage.h"
#import "MNCityInfoQuery.h"
#import "MNDefinitions.h"

@implementation MNWorldWeatherOnlineParser

+ (MNWeatherData *)getWeatherDataFromWorldWeatherOnlineWithLocation:(MNLocationInfo *)locationInfo withTemperatureUnit:(enum MNWeatherTemperatureUnit)tempUnit {
    
    // 바꾸고 싶은 로직. dispatch queue를 쓰되, 날씨를 먼저 가져오게 하는 파서와 구글에서 이름을 가져오는 파서를 같이 돌려서 순차적 큐에 집어넣는다. 이 큐에서 두 작업을 동시에 진행해서, 결과값을 가지고 동시에 두 일을 처리하고 싶다.
    
    // 결과값 반환할 날씨 데이터
    __block MNWeatherData *weatherData = [[MNWeatherData alloc] init];
    
    // 날씨를 읽을 당시의 시간을 저장
    weatherData.locationInfo.timestamp = [NSDate date];
    
    // 블락 처리를 위해 바깥으로 변수를 뺌
    __block BOOL wwoWeatherBlockFinished = NO;
    __block BOOL googleCityNameBlockFinished = NO;
    __block BOOL googleCurrentCityNameBlockFinished = NO;
    __block NSString *googleReverseGeocodeCityName = nil;
    __block NSString *googleReverseGeocodeCityName_CurrentLanguage = nil;
    __block NSDictionary *allWeatherData;
    
    // 돌릴 큐
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 1번 블락: 날씨 가져오기
    dispatch_async(global_queue, ^{
        // 위도, 경도값을 가지고 json 으로 파싱해서 결과값을 보여준다.
        //    NSLog(@"%f %f", locationInfo.latitude, locationInfo.longitude);
        
        NSString *queryURLString = [NSString stringWithFormat:@"http://api.worldweatheronline.com/premium/v1/weather.ashx?q=+%f%%2C%f&format=json&extra=localObsTime&num_of_days=1&date=today&includelocation=yes&show_comments=no&key=%@", locationInfo.latitude, locationInfo.longitude, WWO_KEY];
        
//        NSLog(@"%@", queryURLString);
        
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:queryURLString]];
        //    NSLog(@"%@", jsonData);
        JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
        if (jsonData) {
            weatherData.locationInfo.latitude = locationInfo.latitude;
            weatherData.locationInfo.longitude = locationInfo.longitude;
            
            // The string argument is NULL
            // 잘못된 값이 들어온다면 다음 값이 NULL이다
            if ([jsonData bytes] != NULL) {
                allWeatherData = [[jsonKitDecoder objectWithData:jsonData] objectForKey:@"data"]; // JSONKit
                
                //        NSLog(@"%@", allWeatherData);
                
                NSDictionary *current_condition = [[allWeatherData objectForKey:@"current_condition"] objectAtIndex:0];
                if ([current_condition isKindOfClass:[NSNull class]] == NO) {
                    NSString *current_tempKey = (tempUnit==eWTU_Celcius) ? @"temp_C" : @"temp_F";
                    weatherData.currentTemp = [NSString stringWithFormat:@"%@º", [current_condition objectForKey:current_tempKey]];
                    
                    // 섭/화씨 둘다 얻기
                    weatherData.currentTemp_c = [NSString stringWithFormat:@"%@º", [current_condition objectForKey:@"temp_C"]];
                    weatherData.currentTemp_f = [NSString stringWithFormat:@"%@º", [current_condition objectForKey:@"temp_F"]];
                    
                    weatherData.wwoWeatherCondition = [[current_condition objectForKey:@"weatherCode"] integerValue];
                    weatherData.weatherCondition = eWC_noData;
                    //        NSLog(@"%@", current_condition);
                    
                    // 추가: GMT 와 timeOffset 계산
                    NSString *dateString = [current_condition objectForKey:@"localObsDateTime"];
                    //            NSLog(@"localObsDateTime: %@", [current_condition objectForKey:@"localObsDateTime"]);
                    
                    if (dateString) {
                        // 2013-06-29 03:20 PM 의 형식을 DateFormatter로 미리 만들어줘서 NSDate로 변환한다.
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
                        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
                        
                        // 둘다 UTC 기준이라고 가정하고 offset만을 구함
                        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                        //                NSLog(@"UTC:    %@", [dateFormatter stringFromDate:[NSDate date]]);
                        NSDate *UTCDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
                        
                        NSDate *targetDate = [dateFormatter dateFromString:dateString];
                        //                NSLog(@"Target: %@", [dateFormatter stringFromDate:targetDate]);
                        
                        //                NSLog(@"UTCDate: %@", UTCDate);
                        //                NSLog(@"targetDate: %@", targetDate);
                        
                        // yyyy-mm-dd HH:mm
                        weatherData.locationInfo.timeOffset = [targetDate timeIntervalSinceDate:UTCDate];
                        //                NSLog(@"timeOffset: %d", weatherData.locationInfo.timeOffset);
                    }
                }
                
                NSDictionary *todayCondition = [[allWeatherData objectForKey:@"weather"] objectAtIndex:0];
                if ([todayCondition isKindOfClass:[NSNull class]] == NO) {
                    NSString *maxTempKey = (tempUnit==eWTU_Celcius) ? @"maxtempC" : @"maxtempF";
                    NSString *minTempKey = (tempUnit==eWTU_Celcius) ? @"mintempC" : @"mintempF";
                    
                    weatherData.todayTemp = [NSString stringWithFormat:@"%@º/%@º", [todayCondition objectForKey:minTempKey], [todayCondition objectForKey:maxTempKey]];
                    
                    // 화씨/섭씨 모든 온도를 저장해버리자. 옵션에 따라 골라서 보여주는 것이다.
                    weatherData.todayTemp_c = [NSString stringWithFormat:@"%@º/%@º", [todayCondition objectForKey:@"mintempC"], [todayCondition objectForKey:@"maxtempC"]];
                    weatherData.todayTemp_f = [NSString stringWithFormat:@"%@º/%@º", [todayCondition objectForKey:@"mintempF"], [todayCondition objectForKey:@"maxtempF"]];
                }
            }
        }
        
        // 다른 블록 작업을 기다리기
        wwoWeatherBlockFinished = YES;
        while ((googleCityNameBlockFinished && googleCurrentCityNameBlockFinished) == NO) {
            [NSThread sleepForTimeInterval:0.2];
        }
    });

    // 2번 블락: 구글에서 도시 이름 가져오기
    dispatch_async(global_queue, ^{
        // 현재 위치 얻는 로직을 변경 - 구글에서 얻을 수 있다면 그것을 사용하는 것이 이상적.
        googleReverseGeocodeCityName = [MNReverseGeocodeParser getCityNameFromLatitude:locationInfo.latitude withLongitude:locationInfo.longitude];
        
        // 다른 블록 작업을 기다리기
        googleCityNameBlockFinished = YES;
        while ((wwoWeatherBlockFinished && googleCurrentCityNameBlockFinished) == NO) {
            [NSThread sleepForTimeInterval:0.1];
        }
    });
    
    // 3번 블락: 구글에서 현재 언어 도시 이름 가져오기
    dispatch_async(global_queue, ^{
        googleReverseGeocodeCityName_CurrentLanguage = [MNReverseGeocodeParser getCityNameFromLatitude:locationInfo.latitude withLongitude:locationInfo.longitude withLanguage:[MNLanguage getCurrentLanguage]];
        
//        NSLog(@"%@", googleReverseGeocodeCityName_CurrentLanguage);
        
        // 다른 블록 작업을 기다리기
        googleCurrentCityNameBlockFinished = YES;
        while ((wwoWeatherBlockFinished && googleCityNameBlockFinished) == NO) {
            [NSThread sleepForTimeInterval:0.1];
        }
    });
    
    // 4번 블락: 세 블락 작업이 끝나고 리턴하기 위해 sync를 사용
    dispatch_sync(global_queue, ^{
        // 두 블록 작업이 끝나기를 기다리기
        while ((wwoWeatherBlockFinished && googleCityNameBlockFinished && googleCurrentCityNameBlockFinished) == NO) {
            [NSThread sleepForTimeInterval:0.1];
        }
        
        // 두 블록이 끝나면 weather data 조립하기
        if (googleReverseGeocodeCityName) {
            weatherData.locationInfo.englishName = googleReverseGeocodeCityName;
            
            // 추가: 나중에는 일본의 경우 도시/현으로 표기를 하고, 일본일 경우는 로컬 DB의 도시와 이 두 요소를 둘다 비교해야함.
            // 영어 이름을 얻어왔다면, 영어 이름과 Local DB의 이름을 비교하는 과정이 필요함. 비교해서 일치하면 woeid 를 뽑아냄
            // MNCityInfoQuery 싱글톤으로 만들 필요도 있음
            MNCityInfoQuery *cityInfoQurey = [[MNCityInfoQuery alloc] initWithNonEtc];
            //            MNCityInfoQuery *cityInfoQurey = [[MNCityInfoQuery alloc] init];
            
            MNLocationInfo *foundCityInDB = [cityInfoQurey findSameCityLocationInfoWithCityName:googleReverseGeocodeCityName];
            
            //            NSLog(@"found location Info: %@, %d", foundCityInDB.englishName, foundCityInDB.woeid);
            weatherData.locationInfo.woeid = foundCityInDB.woeid;
            
            
            // 현재 앱 언어로 설정된 국가의 표기도 얻어 오자.
            //            NSLog(@"%@", [MNLanguage getCurrentLanguage]);
            if (googleReverseGeocodeCityName_CurrentLanguage) {
                weatherData.locationInfo.name = googleReverseGeocodeCityName_CurrentLanguage;
            }else{
                weatherData.locationInfo.name = googleReverseGeocodeCityName;
            }

            //            NSLog(@"%@", weatherData.locationInfo.name);
        }else{
            // 기존 현재 위치 코드 - 만약 제대로 된 값이 나오지 않는다면 기존의 것을 쓰기
            NSDictionary *nearestArea = [[allWeatherData objectForKey:@"nearest_area"] objectAtIndex:0];
            if ([nearestArea isKindOfClass:[NSNull class]] == NO) {
                NSDictionary *areaName = [[nearestArea objectForKey:@"areaName"] objectAtIndex:0];
                //            NSDictionary *region = [[nearestArea objectForKey:@"region"] objectAtIndex:0];
                
                weatherData.locationInfo.name = [areaName objectForKey:@"value"];
                /*
                 if (region) {
                 weatherData.locationInfo.name = [NSString stringWithFormat:@"%@, %@", [areaName objectForKey:@"value"], [region objectForKey:@"value"]];
                 }else{
                 weatherData.locationInfo.name = [areaName objectForKey:@"value"];
                 }
                 */
            }
        }
    });
//        NSLog(@"%@", todayCondition);
    
    // 최종 값을 넘겨주기 전에 예외처리를 하기 - 오늘날씨나 현재날씨에 null이 있으면 날씨 정보를 못 받은 것.
//    if ([weatherData.todayTemp_c rangeOfString:@"(null)"].location != NSNotFound ||
//        [weatherData.currentTemp_c rangeOfString:@"(null)"].location != NSNotFound) {
//        return nil;
//    }
//    
//    return nil;
    
//    weatherData.currentTemp_f = @"null";
    return weatherData;
}


+ (MNWeatherData *)getOnlyWeatherDataFromWorldWeatherOnlineWithLocation:(MNLocationInfo *)locationInfo withTemperatureUnit:(enum MNWeatherTemperatureUnit)tempUnit {
    
    // 바꾸고 싶은 로직. dispatch queue를 쓰되, 날씨를 먼저 가져오게 하는 파서와 구글에서 이름을 가져오는 파서를 같이 돌려서 순차적 큐에 집어넣는다. 이 큐에서 두 작업을 동시에 진행해서, 결과값을 가지고 동시에 두 일을 처리하고 싶다.
    
    // 결과값 반환할 날씨 데이터
    __block MNWeatherData *weatherData = [[MNWeatherData alloc] init];
    
    // 날씨를 읽을 당시의 시간을 저장
    weatherData.locationInfo.timestamp = [NSDate date];
    
    // 블락 처리를 위해 바깥으로 변수를 뺌
    __block BOOL wwoWeatherBlockFinished = NO;
    __block NSDictionary *allWeatherData;
    
    // 돌릴 큐
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 1번 블락: 날씨 가져오기
    dispatch_async(global_queue, ^{
        // 위도, 경도값을 가지고 json 으로 파싱해서 결과값을 보여준다.
        //    NSLog(@"%f %f", locationInfo.latitude, locationInfo.longitude);
        
        NSString *queryURLString = [NSString stringWithFormat:@"http://api.worldweatheronline.com/premium/v1/weather.ashx?q=+%f%%2C%f&format=json&extra=localObsTime&num_of_days=1&date=today&includelocation=yes&show_comments=no&key=%@", locationInfo.latitude, locationInfo.longitude, WWO_KEY];
        
//        NSLog(@"%@", queryURLString);
        
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:queryURLString]];
        //    NSLog(@"%@", jsonData);
        JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
        if (jsonData) {
            weatherData.locationInfo.latitude = locationInfo.latitude;
            weatherData.locationInfo.longitude = locationInfo.longitude;
            
            // The string argument is NULL
            // 잘못된 값이 들어온다면 다음 값이 NULL이다
            if ([jsonData bytes] != NULL) {
                allWeatherData = [[jsonKitDecoder objectWithData:jsonData] objectForKey:@"data"]; // JSONKit
                
                //        NSLog(@"%@", allWeatherData);
                
                NSDictionary *current_condition = [[allWeatherData objectForKey:@"current_condition"] objectAtIndex:0];
                if ([current_condition isKindOfClass:[NSNull class]] == NO) {
                    NSString *current_tempKey = (tempUnit==eWTU_Celcius) ? @"temp_C" : @"temp_F";
                    weatherData.currentTemp = [NSString stringWithFormat:@"%@º", [current_condition objectForKey:current_tempKey]];
                    weatherData.wwoWeatherCondition = [[current_condition objectForKey:@"weatherCode"] integerValue];
                    weatherData.weatherCondition = eWC_noData;
                    //        NSLog(@"%@", current_condition);
                    
                    // 섭/화씨 둘다 얻기
                    weatherData.currentTemp_c = [NSString stringWithFormat:@"%@º", [current_condition objectForKey:@"temp_C"]];
                    weatherData.currentTemp_f = [NSString stringWithFormat:@"%@º", [current_condition objectForKey:@"temp_F"]];
                    
                    // 추가: GMT 와 timeOffset 계산
                    NSString *dateString = [current_condition objectForKey:@"localObsDateTime"];
                    //            NSLog(@"localObsDateTime: %@", [current_condition objectForKey:@"localObsDateTime"]);
                    
                    if (dateString) {
                        // 2013-06-29 03:20 PM 의 형식을 DateFormatter로 미리 만들어줘서 NSDate로 변환한다.
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
                        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
                        
                        // 둘다 UTC 기준이라고 가정하고 offset만을 구함
                        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                        //                NSLog(@"UTC:    %@", [dateFormatter stringFromDate:[NSDate date]]);
                        NSDate *UTCDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
                        
                        NSDate *targetDate = [dateFormatter dateFromString:dateString];
                        //                NSLog(@"Target: %@", [dateFormatter stringFromDate:targetDate]);
                        
                        //                NSLog(@"UTCDate: %@", UTCDate);
                        //                NSLog(@"targetDate: %@", targetDate);
                        
                        // yyyy-mm-dd HH:mm
                        weatherData.locationInfo.timeOffset = [targetDate timeIntervalSinceDate:UTCDate];
                        //                NSLog(@"timeOffset: %d", weatherData.locationInfo.timeOffset);
                    }
                }
                
                NSDictionary *todayCondition = [[allWeatherData objectForKey:@"weather"] objectAtIndex:0];
                if ([todayCondition isKindOfClass:[NSNull class]] == NO) {
                    NSString *maxTempKey = (tempUnit==eWTU_Celcius) ? @"maxtempC" : @"maxtempF";
                    NSString *minTempKey = (tempUnit==eWTU_Celcius) ? @"mintempC" : @"mintempF";
                    weatherData.todayTemp = [NSString stringWithFormat:@"%@º/%@º", [todayCondition objectForKey:minTempKey], [todayCondition objectForKey:maxTempKey]];
                    
                    // 화씨/섭씨 모든 온도를 저장해버리자. 옵션에 따라 골라서 보여주는 것이다.
                    weatherData.todayTemp_c = [NSString stringWithFormat:@"%@º/%@º", [todayCondition objectForKey:@"mintempC"], [todayCondition objectForKey:@"maxtempC"]];
                    weatherData.todayTemp_f = [NSString stringWithFormat:@"%@º/%@º", [todayCondition objectForKey:@"mintempF"], [todayCondition objectForKey:@"maxtempF"]];
                }
            }
        }
        
        // 다른 블록 작업을 기다리기
        wwoWeatherBlockFinished = YES;
    });
    
    // 4번 블락: 세 블락 작업이 끝나고 리턴하기 위해 sync를 사용
    dispatch_sync(global_queue, ^{
        // 두 블록 작업이 끝나기를 기다리기
        while (wwoWeatherBlockFinished == NO) {
            [NSThread sleepForTimeInterval:0.1];
        }
        
        // 이사님 수정 요청: 모달에서 검색된 글자를 그래도 보여주자
        weatherData.locationInfo.name = locationInfo.name;
        weatherData.locationInfo.englishName = locationInfo.englishName;
        
        // 추가: 나중에는 일본의 경우 도시/현으로 표기를 하고, 일본일 경우는 로컬 DB의 도시와 이 두 요소를 둘다 비교해야함.
        // 영어 이름을 얻어왔다면, 영어 이름과 Local DB의 이름을 비교하는 과정이 필요함. 비교해서 일치하면 woeid 를 뽑아냄
        // MNCityInfoQuery 싱글톤으로 만들 필요도 있음
        MNCityInfoQuery *cityInfoQurey = [[MNCityInfoQuery alloc] initWithNonEtc];
        //            MNCityInfoQuery *cityInfoQurey = [[MNCityInfoQuery alloc] init];
        
//        NSLog(@"%@", locationInfo.englishName);
//        NSLog(@"%@", locationInfo.name);
        MNLocationInfo *foundCityInDB = [cityInfoQurey findSameCityLocationInfoWithCityName:locationInfo.englishName];
        
        //            NSLog(@"found location Info: %@, %d", foundCityInDB.englishName, foundCityInDB.woeid);
        weatherData.locationInfo.woeid = foundCityInDB.woeid;
    });
    
    // 최종 값을 넘겨주기 전에 예외처리를 하기 - 오늘날씨나 현재날씨에 null이 있으면 날씨 정보를 못 받은 것.
//    if ([weatherData.todayTemp_c rangeOfString:@"(null)"].location != NSNotFound ||
//        [weatherData.currentTemp_c rangeOfString:@"(null)"].location != NSNotFound) {
//        return nil;
//    }
//    
//    return nil;
    
//    weatherData.currentTemp_f = @"(null)º";
    return weatherData;
}

@end
