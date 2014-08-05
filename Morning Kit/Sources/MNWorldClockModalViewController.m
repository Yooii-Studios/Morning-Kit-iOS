//
//  MNWorldClockModalViewController.m
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 10..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWorldClockModalViewController.h"
#import "MNTheme.h"
#import "MNDefinitions.h"
#import "MNTimeZoneProcessor.h"
#import "MNWorldClockTimeZoneCell.h"
#import "MNLanguage.h"

@interface MNWorldClockModalViewController ()

@end

@implementation MNWorldClockModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 모든 타임존 비동기 로딩
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.allTimeZones = [MNTimeZoneProcessor loadTimeZonesFromRawFile:@"city_list"];
    });
    
    self.view.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    // selectedTimeZone 로딩
    NSData *selectedTimeZoneData = [self.widgetDictionary objectForKey:WORLD_CLOCK_SELECTED_TIMEZONE];
    if (selectedTimeZoneData) {
        self.selectedTimeZone = [NSKeyedUnarchiver unarchiveObjectWithData:selectedTimeZoneData];
    }else{
        self.selectedTimeZone = [MNTimeZoneProcessor getDefaultTimeZone];
    }
    
//    self.searchBar.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self.searchBar setBarTintColor:[MNTheme getButtonBackgroundUIColor]];
        self.searchBar.tintColor = [MNTheme getButtonBackgroundUIColor];
    }else{
        self.searchBar.tintColor = [MNTheme getButtonBackgroundUIColor];
    }
//    self.searchBar.barStyle = UIBarStyleBlackTranslucent;
    self.searchBar.text = self.selectedTimeZone.cityName;
    self.searchBar.placeholder = MNLocalizedString(@"weather_search_city", @"도시 검색(영어)");
    
//    NSLog(@"viewDidLoad");
    self.searchDisplayController.searchResultsTableView.hidden = YES;
    
    // Clock Type Label
    self.clockTypeLabel.text = MNLocalizedString(@"world_clock_clock_type_text", @"시계 타입");
    self.clockTypeLabel.textColor = [MNTheme getMainFontUIColor];
    
    // SegmentedControl
    if ([self.widgetDictionary objectForKey:WORLD_CLOCK_TYPE]) {
        NSInteger clockTypeIndex = ((NSNumber *)[self.widgetDictionary objectForKey:WORLD_CLOCK_TYPE]).integerValue;
        self.clockTypeSegmentedControl.selectedSegmentIndex = clockTypeIndex;
    }
//    self.clockTypeSegmentedControl.tintColor = [MNTheme getBackwardBackgroundUIColor];
//    self.clockTypeSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.clockTypeSegmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    [self.clockTypeSegmentedControl setTitle:MNLocalizedString(@"world_clock_analog", @"아날로그") forSegmentAtIndex:0];
    [self.clockTypeSegmentedControl setTitle:MNLocalizedString(@"world_clock_digital", @"디지털") forSegmentAtIndex:1];
    
    CGFloat suitableFontSize = 16.0;
    // 러시아어 폰트 최적화
    if ([[MNLanguage getCurrentLanguage] isEqualToString:@"ru"]) {
        suitableFontSize = 11.0;
    }
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [MNTheme getMainFontUIColor], UITextAttributeTextColor,
                                    [UIFont fontWithName:@"Helvetica-Bold" size:suitableFontSize], UITextAttributeFont
                                    , nil];
    [self.clockTypeSegmentedControl setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    if (self.clockTypeSegmentedControl.selectedSegmentIndex == WORLD_CLOCK_TYPE_ANALOG) {
        self.isUsing24HoursLabel.alpha = 0;
        self.isUsing24HoursSwitch.alpha = 0;
    }else{
        self.isUsing24HoursLabel.alpha = 1;
        self.isUsing24HoursSwitch.alpha = 1;
    }
    [self.clockTypeSegmentedControl addTarget:self action:@selector(segmentedClicked:) forControlEvents:UIControlEventValueChanged];
    
    // segment control 추가: 안눌린 것은 색 조절
//    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObject:[MNTheme getWidgetSubFontUIColor] forKey:UITextAttributeTextColor];
//    [self.clockTypeSegmentedControl setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
//    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
//    [self.clockTypeSegmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    // searchBar
    self.searchBar.delegate = self;
    
    // 24시간제 관련 세팅
    self.isUsing24HoursLabel.text = MNLocalizedString(@"world_clock_use_24_hour_format", @"24시간제 사용");
    self.isUsing24HoursLabel.textColor = [MNTheme getMainFontUIColor];
    if ([self.widgetDictionary objectForKey:WORLD_CLOCK_USING_24HOURS]) {
        self.isUsing24HoursSwitch.on = ((NSNumber *)[self.widgetDictionary objectForKey:WORLD_CLOCK_USING_24HOURS]).boolValue;
    }else{
        self.isUsing24HoursSwitch.on = NO;
    }
//    self.isUsing24HoursSwitch.onTintColor = [MNTheme getSecondSubFontUIColor];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.clockTypeSegmentedControl.tintColor = [MNTheme getMainFontUIColor];
        self.isUsing24HoursSwitch.tintColor = [MNTheme getSwitchTintColorInModalController];
        
        // iOS7용 서치바를 스테이터스바에 침범하지 않게 하는 코드
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - button handler

- (void)doneButtonClicked {
    [self.widgetDictionary setObject:@(self.clockTypeSegmentedControl.selectedSegmentIndex) forKey:WORLD_CLOCK_TYPE];
    if (self.selectedTimeZone) {
        [self.widgetDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:self.selectedTimeZone] forKey:WORLD_CLOCK_SELECTED_TIMEZONE];
        
        // 최근 입력했던 도시를 기억하기
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.selectedTimeZone] forKey:@"world_clock_latest_timezone"];
    }else{
        [self.widgetDictionary removeObjectForKey:WORLD_CLOCK_SELECTED_TIMEZONE];
    }
    
    if (self.clockTypeSegmentedControl.selectedSegmentIndex == WORLD_CLOCK_TYPE_ANALOG) {
        [self.widgetDictionary removeObjectForKey:WORLD_CLOCK_USING_24HOURS];
    }else{
        [self.widgetDictionary setObject:@(self.isUsing24HoursSwitch.on) forKey:WORLD_CLOCK_USING_24HOURS];
    }
    
    [super doneButtonClicked];
}


#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.searchDisplayController setActive:NO animated:YES];
    self.selectedTimeZone = [self.searchedTimeZones objectAtIndex:indexPath.row];
    self.searchBar.text = self.selectedTimeZone.cityName;
    
    [self doneButtonClicked];
}

#pragma mark - UITableView data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MNWorldClockTimeZoneCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    NSLog(@"count: %d", self.searchedTimeZones.count);
    return self.searchedTimeZones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
    
    MNWorldClockTimeZoneCell *cell = (MNWorldClockTimeZoneCell *)[tableView dequeueReusableCellWithIdentifier:@"MNWorldClockTimeZoneCell"];
//    cell.contentView.backgroundColor = [UIColor clearColor];
    
    if (cell == nil) {
        cell = (MNWorldClockTimeZoneCell *)[[[NSBundle mainBundle] loadNibNamed:@"MNWorldClockTimeZoneCell_iPhone" owner:self options:nil] objectAtIndex:0];
//        cell.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    }
    
    // Configure the cell...
    cell.cityNameLabel.text = ((MNTimeZone *)[self.searchedTimeZones objectAtIndex:indexPath.row]).cityName;
    cell.timeZoneLabel.text = ((MNTimeZone *)[self.searchedTimeZones objectAtIndex:indexPath.row]).timeZoneName;
    
    return cell;
}


#pragma mark - UISearchBarDisplayController delegate method

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // 검색 함수 구현해서 source를 구함
    // your method

    // 디스패치로 해결하려 했지만 불안정하다 
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.searchedTimeZones = [MNTimeZoneProcessor getFilteredArrayWithSearchString:searchString fromTimeZoneArray:self.allTimeZones];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchDisplayController.searchResultsTableView reloadData];
        });
    });
     */
    self.searchedTimeZones = [MNTimeZoneProcessor getFilteredArrayWithSearchString:searchString fromTimeZoneArray:self.allTimeZones];
    
    return YES;
}


#pragma mark - UISearchBar delegate method

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {                     // called when text starts editing
//    NSLog(@"searchBarTextDidBeginEditing");

    self.searchDisplayController.searchResultsTableView.hidden = NO;
    [self.searchDisplayController setActive:YES animated:YES];
    
    NSString *searchString = searchBar.text;
    searchBar.text = @""; // 빈칸 넣어줘야 백그라운드로 밀리지 않음
    searchBar.text = searchString;
}

// 검색 결과가 하나뿐일때는 확인 누르면 확정
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (self.searchedTimeZones.count == 1) {
        [self.searchDisplayController setActive:NO animated:YES];
        self.selectedTimeZone = [self.searchedTimeZones objectAtIndex:0];
        self.searchBar.text = self.selectedTimeZone.cityName;
        
        [self doneButtonClicked];
    }
}


#pragma mark - UISegmentedControl target action

- (void)segmentedClicked:(UISegmentedControl *)sender {
//    NSLog(@"segmentedClicked: %d", sender.selectedSegmentIndex);
    if (sender.selectedSegmentIndex == WORLD_CLOCK_TYPE_ANALOG) {
        [UIView animateWithDuration:0.2 animations:^{
            self.isUsing24HoursLabel.alpha = 0;
            self.isUsing24HoursSwitch.alpha = 0;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.isUsing24HoursLabel.alpha = 1;
            self.isUsing24HoursSwitch.alpha = 1;
        }];
    }
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
