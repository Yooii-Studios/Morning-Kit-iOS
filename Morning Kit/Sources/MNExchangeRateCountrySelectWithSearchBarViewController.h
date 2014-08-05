//
//  MNExchangeRateCountrySelectWithSearchBarViewController.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 18..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  MNExchangeRateCountrySelectTableViewWithSearchBarControllerDelegate <NSObject>

- (void)CountrySelected:(NSString *)code;

@end

@interface MNExchangeRateCountrySelectWithSearchBarViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSArray *searchedCountries;

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchController;

@property (strong, nonatomic) NSArray *sources;
@property (strong, nonatomic) id<MNExchangeRateCountrySelectTableViewWithSearchBarControllerDelegate> selectDelegate;

@end
