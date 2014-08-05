//
//  MNTimeZone.h
//  SearchDisplayTestProject
//
//  Created by 김우성 on 13. 5. 18..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNTimeZone : NSObject <NSCoding>

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *timeZoneName;
@property (nonatomic) NSInteger searchPriority;
@property (nonatomic, strong) NSArray *localizedCityNames; // 해당 도시 이름이 다국어 처리가 된 경우가 있음
@property (nonatomic) NSInteger hourOffset;
@property (nonatomic) NSInteger minuteOffset; // 일반적으로는 0이지만 있는 경우도 있음.

@property (nonatomic) NSDate *worldClockDate; // 동적으로 구하는 Value

@end
