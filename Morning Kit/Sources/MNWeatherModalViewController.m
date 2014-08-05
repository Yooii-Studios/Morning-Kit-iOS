//
//  MNWeatherModalViewController.m
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 5. 4..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWeatherModalViewController.h"
#import "MNWeatherModalTableCell.h"
#import "MNCountryFlagImageFactory.h"
#import "MNWeatherLocationSpecificationMaker.h"
#import "MNTheme.h"

@implementation MNWeatherModalViewController

@synthesize latestSearchIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        latestSearchIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _animation_Initial_Y = _label_useCurrentLocation.center.y;
    _animation_Height= _label_useCurrentLocation.center.y - (_label_useCurrentLocation.bounds.size.height/2 + 14);
    
    // color set
    self.view.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    _label_useCurrentLocation.textColor = [MNTheme getMainFontUIColor];
    _label_temperatureMode.textColor = [MNTheme getMainFontUIColor];
    _label_displayLocalTime.textColor = [MNTheme getMainFontUIColor];
    
    _label_useCurrentLocation.text = MNLocalizedString(@"weather_use_current_location", "useCurrentLocation");
    _label_temperatureMode.text = MNLocalizedString(@"weather_temperature_unit", "useCurrentLocation");
    _label_displayLocalTime.text = MNLocalizedString(@"display_local_time", "useCurrentLocation");
    
    self.searchDisplayController.searchBar.tintColor = [MNTheme getButtonBackgroundUIColor];
    self.searchDisplayController.searchBar.placeholder = MNLocalizedString(@"weather_search_city", "weather_search_city");
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self.searchDisplayController.searchBar setBarTintColor:[MNTheme getButtonBackgroundUIColor]];
        [self.searchDisplayController.searchBar setTintColor:[MNTheme getButtonBackgroundUIColor]];
    }else{
        self.searchDisplayController.searchBar.tintColor = [MNTheme getButtonBackgroundUIColor];
    }
    
//    _switch_temperatureMode.tintColor = [MNTheme getForwardBackgroundUIColor];
//    _switch_temperatureMode.segmentedControlStyle = UISegmentedControlStyleBar;
    _switch_temperatureMode.segmentedControlStyle = UISegmentedControlStylePlain;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        _switch_temperatureMode.tintColor = [MNTheme getMainFontUIColor];
    }
    
//    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObject:[MNTheme getWidgetSubFontUIColor] forKey:UITextAttributeTextColor];
//    [_switch_temperatureMode setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
//    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
//    [_switch_temperatureMode setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];

    //_switch_displayLocalTime.onTintColor = [MNTheme getSecondSubFontUIColor];
    //_switch_useCurrentLocation.onTintColor = [MNTheme getSecondSubFontUIColor];
    
    // color set end
    
    _cityInfoQuery = [[MNCityInfoQuery alloc] init];
    _cityInfoesInTable = [[NSMutableArray alloc] init];
    
    NSData* tData = [self.widgetDictionary objectForKey:DictKey_WeatherSetting];
    [self setWeatherSetting:(MNWeatherSetting*)((tData!=nil)?[NSKeyedUnarchiver unarchiveObjectWithData:tData]:NULL)];
    tData = [self.widgetDictionary objectForKey:DictKey_TargetLocation];
    [self setTargetLocation:(MNLocationInfo *)((tData!=nil)?[NSKeyedUnarchiver unarchiveObjectWithData:tData]:NULL)];
    
    ([_weatherSetting temperatureUnit]==eWTU_Celcius) ? [_switch_temperatureMode setSelectedSegmentIndex:0] : [_switch_temperatureMode setSelectedSegmentIndex:1];
    [_switch_displayLocalTime setOn:[_weatherSetting displayLocalTime]];
    
    if( [_weatherSetting useCurrentLocation] )
    {
        [_switch_useCurrentLocation setOn:YES];
        [self.searchDisplayController setActive:NO animated:YES];
        [self.searchDisplayController.searchBar setHidden:YES];
        [self.searchDisplayController.searchResultsTableView setHidden:YES];
        [_text_currentLocation setText:[_targetLocation name]];
        
        [UIView animateWithDuration:0.5f animations:^{
            
            // label
            _label_useCurrentLocation.center = CGPointMake(_label_useCurrentLocation.center.x, _label_useCurrentLocation.center.y - _animation_Height );
            _label_displayLocalTime.center = CGPointMake(_label_displayLocalTime.center.x , _label_displayLocalTime.center.y - _animation_Height );
            _label_temperatureMode.center = CGPointMake(_label_temperatureMode.center.x , _label_temperatureMode.center.y - _animation_Height );
            // switch
            _switch_useCurrentLocation.center = CGPointMake(_switch_useCurrentLocation.center.x, _switch_useCurrentLocation.center.y - _animation_Height );
            _switch_displayLocalTime.center = CGPointMake(_switch_displayLocalTime.center.x , _switch_displayLocalTime.center.y - _animation_Height );
            _switch_temperatureMode.center = CGPointMake(_switch_temperatureMode.center.x , _switch_temperatureMode.center.y - _animation_Height );
            
        }];
    }
    else
    {
        [_switch_useCurrentLocation setOn:NO];
        [self.searchDisplayController setActive:NO animated:YES];
        [self.searchDisplayController.searchBar setHidden:NO];
        [self.searchDisplayController.searchResultsTableView setHidden:YES];
        [_text_currentLocation setText:[_targetLocation name]];
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        _switch_useCurrentLocation.tintColor = [MNTheme getSwitchTintColorInModalController];
        _switch_displayLocalTime.tintColor = [MNTheme getSwitchTintColorInModalController];
        
        // iOS7용 서치바를 스테이터스바에 침범하지 않게 하는 코드
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void) setTargetLocation:(MNLocationInfo *) _location
{
    if( _location )
        _targetLocation = _location;
    
    if( _targetLocation == nil )
        _targetLocation = [[MNLocationInfo alloc] init];
}

- (void) setWeatherSetting:(MNWeatherSetting *) _setting
{
    if( _setting )
        _weatherSetting = _setting;
    
    if( _weatherSetting == nil )
        _weatherSetting = [[MNWeatherSetting alloc]init];
    
}
- (void) setUseCurrentLocation:(bool)_useCurrentLocation
{
    [self.switch_useCurrentLocation setOn:_useCurrentLocation];
    if( _useCurrentLocation == NO )
    {
        [self.text_currentLocation setHidden:NO];
        [self.table_searchedLocations setHidden:NO];
        [self.searchDisplayController setActive:YES animated:YES];
    }
    else
    {
        [self.text_currentLocation setHidden:YES];
        [self.table_searchedLocations setHidden:YES];
        [self.searchDisplayController setActive:NO animated:YES];
    }
}

#pragma mark - click handling
- (void)doneButtonClicked
{
    [_weatherSetting setTemperatureUnit: [_switch_temperatureMode selectedSegmentIndex]?eWTU_Fahrenheit:eWTU_Celcius];
    [_weatherSetting setDisplayLocalTime:[_switch_displayLocalTime isOn]];
    [_weatherSetting setUseCurrentLocation:[_switch_useCurrentLocation isOn]];
    
    if( _targetLocation.latitude == 0 && _targetLocation.longitude == 0 )
      [_weatherSetting setUseCurrentLocation:YES];
    
    [self.widgetDictionary setObject: [NSKeyedArchiver archivedDataWithRootObject:self.targetLocation]  forKey:DictKey_TargetLocation];
    [self.widgetDictionary setObject: [NSKeyedArchiver archivedDataWithRootObject:self.weatherSetting]  forKey:DictKey_WeatherSetting];

    [super doneButtonClicked];
}

- (void)cancelButtonClicked
{
    [super cancelButtonClicked];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDisplayController delegate method
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {

    ++latestSearchIndex;
    
    // 검색 함수 구현해서 source를 구함
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int searchIndex = latestSearchIndex;
        
       // _cityInfoesInTable - 여기서 키워드로 시작하는 리스트와 포함하는 리스트를 같이 구한다.        
        NSMutableArray* tempCityInfoes = [_cityInfoQuery getCityLocations:searchString inMethod:eSM_Prefix];
//        [tempCityInfoes addObjectsFromArray:[_cityInfoQuery getCityLocations:searchString inMethod:eSM_Contains_But_Not_Prefix]];
        
        if( searchIndex == latestSearchIndex )
        {
            _cityInfoesInTable = tempCityInfoes;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchDisplayController.searchResultsTableView reloadData ];
            });
        }
    });
    
    
    return YES;
}

#pragma UISearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchDisplayController.searchBar setHidden:NO];
    [self.searchDisplayController.searchResultsTableView setHidden:NO];
    
    [self.searchDisplayController setActive:YES animated:YES];
    
    NSString* tStr = _text_currentLocation.text;
    self.searchDisplayController.searchBar.text = @"";
    self.searchDisplayController.searchBar.text = tStr;
    
}

#pragma UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cityInfoesInTable count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    MNLocationInfo *locationOfCell = _cityInfoesInTable[[indexPath row]];
    
    MNWeatherModalTableCell *cell = (MNWeatherModalTableCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        
        cell = (MNWeatherModalTableCell *)[[[NSBundle mainBundle] loadNibNamed:@"MNWeatherModalTableCell" owner:self options:nil] objectAtIndex:0];
    }
    
    [[cell label_locationName] setText:[locationOfCell name]];
    [[cell label_locationSpecification] setText:[MNWeatherLocationSpecificationMaker getLocationSpecificationOfCountry:[locationOfCell countryCode] OfRegion:[locationOfCell regionCode]]];
    [[cell image_countryFlag] setImage:[MNCountryFlagImageFactory getImage:[locationOfCell countryCode] bwImage:NO]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( [[tableView subviews] count] == 0 )
        return 0;
    
    return [MNWeatherModalTableCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setTargetLocation: _cityInfoesInTable[[indexPath row]] ];
    
    [self doneButtonClicked];
}

#pragma IBAction
-(IBAction)action_switch_temperatureMode:(id)sender
{
}
-(IBAction)action_switch_displayLocalTime:(id)sender
{
}
-(IBAction)action_switch_useCurrentLocation:(id)sender
{
    if( [_switch_useCurrentLocation isOn] )
    {
        [self.searchDisplayController.searchBar setHidden:YES];
        [self.searchDisplayController.searchResultsTableView setHidden:YES];
        
        [self.searchDisplayController setActive:NO animated:YES];
        
        [UIView animateWithDuration:0.3f animations:^{
            
            // label
            _label_useCurrentLocation.center = CGPointMake(_label_useCurrentLocation.center.x, _animation_Initial_Y - _animation_Height + _animation_Height*0);
            _label_displayLocalTime.center = CGPointMake(_label_displayLocalTime.center.x , _animation_Initial_Y - _animation_Height + _animation_Height*1 );
            _label_temperatureMode.center = CGPointMake(_label_temperatureMode.center.x , _animation_Initial_Y - _animation_Height + _animation_Height*2 );
            // switch
            _switch_useCurrentLocation.center = CGPointMake(_switch_useCurrentLocation.center.x, _animation_Initial_Y - _animation_Height + _animation_Height*0 );
            _switch_displayLocalTime.center = CGPointMake(_switch_displayLocalTime.center.x , _animation_Initial_Y - _animation_Height + _animation_Height*1 );
            _switch_temperatureMode.center = CGPointMake(_switch_temperatureMode.center.x , _animation_Initial_Y - _animation_Height + _animation_Height*2 );

            //[_label_displayLocalTime setBounds:copy];
        }];
    }
    else
    {
        [self.searchDisplayController.searchBar setHidden:NO];
        [self.searchDisplayController.searchResultsTableView setHidden:NO];
        
        NSString* tStr =[_targetLocation name];
        self.searchDisplayController.searchBar.text = @"";
        [self.searchDisplayController setActive:YES animated:YES];
        
        self.searchDisplayController.searchBar.text = tStr;
        [self.searchDisplayController.searchBar becomeFirstResponder];
        
        [UIView animateWithDuration:0.5f animations:^{
            
            // label
            _label_useCurrentLocation.center = CGPointMake(_label_useCurrentLocation.center.x, _animation_Initial_Y + _animation_Height*0 );
            _label_displayLocalTime.center = CGPointMake(_label_displayLocalTime.center.x , _animation_Initial_Y + _animation_Height*1 );
            _label_temperatureMode.center = CGPointMake(_label_temperatureMode.center.x , _animation_Initial_Y + _animation_Height*2 );
            // switch
            _switch_useCurrentLocation.center = CGPointMake(_switch_useCurrentLocation.center.x, _animation_Initial_Y + _animation_Height*0 );
            _switch_displayLocalTime.center = CGPointMake(_switch_displayLocalTime.center.x , _animation_Initial_Y + _animation_Height*1 );
            _switch_temperatureMode.center = CGPointMake(_switch_temperatureMode.center.x , _animation_Initial_Y + _animation_Height*2 );
            
            //[_label_displayLocalTime setBounds:copy];
        }];
    }
    //[self setUseCurrentLocation: [_switch_useCurrentLocation isOn]];
}
-(IBAction)action_text_cityQuery:(id)sender
{
}

#pragma mark - rotate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    return NO;
}

// for over iOS 6.0
- (BOOL)shouldAutorotate {
    return YES;
}

// Tell the system which initial orientation we want to have
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
    
}

// Tell the system what we support
-(NSUInteger)supportedInterfaceOrientations
{
    // return UIInterfaceOrientationMaskLandscapeRight;
    // return UIInterfaceOrientationMaskAll;
    return UIInterfaceOrientationMaskPortrait;
}


@end










