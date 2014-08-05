//
//  MNExchangeRateCountrySelectTabBarController.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 18..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNExchangeRateCountrySelectTableViewController.h"
#import "MNExchangeRateCountrySelectWithSearchBarViewController.h"
#import "MHTabBarController.h"

@protocol MNExchangeRateCountrySelectTabBarControllerDelegate <NSObject>

- (void)countrySelected:(NSString *)code Target:(NSString *)target;

@end

@interface MNExchangeRateCountrySelectTabBarController : MHTabBarController <MNExchangeRateCountrySelectTableViewControllerDelegate, MNExchangeRateCountrySelectTableViewWithSearchBarControllerDelegate>

@property (strong, nonatomic) id<MNExchangeRateCountrySelectTabBarControllerDelegate> selectDelegate;
@property (strong, nonatomic) NSString* Target;

@end
