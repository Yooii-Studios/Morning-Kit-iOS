//
//  MNExchangeRateCountrySelectTableViewController.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 18..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  MNExchangeRateCountrySelectTableViewControllerDelegate <NSObject>

- (void)CountrySelected:(NSString *)code;

@end

@interface MNExchangeRateCountrySelectTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *sources;
@property (strong, nonatomic) id<MNExchangeRateCountrySelectTableViewControllerDelegate> selectDelegate;

@end
