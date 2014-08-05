//
//  MNExchangeRateParser.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 10..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//
#import "MNExchangeRateParser.h"
#import "MNExchangeRateXMLParser.h"

@implementation MNExchangeRateParser

+ (double)getExchangeRateWithBase:(NSString *)baseStr Target:(NSString *)targetStr
{
//    double exchangeRate = 1;
    
//    NSError* error;
    
    // 새로운 방식: 다섯 개의 동현이의 추천 서비스 중에서 제일 아래 것을 사용하기로 결정
    /*
     http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json
     
     http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml
     
     http://fx.keb.co.kr/FER1101C.web?schID=fex&mID=FER1101C
     
     http://www.ergosoft.com.ua/forex.js?n=Tue Nov 05 2013 14:11:26 GMT+0900 (KST)
     
     http://webservicex.net/currencyconvertor.asmx/ConversionRate?FromCurrency=%s&ToCurrency=%s
     */
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://webservicex.net/currencyconvertor.asmx/ConversionRate?FromCurrency=%@&ToCurrency=%@", baseStr, targetStr]];
    MNExchangeRateXMLParser *exchangeRateXmlParser = [[MNExchangeRateXMLParser alloc] init];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:exchangeRateXmlParser];
    [parser parse];
    
    // 만약 파싱이 제대로 안되었으면 에러 값을 리턴함
    return exchangeRateXmlParser.exchangeRate;
    
    /*
     기존의 방식: 2013년 11월 1일부로 구글 서비스는 폐쇠됨
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/ig/calculator?hl=en&q=1%@=?%@", baseStr, targetStr]];
    NSData *responseData = [NSData dataWithContentsOfURL:url];
    
    NSString *jsonStr = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSASCIIStringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"rhs" withString:@"\"rhs\""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"lhs" withString:@"\"lhs\""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"error" withString:@"\"error\""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"icc" withString:@"\"icc\""];
    responseData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* json =  [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    if (error)
    {
        NSLog(@"%@", [error localizedDescription]);
        exchangeRate = MNExchangeRateParseErr;
    }
    else
    {
        NSString *rhs = (NSString *)[json objectForKey:@"rhs"];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\.0123456789]" options:0 error:&error];
        rhs = [regex stringByReplacingMatchesInString:rhs options:0 range:NSMakeRange(0, [rhs length]) withTemplate:@""];
        exchangeRate = [rhs doubleValue];
     }
     return exchangeRate;
    */
}

@end
