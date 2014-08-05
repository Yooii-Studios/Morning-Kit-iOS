//
//  MNERCountrySelectTabBarControllerViewController.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 7. 27..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNERCountrySelectTabBarControllerViewController.h"

@implementation MNERCountrySelectTabBarControllerViewController
{
    MNExchangeRateCountrySelectTableViewController *mainCurrencySelectController;
    MNExchangeRateCountrySelectWithSearchBarViewController *allCurrencySelectController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:MNLocalizedString(@"cancel", @"취소버튼") style:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked)];
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
    
    mainCurrencySelectController.selectDelegate = self;
}

- (void)initAllCurrencySelectController
{
    allCurrencySelectController = [[MNExchangeRateCountrySelectWithSearchBarViewController alloc] initWithStyle:UITableViewStylePlain];
    [allCurrencySelectController setTitle:MNLocalizedString(@"exchange_rate_all_currencies", "All currencies")];
    
    allCurrencySelectController.selectDelegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.translucent = NO;
    }
}

#pragma mark - Country Select Delegate

- (void)CountrySelected:(NSString *)code
{
    [self.selectDelegate countrySelected:code Target:self.Target];
    
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
