//
//  MNExchangeRateModalViewController_iPhone.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 10..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetModalController.h"
#import "MNExchangeRateCountryLoader.h"
//#import "LeveyPopListView.h"
#import "MNERCountrySelectTabBarControllerViewController.h"

@interface MNExchangeRateModalViewController : MNWidgetModalController <MNExchangeRateCountrySelectTabBarControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *targetLabel;
@property (strong, nonatomic) IBOutlet UIImageView *targetFlag;
@property (strong, nonatomic) IBOutlet UILabel *baseLabel;
@property (strong, nonatomic) IBOutlet UIImageView *baseFlag;
@property (strong, nonatomic) IBOutlet UITextField *baseCurrency;
@property (strong, nonatomic) IBOutlet UITextField *targetCurrency;
@property (strong, nonatomic) IBOutlet UIView *reverseButton;
@property (strong, nonatomic) IBOutlet UILabel *reverseLabel;
@property (strong, nonatomic) IBOutlet UIButton *hideKeyboardButton;

@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;

@property (strong, nonatomic) MNExchangeRateCountry *baseCountry;
@property (strong, nonatomic) MNExchangeRateCountry *targetCountry;
@property (nonatomic) double exchangeRate;

@end
