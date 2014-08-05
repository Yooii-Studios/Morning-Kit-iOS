//
//  MNCityInfo.h
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 4. 25..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNLocationInfo : NSObject <NSCoding>

@property (nonatomic) NSString *name;
@property (nonatomic) NSMutableArray *alternativeNames;
@property (nonatomic) NSString *regionCode;
@property (nonatomic) NSString *countryCode;
@property (nonatomic) NSString *timezoneCode;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;

// 추가: woeid
// originalName, otherNames추가: originalName이 검색되면 이것을 보여 주고, otherNames가 검색되면 englishName(name)을 보여 줌.

@property (nonatomic) NSInteger woeid;
@property (nonatomic, strong) NSString *englishName;
@property (nonatomic, strong) NSString *originalName;
@property (nonatomic) NSArray *otherNames;

// 추가: time stamp - 날씨 정보(위도,경도)가 기록된 시간.
@property (nonatomic, strong) NSDate *timestamp;

// 추가: 현지 시간을 위한 time offset (초)
@property (nonatomic) NSInteger timeOffset;

- (id) initByLanguageCode : (NSString*) _languageCode;

@end



