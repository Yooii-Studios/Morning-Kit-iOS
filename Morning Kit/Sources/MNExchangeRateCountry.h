//
//  MNExchangeRateCountry.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 11..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_TARGET_COUNTRY @"ExchangeRateTargetCountry"
#define KEY_BASE_COUNTRY @"ExchangeRateBaseCountry"
#define KEY_BASE_CURRENCY @"ExchangeRateBaseCurrency"

#define KEY_SHARED_BASE_COUNTRY @"ExchangeRateLatestBaseCountry"
#define KEY_SHARED_TARGET_COUNTRY @"ExchangeRateLatestTargetCountry"
#define KEY_SHARED_BASE_CURRENCY @"ExchangeRateLatestBaseCurrency"

@interface MNExchangeRateCountry : NSObject <NSCoding>

@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *currencyUnitName;
@property (strong, nonatomic) NSString *currencyUnitCode;
@property (strong, nonatomic) NSString *currencySymbol;

@property (strong, nonatomic) UIImage *flag;

@end