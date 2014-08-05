//
//  MNConfigureInfoController.m
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 30..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNConfigureInfoController.h"
#import "MNDefinitions.h"
#import "MNTheme.h"
#import "MNRoundRectedViewMaker.h"
#import "MNEffectSoundPlayer.h"
#import "Flurry.h"
#import "MNAppStoreRateManager.h"

#define STORE_INDEX 0
#define RATE_MORNING_KIT_INDEX 2
#define CONNECTOR_INDEX -1
#define LIKE_US_ON_FACEBOOK_INDEX 3

@interface MNConfigureInfoController ()

@end

@implementation MNConfigureInfoController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - init

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // iOS 7 이상이면 네비게이션 탭 변경
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.translucent = NO;
        
        // 타이틀
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeFont : [UIFont fontWithName:@"helvetica-bold" size:iOS7_NAV_TITLE_FONT_SIZE]};
    }
    
    self.tableView.contentInset = UIEdgeInsetsMake(CONTENT_INSET_TOP, 0, 0, 0);
    self.tableView.delaysContentTouches = NO;
    
    // 현재 테마에 맞게 아트 세팅
    [self initThemeStuff];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initThemeColor];
    self.title = MNLocalizedString(@"tab_info", @"인포");
    [self setLocalizedLanguages];
    
    // 양쪽 버튼도 다국어 처리
    self.navigationItem.rightBarButtonItem.title = MNLocalizedString(@"done", "완료");
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
}

- (void)initThemeColor {
    
    // iOS 7 이상이면 네비게이션 탭 변경
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.tintColor = [MNTheme getNavigationTintColor_iOS7];
        self.navigationController.navigationBar.barTintColor = [MNTheme getNavigationBarTintBackgroundColor_iOS7];
    }
    
    self.tableView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    // 각 테이블셀 테마 적용
    // store
    self.storeCell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    UIView *backgroundView = [self.storeCell viewWithTag:300];
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    
//    self.restoreCell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
//    backgroundView = [self.restoreCell viewWithTag:300];
//    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    
    // Rate
    self.rateMorningKitCell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    backgroundView = [self.rateMorningKitCell viewWithTag:300];
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    
    // help
    self.helpCell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    backgroundView = [self.helpCell viewWithTag:300];
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    
    // credit
    self.creditCell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    backgroundView = [self.creditCell viewWithTag:300];
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    
    // Like Us
    self.likeUsOnFaceBookCell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    backgroundView = [self.likeUsOnFaceBookCell viewWithTag:300];
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    
    // moreApps
//    self.moreAppsCell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
//    backgroundView = [self.moreAppsCell viewWithTag:300];
//    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
}

- (void)initThemeStuff {
    // 각 테이블셀 테마 적용
    // store
    UIView *backgroundView = [self.storeCell viewWithTag:300];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:self.storeCell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
//    // restore
//    backgroundView = [self.restoreCell viewWithTag:300];
//    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:self.storeCell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    // Rate
    backgroundView = [self.rateMorningKitCell viewWithTag:300];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:self.rateMorningKitCell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    // help
    backgroundView = [self.helpCell viewWithTag:300];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:self.helpCell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    
    // credit
    backgroundView = [self.creditCell viewWithTag:300];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:self.creditCell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    
    // Like us
    backgroundView = [self.likeUsOnFaceBookCell viewWithTag:300];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:self.creditCell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    // moreApps
//    backgroundView = [self.moreAppsCell viewWithTag:300];
//    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:self.moreAppsCell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:67.0/255 green:67.0/255 blue:67.0/255 alpha:1];
    
    // 셀 간 여백 추가
    UIView *cellSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, ALARM_ITEM_HEIGHT, 320 ,2)];
    [cellSeparator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
     UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleWidth];
    [cellSeparator setContentMode:UIViewContentModeTopLeft];
    [cellSeparator setBackgroundColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1]];
    [cell addSubview:cellSeparator];
}
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        // 스토어
        case STORE_INDEX:  {
            // 스토어 컨트롤러를 호출
            UIStoryboard *storyboard;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                storyboard = [UIStoryboard storyboardWithName:@"IAPStoryboard_iPad" bundle:[NSBundle mainBundle]];
            }else{
                storyboard = [UIStoryboard storyboardWithName:@"IAPStoryboard" bundle:[NSBundle mainBundle]];
            }
            UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"Nav_MNStoreController"];
            //        MNStoreController *storeController = [[UIStoryboard storyboardWithName:@"IAPStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MNStoreController"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary *param = [NSDictionary dictionaryWithObject:@"Info" forKey:@"From"];
                
                [Flurry logEvent:@"Store" withParameters:param];
            });
            
            [self presentViewController:navigationController animated:YES completion:nil];
            break;
        }
            
        case RATE_MORNING_KIT_INDEX:
            [MNAppStoreRateManager presentAppStoreControllerWithMorningKitWithController:self];
            break;
            
        case LIKE_US_ON_FACEBOOK_INDEX:
            // 페이스북 앱이 있으면 무조건 여기서 열린다. 따라서 팬 페이지ID를 알아놓았다가 무조건 여기서 열기
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://profile/652380814790935"]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/652380814790935"]];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/YooiiMooii"]];
            }
            break;
//        case CONNECTOR_INDEX: // 커넥터
//            [CNConnector openConnectorNoTransferFeature:self];
//            break;
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark - navigation button methods

- (IBAction)doneButtonClicked:(id)sender {
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_SETTING];
    [self.delegate doneButtonClicked];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - localization

- (void)setLocalizedLanguages {
    UILabel *storeLabel = (UILabel *)[self.storeCell viewWithTag:100];
    storeLabel.text = MNLocalizedString(@"info_store", @"스토어");
    storeLabel.textColor = [MNTheme getMainFontUIColor];
    
    UILabel *rateLabel = (UILabel *)[self.rateMorningKitCell viewWithTag:100];
    rateLabel.text = MNLocalizedString(@"rate_morning_kit", @"모닝키트 평가하기");
    rateLabel.textColor = [MNTheme getMainFontUIColor];
    
//    UILabel *restoreLabel = (UILabel *)[self.restoreCell viewWithTag:100];
//    restoreLabel.text = MNLocalizedString(@"store_restore_purchases", @"구매 복원");
//    restoreLabel.textColor = [MNTheme getMainFontUIColor];
    
    UILabel *helpLabel = (UILabel *)[self.helpCell viewWithTag:100];
    helpLabel.text = MNLocalizedString(@"more_information", @"더 많은 정보");
    helpLabel.textColor = [MNTheme getMainFontUIColor];
    
    UILabel *creditLabel = (UILabel *)[self.creditCell viewWithTag:100];
    creditLabel.text = MNLocalizedString(@"info_credit", @"크레딧");
    creditLabel.textColor = [MNTheme getMainFontUIColor];
    
    UILabel *likeUsLabel = (UILabel *)[self.likeUsOnFaceBookCell viewWithTag:100];
//    creditLabel.text = MNLocalizedString(@"info_credit", @"크레딧");
    likeUsLabel.text = @"Like us on Facebook";
    likeUsLabel.textColor = [MNTheme getMainFontUIColor];
    
//    UILabel *moreAppsLabel = (UILabel *)[self.moreAppsCell viewWithTag:100];
//    moreAppsLabel.text = MNLocalizedString(@"info_yooii_connector", @"더 많은 앱");
//    moreAppsLabel.textColor = [MNTheme getMainFontUIColor];
}


/*
#pragma mark - OpenYooiiAppMarketDelegate method

- (void)onOpenMarket:(id)sender {
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK];
    
    // 스토어 컨트롤러를 호출
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"IAPStoryboard_iPad" bundle:[NSBundle mainBundle]];
    }else{
        storyboard = [UIStoryboard storyboardWithName:@"IAPStoryboard" bundle:[NSBundle mainBundle]];
    }
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"Nav_MNStoreController"];
    //        MNStoreController *storeController = [[UIStoryboard storyboardWithName:@"IAPStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MNStoreController"];
    [sender presentViewController:navigationController animated:YES completion:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *param = [NSDictionary dictionaryWithObject:@"Connector" forKey:@"From"];
        
        [Flurry logEvent:@"Store" withParameters:param];
    });
}
 */

#pragma mark - SKStoreProductViewController delegate method

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    //    NSLog(@"productViewControllerDidFinish");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
