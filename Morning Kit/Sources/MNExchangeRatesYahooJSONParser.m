//
//  MNExchangeRatesYahooJSONParser.m
//  Morning Kit
//
//  Created by Wooseong Kim on 2014. 1. 23..
//  Copyright (c) 2014년 Yooii Studios. All rights reserved.
//

#import "MNExchangeRatesYahooJSONParser.h"
#import "JSONKit.h"

#define MNExchangeRateParseErr -1

@implementation MNExchangeRatesYahooJSONParser

+ (double)getExchangeRateWithBase:(NSString *)baseStr Target:(NSString *)targetStr {
    // Yahoo에서 전부 받아 오려고 했으나 새 API를 찾음
//    NSString *queryURLString = @"http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=
    NSString *queryURLString = [NSString stringWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.xchange where pair in (\"%@%@\")&format=json&env=store://datatables.org/alltableswithkeys&callback=", baseStr, targetStr];
    queryURLString = [queryURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // JSON을 사용해 파싱
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:queryURLString]];
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    if (jsonKitDecoder && jsonData) {
        if ([jsonKitDecoder objectWithData:jsonData]) {
            NSDictionary *exchangeRateDictionary = [[jsonKitDecoder objectWithData:jsonData] objectForKey:@"query"]; // JSONKit
            
            if (![exchangeRateDictionary isKindOfClass:[NSNull class]]) {
                NSDictionary *resultsDictionary = [exchangeRateDictionary objectForKey:@"results"];
                
                if (![resultsDictionary isKindOfClass:[NSNull class]]) {
                    NSDictionary *rateDictionary = [resultsDictionary objectForKey:@"rate"];
                    
                    if (![rateDictionary isKindOfClass:[NSNull class]]) {
                        double rate = ((NSString *)[rateDictionary objectForKey:@"Rate"]).doubleValue;
                        
                        if (rate != 0.0f) {
                            return rate;
                        }
                    }
                }
            }
        }
    }
    // 제대로 파싱이 안되었다면 에러 메시지 보내기
    return MNExchangeRateParseErr;
}

@end
