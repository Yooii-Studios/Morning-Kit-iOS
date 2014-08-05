//
//  MNWorldClockModalViewController.h
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 10..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetModalController.h"
#import "MNTimeZone.h"

@interface MNWorldClockModalViewController : MNWidgetModalController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UILabel *clockTypeLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *clockTypeSegmentedControl;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSArray *allTimeZones;
@property (strong, nonatomic) NSArray *searchedTimeZones;
@property (strong, nonatomic) MNTimeZone *selectedTimeZone;

// 24시간제
@property (strong, nonatomic) IBOutlet UILabel *isUsing24HoursLabel;
@property (strong, nonatomic) IBOutlet UISwitch *isUsing24HoursSwitch;

@end
