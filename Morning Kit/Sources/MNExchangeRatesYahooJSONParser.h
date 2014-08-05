//
//  MNExchangeRatesYahooJSONParser.h
//  Morning Kit
//
//  Created by Wooseong Kim on 2014. 1. 23..
//  Copyright (c) 2014년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

// 제일 최근 (2014. 01. 23.)에 만든 야후 Finance에서 가져오는 파서
// 1시간 간격으로 캐싱을 하자(싱글톤)
@interface MNExchangeRatesYahooJSONParser : NSObject

@property (strong, nonatomic) NSMutableArray *latestExchangeRates; // 캐싱용

+ (double)getExchangeRateWithBase:(NSString *)baseStr Target:(NSString *)targetStr;

@end
