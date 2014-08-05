//
//  MNExchangeRateCountry.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 11..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNExchangeRateCountry.h"

@implementation MNExchangeRateCountry

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.countryCode                        = [aDecoder decodeObjectForKey:@"countryCode"];
        self.currencySymbol                     = [aDecoder decodeObjectForKey:@"currencySymbol"];
        self.currencyUnitCode                   = [aDecoder decodeObjectForKey:@"currencyUnitCode"];
        self.currencyUnitName                   = [aDecoder decodeObjectForKey:@"currencyUnitName"];
        self.flag                               = [aDecoder decodeObjectForKey:@"flag"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:       self.countryCode            forKey:@"countryCode"];
    [aCoder encodeObject:       self.currencySymbol         forKey:@"currencySymbol"];
    [aCoder encodeObject:       self.currencyUnitCode       forKey:@"currencyUnitCode"];
    [aCoder encodeObject:       self.currencyUnitName       forKey:@"currencyUnitName"];
    [aCoder encodeObject:       self.flag                   forKey:@"flag"];
}

@end
