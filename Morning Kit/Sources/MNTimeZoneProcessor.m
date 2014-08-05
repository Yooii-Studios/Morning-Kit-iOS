//
//  MNTimeZoneProcessor.m
//  SearchDisplayTestProject
//
//  Created by 김우성 on 13. 5. 18..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import "MNTimeZoneProcessor.h"
#import "MNTimeZone.h"
#import "MNLanguage.h"

@implementation MNTimeZoneProcessor

+ (NSArray *)loadTimeZonesFromRawFile:(NSString *)rawFileName {
    NSMutableArray *MNTimeZones = [NSMutableArray array];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:rawFileName ofType:@"txt"];
    NSError *error = nil;
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    NSArray *allLinedStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
//    NSLog(@"allLinedStrings count: %d", allLinedStrings.count);
    for (NSString *timeZoneItemString in allLinedStrings) {
//        NSLog(@"%@", timeZoneItemString);
        // 탭으로 나누기
        NSArray *timeZoneRawItems = [timeZoneItemString componentsSeparatedByString:@"\t"];
        
        // 방어 코드
        if (timeZoneRawItems.count == 4) {
            MNTimeZone *timeZone = [[MNTimeZone alloc] init];
            // cityName, offset 파싱
            timeZone.cityName = [timeZoneRawItems objectAtIndex:0];
            timeZone.hourOffset = ((NSString *)[timeZoneRawItems objectAtIndex:1]).integerValue;
            timeZone.minuteOffset = ((NSString *)[timeZoneRawItems objectAtIndex:2]).integerValue;
            
            NSArray *timeZoneNameArray = [[timeZoneRawItems objectAtIndex:3] componentsSeparatedByString:@";"];
            // '/'로 파싱 - timeZone 이름, priority 파싱
            NSArray *parsedTimeZoneNameArray = [[timeZoneNameArray objectAtIndex:0] componentsSeparatedByString:@"/"];
            if (parsedTimeZoneNameArray.count == 2) {
                timeZone.timeZoneName = [parsedTimeZoneNameArray objectAtIndex:0];
                timeZone.searchPriority = ((NSString *)[parsedTimeZoneNameArray objectAtIndex:1]).integerValue;
            }

            if (timeZoneNameArray.count != 1) {
                // 다국어가 있으므로, 뒤쪽 처리 필요
                timeZone.localizedCityNames = [[timeZoneNameArray objectAtIndex:1] componentsSeparatedByString:@"/"];
            }
            [MNTimeZones addObject:timeZone];
//            NSLog(@"%@", timeZone.cityName);
        }
    }
    return [NSArray arrayWithArray:MNTimeZones]; // NSArray로 반환
}

+ (NSArray *)getFilteredArrayWithSearchString:(NSString *)searchString fromTimeZoneArray:(NSArray *)allTimeZones {
    
    searchString = [[[searchString lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\'" withString:@""];
    
    // 타임 존이 로딩이 다 되었을 경우에만 검색을 진행
    if (allTimeZones) {
        // 전체 타임존을 구함
        //        NSArray *timeZones = [NSTimeZone knownTimeZoneNames];
        
        // 1. 시작하는 TimeZone - [c] = case insensitive, [d] 는 영어권에서 영어와 비슷한 알파벳을 영어로 변환해주는 것
//        NSPredicate *startPredicate = [NSPredicate predicateWithFormat:@"cityName beginsWith[cd] %@", searchString];
        //        NSPredicate *beginsWithPredicate = [NSPredicate predicateWithBlock:^BOOL(MNTimeZone *timeZone, NSDictionary *bindings) {
        //            if (timeZone.localizedCityNames) {
        //                // 기존 검색
        //            }else{
        //            }
        //            return YES;
        //        }];
        
        NSPredicate *startPredicate_complicated = [NSPredicate predicateWithBlock:^BOOL(MNTimeZone *timeZone, NSDictionary *bindings) {
            NSString *englishCityName = [[[timeZone.cityName lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\'" withString:@""];
            
            if ([englishCityName hasPrefix:searchString]) {
                return YES;
            }
            return NO;
        }];
        
        // 2. 시작하지 않으면서 포함하는 TimeZone
//        NSPredicate *containPredicate = [NSPredicate predicateWithFormat:@"cityName contains[cd] %@", searchString]; //, searchString];
        
        NSPredicate *containPredicate_complicated = [NSPredicate predicateWithBlock:^BOOL(MNTimeZone *timeZone, NSDictionary *bindings) {
            NSString *englishCityName = [[[timeZone.cityName lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\'" withString:@""];            
            if ([englishCityName hasPrefix:searchString] == NO && [englishCityName rangeOfString:searchString].location != NSNotFound) {
                return YES;
            }
            return NO;
        }];
        
        NSPredicate *notBeginsWithPredicate = [NSCompoundPredicate notPredicateWithSubpredicate:startPredicate_complicated];
        NSPredicate *compoundedContainPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[notBeginsWithPredicate, containPredicate_complicated]];
        
        NSArray *arrayBeginsWithSearchString = [allTimeZones filteredArrayUsingPredicate:startPredicate_complicated];
        NSArray *arrayContainsSearchString = [allTimeZones filteredArrayUsingPredicate:compoundedContainPredicate];
        
        return [arrayBeginsWithSearchString arrayByAddingObjectsFromArray:arrayContainsSearchString];
        //        NSLog(@"%@", self.timeZoneSearchResults);
    }else{
        return nil;
    }
}

+ (MNTimeZone *)getDefaultTimeZone {
    
    // 최근 앱에서 선택했던 도시를 기억
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *latestTimeZoneData = [userDefaults objectForKey:@"world_clock_latest_timezone"];
    if (latestTimeZoneData) {
        MNTimeZone *latestTimeZone = [NSKeyedUnarchiver unarchiveObjectWithData:latestTimeZoneData];
        if (latestTimeZone) {
            return latestTimeZone;
        }
    }

    // 언어를 체크해서 영어라면 Paris, 아니라면 London을 반환한다.
    MNTimeZone *defaultTimeZone = [[MNTimeZone alloc] init];
    
    NSArray *languageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageCodeString = [MNLanguage languageStringFromCodeString:[languageArray objectAtIndex:0]];
    
    if ([languageCodeString isEqualToString:@"en"]) {
        // Paris 생성
        defaultTimeZone.cityName = @"Paris";
        defaultTimeZone.timeZoneName = @"Romance Standard Time";
        defaultTimeZone.searchPriority = 100;
        defaultTimeZone.hourOffset = 1;
        defaultTimeZone.minuteOffset = 0;
        defaultTimeZone.localizedCityNames = nil;
    }else{
        // London 생성
        defaultTimeZone.cityName = @"London";
        defaultTimeZone.timeZoneName = @"GMT Standard Time";
        defaultTimeZone.searchPriority = 4;
        defaultTimeZone.hourOffset = 0;
        defaultTimeZone.minuteOffset = 0;
        defaultTimeZone.localizedCityNames = nil;
    }
    
    return defaultTimeZone;
}

@end
