//
//  MNConfigureWidgetMatrixController.m
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 13..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNConfigureWidgetMatrixController.h"
#import "MNEffectSoundPlayer.h"
#import "MNRoundRectedViewMaker.h"
#import "MNDefinitions.h"
#import "MNTheme.h"
#import "MNWidgetMatrix.h"
#import "MNUnlockController.h"
#import "MNUnlockManager.h"
#import "MNConfigureCell.h"

@interface MNConfigureWidgetMatrixController ()

@end

@implementation MNConfigureWidgetMatrixController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = MNLocalizedString(@"setting_widgettable", @"제목");
    
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
    static NSString *CellIdentifier = @"WidgetMatrixCell";
    MNConfigureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];  // forIndexPath:indexPath];
    
    // Configure the cell...
    cell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    UIView *backgroundView = [cell viewWithTag:300];
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:cell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    UILabel *matrixLable = (UILabel *)[cell viewWithTag:100];
    matrixLable.textColor = [MNTheme getMainFontUIColor];
    
    switch (indexPath.row) {
        case 0:
            matrixLable.text = [MNWidgetMatrix getMatrixStringFromIndex:2];
            break;
            
        case 1:
            matrixLable.text = [MNWidgetMatrix getMatrixStringFromIndex:1];
            
            // 추가: 2*1은 Unlock 을 체크해서 구매가 되어있지 않다면 잠그기
            // 취소 -> 무료로
//            if ([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_MORE_MATRIX] == NO) {
//                cell.isCellUnlocked = NO;
//                backgroundView.backgroundColor = [MNTheme getLockedBackgroundUIColor];
//            }else{
                cell.isCellUnlocked = YES;
                backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
//            }
            
            break;
    }
    
    // 체크 확인
    UIImageView *checkImageView = (UIImageView *)[cell viewWithTag:500];
    checkImageView.image = [UIImage imageNamed:[MNTheme getCheckImageResourceName]];
    // 2*2 = 2, 2*1 = 1
    if ([MNWidgetMatrix getCurrentMatrixType] == 2-indexPath.row) {
        checkImageView.alpha = 1;
    }else{
        checkImageView.alpha = 0;
    }
    
    // 락 이미지 -> 무료로 품
    UIImageView *lockImageView = (UIImageView *)[cell viewWithTag:501];
    lockImageView.image = [UIImage imageNamed:[MNTheme getSettingLockerImageResourceName]];
    // 2*2 = 2, 2*1 = 1
    if ([MNWidgetMatrix getCurrentMatrixType] == 2-indexPath.row) {
        lockImageView.alpha = 0;
    }else{
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_MORE_MATRIX]) {
            lockImageView.alpha = 0;
//        }else{
//            lockImageView.alpha = 1;
//        }
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
    
    switch (indexPath.row) {
        case 0:
            [MNWidgetMatrix setMatrixType:2];
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
            
        case 1:
            // Unlock 체크 -> 무료로 품
//            if ([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_MORE_MATRIX] == NO) {
//                [MNUnlockManager showUnlockControllerWithProductID:STORE_PRODUCT_ID_MORE_MATRIX withController:self];
//                [self.tableView reloadData];
//            }else{
                [MNWidgetMatrix setMatrixType:1];
                [self.navigationController popToRootViewControllerAnimated:YES];
//            }
            break;
            
        default:
            break;
    }
    
}

@end
