//
//  MNWidgetExchangeRateView.m
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNWidgetExchangeRateView.h"
#import "MNExchangeRateParser.h"
#import "MNTheme.h"
#import "MNLanguage.h"
#import "MNExchangeRatesYahooJSONParser.h"

#define OFFSET_IMAGE_HORIZON ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 25 : 11)
#define OFFSET_IMAGE_VERTICAL ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 112 : 42)
#define OFFSET_LABEL_CURRENCY ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 27 : 10)
#define OFFSET_LABEL_REVERSE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 73 : 29)

#define FONTSIZE_LABEL_CURRENCY 24
#define FONTSIZE_LABEL_REVERSE 20
#define FONTSIZE_LABEL_CURRENCY_LAND 36
#define FONTSIZE_LABEL_REVERSE_LAND 28

@implementation MNWidgetExchangeRateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWidgetView
{
    
}

- (void)doWidgetLoadingInBackground
{
    NSString *baseCountryCode = [self.widgetDictionary objectForKey:KEY_BASE_COUNTRY];
    NSString *targetCountryCode = [self.widgetDictionary objectForKey:KEY_TARGET_COUNTRY];
    
    if (baseCountryCode && targetCountryCode)
    {
        self.baseCountry = [MNExchangeRateCountryLoader countryWithCountryCode:baseCountryCode];
        self.targetCountry = [MNExchangeRateCountryLoader countryWithCountryCode:targetCountryCode];
    }
    else
    {
        // 없다면 마지막 설정 값이 있는지 체크
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *latestSettings = [defaults objectForKey:@"exchange_rate_latest_setting"];
        
        if (latestSettings)
        {
            baseCountryCode = latestSettings[KEY_SHARED_BASE_COUNTRY];
            targetCountryCode = latestSettings[KEY_SHARED_TARGET_COUNTRY];
            NSString* base_currency = latestSettings[KEY_SHARED_BASE_CURRENCY];
            
            self.baseCountry = [MNExchangeRateCountryLoader countryWithCountryCode:baseCountryCode];
            self.targetCountry = [MNExchangeRateCountryLoader countryWithCountryCode:targetCountryCode];
            
            [self.widgetDictionary setObject:baseCountryCode forKey:KEY_BASE_COUNTRY];
            [self.widgetDictionary setObject:targetCountryCode forKey:KEY_TARGET_COUNTRY];
            [self.widgetDictionary setObject:base_currency forKey:KEY_BASE_CURRENCY];
        }
        else
        {
            // Default Country
            
            //한국어: 1000원 -> 달러
            //일본어: 100엔 -> 달러
            //간체: 10위엔 -> 달러
            //번체: 100대만달러 -> 달러
            //영어: $1 -> 유로
            
            if ([[MNLanguage getCurrentLanguage] isEqualToString:@"ko"])
            { // 한국어
                self.baseCountry = [MNExchangeRateCountryLoader countryWithCountryCode:@"KRW"];
                self.targetCountry = [MNExchangeRateCountryLoader countryWithCountryCode:@"USD"];
                [self.widgetDictionary setObject:@"1000" forKey:KEY_BASE_CURRENCY];
            }
            else if ([[MNLanguage getCurrentLanguage] isEqualToString:@"en"])
            { // 영어
                self.baseCountry = [MNExchangeRateCountryLoader countryWithCountryCode:@"USD"];
                self.targetCountry = [MNExchangeRateCountryLoader countryWithCountryCode:@"EUR"];
                [self.widgetDictionary setObject:@"1" forKey:KEY_BASE_CURRENCY];
            }
            else if ([[MNLanguage getCurrentLanguage] isEqualToString:@"ja"])
            { // 일본어
                self.baseCountry = [MNExchangeRateCountryLoader countryWithCountryCode:@"JPY"];
                self.targetCountry = [MNExchangeRateCountryLoader countryWithCountryCode:@"USD"];
                [self.widgetDictionary setObject:@"100" forKey:KEY_BASE_CURRENCY];
                
            }
            else if ([[MNLanguage getCurrentLanguage] isEqualToString:@"zh-hans"])
            { // 중국어 간체
                self.baseCountry = [MNExchangeRateCountryLoader countryWithCountryCode:@"CNY"];
                self.targetCountry = [MNExchangeRateCountryLoader countryWithCountryCode:@"USD"];
                [self.widgetDictionary setObject:@"10" forKey:KEY_BASE_CURRENCY];            
            }
            else if ([[MNLanguage getCurrentLanguage] isEqualToString:@"zh-hant"])
            { // 중국어 본체
                self.baseCountry = [MNExchangeRateCountryLoader countryWithCountryCode:@"TWD"];
                self.targetCountry = [MNExchangeRateCountryLoader countryWithCountryCode:@"USD"];
                [self.widgetDictionary setObject:@"100" forKey:KEY_BASE_CURRENCY];            
            }
            // 러시안 루블 & USD
            [self.widgetDictionary setObject:self.baseCountry.currencyUnitCode forKey:KEY_BASE_COUNTRY];
            [self.widgetDictionary setObject:self.targetCountry.currencyUnitCode forKey:KEY_TARGET_COUNTRY];
        }
    }
    
    // 기존에 쓰던 파서, 이제 안됨
//    self.exchangeRate = [MNExchangeRateParser getExchangeRateWithBase:self.baseCountry.currencyUnitCode Target:self.targetCountry.currencyUnitCode];
    // 새로 만든 야후 파서
    self.exchangeRate = [MNExchangeRatesYahooJSONParser getExchangeRateWithBase:self.baseCountry.currencyUnitCode Target:self.targetCountry.currencyUnitCode];
    // 정확하지 않은 야후 환율은 0.001이 나오기에, 다시 계산해 준다.
    if (self.exchangeRate != 0 && self.exchangeRate <= 0.001) {
        double reversedExchangeRates = [MNExchangeRatesYahooJSONParser getExchangeRateWithBase:self.targetCountry.currencyUnitCode Target:self.baseCountry.currencyUnitCode];
        self.exchangeRate = 1.0f / reversedExchangeRates;
    }
    
    NSMutableDictionary *latestSettings = [NSMutableDictionary dictionary];

    [latestSettings setObject:self.widgetDictionary[KEY_BASE_COUNTRY] forKey:KEY_SHARED_BASE_COUNTRY];
    [latestSettings setObject:self.widgetDictionary[KEY_TARGET_COUNTRY] forKey:KEY_SHARED_TARGET_COUNTRY];
    [latestSettings setObject:self.widgetDictionary[KEY_BASE_CURRENCY] forKey:KEY_SHARED_BASE_CURRENCY];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:latestSettings forKey:@"exchange_rate_latest_setting"];
}

- (void)updateUI
{
    if (self.exchangeRate == MNExchangeRateParseErr)
    {
        [self.loadingDelegate showNetworkFail];
    }
    else
    {
        self.Image_Base.image = self.baseCountry.flag;
        self.Image_Target.image = self.targetCountry.flag;
        
        NSString *fullStr;
        
        NSNumberFormatter *formmater = [[NSNumberFormatter alloc] init];      
        [formmater setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formmater setMinimumFractionDigits:2];
        
        NSString *baseCurrencyStr = self.widgetDictionary[KEY_BASE_CURRENCY];
        long double baseCurrency = [baseCurrencyStr doubleValue];
        
        if (baseCurrencyStr == nil) {
            baseCurrency = 1;
        }
        
        long double targetCurrency = baseCurrency * self.exchangeRate;
        long double reverseCurrency = baseCurrency / self.exchangeRate;
        
        // 윗줄
        [formmater setCurrencySymbol:self.baseCountry.currencySymbol];
        if (((int)(baseCurrency*100)%100 == 0))
            [formmater setMinimumFractionDigits:0];
        else
            [formmater setMinimumFractionDigits:2];
        fullStr = [NSString stringWithFormat:@"%@ = ", [formmater stringFromNumber:[NSNumber numberWithDouble:baseCurrency]]];
        [formmater setCurrencySymbol:self.targetCountry.currencySymbol];
        if (((int)(targetCurrency*100)%100 == 0))
            [formmater setMinimumFractionDigits:0];
        else
            [formmater setMinimumFractionDigits:2];
        fullStr = [fullStr stringByAppendingFormat:@"%@", [formmater stringFromNumber:[NSNumber numberWithDouble:targetCurrency]]];
        
        self.Label_ExchangeRate.text = fullStr;
        
        // 아랫줄
        while (reverseCurrency < 0.1 && baseCurrency != 0) {
                baseCurrency *= 10;
                reverseCurrency *= 10;
            }
        
        reverseCurrency = baseCurrency / self.exchangeRate;
        
        [formmater setCurrencySymbol:self.targetCountry.currencySymbol];
        if (((int)(baseCurrency*100)%100 == 0))
            [formmater setMinimumFractionDigits:0];
        else
            [formmater setMinimumFractionDigits:2];
        fullStr = [NSString stringWithFormat:@"%@ = ", [formmater stringFromNumber:[NSNumber numberWithDouble:baseCurrency]]];
        [formmater setCurrencySymbol:self.baseCountry.currencySymbol];
        if (((int)(reverseCurrency*100)%100 == 0))
            [formmater setMinimumFractionDigits:0];
        else
            [formmater setMinimumFractionDigits:2];
        fullStr = [fullStr stringByAppendingFormat:@"%@", [formmater stringFromNumber:[NSNumber numberWithDouble:reverseCurrency]]];
        
        self.Label_ExchangeRate_Reverse.text = fullStr;
    }
}

- (void)initThemeColor
{
    [super initThemeColor];
    
//    self.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    self.Label_ExchangeRate.textColor = [MNTheme getWidgetPointFontUIColor];
    self.Label_ExchangeRate_Reverse.textColor = [MNTheme getWidgetSubFontUIColor];
}

- (void)onRotationWithOrientation:(UIInterfaceOrientation)orientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight))
        {
//            [self.Image_Base setFrame:CGRectMake(self.frame.size.width/2 - 87, 15.f, 75.f, 44.f)];
//            [self.Image_Target setFrame:CGRectMake(self.frame.size.width/2 + 10, 15.f, 75.f, 44.f)];
            self.Image_Base.frame = CGRectMake(self.frame.size.width/2 - OFFSET_IMAGE_HORIZON - 75,
                                               self.frame.size.height/2 - OFFSET_IMAGE_VERTICAL,
                                               75, 44);
            self.Image_Target.frame = CGRectMake(self.frame.size.width/2 + OFFSET_IMAGE_HORIZON,
                                                 self.frame.size.height/2 - OFFSET_IMAGE_VERTICAL,
                                                 75, 44);
            
            CGRect exchangeRateFrame = self.Label_ExchangeRate.frame;
            CGRect reverseFrame = self.Label_ExchangeRate_Reverse.frame;
            
            exchangeRateFrame.origin.y = self.frame.size.height/2 + OFFSET_LABEL_CURRENCY;
            reverseFrame.origin.y = self.frame.size.height/2 + OFFSET_LABEL_REVERSE;
            
            self.Label_ExchangeRate.frame = exchangeRateFrame;
            self.Label_ExchangeRate_Reverse.frame = reverseFrame;
        }
        else
        {
            [self.Image_Base setFrame:CGRectMake(20.f, 15.f, 50.f, 35.f)];
            [self.Image_Target setFrame:CGRectMake(84.f, 15.f, 50.f, 35.f)];
            self.Label_ExchangeRate.frame = CGRectMake(11, 54, 132, 21);
            self.Label_ExchangeRate_Reverse.frame = CGRectMake(11, 72, 132, 21);
        }
    }
    else
    {
        if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight))
        {
            self.Image_Base.frame = CGRectMake(self.frame.size.width/2 - OFFSET_IMAGE_HORIZON - 161,
                                               self.frame.size.height/2 - OFFSET_IMAGE_VERTICAL,
                                               161, 108);
            self.Image_Target.frame = CGRectMake(self.frame.size.width/2 + OFFSET_IMAGE_HORIZON,
                                                 self.frame.size.height/2 - OFFSET_IMAGE_VERTICAL,
                                                 161, 108);
            
            CGRect exchangeRateFrame = self.Label_ExchangeRate.frame;
            CGRect reverseFrame = self.Label_ExchangeRate_Reverse.frame;
            
            exchangeRateFrame.origin.y = self.frame.size.height/2 + OFFSET_LABEL_CURRENCY;
            reverseFrame.origin.y = self.frame.size.height/2 + OFFSET_LABEL_REVERSE;
            
            self.Label_ExchangeRate.frame = exchangeRateFrame;
            self.Label_ExchangeRate_Reverse.frame = reverseFrame;
            [self.Label_ExchangeRate setFont:[UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LABEL_CURRENCY_LAND]];
            [self.Label_ExchangeRate_Reverse setFont:[UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LABEL_REVERSE_LAND]];
        }
        else
        {
            [self.Image_Base setFrame:CGRectMake(48.f, 44.f, 120.f, 83.f)];
            [self.Image_Target setFrame:CGRectMake(201.f, 44.f, 120.f, 83.f)];
            self.Label_ExchangeRate.frame = CGRectMake(22, 147, 326, 38);
            self.Label_ExchangeRate_Reverse.frame = CGRectMake(22, 179, 326, 38);
            [self.Label_ExchangeRate setFont:[UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LABEL_CURRENCY]];
            [self.Label_ExchangeRate_Reverse setFont:[UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LABEL_REVERSE]];
        }
    }
    
//    NSLog(@"%f", self.frame.size.height);
//    NSLog(@"%f %f", self.Label_ExchangeRate.frame.origin.x, self.Label_ExchangeRate.frame.origin.y);
//    NSLog(@"%f %f", self.Label_ExchangeRate_Reverse.frame.origin.x, self.Label_ExchangeRate_Reverse.frame.origin.y);
//    NSLog(@"%f %f", self.Image_Base.frame.size.width, self.Image_Base.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
