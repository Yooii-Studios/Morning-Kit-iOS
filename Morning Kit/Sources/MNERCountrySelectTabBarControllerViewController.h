//
//  MNERCountrySelectTabBarControllerViewController.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 7. 27..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MHTabBarController.h"
#import "MNExchangeRateCountrySelectTableViewController.h"
#import "MNExchangeRateCountrySelectWithSearchBarViewController.h"

@protocol MNExchangeRateCountrySelectTabBarControllerDelegate <NSObject>

- (void)countrySelected:(NSString *)code Target:(NSString *)target;

@end

@interface MNERCountrySelectTabBarControllerViewController : MHTabBarController <MNExchangeRateCountrySelectTableViewControllerDelegate, MNExchangeRateCountrySelectTableViewWithSearchBarControllerDelegate>

@property (strong, nonatomic) id<MNExchangeRateCountrySelectTabBarControllerDelegate> selectDelegate;
@property (strong, nonatomic) NSString* Target;


@end
