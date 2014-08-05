//
//  MNConfigureEffectSoundController.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 7. 1..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNConfigureEffectSoundController.h"
#import "MNTheme.h"
#import "MNRoundRectedViewMaker.h"
#import "MNEffectSoundPlayer.h"
#import "MNDefinitions.h"
#import "MNEffectSound.h"

@interface MNConfigureEffectSoundController ()

@end

@implementation MNConfigureEffectSoundController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = MNLocalizedString(@"setting_effect_sound", @"제목");
    
    self.tableView.delaysContentTouches = NO;
    
    self.tableView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    self.tableView.contentInset = UIEdgeInsetsMake(CONTENT_INSET_TOP, 0, 0, 0);
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
    static NSString *CellIdentifier = @"EffectSoundCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];  // forIndexPath:indexPath];
    
    // Configure the cell...
    cell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    UIView *backgroundView = [cell viewWithTag:300];
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:cell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    UILabel *statusLabel = (UILabel *)[cell viewWithTag:100];
    statusLabel.textColor = [MNTheme getMainFontUIColor];
    
    if (indexPath.row+1 == MNEffectSoundStatusOn) {
        statusLabel.text = MNLocalizedString(@"setting_effect_sound_on", @"On");
    }else{
        statusLabel.text = MNLocalizedString(@"setting_effect_sound_off", @"Off");
    }
    
    // 체크 확인, On=1, Off=2
    UIImageView *checkImageView = (UIImageView *)[cell viewWithTag:500];
    checkImageView.image = [UIImage imageNamed:[MNTheme getCheckImageResourceName]];
    if ([MNEffectSound getCurrentEffectSoundStatus] == indexPath.row+1) {
        checkImageView.alpha = 1;
    }else{
        checkImageView.alpha = 0;
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT + PADDING_INNER*2;
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
    
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK_CLOSE];
    
    [MNEffectSound setEffectSoundStatus:indexPath.row+1];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
