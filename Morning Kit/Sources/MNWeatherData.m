//
//  MNWeatherInfo.m
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 4. 25..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWeatherData.h"

@implementation MNWeatherData

//@synthesize currentTemperature;
//@synthesize todayTemperature;
//@synthesize condition;

@synthesize weatherCondition;
@synthesize currentTemp;
@synthesize todayTemp;

- (id)init
{
    self = [super init];
    if( self )
    {
        // initialize code
        _locationInfo = [[MNLocationInfo alloc] init];
        
        currentTemp = @"";
        todayTemp = @"";
        //currentTemperature = [[NSString alloc] init];
        //todayTemperature = [[NSString alloc]init];
        
        weatherCondition = eWC_not_available;
        self.wwoWeatherCondition = e_WWO_WC_not_available;
        //condition = eWC_tornado;
        
    }
    
    return self;
}

- (id)initWithLocation:(MNLocationInfo*)_location 
{
    self = [super init];
    if( self )
    {
        // initialize code
        if( _location )
            _locationInfo = _location;
        else
            _locationInfo = [[MNLocationInfo alloc]init];
        
    }
    return self;
}

- (void)setCurrentTemperature:(NSString *)currentTemperature
{
    
}

- (void)setTodayTemperature:(NSString *)todayTemperature
{
    
}

- (void)setCondition:(enum MNWeatherCondition)weatherCondition
{
    
}

- (NSString*)getLocationName
{
    return [_locationInfo name];
}

- (NSString*)getLocationCountryCode
{
    return [_locationInfo countryCode];
}

- (NSString*)getLocationTimezoneCode
{
    return [_locationInfo timezoneCode];
}
- (BOOL)isValid
{
    if( _locationInfo == nil ) {
        return NO;
    }
    
    if( _locationInfo != nil && _locationInfo.latitude == 0 && _locationInfo.longitude == 0 ) {
        return NO;
    }
    
    if( [currentTemp length] == 0 ) {
        return NO;
    }
        
    if( [todayTemp length] == 0 ) {
        return NO;
    }
    
    return YES;
}

#pragma mark - NSCoding Delegate Methods
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.locationInfo       = [aDecoder decodeObjectForKey:@"locationInfo"];
        self.currentTemp        = [aDecoder decodeObjectForKey:@"currentTemp"];
        self.todayTemp          = [aDecoder decodeObjectForKey:@"todayTemp"];
        self.weatherCondition    = [aDecoder decodeIntForKey:@"wetherCondition"];
        self.wwoWeatherCondition = [aDecoder decodeIntegerForKey:@"wwoWeatherCondition"];
        
        self.currentTemp_c       = [aDecoder decodeObjectForKey:@"currentTemp_c"];
        self.todayTemp_c         = [aDecoder decodeObjectForKey:@"todayTemp_c"];
        self.currentTemp_f       = [aDecoder decodeObjectForKey:@"currentTemp_f"];
        self.todayTemp_f         = [aDecoder decodeObjectForKey:@"todayTemp_f"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:       self.locationInfo           forKey:@"locationInfo"];
    [aCoder encodeObject:       self.currentTemp            forKey:@"currentTemp"];
    [aCoder encodeObject:       self.todayTemp              forKey:@"todayTemp"];
    [aCoder encodeInt:          self.weatherCondition        forKey:@"wetherCondition"];
    [aCoder encodeInteger:      self.wwoWeatherCondition     forKey:@"wwoWeatherCondition"];

    [aCoder encodeObject:       self.currentTemp_c          forKey:@"currentTemp_c"];
    [aCoder encodeObject:       self.todayTemp_c            forKey:@"todayTemp_c"];
    
    [aCoder encodeObject:       self.currentTemp_f          forKey:@"currentTemp_f"];
    [aCoder encodeObject:       self.todayTemp_f            forKey:@"todayTemp_f"];
}

@end



