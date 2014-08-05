//
//  MNExchangeRateCountryLoader.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 12..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNExchangeRateCountry.h"

#define NUM_OF_COUNTRIES 46

@interface MNExchangeRateCountryLoader : NSObject

+ (MNExchangeRateCountryLoader *)sharedInstance;
+ (MNExchangeRateCountry *)countryWithCountryCode:(NSString *)code;
+ (NSMutableDictionary *)countriesDict;
+ (NSMutableArray *)countriesArr;
+ (NSMutableArray *)mainCountriesArr;
+ (NSArray *)getFilteredArrayWithSearchString:(NSString *)searchString fromTimeZoneArray:(NSArray *)allArray;

@end
