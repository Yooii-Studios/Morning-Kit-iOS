//
//  MNWeatherLocationSpecificationMaker.h
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 5. 12..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNWeatherLocationSpecificationMaker : NSObject

+ (NSString*) getLocationSpecificationOfCountry : (NSString*) _countryCode OfRegion : (NSString*) _region;

@end
