//
//  MNCityInfoQuery.m
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 5. 11..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNCityInfoQuery.h"

@interface MNCityLocationFiber : NSObject

- (id)initWithRawFile : (NSString*)_path;
- (id)initNotDispatchModeWithRawFile:(NSString *)_path;
- (NSMutableArray*)getCityLocations: (NSString*)_query inMethod : (enum SearchMethod) _method ;
- (NSArray *)findSameCityLocationInfoWithCityName:(NSString*)cityNameToFind;

@property (strong, nonatomic) NSMutableArray *cityLocations;
@property BOOL readComplete;

@end

@implementation MNCityInfoQuery

- (id) init
{
    self = [super init];
    
    if( self )
    {
        _fibers = [[NSMutableArray alloc] init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityInfo_currentlocation"]];
            
            /*
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_us_high_priority"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_us"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_au"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_jp"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_gb"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_cn"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_kr"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_ca"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_etc"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_etc_2"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_etc_3"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_etc_4"]];
             */
            
            // woeid DB로 변경
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_us_high_priority_woeid"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_us_woeid"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_au_woeid"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_jp_woeid"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_gb_woeid"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_cn_woeid"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_kr_woeid"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_ca_woeid"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_etc_woeid"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_etc_2_woeid"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_etc_3_woeid"]];
            [_fibers addObject: [[MNCityLocationFiber alloc] initWithRawFile:@"cityinfo_etc_4_woeid"]];
        });
    }
    return self;
}

- (id) initWithNonEtc {
    self = [super init];
    
    if( self )
    {
        _fibers = [[NSMutableArray alloc] init];
        
        // woeid DB로 변경
        [_fibers addObject: [[MNCityLocationFiber alloc] initNotDispatchModeWithRawFile:@"cityinfo_us_high_priority_woeid"]];
        [_fibers addObject: [[MNCityLocationFiber alloc] initNotDispatchModeWithRawFile:@"cityinfo_us_woeid"]];
        [_fibers addObject: [[MNCityLocationFiber alloc] initNotDispatchModeWithRawFile:@"cityinfo_au_woeid"]];
        [_fibers addObject: [[MNCityLocationFiber alloc] initNotDispatchModeWithRawFile:@"cityinfo_jp_woeid"]];
        [_fibers addObject: [[MNCityLocationFiber alloc] initNotDispatchModeWithRawFile:@"cityinfo_gb_woeid"]];
        [_fibers addObject: [[MNCityLocationFiber alloc] initNotDispatchModeWithRawFile:@"cityinfo_cn_woeid"]];
        [_fibers addObject: [[MNCityLocationFiber alloc] initNotDispatchModeWithRawFile:@"cityinfo_kr_woeid"]];
        [_fibers addObject: [[MNCityLocationFiber alloc] initNotDispatchModeWithRawFile:@"cityinfo_ca_woeid"]];
        [_fibers addObject: [[MNCityLocationFiber alloc] initNotDispatchModeWithRawFile:@"cityinfo_etc_woeid"]];
    }
    return self;
}

- (NSMutableArray*)getCityLocations: (NSString*)_query inMethod : (enum SearchMethod) _method
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    _query = [_query lowercaseString];
    // merge results of each fiber
    for(int i=0; i<_fibers.count; ++i)
    {
        [result addObjectsFromArray:[(MNCityLocationFiber*)_fibers[i] getCityLocations:_query inMethod:_method]];
    }
    
    return result;
}

- (MNLocationInfo *)findSameCityLocationInfoWithCityName:(NSString*)cityNameToFind {
    
    NSMutableArray* results = [[NSMutableArray alloc] init];
    
    for(int i=0; i<_fibers.count; ++i)
    {
//        NSLog(@"%d", ((MNCityLocationFiber*)_fibers[i]).cityLocations.count);
        [results addObjectsFromArray:[(MNCityLocationFiber*)_fibers[i] findSameCityLocationInfoWithCityName:cityNameToFind]];
    }
    
    if (results && results.count > 0) {
//        for (MNLocationInfo *locationInfo in results) {
//            NSLog(@"city Name: %@", locationInfo.englishName);
//        }
        // 검색 결과 중 제일 첫번째 것만 반환
        return [results objectAtIndex:0];
    }
    return nil;
}

@end

@implementation MNCityLocationFiber

- (id) initWithRawFile:(NSString *)_path
{
    self = [super init];
    if( self )
    {
        _cityLocations = [[NSMutableArray alloc] init];
        _readComplete = NO;
        
        if( _path == nil )
            _readComplete = YES;
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSStringEncoding encoding;
                NSString* content;
                NSString* path = [[NSBundle mainBundle] pathForResource:_path ofType:@"txt"];
                
                if(path)
                {
                    content = [NSString stringWithContentsOfFile:path  usedEncoding:&encoding  error:NULL];
                }
                // NSLog(@"path is %@",path);
                if (content)
                {
                    NSArray* seperates = [content componentsSeparatedByString:@"\n"];
                    
//                    NSLog(@"%d", seperates.count);
                    
                    for(int i=0; (i<seperates.count) && (i+4 < seperates.count); i+=5)
                    {
                        @try
                        {
                            MNLocationInfo* newCity = [[MNLocationInfo alloc] init];
                            
                            // name(s) : alternative names all together. Format : [name1]/[name2]/...
                            // latitude
                            // longitude
                            // country
                            // region
                            
                            /*
                            NSArray* alternativeNames = [seperates[i] componentsSeparatedByString:@"/"];
                            for (int a=0; a<alternativeNames.count; ++a)
                                [[newCity alternativeNames] addObject:alternativeNames[a]];
                            
                            [newCity setName:alternativeNames[0]];
                            [newCity setAlternativeNames:[[NSMutableArray alloc] initWithArray:alternativeNames]];
                            */
                            
                            // 이름 부분 변경
                            newCity.name = nil;
                            newCity.englishName = nil;
                            newCity.originalName = nil;
                            newCity.otherNames = nil;
                            newCity.woeid = 0;

                            NSArray *nameAndWoeidParts = [seperates[i] componentsSeparatedByString:@";"];
                            if (nameAndWoeidParts.count == 2) {
                                // name(english)/originalName/otherName1:otherName2:othername3
                                NSArray *names = [nameAndWoeidParts[0] componentsSeparatedByString:@"/"];
                            
                                if (names.count == 3) {
                                    // 본토 표기나 다른 검색어가 있는 경우
                                    newCity.name = names[0];
                                    newCity.englishName = newCity.name;
                                    
                                    if ([((NSString *)names[1]) isEqualToString:@""]) {
                                        newCity.originalName = nil;
                                    }else{
                                        newCity.originalName = names[1];
                                    }
                                    
                                    if ([((NSString *)names[2]) isEqualToString:@""]) {
                                        newCity.otherNames = nil;
                                    }else{
                                        newCity.otherNames = [names[2] componentsSeparatedByString:@":"];
                                    }
//                                    NSLog(@"%@/%@/%@", newCity.name, newCity.originalName, newCity.otherNames);
                                    
                                }else if(names.count == 1) {
                                    newCity.name = names[0];
                                    newCity.englishName = newCity.name;
                                }
//                                NSLog(@"%@", newCity.name);
                                newCity.woeid = ((NSString *)[nameAndWoeidParts objectAtIndex:1]).integerValue;
                            }
//                            NSLog(@"%@", newCity.name);
                            
                            newCity.alternativeNames = nil;
                            [newCity setLatitude:[seperates[i+1] floatValue]];
                            [newCity setLongitude:[seperates[i+2] floatValue]];
                            [newCity setCountryCode:seperates[i+3]];
                            [newCity setRegionCode:seperates[i+4]];
                            
                            [_cityLocations addObject:newCity];
                        }
                        @catch(NSException* e)
                        {
                            continue;
                        }

                        }
                }// end if
                _readComplete = YES;
                
            });
        }

    }
    return self;
}

- (id)initNotDispatchModeWithRawFile:(NSString *)_path {
    self = [super init];
    if( self )
    {
        _cityLocations = [[NSMutableArray alloc] init];
        _readComplete = NO;
        
        if( _path == nil )
            _readComplete = YES;
        else
        {
            NSStringEncoding encoding;
            NSString* content;
            NSString* path = [[NSBundle mainBundle] pathForResource:_path ofType:@"txt"];
            
            if(path)
            {
                content = [NSString stringWithContentsOfFile:path  usedEncoding:&encoding  error:NULL];
            }
            // NSLog(@"path is %@",path);
            if (content)
            {
                NSArray* seperates = [content componentsSeparatedByString:@"\n"];
                
//                NSLog(@"%d", seperates.count);
                
                for(int i=0; (i<seperates.count) && (i+4 < seperates.count); i+=5)
                {
                    @try
                    {
                        MNLocationInfo* newCity = [[MNLocationInfo alloc] init];
                        
                        // name(s) : alternative names all together. Format : [name1]/[name2]/...
                        // latitude
                        // longitude
                        // country
                        // region
                        
                        /*
                         NSArray* alternativeNames = [seperates[i] componentsSeparatedByString:@"/"];
                         for (int a=0; a<alternativeNames.count; ++a)
                         [[newCity alternativeNames] addObject:alternativeNames[a]];
                         
                         [newCity setName:alternativeNames[0]];
                         [newCity setAlternativeNames:[[NSMutableArray alloc] initWithArray:alternativeNames]];
                         */
                        
                        // 이름 부분 변경
                        newCity.name = nil;
                        newCity.englishName = nil;
                        newCity.originalName = nil;
                        newCity.otherNames = nil;
                        newCity.woeid = 0;
                        
                        NSArray *nameAndWoeidParts = [seperates[i] componentsSeparatedByString:@";"];
                        if (nameAndWoeidParts.count == 2) {
                            // name(english)/originalName/otherName1:otherName2:othername3
                            NSArray *names = [nameAndWoeidParts[0] componentsSeparatedByString:@"/"];
                            
                            if (names.count == 3) {
                                // 본토 표기나 다른 검색어가 있는 경우
                                newCity.name = names[0];
                                newCity.englishName = newCity.name;
                                
                                if ([((NSString *)names[1]) isEqualToString:@""]) {
                                    newCity.originalName = nil;
                                }else{
                                    newCity.originalName = names[1];
                                }
                                
                                if ([((NSString *)names[2]) isEqualToString:@""]) {
                                    newCity.otherNames = nil;
                                }else{
                                    newCity.otherNames = [names[2] componentsSeparatedByString:@":"];
                                }
                                //                                    NSLog(@"%@/%@/%@", newCity.name, newCity.originalName, newCity.otherNames);
                                
                            }else if(names.count == 1) {
                                newCity.name = names[0];
                                newCity.englishName = newCity.name;
                            }
                            //                                NSLog(@"%@", newCity.name);
                            newCity.woeid = ((NSString *)[nameAndWoeidParts objectAtIndex:1]).integerValue;
                        }
                        //                            NSLog(@"%@", newCity.name);
                        
                        newCity.alternativeNames = nil;
                        [newCity setLatitude:[seperates[i+1] floatValue]];
                        [newCity setLongitude:[seperates[i+2] floatValue]];
                        [newCity setCountryCode:seperates[i+3]];
                        [newCity setRegionCode:seperates[i+4]];
                        
                        [_cityLocations addObject:newCity];
                    }
                    @catch(NSException* e)
                    {
                        continue;
                    }
                    
                }
            }// end if
            _readComplete = YES;
        }
    }
    return self;
}


#pragma mark - get cities whose name contains or begins with search keyword

- (NSArray*)getCityLocations: (NSString*)_query inMethod : (enum SearchMethod) _method
{
    NSArray* result = [[NSMutableArray alloc] init];
    
    if( _query == nil )
        return [[NSMutableArray alloc]init];
    
    _query = [[[_query lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""]
              stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    // 이사님 추가사항: 어포스트로피도 삭제해주자. 
    _query = [_query stringByReplacingOccurrencesOfString:@"\'" withString:@""];
//    NSLog(@"%@", _query);
    
    /*
    for(int i=0;  !(_readComplete && i>=_cityLocations.count); )
    {
        if( i<_cityLocations.count )
        {
            NSString* alternativeName;
            
            // 모든 대체 언어에 대해 검사한다 - 기존 방식
            for(int a=0; a<[_cityLocations[i] alternativeNames].count; ++a)
            {
                alternativeName = [_cityLocations[i] alternativeNames][a];
                alternativeName = [alternativeName lowercaseString];
                
                if( _method == eSM_Prefix )
                {
                    // 키워드로 시작하는 도시라면
                    if( [alternativeName hasPrefix: _query] )
                    {
                        // 도시 이름에 검색된 대체 언어를 설정해줌
                        [_cityLocations[i] setName:[alternativeName capitalizedString]];
                        [result addObject:_cityLocations[i]];
                        break;
                    }
                }
                else if( _method == eSM_Contains_But_Not_Prefix )
                {
                    // 도시 이름으로 시작하지 않고 포함되는 언어라면
                    if( [alternativeName hasPrefix: _query] == NO &&
                       [alternativeName rangeOfString:_query].location != NSNotFound )
                    {
                        // 도시 이름에 검색된 대체 언어를 설정해줌
                        [_cityLocations[i] setName:[alternativeName capitalizedString]];
                        [result addObject:_cityLocations[i]];
                        break;
                    }
                }
//                if( [alternativeName hasPrefix: _query] )
//                {
//                    [_cityLocations[i] setName:[alternativeName capitalizedString]];
//                    [resultStartsWith addObject:_cityLocations[i]];
//                    break;
//                }
//                else if( [alternativeName rangeOfString:_query].location != NSNotFound )
//                {
//                    [_cityLocations[i] setName:[alternativeName capitalizedString]];
//                    [resultContains addObject:_cityLocations[i]];
//                    break;
//                }
            }
            ++i;
        }
    }
     */
    
    // 바꿔야 할 방식: 영어 표기 검사/본토 표기 검사/기타 표기 검사
    // 본토 표기가 가장 우선, 본토 표기 일치하면, 본토 표기로 도시 이름을 변경하고 바로 종료.
    // 본토 표기가 검색 안되고 영어 표기가 검사되면, 바로 종료,
    // 영어 표기, 본토 표기 둘다 검색 안되고 기타 표기가 검사되면 도시 이름 변경하지 않고 종료
    
    // 1. 키워드로 시작하는 도시들 - [c] = case insensitive, [d] 는 영어권에서 영어와 비슷한 알파벳을 영어로 변환해주는 것
//    NSPredicate *startPredicate = [NSPredicate predicateWithFormat:@"name beginsWith[cd] %@", _query];
    NSPredicate *startPredicate_complicated = [NSPredicate predicateWithBlock:^BOOL(MNLocationInfo *locationInfo, NSDictionary *bindings) {
        if (locationInfo.originalName) {
            NSString *originalName = [[locationInfo.originalName lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
            originalName = [originalName stringByReplacingOccurrencesOfString:@"\'" withString:@""];
            
            if ([originalName hasPrefix:_query]) {
                locationInfo.name = locationInfo.originalName;
                return YES;
            }
        }
        // 악센트 삭제하고 영어 알파벳으로 변환하기 - 속도 저하가 심함
//        NSString *convertedCityName = [[[locationInfo.englishName lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        NSString *convertedCityName = [[locationInfo.englishName lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
        convertedCityName = [convertedCityName stringByReplacingOccurrencesOfString:@"\'" withString:@""];

//        if ([convertedCityName hasPrefix:@"xi"]) {
//            NSLog(@"%@", convertedCityName);
//        }
        
        if ([convertedCityName hasPrefix:_query]) {
            
            locationInfo.name = locationInfo.englishName;
            return YES;
        }
        if (locationInfo.otherNames) {
            for (NSString *otherName in locationInfo.otherNames) {
                NSString *convertedOtherName = [[otherName lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
                convertedOtherName = [convertedOtherName stringByReplacingOccurrencesOfString:@"\'" withString:@""];
                if ([convertedOtherName hasPrefix:_query]) {
                    locationInfo.name = locationInfo.englishName;
                    return YES;
                }
            }
        }
        return NO;
    }];
    
    // 2. 키워드로 시작하지 않으면서 포함하는 도시들
    NSPredicate *notBeginsWithPredicate = [NSCompoundPredicate notPredicateWithSubpredicate:startPredicate_complicated];
//    NSPredicate *containPredicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", _query]; //, searchString];
    NSPredicate *containPredicate_complicated = [NSPredicate predicateWithBlock:^BOOL(MNLocationInfo *locationInfo, NSDictionary *bindings) {
        
        if (locationInfo.originalName) {
            NSString *originalName = [[locationInfo.originalName lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
            originalName = [originalName stringByReplacingOccurrencesOfString:@"\'" withString:@""];
            if ([originalName hasPrefix:_query] == NO &&
                [originalName rangeOfString:_query].location != NSNotFound) {
                locationInfo.name = locationInfo.originalName;
                return YES;
            }
        }
         
//        NSString *cityName = [[[locationInfo.englishName lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        NSString *cityName = [[locationInfo.englishName lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
        cityName = [cityName stringByReplacingOccurrencesOfString:@"\'" withString:@""];
        if ([cityName hasPrefix:_query] == NO &&
            [cityName rangeOfString:_query].location != NSNotFound) {
            locationInfo.name = locationInfo.englishName;
            return YES;
        }
        
        if (locationInfo.otherNames) {
            for (NSString *otherName in locationInfo.otherNames) {
                NSString *convertedOtherName = [[otherName lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
                convertedOtherName = [convertedOtherName stringByReplacingOccurrencesOfString:@"\'" withString:@""];
                if ([convertedOtherName hasPrefix:_query] == NO &&
                    [convertedOtherName rangeOfString:_query].location != NSNotFound) {
                    locationInfo.name = locationInfo.englishName;
                    return YES;
                }
            }
        }
         
        return NO;
    }];
    NSPredicate *compoundedContainPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[notBeginsWithPredicate, containPredicate_complicated]];
    
    if (_method == eSM_Prefix) {
        result = [_cityLocations filteredArrayUsingPredicate:startPredicate_complicated];
    }else if(_method == eSM_Contains_But_Not_Prefix){
        result = [_cityLocations filteredArrayUsingPredicate:compoundedContainPredicate];
    }
    
    return result;
}


#pragma mark - get cities whose name is same with a searching city

// 입력받은 도시 이름과 일치하는 이름을 가진 도시가 있는지 찾아내기
- (NSArray *)findSameCityLocationInfoWithCityName:(NSString*)cityNameToFind {
    if (cityNameToFind) {
        NSString *convertedCityName = [[[cityNameToFind lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        convertedCityName = [convertedCityName stringByReplacingOccurrencesOfString:@"\'" withString:@""];
        
        NSPredicate *samePredicate = [NSPredicate predicateWithBlock:^BOOL(MNLocationInfo *locationInfo, NSDictionary *bindings) {
            if (locationInfo.englishName) {
                NSString *englishName = [[locationInfo.englishName lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
                englishName = [englishName stringByReplacingOccurrencesOfString:@"\'" withString:@""];
                if ([englishName isEqualToString:convertedCityName]) {
//                    NSLog(@"locationInfo EnglishName: %@", locationInfo.englishName);
//                    NSLog(@"cityNameToFind: %@", cityNameToFind);
                    return YES;
                }
            }
            return NO;
        }];
        return [_cityLocations filteredArrayUsingPredicate:samePredicate];
    }
    return nil;
}

@end

