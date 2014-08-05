//
//  MNExchangeRateCountrySelectTableViewController.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 18..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNExchangeRateCountrySelectTableViewController.h"
#import "MNExchangeRateCell.h"
#import "MNExchangeRateCountryLoader.h"
#import "MNTheme.h"

@interface MNExchangeRateCountrySelectTableViewController ()

@end

@implementation MNExchangeRateCountrySelectTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.sources = [[MNExchangeRateCountryLoader mainCountriesArr] mutableCopy];
        [MNTheme sharedTheme].isThemeForConfigure = YES;
        self.tableView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
        [self.tableView setSeparatorColor:[MNTheme getForwardBackgroundUIColor]];
        [MNTheme sharedTheme].isThemeForConfigure = NO;
//        self.sources = [[MNExchangeRateCountryLoader countriesArr] mutableCopy];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sources.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MNExchangeRateCell";
    MNExchangeRateCell *cell = (MNExchangeRateCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MNExchangeRateCell" owner:self options:nil] objectAtIndex:0];
    
    MNExchangeRateCountry *country = self.sources[indexPath.row];
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
    
    [self.selectDelegate CountrySelected:((MNExchangeRateCountry *)self.sources[indexPath.row]).currencyUnitCode];
}

@end
