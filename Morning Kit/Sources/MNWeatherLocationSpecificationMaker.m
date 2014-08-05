//
//  MNWeatherLocationSpecificationMaker.m
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 5. 12..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWeatherLocationSpecificationMaker.h"
#import "MNCountryNameFactory.h"
#import "MNUSStateNameFactory.h"

@implementation MNWeatherLocationSpecificationMaker

+ (NSString*) getLocationSpecificationOfCountry : (NSString*) _countryCode OfRegion : (NSString*) _region
{
    if( _countryCode == nil )
        return @"";
    if( _region == nil )
        return @"";
    
    if( [_countryCode caseInsensitiveCompare:@"us"] == NSOrderedSame )
        return [NSString stringWithFormat:@"%@ / %@", [MNUSStateNameFactory getStateName:_region], [MNCountryNameFactory getCountryName:_countryCode]];
    
    return [MNCountryNameFactory getCountryName:_countryCode];
}
@end










