//
//  MNWeatherSetting.m
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 4. 25..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWeatherSetting.h"

@implementation MNWeatherSetting

-(id)init
{
    self = [super init];
    if( self )
    {
        // initialize code
        NSLocale *locale = [NSLocale currentLocale];
        NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
//        NSLog(@"countryCode:%@", countryCode);
  
        if ([countryCode isEqualToString:@"US"]) {
            _temperatureUnit = eWTU_Fahrenheit;
        }else{
            _temperatureUnit = eWTU_Celcius;
        }
        _useCurrentLocation = YES;
        _displayLocalTime = YES;
    }
    
    return self;
}

#pragma mark - NSCoding Delegate Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.temperatureUnit       = [aDecoder decodeIntegerForKey:@"temperatureUnit"];
        self.useCurrentLocation    = [aDecoder decodeBoolForKey:@"useCurrentLocation"];
        self.displayLocalTime      = [aDecoder decodeBoolForKey:@"displayLocalTime"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger: self.temperatureUnit        forKey:@"temperatureUnit"];
    [aCoder encodeBool:    self.useCurrentLocation     forKey:@"useCurrentLocation"];
    [aCoder encodeBool:    self.displayLocalTime       forKey:@"displayLocalTime"];
}


@end
