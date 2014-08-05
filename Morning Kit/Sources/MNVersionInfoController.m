//
//  MNVersionInfoController.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 8. 13..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNVersionInfoController.h"
#import "MNTheme.h"
#import "MNRoundRectedViewMaker.h"
#import "MNDefinitions.h"

@interface MNVersionInfoController ()

@end

@implementation MNVersionInfoController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(CONTENT_INSET_TOP, 0, 0, 0);
    self.tableView.delaysContentTouches = NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    self.title = MNLocalizedString(@"more_information_version_info", nil);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VersionInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    // Configure the cell...
    UIView *backgroundView = [cell viewWithTag:300];
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:cell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.textColor = [MNTheme getMainFontUIColor];
    titleLabel.text = [self titleStringWithIndex:indexPath.row];

    UILabel *versionLabel = (UILabel *)[cell viewWithTag:101];
    versionLabel.textColor = [MNTheme getMainFontUIColor];
    versionLabel.text = [self versionStringWithIndex:indexPath.row];
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
}


#pragma mark - Text

- (NSString *)titleStringWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return MNLocalizedString(@"more_information_version_current", nil);
            
        case 1:
            return MNLocalizedString(@"more_information_version_latest", nil);
    }
    return nil;
}

- (NSString *)versionStringWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            // 현재 버전 얻어내기
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            return majorVersion;
        }
        case 1: {
            // 현재 버전 얻어내기 - 일단 이렇게 구현
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            return majorVersion;
        }
    }
    return nil;
}

@end
