//
//  MNInfoCreditController.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 5..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNInfoCreditController.h"
#import "MNDefinitions.h"
#import "MNRoundRectedViewMaker.h"
#import "MNTheme.h"
#import "MNEffectSoundPlayer.h"
#import "MNConfigureCell.h"
#import "JLToast.h"

#define NUMBER_OF_ITEMS 16
#define NUMBER_OF_LOCALIAZATION_TEAM_MEMBER 10
#define NUMBER_OF_SPECIAL_THANKS_PEOPLE 10
#define HEIGHT_OF_NAME_LABEL ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 23 : 44) // 레이블 높이 + 패딩을 이 값으로 정해서, 사람이 늘어나도 유연하게 대응할 수 있게 한다.

@interface MNInfoCreditController ()

@end

@implementation MNInfoCreditController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom
        //        NSLog(@"initWithCoder");
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    //    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK_CLOSE];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initThemeColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = MNLocalizedString(@"info_credit", @"크레딧");
    
    self.tableView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    self.tableView.contentInset = UIEdgeInsetsMake(CONTENT_INSET_TOP, 0, 0, 0);
    self.tableView.delaysContentTouches = NO;
    [self initThemeStuff];
    
    //    self.navigationController.delegate = self;
}

- (void)initThemeColor {
    self.tableView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    /*
     // 각 테이블셀 테마 적용
     // stevenKimCell
     self.stevenKimCell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
     UIView *backgroundView = [self.stevenKimCell viewWithTag:300];
     backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
     UILabel *titleLabel = (UILabel *)[backgroundView viewWithTag:101];
     titleLabel.textColor = [MNTheme getSubFontUIColor];
     UILabel *nameLabel = (UILabel *)[backgroundView viewWithTag:102];
     nameLabel.textColor = [MNTheme getMainFontUIColor];
     
     // brianBaeCell
     self.brianBaeCell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
     backgroundView = [self.brianBaeCell viewWithTag:300];
     backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
     titleLabel = (UILabel *)[backgroundView viewWithTag:101];
     titleLabel.textColor = [MNTheme getSubFontUIColor];
     nameLabel = (UILabel *)[backgroundView viewWithTag:102];
     nameLabel.textColor = [MNTheme getMainFontUIColor];
     
     // davidKwakCell
     self.davidKwakCell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
     backgroundView = [self.davidKwakCell viewWithTag:300];
     backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
     titleLabel = (UILabel *)[backgroundView viewWithTag:101];
     titleLabel.textColor = [MNTheme getSubFontUIColor];
     nameLabel = (UILabel *)[backgroundView viewWithTag:102];
     nameLabel.textColor = [MNTheme getMainFontUIColor];
     */
}

- (void)initThemeStuff {
    // 각 테이블셀 테마 적용
    // stevenKimCell
    /*
     UIView *backgroundView = [self.stevenKimCell viewWithTag:300];
     [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:self.stevenKimCell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
     
     // brianBaeCell
     backgroundView = [self.brianBaeCell viewWithTag:300];
     [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:self.brianBaeCell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
     
     
     // davidKwakCell
     backgroundView = [self.davidKwakCell viewWithTag:300];
     [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:self.davidKwakCell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
     */
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
    return NUMBER_OF_ITEMS - 1; // 라이센스 삭제
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CreditCell";
    
    MNConfigureCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.contentView.frame= cell.frame;
    cell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    UIView *backgroundView = [cell viewWithTag:300];
    
    // 재사용되었던 multiline label은 삭제
    for (UIView *subView in backgroundView.subviews)
    {
        if (subView.tag/100 == 4)
        {
            [subView removeFromSuperview];
        }
    }
    
    if (indexPath.row == NUMBER_OF_ITEMS - 2) {
        backgroundView.frame = CGRectMake(backgroundView.frame.origin.x, backgroundView.frame.origin.y, backgroundView.frame.size.width, backgroundView.frame.size.height + HEIGHT_OF_NAME_LABEL * (NUMBER_OF_SPECIAL_THANKS_PEOPLE-1));
    }
    
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:cell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    UILabel *titleLabel = (UILabel *)[backgroundView viewWithTag:101];
    titleLabel.textColor = [MNTheme getWidgetSubFontUIColor];
    titleLabel.text = [self getTitleFromIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[backgroundView viewWithTag:102];
    nameLabel.textColor = [MNTheme getMainFontUIColor];
    
    if (indexPath.row == NUMBER_OF_ITEMS - 2) {
        // Special Thanks
        for (NSInteger i=0; i<NUMBER_OF_SPECIAL_THANKS_PEOPLE; i++) {
            if (i == 0) {
                nameLabel.text = [self getSpecialThanksNameFromIndex:i];
            }else{
                UILabel *multiLineLabel = [[UILabel alloc] initWithFrame:nameLabel.frame];
                multiLineLabel.backgroundColor = [UIColor clearColor];
                multiLineLabel.frame = CGRectOffset(multiLineLabel.frame, 0, HEIGHT_OF_NAME_LABEL*i);
                multiLineLabel.font = nameLabel.font;
                multiLineLabel.text = [self getSpecialThanksNameFromIndex:i];
                multiLineLabel.textColor = [MNTheme getMainFontUIColor];
                multiLineLabel.tag = 400 + i;
                [backgroundView addSubview:multiLineLabel];
            }
        }
    }else if (indexPath.row == NUMBER_OF_ITEMS - 3) {
        // Localization
        for (NSInteger i=0; i<NUMBER_OF_LOCALIAZATION_TEAM_MEMBER; i++) {
            if (i == 0) {
                nameLabel.text = [self getLocalizationMemberNameFromIndex:i];
            }else{
                UILabel *multiLineLabel = [[UILabel alloc] initWithFrame:nameLabel.frame];
                multiLineLabel.backgroundColor = [UIColor clearColor];
                multiLineLabel.frame = CGRectOffset(multiLineLabel.frame, 0, HEIGHT_OF_NAME_LABEL*i);
                multiLineLabel.font = nameLabel.font;
                multiLineLabel.text = [self getLocalizationMemberNameFromIndex:i];
                multiLineLabel.textColor = [MNTheme getMainFontUIColor];
                multiLineLabel.tag = 400 + i;
                [backgroundView addSubview:multiLineLabel];
            }
        }
    }else{
        nameLabel.text = [self getNameFromIndex:indexPath.row];
    }
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Special Thanks
    if (indexPath.row == NUMBER_OF_ITEMS-2) {
        return CELL_HEIGHT + PADDING_INNER * 2 + HEIGHT_OF_NAME_LABEL * (NUMBER_OF_SPECIAL_THANKS_PEOPLE-1);
    }
    // Localization Team
    else if(indexPath.row == NUMBER_OF_ITEMS-3){
        return CELL_HEIGHT + PADDING_INNER * 2 + HEIGHT_OF_NAME_LABEL * (NUMBER_OF_LOCALIAZATION_TEAM_MEMBER-1);
    }else{
        return CELL_HEIGHT + PADDING_INNER * 2;
    }
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

/*
 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
 cell.backgroundColor = [UIColor colorWithRed:67.0/255 green:67.0/255 blue:67.0/255 alpha:1];
 
 // 셀 간 여백 추가
 UIView *cellSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320 ,2)];
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 나를 클릭하면
    if (indexPath.row == 1) {
        [[[UIActionSheet alloc] initWithTitle:@"Do you want to use face sensor?\n(only for iPhone)" delegate:self cancelButtonTitle:@"NO" destructiveButtonTitle:nil otherButtonTitles:@"YES", nil] showFromTabBar:self.tabBarController.tabBar]; //:self.view];
//        [[[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", nil) message:@"Do you want to use face sensor? (only for iPhone)" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil] show];
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark - label setter

- (NSString *)getTitleFromIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @"Executive Producer";
        case 1:
            return @"Lead Software Engineer";
        case 2:
            return @"Software Engineer";
        case 3:
            return @"Software Engineer";
        case 4:
            return @"Art Director";
        case 5:
            return @"Main Artist";
        case 6:
            return @"Artist";
        case 7:
            return @"Artist";
        case 8:
            return @"Creative Manager";
        case 9:
            return @"Development Manager";
        case 10:
            return @"Sound Director";
        case 11:
            return @"QA";
        case 12:
            return @"Development Consulting by ";
        case 13:
            return @"Localization";
        case 14:
            return @"Special Thanks to";
    }
    return nil;
}

- (NSString *)getNameFromIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @"Robert Song";
        case 1:
            return @"Steven Kim";
        case 2:
            return @"Brian Bae";
        case 3:
            return @"David Kwak";
        case 4:
            return @"Ted";
        case 5:
            return @"Ga Hyeon Park";
        case 6:
            return @"Jeong Eun Sil";
        case 7:
            return @"Kylie Oh";
        case 8:
            return @"Jasmine Jeongmin Oh";
        case 9:
            return @"Ray Youn";
        case 10:
            return @"Sean Lee";
        case 11:
            return @"Yooii Studios Members";
        case 12:
            return @"PlayFluent";
        case 13:
            return @"Jasmine Jeongmin Oh, Brad Tsao, Chez Kuo, Matt Wang, Taft Love, Angela Choi";
        case 14:
            return @"You :)";
    }
    return nil;
}

- (NSString *)getLocalizationMemberNameFromIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @"Akira Yamada";
        case 1:
            return @"Angela Choi";
        case 2:
            return @"Brad Tsao";
        case 3:
            return @"Chez Kuo";
        case 4:
            return @"Jasmine Jeongmin Oh";
        case 5:
            return @"Jason Piros";
        case 6:
            return @"Lena Zaverukha";
        case 7:
            return @"Matt Wang";
        case 8:
            return @"Taft Love";
        case 9:
            return @"Yu Wang";
    }
    return nil;
}

- (NSString *)getSpecialThanksNameFromIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @"Andrew Ryu";
        case 1:
            return @"HyoSang Lim";
        case 2:
            return @"JongHwa Kim";
        case 3:
            return @"Kevin Cho";
        case 4:
            return @"KwanSoo Choi";
        case 5:
            return @"Lou Hsin";
        case 6:
            return @"Osamu Takahashi";
        case 7:
            return @"SangWon Ko";
        case 8:
            return @"SungMoon Cho";
        case 9:
            return @"The Great Frog Party";
            
    }
    return nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            // YES
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_FACE_SENSOR_USING];
            [[JLToast makeText:@"Face Sensor On"] show];
            break;
            
        case 1:
            // NO
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_FACE_SENSOR_USING];
            [[JLToast makeText:@"Face Sensor Off"] show];
            break;
            
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            // NO
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_FACE_SENSOR_USING];
            [[JLToast makeText:@"Face Sensor Off"] show];
            break;
        
        case 1:
            // YES
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_FACE_SENSOR_USING];
            [[JLToast makeText:@"Face Sensor On"] show];
            break;
            
        default:
            break;
    }
}

@end
