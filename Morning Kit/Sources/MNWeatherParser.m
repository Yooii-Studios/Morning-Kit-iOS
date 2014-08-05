//
//  MNWeatherParser.m
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 5. 4..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWeatherParser.h"
#import "MNWoeidParser.h"
#import "MNWeatherData.h"
#import "MNWeatherCityParser.h"
//#import "AFXMLRequestOperation.h"
//#import "MNWidgetWeatherView.h"

// private class for MNWoeidParser
@interface MNWeatherParseDelegate : NSObject <NSXMLParserDelegate>
@property (nonatomic) MNWeatherData* weatherData;
@property BOOL isForecastDone;
@property BOOL isPubDate;
@property BOOL isLatitude;
@property BOOL isLongitude;
//@property BOOL isGuid;
@end

// MNWeatherParser
@implementation MNWeatherParser

+ (MNWeatherData*) parseWithLocation : (MNLocationInfo*) _location OfTemperatureUnit : (enum MNWeatherTemperatureUnit) _tempUnit;
{
    //if( _location == Nil )
    //    return Nil;
    
    // 기능 수정: woeid는 미리 얻어져 있다.
//    NSInteger woeid = _location.woeid;
    NSInteger woeid = [MNWoeidParser parseWithLocation:_location];
    
    
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"MNWeatherParser"
                                    message:[NSString stringWithFormat:@"parseLocation: %f/%f\nwoeid: %d", _location.latitude, _location.longitude, woeid]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    });
     */
    
    if( woeid == 0 )
        return [[MNWeatherData alloc] init];
    
    NSString*  weatherParsingUrlString = [NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=%c", [NSString stringWithFormat:@"%d", woeid ], (_tempUnit==eWTU_Celcius)?('c'):('f')];
    weatherParsingUrlString = [weatherParsingUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    NSLog(@"WeatherParsingURL : %@", weatherParsingUrlString);
    
    NSURL *weatherParsingUrl = [NSURL URLWithString:weatherParsingUrlString];
    
    MNWeatherParseDelegate* parseDelegate = [[MNWeatherParseDelegate alloc] init];
    
    // 기존 파싱 로직
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:weatherParsingUrl];
    [xmlParser setDelegate:parseDelegate];
    [xmlParser parse];
    
    // 파싱하는 로직 새로 짬. AFNetworking 을 이용 - 하지만 느린 네트워크 개선에 도움이 안되서 다시 롤백함.
    /*
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:weatherParsingUrl];
        // 야후 날씨의 헤더값 다로 추가
        [AFXMLRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"application/rss+xml"]];
        AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            XMLParser.delegate = parseDelegate;
            [XMLParser parse];
            widgetWeatherView.weatherData = parseDelegate.weatherData;
            [widgetWeatherView updateUI];
//            [widgetWeatherView refreshWidgetView];
//            NSLog(@"parse end");
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"MNWeatherParser Error"
                                            message:[NSString stringWithFormat:@"%@", error.description]
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            });
        }];
        [operation start];
    });
     */
    
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"MNWeatherParser"
                                    message:[NSString stringWithFormat:@"latitude: %f\nlongitude: %f\ntodayTemp: %@\ncurrentTemp:%@\nweatherCondition: %d", parseDelegate.weatherData.locationInfo.latitude, parseDelegate.weatherData.locationInfo.longitude, parseDelegate.weatherData.todayTemp, parseDelegate.weatherData.currentTemp, parseDelegate.weatherData.wetherCondition]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    });
     */
    
    return parseDelegate.weatherData;
}

@end

#pragma mark - MNWeatherParseDelegate

@implementation MNWeatherParseDelegate
-(id)init
{
    self = [super init];
    if( self )
    {
        _weatherData = [[MNWeatherData alloc] init];
        
        self.isForecastDone = NO;
        self.isPubDate = NO;
        self.isLatitude = NO;
        self.isLongitude = NO;
//        self.isGuid = NO;
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if( [elementName caseInsensitiveCompare:@"pubDate"] == NSOrderedSame )
    {
        self.isPubDate = YES;
    }
    else if( [elementName caseInsensitiveCompare:@"yweather:location"] == NSOrderedSame )
    {
        //for(int i=0; i<attributeDict.count; ++i)
        //    NSLog(@"WeatherParse Location Attributes : [%@] %@", [attributeDict.allKeys objectAtIndex:i], [attributeDict.allValues objectAtIndex:i]);
        
        self.weatherData.locationInfo.name = [attributeDict valueForKey:@"city"];
        self.weatherData.locationInfo.regionCode = [attributeDict valueForKey:@"region"];
//        NSLog(@"%@", self.weatherData.locationInfo.name);
    }
    else if( [elementName caseInsensitiveCompare:@"geo:lat"] == NSOrderedSame)
    {
        self.isLatitude = YES;
    }
    else if( [elementName caseInsensitiveCompare:@"geo:long"] == NSOrderedSame)
    {
        self.isLongitude = YES;
    }
    else if( [elementName caseInsensitiveCompare:@"yweather:condition"] == NSOrderedSame)
    {
        //for(int i=0; i<attributeDict.count; ++i)
        //   NSLog(@"WeatherParse Condition Attributes : [%@] %@", [attributeDict.allKeys objectAtIndex:i], [attributeDict.allValues objectAtIndex:i]);
        
        self.weatherData.weatherCondition = [[attributeDict valueForKey:@"code"] intValue];
        self.weatherData.wwoWeatherCondition = e_WWO_WC_noData;
        self.weatherData.currentTemp = [NSString stringWithFormat:@"%@º",[attributeDict valueForKey:@"temp"]];
        
        //NSLog(@"condition = %d", self.weatherData.wetherCondition );
        
        
    }
    else if( [elementName caseInsensitiveCompare:@"yweather:forecast"] == NSOrderedSame)
    {
        if( self.isForecastDone == NO )
        {
            //for(int i=0; i<attributeDict.count; ++i)
            //NSLog(@"WeatherParse Condition Attributes : [%@] %@", [attributeDict.allKeys objectAtIndex:i], [attributeDict.allValues objectAtIndex:i]);
            
            self.weatherData.todayTemp = [NSString stringWithFormat:@"%@º/%@º", [attributeDict valueForKey:@"low"], [attributeDict valueForKey:@"high"]];
            
            self.isForecastDone = YES;
        }
    }
    
    // 추가: 도시 이름을 얻기 위해 파싱을 한 번 더 함 - 현재 위치 사용을 할 경우에 해당됨.
//    else if([elementName caseInsensitiveCompare:@"guid"] == NSOrderedSame) {
//        self.isGuid = YES;
//    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if( self.isPubDate )
    {
       // NSLog(@"WeatherParse PubDate : %@", string);
        NSArray* seperates = [string componentsSeparatedByString:@" "];
        
        self.weatherData.locationInfo.timezoneCode = seperates[ seperates.count-1 ];
        self.isPubDate = NO;
    }
    else if( self.isLatitude )
    {
        self.weatherData.locationInfo.latitude = [string floatValue];
//        NSLog(@"%f", self.weatherData.locationInfo.latitude);
    }
    else if( self.isLongitude )
    {
        self.weatherData.locationInfo.longitude = [string floatValue];
//        NSLog(@"%f", self.weatherData.locationInfo.longitude);
    }
    /*
    else if( self.isGuid) {
        NSArray *cityCodeStrings = [string componentsSeparatedByString:@"_"];
        NSString *cityCodeString = [cityCodeStrings objectAtIndex:0];
//        NSLog(@"%@", cityCodeString);
        self.isGuid = NO;
        
        // 이 것을 가지고 다시 파싱해야 한다. p 자리에 코드가 들어 간다.
        // http://weather.yahooapis.com/forecastrss?p=KSXX0026&u=c
//        NSLog(@"%@", [MNWeatherCityParser getCityFromCityCode:cityCodeString]);
        self.weatherData.locationInfo.name = [MNWeatherCityParser getCityFromCityCode:cityCodeString];
//        NSLog(@"%@", self.weatherData.locationInfo.name);
    }
     */
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if( [elementName caseInsensitiveCompare:@"pubDate"] == NSOrderedSame )
    {
        self.isPubDate = NO;
    }
    else if( [elementName caseInsensitiveCompare:@"geo:lat"] == NSOrderedSame)
    {
        self.isLatitude = NO;
    }
    else if( [elementName caseInsensitiveCompare:@"geo:long"] == NSOrderedSame)
    {
        self.isLongitude = NO;
    }
    /*
    else if( [elementName caseInsensitiveCompare:@"guid"] == NSOrderedSame)
    {
        self.isLongitude = NO;
    }
     */
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    dispatch_async(dispatch_get_main_queue(), ^{
        /*
        [[[UIAlertView alloc] initWithTitle:@"MNWeatherParser Error"
                                    message:[NSString stringWithFormat:@"parseErrorOccurred: %@", parseError.description]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
         */
        NSLog(@"MNWeatherParser Error: %@", parseError.description);
    });
}

/*
- (void) parserDidEndDocument:(NSXMLParser *)parser {
//    NSLog(@"parserDidEndDocument");
}
 */



@end

