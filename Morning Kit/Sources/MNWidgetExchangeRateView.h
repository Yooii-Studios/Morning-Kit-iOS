//
//  MNWidgetExchangeRateView.h
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//
#pragma once

#import "MNWidgetView.h"
#import "MNExchangeRateCountryLoader.h"

@interface MNWidgetExchangeRateView : MNWidgetView

@property (strong, nonatomic) IBOutlet UIImageView *Image_Base;
@property (strong, nonatomic) IBOutlet UIImageView *Image_Target;
@property (strong, nonatomic) IBOutlet UILabel *Label_ExchangeRate;
@property (strong, nonatomic) IBOutlet UILabel *Label_ExchangeRate_Reverse;

@property (strong, nonatomic) MNExchangeRateCountry *targetCountry;
@property (strong, nonatomic) MNExchangeRateCountry *baseCountry;
@property (nonatomic) double exchangeRate;

@end
