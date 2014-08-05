//
//  MNWeatherCityParser.h
//  Morning Kit
//
//  Created by 김우성 on 13. 6. 11..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNWeatherCityParser : NSObject<NSXMLParserDelegate>

+ (NSString *)getCityFromCityCode:(NSString *)cityCodeStrings;

@end
