//
//  MNExchangeRateCountrySelectWithSearchBarViewController.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 18..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNExchangeRateCountrySelectWithSearchBarViewController.h"
#import "MNExchangeRateCountryLoader.h"
#import "MNExchangeRateCell.h"
#import "MNTheme.h"

@interface MNExchangeRateCountrySelectWithSearchBarViewController ()

@end

@implementation MNExchangeRateCountrySelectWithSearchBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.sources = [[MNExchangeRateCountryLoader countriesArr] mutableCopy];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.\
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.searchBar = [[UISearchBar alloc] initWithFrame:frame];
    self.searchBar.tintColor = [MNTheme getButtonBackgroundUIColor];
    self.searchBar.delegate = self;
    [self.tableView setTableHeaderView:self.searchBar];
    
    [MNTheme sharedTheme].isThemeForConfigure = YES;
    self.tableView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    [self.tableView setSeparatorColor:[MNTheme getForwardBackgroundUIColor]];
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.searchResultsTableView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    self.searchController.searchResultsTableView.separatorColor = [MNTheme getForwardBackgroundUIColor];
    [MNTheme sharedTheme].isThemeForConfigure = NO;
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    
    // iOS7용 서치바를 스테이터스바에 침범하지 않게 하는 코드
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchbar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchDisplayController setActive:YES];
}

#pragma mark - UISearchbarController Delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.searchedCountries = [MNExchangeRateCountryLoader getFilteredArrayWithSearchString:searchString fromTimeZoneArray:self.sources];
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return self.searchedCountries.count;
    else
        return self.sources.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MNExchangeRateCell";
    MNExchangeRateCell *cell = (MNExchangeRateCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MNExchangeRateCell" owner:self options:nil] objectAtIndex:0];
    
    MNExchangeRateCountry *country;// = self.sources[indexPath.row];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
        country = self.searchedCountries[indexPath.row];
    else
        country = self.sources[indexPath.row];
    
    cell.currencyUnitCodeLabel.text = country.currencyUnitCode;
    cell.countryNameLabel.text = country.currencyUnitName;
    cell.flagImageView.image = country.flag;
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    MNExchangeRateCountry *country;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
        country = self.searchedCountries[indexPath.row];
    else
        country = self.sources[indexPath.row];
    
    [self.selectDelegate CountrySelected:country.currencyUnitCode];
}

@end
