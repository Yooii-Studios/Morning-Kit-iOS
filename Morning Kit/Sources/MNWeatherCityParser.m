//
//  MNWeatherCityParser.m
//  Morning Kit
//
//  Created by 김우성 on 13. 6. 11..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWeatherCityParser.h"

@interface MNWeatherCityParserDelegate : NSObject <NSXMLParserDelegate>
@property (nonatomic, strong) NSString *cityNameString;
@end


#pragma mark - MNWeatherCityParser

@implementation MNWeatherCityParser

+ (NSString *)getCityFromCityCode:(NSString *)cityCodeStrings {
    NSURL *weatherURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?p=%@&u=c", cityCodeStrings]];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:weatherURL];
    MNWeatherCityParserDelegate *parserDelegate = [[MNWeatherCityParserDelegate alloc] init];
    parser.delegate = parserDelegate;
    [parser parse];
    
    return parserDelegate.cityNameString;
}

@end


#pragma mark - MNWeatherCityParserDelegate

@implementation MNWeatherCityParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if( [elementName caseInsensitiveCompare:@"yweather:location"] == NSOrderedSame )
    {
//        NSLog(@"%@", [attributeDict valueForKey:@"city"]);
        self.cityNameString = [attributeDict valueForKey:@"city"];
    }
}

@end
