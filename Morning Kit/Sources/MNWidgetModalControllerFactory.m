//
//  MNWidgetModalControllerFactory.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 3..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetModalControllerFactory.h"

#import "MNCalendarModalViewController.h"
#import "MNWeatherModalViewController.h"
#import "MNQuotesModalViewController.h"
#import "MNFlickrModalViewController.h"
#import "MNWorldClockModalViewController.h"
#import "MNMemoModalViewController.h"
#import "MNExchangeRateModalViewController.h"
#import "MNDateCountdownModalViewController.h"
#import "MNReminderModalController.h"

#import "MNDefinitions.h"

#define WEATHER_WIDGET_NIB_NAME ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNWeatherModalViewController_iPad" : @"MNWeatherModalViewController")
#define EXCHANGERATES_WIDGET_NIB_NAME ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNExchangeRateModalView_iPad" : @"MNExchangeRateModalView")
#define FLICKR_WIDGET_NIB_NAME ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNFlickrModalViewController_iPad" : @"MNFlickrModalViewController_iPhone")
#define MEMO_WIDGET_NIB_NAME ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNMemoModalViewController_iPad" : @"MNMemoModalViewController_iPhone")
#define QUOTES_WIDGET_NIB_NAME ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNQuotesModalViewController_iPad" : @"MNQuotesModalViewController_iPhone")
#define REMINDER_WIDGET_NIB_NAME ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNReminderModalController_iPad" : @"MNReminderModalController")


@implementation MNWidgetModalControllerFactory

+ (MNWidgetModalController *)getModalControllerWithDictionary:(NSMutableDictionary *)dict
{
    MNWidgetModalController *tempController = nil;
    
    switch ([(NSNumber *)[dict objectForKey:@"Type"] integerValue]) {
        case WEATHER:
            tempController = (MNWeatherModalViewController *)[[MNWeatherModalViewController alloc] initWithNibName:WEATHER_WIDGET_NIB_NAME bundle:nil];
            break;
            
        case FLICKR:
            tempController = [[MNFlickrModalViewController alloc] initWithNibName:FLICKR_WIDGET_NIB_NAME bundle:nil];
            break;
            
        case WORLDCLOCK:
            tempController = [[MNWorldClockModalViewController alloc] initWithNibName:@"MNWorldClockModalViewController_iPhone" bundle:nil];
            break;
            
        case QUOTES:
            tempController = [[MNQuotesModalViewController alloc] initWithNibName:QUOTES_WIDGET_NIB_NAME bundle:nil];
            break;
            
        case MEMO:
            tempController = [[MNMemoModalViewController alloc] initWithNibName:MEMO_WIDGET_NIB_NAME bundle:nil];
            break;
            
        case EXCHANGE_RATE:
            tempController = [[MNExchangeRateModalViewController alloc] initWithNibName:EXCHANGERATES_WIDGET_NIB_NAME bundle:nil];
            break;
            
        case DATE_COUNTDOWN:
            tempController = [[MNDateCountdownModalViewController alloc] initWithNibName:@"MNDateCountdownModalViewController_iPhone" bundle:nil];
            break;
            
        case CALENDAR:
            tempController = [[MNCalendarModalViewController alloc] initWithNibName:@"MNCalendarModalViewController_iPhone" bundle:nil];
            break;
            
        case REMINDER:
            tempController = [[MNReminderModalController alloc] initWithNibName:REMINDER_WIDGET_NIB_NAME bundle:nil];
            break;
            
        default:
            break;
    }
    
    [tempController initWithDictionary:dict];
    
    return tempController;
}

@end
