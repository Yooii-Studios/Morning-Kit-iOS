//
//  MNConfigureSettingsLanguageController.m
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 13..
//  Copyright (c) 2013년 Yooii. All rights reserved.
//

#import "MNConfigureSettingsLanguageController.h"
#import "MNDefinitions.h"
#import "MNAppDelegate.h"
#import "MNLanguage.h"
#import "MNRoundRectedViewMaker.h"
#import "MNTheme.h"
#import "MNEffectSoundPlayer.h"
#import "MNConfigureTabBarController.h"

#define TAG "MNConfigureSettingsLanguageController"

@interface MNConfigureSettingsLanguageController ()

@end

@implementation MNConfigureSettingsLanguageController

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
    
    self.title = MNLocalizedString(@"setting_language", @"title");
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    
    // iOS5 에서는 아래의 함수를 사용할 수 없음!! 무조건 indexPath 부분을 빼 줘야 한다!
    //        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CellIdentifier = @"LanguageCell";

    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    UIView *backgroundView = [cell viewWithTag:300];
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:cell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    UILabel *localizedLanguageLable = (UILabel *)[cell viewWithTag:100];
    localizedLanguageLable.textColor = [MNTheme getMainFontUIColor];
    
    UILabel *englishLanguageLable = (UILabel *)[cell viewWithTag:101];
    englishLanguageLable.textColor = [MNTheme getWidgetSubFontUIColor];
    
//    [self setLanguageTitleLabel:localizedLanguageLable summaryLabel:englishLanguageLable atIndex:indexPath.row];
    [MNLanguage setLocalizedTitleLabel:localizedLanguageLable withSummaryLabel:englishLanguageLable AtIndex:indexPath.row];
    
    // 체크 확인
    UIImageView *checkImageView = (UIImageView *)[cell viewWithTag:500];
    checkImageView.image = [UIImage imageNamed:[MNTheme getCheckImageResourceName]];
    if ([MNLanguage getLanguageIndexFromCodeString:[MNLanguage getCurrentLanguage]] == indexPath.row) {
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

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


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
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK_CLOSE];
    
    // 선택한 인덱스를 기억
    self.selectedIndex = indexPath.row;

    // 언어 설정
    NSString *languageToBeReplaced = [MNLanguage languageCodeStringAtIndex:indexPath.row];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSMutableArray *languages = [userDefaults objectForKey:@"AppleLanguages"];
    NSArray *languages = [NSArray arrayWithObject:languageToBeReplaced];
//    [languages insertObject:languageToBeReplaced atIndex:0];
    [userDefaults setObject:languages forKey:@"AppleLanguages"];

    
    [userDefaults setInteger:indexPath.row forKey:@"languageType"];
    [userDefaults synchronize];
    
//    NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0]);
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    // 클릭하면 앱 재실행을 묻기 - 필요 없어짐
    /*
    UIAlertView *restartAlertView = [[UIAlertView alloc] initWithTitle:@"Morning Kit"
                                                               message:@"Restart?"
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                     otherButtonTitles:@"OK", nil];
    [restartAlertView show];
     */
    
    if (self.MNDelegate) {
        [self.MNDelegate languageDidChanged];
    }
}

- (void)setLanguageTitleLabel:(UILabel *)titleLabel summaryLabel:(UILabel *)summaryLabel atIndex:(int)index {
    switch (index) {
        case 0:
            titleLabel.text = MNLocalizedString(@"setting_language_default_language", @"기본 언어");
            summaryLabel.text = @"Default Language";
            break;
            
        case 1:
            titleLabel.text = MNLocalizedString(@"setting_language_english", @"영어");
            summaryLabel.text = @"English";
            break;
            
        case 2:
            titleLabel.text = MNLocalizedString(@"setting_language_korean", @"한국어");
            summaryLabel.text = @"Korean";
            break;
            
        case 3:
            titleLabel.text = MNLocalizedString(@"setting_language_japanese", @"일본어");
            summaryLabel.text = @"Japanese";
            break;
            
        case 4:
            titleLabel.text = MNLocalizedString(@"setting_language_simplified_chinese", @"중국어(간체)");
            summaryLabel.text = @"Chinese (Simplified)";
            break;
            
        case 5:
            titleLabel.text = MNLocalizedString(@"setting_language_traditional_chinese", @"중국어(번체)");
            summaryLabel.text = @"Chinese (Traditional)";
            break;
            
        case 6:
            titleLabel.text = MNLocalizedString(@"setting_language_russian", "Russian, 러시아어");
            summaryLabel.text = @"Russian";
            break;
    }
}

@end
