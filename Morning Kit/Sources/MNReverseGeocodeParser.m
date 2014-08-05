//
//  MNReverseGeocodeParser.m
//  Morning Kit
//
//  Created by 김우성 on 13. 6. 20..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNReverseGeocodeParser.h"
#import "JSONKit.h"
#import "MNLanguage.h"

@implementation MNReverseGeocodeParser

#pragma mark - private

+ (NSString *)getQueryFromLatitude:(CGFloat)latitude withLongitude:(CGFloat)longitude withLanguageCode:(NSString *)langugaeCode {
    return [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&language=%@", latitude, longitude, langugaeCode];
}

+ (NSString *)getCityNameFromQuery:(NSString *)queryURLString {
//    NSLog(@"%@", queryURLString);
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:queryURLString]];
    //    NSLog(@"%@", jsonData);
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    if (jsonData) {
        NSString *status = [[jsonKitDecoder objectWithData:jsonData] objectForKey:@"status"];
        //        NSLog(@"%@", status);
        if ([status isEqualToString:@"OK"]) {
            NSDictionary *locationData = [[[jsonKitDecoder objectWithData:jsonData] objectForKey:@"results"] objectAtIndex:0]; // JSONKit
            //        NSLog(@"%@", locationData);
            
            NSDictionary *address_components = [locationData objectForKey:@"address_components"];
            
            NSString *cityName = nil;
//            NSString *countryCode_short = nil;
            for (NSDictionary *address_component in address_components) {
                
                NSArray *types = [address_component objectForKey:@"types"];
                // 이 두 값이 있는 도시가 일반적으로 원하는 값이다.
                NSArray *wantedTypes = [NSArray arrayWithObjects:@"locality", @"political", nil];
//                NSArray *countryTypes = [NSArray arrayWithObjects:@"country", @"political", nil];
                if ([types isEqualToArray:wantedTypes]) {
                    cityName = [address_component objectForKey:@"long_name"];
                    //                    NSLog(@"%@", cityName);
                }
                
//                else if([types isEqualToArray:countryTypes]) {
//                    countryCode_short = [address_component objectForKey:@"short_name"];
//                    NSLog(@"%@", countryCode_short);
//                }
            }
            return cityName;
        }
    }
    return nil;
}

#pragma mark - public

+ (NSString *)getCityNameFromLatitude:(CGFloat)latitude withLongitude:(CGFloat)longitude {
    
    // 영어 쿼리를 날려서 영어로 된 정보를 받아 온다.
    // 끝에 language 매개 변수에 현재 언어 설정을 받아와서 작업할 수 있을 것 같다.
    // 영어로 받아 와서, 만약 현재 앱의 언어 설정과, 받을 나라의 이름이 같다면, 그 나라 언어로 표시해주기.
    NSString *queryURLString = [MNReverseGeocodeParser getQueryFromLatitude:latitude withLongitude:longitude withLanguageCode:@"en"];
//    NSLog(@"%@", queryURLString);
    
    return [MNReverseGeocodeParser getCityNameFromQuery:queryURLString];
}

+ (NSString *)getCityNameFromLatitude:(CGFloat)latitude withLongitude:(CGFloat)longitude withLanguage:(NSString *)languageCode {
    NSString *queryURLString = [MNReverseGeocodeParser getQueryFromLatitude:latitude withLongitude:longitude withLanguageCode:languageCode];
    //    NSLog(@"%@", queryURLString);
    
    return [MNReverseGeocodeParser getCityNameFromQuery:queryURLString];
}

@end
