//
//  MNExchangeRateCountrySelectTabBarController.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 18..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNExchangeRateCountrySelectTabBarController.h"
#import "MNExchangeRateCountryLoader.h"

@interface MNExchangeRateCountrySelectTabBarController ()

@end

@implementation MNExchangeRateCountrySelectTabBarController
{
    MNExchangeRateCountrySelectTableViewController *mainCurrencySelectController;
    MNExchangeRateCountrySelectWithSearchBarViewController *allCurrencySelectController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked)];
        self.navigationItem.leftBarButtonItem = cancelItem;
        
        [self initMainCurrencySelectController];
        [self initAllCurrencySelectController];
        
        self.viewControllers = [NSArray arrayWithObjects:mainCurrencySelectController
                                , allCurrencySelectController, nil];
    }
    return self;
}

- (void)cancelButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initMainCurrencySelectController
{
    mainCurrencySelectController = [[MNExchangeRateCountrySelectTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [mainCurrencySelectController setTitle:MNLocalizedString(@"exchange_rate_main_currencies", "All currencies")];
    
    mainCurrencySelectController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -15);
//    mainCurrencySelectController.tabBarItem
    
    NSDictionary *textAttrs;
    textAttrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f], UITextAttributeFont, nil];
    [mainCurrencySelectController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    mainCurrencySelectController.selectDelegate = self;
}

- (void)initAllCurrencySelectController
{
    allCurrencySelectController = [[MNExchangeRateCountrySelectWithSearchBarViewController alloc] initWithStyle:UITableViewStylePlain];
    [allCurrencySelectController setTitle:MNLocalizedString(@"exchange_rate_all_currencies", "All currencies")];
    
    allCurrencySelectController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -15);
    NSDictionary *textAttrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f], UITextAttributeFont, nil];
    [allCurrencySelectController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    allCurrencySelectController.selectDelegate = self;
}

#pragma mark - Country Select Delegate

- (void)CountrySelected:(NSString *)code
{
    [self.selectDelegate countrySelected:code Target:self.Target];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end