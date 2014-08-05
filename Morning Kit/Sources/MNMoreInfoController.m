//
//  MNMoreInfoController.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 8. 12..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNMoreInfoController.h"
#import "MNRoundRectedViewMaker.h"
#import "MNTheme.h"
#import "MNDefinitions.h"
#import "MNStoreController.h"
#import "MNMoreInfoWebController.h"
#import "MNLanguage.h"

#define YOOII_STUDIOS_INDEX 0
#define MORNING_KIT_HELP_INDEX 1
//#define MORNING_LICENSE_INDEX 2
#define RESTORE_PURCHASES_INDEX 2
#define LICENSE_INFO_INDEX 3
#define VERSION_INFO_INDEX 4

@interface MNMoreInfoController ()

@end

@implementation MNMoreInfoController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - init

- (void)initHUD {
    // HUD 초기화
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:self.hud];
	
	self.hud.dimBackground = YES;
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initHUD];
    self.isBuying = NO;
    
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
    self.title = MNLocalizedString(@"more_information", nil);
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
    // MoreInfoLicenseCell
    // MoreInfoVersionCell
    // MoreInfoCell
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case VERSION_INFO_INDEX: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"VersionInfoCell" forIndexPath:indexPath];
            
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
            titleLabel.textColor = [MNTheme getMainFontUIColor];
            
            // 현재 버전 얻어내기
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            titleLabel.text = majorVersion;
            break;
        }
        case LICENSE_INFO_INDEX:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MoreInfoLicenseCell" forIndexPath:indexPath];
            break;
            
        case RESTORE_PURCHASES_INDEX:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MoreInfoRestoreCell" forIndexPath:indexPath];
            break;
            
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MoreInfoCell" forIndexPath:indexPath];
            cell.tag = indexPath.row + 200;
            break;
    }
    cell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    // Configure the cell...
    UIView *backgroundView = [cell viewWithTag:300];
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:cell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.textColor = [MNTheme getMainFontUIColor];
    titleLabel.text = [self titleStringWithIndex:indexPath.row];
    
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

#pragma mark - prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSLog(@"prepareForSegue");
//    NSLog(@"%d", ((UITableViewCell *)sender).tag);

    MNMoreInfoWebController *webController = (MNMoreInfoWebController *)segue.destinationViewController;
    
    switch (((UITableViewCell *)sender).tag) {
        case YOOII_STUDIOS_INDEX + 200: {
            // 사이트 나라별 처리 - 없이 처리하기로
//            NSString *currentLanguage = [MNLanguage getCurrentLanguage];
            webController.urlString = @"http://www.yooiistudios.com";
//            if ([currentLanguage isEqualToString:@"ko"]) {
//                webController.urlString = @"http://www.yooiistudios.com/kr";
//            }else if([currentLanguage isEqualToString:@"ja"]) {
//                webController.urlString = @"http://www.yooiistudios.com/jp";
//            }else if([currentLanguage isEqualToString:@"zh-Hans"]) {
//                webController.urlString = @"http://www.yooiistudios.com/chs";
//            }else if([currentLanguage isEqualToString:@"zh-Hant"]) {
//                webController.urlString = @"http://www.yooiistudios.com/cht";
//            }else{
//                webController.urlString = @"http://www.yooiistudios.com";
//            }
            webController.title = [self titleStringWithIndex:((UITableViewCell *)sender).tag-200];
            break;
        }
        case MORNING_KIT_HELP_INDEX + 200:
            webController.urlString = @"http://www.yooiistudios.com/apps/morning/ios/help.php";
            webController.title = [self titleStringWithIndex:((UITableViewCell *)sender).tag-200];
            break;
            
//        case MORNING_LICENSE_INDEX + 200:
//            webController.urlString = @"http://www.yooiistudios.com/termservice.html";
//            webController.title = [self titleStringWithIndex:((UITableViewCell *)sender).tag-200];
//            break;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"didSelectRow");
//    NSLog(@"%d", indexPath.row);
    
    switch (indexPath.row) {
        case YOOII_STUDIOS_INDEX:
//             [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.yooiistudios.com"]];
            break;
            
        case MORNING_KIT_HELP_INDEX:
//             [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.yooiistudios.com/morning/help.php"]];
            break;
            
//        case MORNING_LICENSE_INDEX:
//             [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.yooiistudios.com/termservice.html"]];
//            break;
            
        case RESTORE_PURCHASES_INDEX:
            // 구매 복원 기능 작동
            // HUD 작동
            self.isBuying = YES;
            [MNStoreManager restorePurchasesWithDelegate:self];
            [self.hud show:YES];
            break;
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (NSString *)titleStringWithIndex:(NSInteger)index {
    switch (index) {
        case YOOII_STUDIOS_INDEX:
            return MNLocalizedString(@"more_information_yooii_studios", nil);
            
        case MORNING_KIT_HELP_INDEX:
            return MNLocalizedString(@"more_information_morning_kit_help", nil);
            
        case VERSION_INFO_INDEX:
            return MNLocalizedString(@"more_information_version_info", nil);
            
//        case MORNING_LICENSE_INDEX:
//            return MNLocalizedString(@"more_information_morning_kit_license", nil);
            
        case RESTORE_PURCHASES_INDEX:
            return MNLocalizedString(@"store_restore_purchases", nil);
            
        case LICENSE_INFO_INDEX:
            return MNLocalizedString(@"more_information_license", nil);
    }
    return nil;
}

#pragma mark - MNStoreManager delegate method

- (void)MNStoreManagerRestoreItems {
    self.isBuying = NO;
    
    NSArray *purchasedItemIDs = [[NSUserDefaults standardUserDefaults] objectForKey:STORE_PURCHASED_ITEM_IDs];
    for (NSString *productID in purchasedItemIDs) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productID];
        
        //        NSLog(@"Restored productID: %@", productID);
        
        // 풀버전 구매기록이 있다면 모두 구매처리하고 빠져나가기
        if ([productID isEqualToString:STORE_PRODUCT_ID_FULL_VERSION]) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:YES forKey:STORE_PRODUCT_ID_MORE_ALARM_DECKS];
            [userDefaults setBool:YES forKey:STORE_PRODUCT_ID_MORE_MATRIX];
            [userDefaults setBool:YES forKey:STORE_PRODUCT_ID_NO_AD];
            [userDefaults setBool:YES forKey:STORE_PRODUCT_ID_THEME_PHOTO_LANDSCAPE];
            [userDefaults setBool:YES forKey:STORE_PRODUCT_ID_THEME_PHOTO_PORTRAIT];
            [userDefaults setBool:YES forKey:STORE_PRODUCT_ID_THEME_SKY_BLUE];
            [userDefaults setBool:YES forKey:STORE_PRODUCT_ID_THEME_CLASSIC_WHITE];
            [userDefaults setBool:YES forKey:STORE_PRODUCT_ID_UNLOCK_PHOTOS_OF_DEVELOPERS];
            [userDefaults setBool:YES forKey:STORE_PRODUCT_ID_WIDGET_DATE_COUNTDOWN];
            [userDefaults setBool:YES forKey:STORE_PRODUCT_ID_WIDGET_MEMO];
            [userDefaults setBool:YES forKey:STORE_PRODUCT_ID_NO_WIDGET_COVER];
            break;
        }
    }
    [self.hud hide:YES afterDelay:0.5];
    //    NSLog(@"restore all items");
}

- (void)MNStoreManagerFinishTransactions { // 애니메이션 취소용
    //    NSLog(@"MNStoreManagerFinishTransactions");
    
    self.isBuying = NO;
    [self.hud hide:YES afterDelay:0.5];
}

@end
