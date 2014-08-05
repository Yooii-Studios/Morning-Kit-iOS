//
//  MNConfigureSettingController.m
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 30..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNConfigureSettingController.h"
#import "MNDefinitions.h"
#import "MNLanguage.h"
#import "MNTheme.h"
#import "MNRoundRectedViewMaker.h"
#import "MNEffectSoundPlayer.h"
#import "MNWidgetMatrix.h"
#import "MNConfigureSettingsLanguageController.h"    
#import "MNConfigureTabBarController.h"
#import "MNEffectSound.h"
#import "JLToast.h"

#define TAG "MNConfigureSettingController"

//#define TUTORIAL_DEBUG 1
#define TUTORIAL_DEBUG 0


@interface MNConfigureSettingController ()

@end

@implementation MNConfigureSettingController

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

    // iOS 7 이상이면 네비게이션 탭 변경
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.translucent = NO;
        
        // 타이틀
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeFont : [UIFont fontWithName:@"helvetica-bold" size:iOS7_NAV_TITLE_FONT_SIZE]};
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.delaysContentTouches = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(CONTENT_INSET_TOP, 0, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    NSLog(@"%@ / viewWillAppear", @TAG);
    
    self.title = MNLocalizedString(@"tab_theme", @"세팅");
    
    // 언어 설정 및 테마를 바꿀 경우 바로 적용 되게 만들기
    self.view.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    [self.tableView reloadData];
    
    // 양쪽 버튼도 다국어 처리
    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.leftBarButtonItem.title = MNLocalizedString(@"cancel", "취소");
    self.navigationItem.rightBarButtonItem.title = MNLocalizedString(@"done", "완료");
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.barTintColor = [MNTheme getNavigationBarTintBackgroundColor_iOS7];
        self.navigationController.navigationBar.tintColor = [MNTheme getNavigationTintColor_iOS7];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (TUTORIAL_DEBUG) {
        return 5;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier;
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        // 테마
        case 0: 
            cell = [self makeThemeCell:cell withTableView:tableView];
            break;
            
        // 언어
        case 1: 
            cell = [self makeLanguageCell:cell withTableView:tableView];
            break;
            
            
        // 위젯 배열
        case 2: 
            cell = [self makeWidgetMatrixCell:cell withTableView:tableView];
            break;
            
        // 효과음
        case 3:
            cell = [self makeEffectSoundCell:cell withTableView:tableView];
            break;
            
        case 4:
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            }
            cell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
            cell.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
            
            cell.textLabel.text = @"Reset Tutorial, Need Restart";
            cell.textLabel.backgroundColor = [MNTheme getForwardBackgroundUIColor];
            cell.textLabel.textColor = [MNTheme getMainFontUIColor];
            break;
    }
    
    cell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    // 셀 간 여백 추가
    /*
    UIView *cellSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT, 320, CELL_SEPERATOR_HEIGHT)];
    [cellSeparator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
     UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleWidth];
    [cellSeparator setContentMode:UIViewContentModeTopLeft];
    [cellSeparator setBackgroundColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1]];
    [cell addSubview:cellSeparator];
    */
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT + PADDING_INNER*2;
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor colorWithRed:67.0/255 green:67.0/255 blue:67.0/255 alpha:1];
    
    // 셀 간 여백 추가
    UIView *cellSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT, 320 ,CELL_SEPERATOR_HEIGHT)];
    [cellSeparator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
     UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleWidth];
    [cellSeparator setContentMode:UIViewContentModeTopLeft];
    [cellSeparator setBackgroundColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1]];
    [cell addSubview:cellSeparator];
}
 */

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
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
    
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 튜토리얼 셀이 클릭되면, 튜토리얼 화면 다시 보이게 만들기
    if (TUTORIAL_DEBUG) {
        if (indexPath.row == 4) {
            [MNTheme changeCurrentThemeTo:MNThemeTypeClassicWhite];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:THEME_TUTORIAL_USED];
            [[JLToast makeText:@"You can use tutorial in next launch(need turning off this app)."] show];
        }
    }
}

#pragma mark - Table cells init methods

- (UITableViewCell *)makeThemeCell:(UITableViewCell *)cell withTableView:(UITableView *)tableView{
    cell = [tableView dequeueReusableCellWithIdentifier:@"SettingThemeCell"];
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    UIView *backgroundView = [cell viewWithTag:300];
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:cell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    // 100 타이틀 텍스트 / 101 내용 텍스트
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.text = MNLocalizedString(@"setting_theme_color", "테마");
    titleLabel.textColor = [MNTheme getMainFontUIColor];
    
    // 나중에 테마 저장 구현되면 표시
    UILabel *summaryLabel = (UILabel *)[cell viewWithTag:101];
    summaryLabel.text = [MNTheme getLocalizedThemeNameAtIndex:[MNTheme getIndexFromTheme:[MNTheme getCurrentlySelectedTheme]]];
    summaryLabel.textColor = [MNTheme getWidgetSubFontUIColor];
    
    return cell;
}

- (UITableViewCell *)makeLanguageCell:(UITableViewCell *)cell withTableView:(UITableView *)tableView{
    cell = [tableView dequeueReusableCellWithIdentifier:@"SettingLanguageCell"];
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    // background
    UIView *backgroundView = [cell viewWithTag:300];
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:cell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    // 100 타이틀 텍스트 / 101 내용 텍스트
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    if ([[MNLanguage getCurrentLanguage] isEqualToString:@"en"]) {
        titleLabel.text = MNLocalizedString(@"setting_language", "언어");
    }else{
        titleLabel.text = [NSString stringWithFormat:@"%@ / Language", MNLocalizedString(@"setting_language", "언어")] ;
    }

    titleLabel.textColor = [MNTheme getMainFontUIColor];
    
    // 현재 설정된 언어 코드를 불러와 지역화 처리된 언어로 변환
    NSArray *languageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    UILabel *summaryLabel = (UILabel *)[cell viewWithTag:101];
    summaryLabel.textColor = [MNTheme getWidgetSubFontUIColor];
    summaryLabel.text = [MNLanguage languageStringFromCodeString:[languageArray objectAtIndex:0]];
    
    return cell;
}

- (UITableViewCell *)makeWidgetMatrixCell:(UITableViewCell *)cell withTableView:(UITableView *)tableView{
    cell = [tableView dequeueReusableCellWithIdentifier:@"SettingWidgetMatrixCell"];
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    // background
    UIView *backgroundView = [cell viewWithTag:300];
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:cell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    // 100 타이틀 텍스트 / 101 내용 텍스트
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.text = MNLocalizedString(@"setting_widgettable", "위젯 배열");
    titleLabel.textColor = [MNTheme getMainFontUIColor];
    
    // 나중에 위젯 배열 구현되면 표시
    UILabel *summaryLabel = (UILabel *)[cell viewWithTag:101];
    summaryLabel.textColor = [MNTheme getWidgetSubFontUIColor];
    summaryLabel.text = [MNWidgetMatrix getMatrixStringFromIndex:[MNWidgetMatrix getCurrentMatrixType]];
    
    return cell;
}

- (UITableViewCell *)makeEffectSoundCell:(UITableViewCell *)cell withTableView:(UITableView *)tableView{
    cell = [tableView dequeueReusableCellWithIdentifier:@"SettingEffectSoundCell"];
    //    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    // background
    UIView *backgroundView = [cell viewWithTag:300];
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:cell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    // 100 타이틀 텍스트 / 101 내용 텍스트
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.text = MNLocalizedString(@"setting_effect_sound", "효과음");
    titleLabel.textColor = [MNTheme getMainFontUIColor];
    
    // 나중에 위젯 배열 구현되면 표시
    UILabel *summaryLabel = (UILabel *)[cell viewWithTag:101];
    summaryLabel.textColor = [MNTheme getWidgetSubFontUIColor];
    summaryLabel.text = [MNEffectSound getMNEffectSoundFromIndex:[MNEffectSound getCurrentEffectSoundStatus]];
    
    return cell;
}


#pragma mark - prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"configureLanguageSegue"]){
        // delegate 넣어주기
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MNConfigureSettingsLanguageController *configureLanguageController = segue.destinationViewController;
            configureLanguageController.MNDelegate = (MNConfigureTabBarController *)self.tabBarController;
        });
    }
}

#pragma mark - navigation button methods

- (IBAction)cancelButtonClicked:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [MNTheme setThemeForMain];
    });
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_SETTING];
    
    // 변경 사항을 취소
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [MNTheme changeCurrentThemeTo:[MNTheme getArchivedOriginalThemeType]];
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonClicked:(id)sender {
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_SETTING];
    [self.delegate doneButtonClicked];
    
    // 변경 사항 그대로 감
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [MNTheme archiveCurrentTheme:[MNTheme getCurrentlySelectedTheme]];
        [MNTheme setThemeForMain];
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
