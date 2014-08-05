//
//  MNWeatherModalViewController.h
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 5. 4..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetModalController.h"
#import "MNWeatherData.h"
#import "MNWeatherSetting.h"
#import "MNCityInfoQuery.h"

#define DictKey_TargetLocation @"Weather_DictKey_TargetLocation"
#define DictKey_WeatherSetting @"Weather_DictKey_WeatherSetting"

@interface MNWeatherModalViewController : MNWidgetModalController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl   *switch_temperatureMode;
@property (strong, nonatomic) IBOutlet UISwitch             *switch_displayLocalTime;
@property (strong, nonatomic) IBOutlet UISwitch             *switch_useCurrentLocation;

@property (strong, nonatomic) IBOutlet UILabel              *label_temperatureMode;
@property (strong, nonatomic) IBOutlet UILabel              *label_displayLocalTime;
@property (strong, nonatomic) IBOutlet UILabel              *label_useCurrentLocation;

@property (strong, nonatomic) IBOutlet UITableView          *table_searchedLocations;

@property (strong, nonatomic) IBOutlet UISearchBar          *text_currentLocation;

@property (strong, nonatomic) MNLocationInfo        *targetLocation;
@property (strong, nonatomic) MNWeatherSetting      *weatherSetting;
@property (strong, nonatomic) MNCityInfoQuery       *cityInfoQuery;
@property (strong, nonatomic) NSArray               *cityInfoesInTable;

@property NSInteger latestSearchIndex;

@property float animation_Height;
@property float animation_Initial_Y;

#pragma private functions
- (void) setTargetLocation:(MNLocationInfo *) _location;
- (void) setWeatherSetting:(MNWeatherSetting *) _setting;
- (void) setUseCurrentLocation:(bool)_useCurrentLocation;

#pragma UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

#pragma UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma IBAction
-(IBAction)action_switch_temperatureMode:(id)sender;
-(IBAction)action_switch_displayLocalTime:(id)sender;
-(IBAction)action_switch_useCurrentLocation:(id)sender;
-(IBAction)action_text_cityQuery:(id)sender;


@end
