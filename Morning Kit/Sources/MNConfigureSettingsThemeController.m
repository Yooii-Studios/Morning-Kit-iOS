//
//  MNConfigureSettingsThemeController.m
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 16..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNConfigureSettingsThemeController.h"
#import "MNTheme.h"
#import "MNDefinitions.h"
#import "MNRoundRectedViewMaker.h"
#import "MNEffectSoundPlayer.h"
#import "MNStoreController.h"
#import "MNUnlockManager.h"
#import "MNPhotoThemeDetailController.h"
#import "MNConfigureCell.h"
#import "MNCameraChecker.h"

//#define CAMERA_DEBUG 1
#define CAMERA_DEBUG 0

@interface MNConfigureSettingsThemeController ()

@end

@implementation MNConfigureSettingsThemeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    self.tableView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 만약 기존에 클래식 화이트를 쓰던 사람이 업데이트를 했을 수도 있으므로 구매한 것으로 처리를 해 줘야한다
    if ([MNTheme getCurrentlySelectedTheme] == MNThemeTypeClassicWhite) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:STORE_PRODUCT_ID_THEME_CLASSIC_WHITE];
    }
    
    // 3GS 등등 기기가 카메라를 쓸 수 있는지 체크하자 - 체크는 완료
    [MNCameraChecker isDeviceHasFrontCamera] == YES ? (self.frontCameraOffset = 0) : (self.frontCameraOffset = 1);
    [MNCameraChecker isDeviceHasBackCamera] == YES ? (self.backCameraOffset = 0) : (self.backCameraOffset = 1);
    if (CAMERA_DEBUG) {
        self.frontCameraOffset = 0;
        self.backCameraOffset = 0;
    }
//    NSLog(@"back camera availability: %@", [MNCameraChecker isDeviceHasBackCamera] == YES ? @"Yes" : @"No");
//    NSLog(@"front camera availability: %@", [MNCameraChecker isDeviceHasFrontCamera] == YES ? @"Yes" : @"No");
    
    // 테스트: 전/후방 카메라 각각의 경우에 테스트
    // 후방/전방 카메라만 있을 경우는 문제없음, 둘다 없을 경우가 문제
//    self.frontCameraOffset = 0;
//    self.backCameraOffset = 0;
    
	// Do any additional setup after loading the view.
    self.title = MNLocalizedString(@"setting_theme_color", @"제목");
    
    self.tableView.delaysContentTouches = NO;
    
    self.view.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
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
    return 7 - self.frontCameraOffset - self.backCameraOffset;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    MNConfigureCell *cell;
    
    // iOS5 에서는 아래의 함수를 사용할 수 없음!! 무조건 indexPath 부분을 빼 줘야 한다!
    //        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // 카메라 여부를 체크함
//    if (indexPath.row != (MNThemeTypePhoto - self.frontCameraOffset - self.backCameraOffset)) {
    if (indexPath.row != ([MNTheme getIndexFromTheme:MNThemeTypePhoto] - self.frontCameraOffset - self.backCameraOffset)) {
        CellIdentifier = @"ThemeCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *backgroundView = [cell viewWithTag:300];
        backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
        cell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
        [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:cell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
        
        UILabel *themeLabel = (UILabel *)[cell viewWithTag:101];
        themeLabel.textColor = [MNTheme getMainFontUIColor];
        
        if (indexPath.row == 0) {
            [themeLabel setText:[MNTheme getLocalizedThemeNameAtIndex:indexPath.row]];
        }else{
            [themeLabel setText:[MNTheme getLocalizedThemeNameAtIndex:indexPath.row + self.frontCameraOffset + self.backCameraOffset]];
        }
        
        // 잠김 표시
        UIImageView *lockImageView = (UIImageView *)[cell viewWithTag:501];
        lockImageView.image = [UIImage imageNamed:[MNTheme getSettingLockerImageResourceName]];
        
        // 스카이 블루 테마는 유료 잠금 확인
//        if (indexPath.row == (MNThemeTypeSkyBlue - self.frontCameraOffset - self.backCameraOffset) && [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_SKY_BLUE] == NO) {
        if (indexPath.row == ([MNTheme getIndexFromTheme:MNThemeTypeSkyBlue] - self.frontCameraOffset - self.backCameraOffset) && [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_SKY_BLUE] == NO) {
            cell.isCellUnlocked = NO;
            backgroundView.backgroundColor = [MNTheme getLockedBackgroundUIColor];
            lockImageView.alpha = 1;
        }
        // 클래식 화이트 테마도 확인 필요
//        else if(indexPath.row == (MNThemeTypeClassicWhite - self.frontCameraOffset - self.backCameraOffset) && [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_CLASSIC_WHITE] == NO) {
        else if(indexPath.row == ([MNTheme getIndexFromTheme:MNThemeTypeClassicWhite] - self.frontCameraOffset - self.backCameraOffset) && [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_CLASSIC_WHITE] == NO) {
            cell.isCellUnlocked = NO;
            backgroundView.backgroundColor = [MNTheme getLockedBackgroundUIColor];
            lockImageView.alpha = 1;
        }else{
            cell.isCellUnlocked = YES;
            backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
            lockImageView.alpha = 0;
        }
    }else{
        // 사진 셀은 전용 셀을 사용한다.
        CellIdentifier = @"ThemeCell_Photo";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UIView *backgroundView = [cell viewWithTag:300];
        backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
        cell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
        
        [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:cell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
        
        UILabel *themeLabel = (UILabel *)[cell viewWithTag:101];
        themeLabel.textColor = [MNTheme getMainFontUIColor];
        
        [themeLabel setText:[MNTheme getLocalizedThemeNameAtIndex:indexPath.row + self.frontCameraOffset + self.backCameraOffset]];

        // 잠김 표시 - 취소, 무료로 사용가능하게 변경
        UIImageView *lockImageView = (UIImageView *)[cell viewWithTag:501];
        lockImageView.image = [UIImage imageNamed:[MNTheme getSettingLockerImageResourceName]];
        
        // 사진 유료 잠금 확인 둘 중 하나만 풀렸어도 사용하게 해 준다.
//        if (([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_PHOTO_PORTRAIT] || [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_PHOTO_LANDSCAPE]) == NO) {
//            cell.isCellUnlocked = NO;
//            backgroundView.backgroundColor = [MNTheme getLockedBackgroundUIColor];
//            lockImageView.alpha = 1;
//        }else{
            cell.isCellUnlocked = YES;
            backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
            lockImageView.alpha = 0;
//        }
    }
    
    // 체크 확인
    UIImageView *checkImageView = (UIImageView *)[cell viewWithTag:500];
    checkImageView.image = [UIImage imageNamed:[MNTheme getCheckImageResourceName]];
    
    if (indexPath.row == 0) {
        
        // 첫번째 테마가 더이상 사진 테마가 아니기에 아래 로직이 필요없을듯
        if (0 == [MNTheme getIndexFromTheme:[MNTheme getCurrentlySelectedTheme]]) {
            checkImageView.alpha = 1;
        }else{
            checkImageView.alpha = 0;
        }
     
//         // 둘다 없다면
//         if (self.backCameraOffset == 1 && self.frontCameraOffset == 1) {
//            NSLog(@"%d", [MNTheme getIndexFromTheme:[MNTheme getCurrentlySelectedTheme]]);
//            NSLog(@"%d", [MNTheme getIndexFromTheme:[MNTheme getThemeFromIndex:(indexPath.row + self.frontCameraOffset + self.backCameraOffset)]]);
//            if ([MNTheme getIndexFromTheme:[MNTheme getCurrentlySelectedTheme]] == [MNTheme getIndexFromTheme:[MNTheme getThemeFromIndex:(indexPath.row + self.frontCameraOffset + self.backCameraOffset)]]) {
//         //            if ([MNTheme getCurrentlySelectedTheme] == indexPath.row + self.frontCameraOffset + self.backCameraOffset) {
//            checkImageView.alpha = 1;
//         }else{
//            checkImageView.alpha = 0;
//         }
//    }else{
//         if ([MNTheme getIndexFromTheme:[MNTheme getCurrentlySelectedTheme]] == indexPath.row + self.backCameraOffset) {
//         //            if ([MNTheme getCurrentlySelectedTheme] == indexPath.row + self.backCameraOffset) {
//            checkImageView.alpha = 1;
//         }else{
//            checkImageView.alpha = 0;
//         }
//     }
     
    }else{
        //        NSLog(@"%d", [MNTheme getIndexFromTheme:[MNTheme getCurrentlySelectedTheme]]);
//        NSLog(@"%d", indexPath.row + self.frontCameraOffset + self.backCameraOffset);
        if ([MNTheme getIndexFromTheme:[MNTheme getCurrentlySelectedTheme]] == indexPath.row + self.frontCameraOffset + self.backCameraOffset) {
            //        if ([MNTheme getCurrentlySelectedTheme] == indexPath.row + self.frontCameraOffset + self.backCameraOffset) {
            checkImageView.alpha = 1;
        }else{
            checkImageView.alpha = 0;
        }
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK_CLOSE];
    
    // 테마 설정 - indexPath.row 와 MNThemeType 을 NSInteger로 통일했기 때문에 단순 타입캐스팅으로 변환가능
//    if ((MNThemeType)indexPath.row != (MNThemeTypePhoto - self.frontCameraOffset - self.backCameraOffset)) {
    if (indexPath.row != ([MNTheme getIndexFromTheme:MNThemeTypePhoto] - self.frontCameraOffset - self.backCameraOffset)) {
        // 스카이 블루 테마는 유료 잠금 확인 - 잠겼다면 unlock 화면 보이기
//        if (indexPath.row == (MNThemeTypeSkyBlue - self.frontCameraOffset - self.backCameraOffset) && [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_SKY_BLUE] == NO) {
        if (indexPath.row == ([MNTheme getIndexFromTheme:MNThemeTypeSkyBlue] - self.frontCameraOffset - self.backCameraOffset) && [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_SKY_BLUE] == NO) {
            [MNUnlockManager showUnlockControllerWithProductID:STORE_PRODUCT_ID_THEME_SKY_BLUE withController:self];
            [self.tableView reloadData];
//        }else if(indexPath.row == (MNThemeTypeClassicWhite - self.frontCameraOffset - self.backCameraOffset) && [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_CLASSIC_WHITE] == NO) {
        }else if(indexPath.row == ([MNTheme getIndexFromTheme:MNThemeTypeClassicWhite] - self.frontCameraOffset - self.backCameraOffset) && [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_CLASSIC_WHITE] == NO) {
            [MNUnlockManager showUnlockControllerWithProductID:STORE_PRODUCT_ID_THEME_CLASSIC_WHITE withController:self];
            [self.tableView reloadData];
        }else{
            if (indexPath.row == 0) {
//                [MNTheme changeCurrentThemeTo:(MNThemeType)indexPath.row];
                [MNTheme changeCurrentThemeTo:[MNTheme getThemeFromIndex:indexPath.row]];
            }else{
                [MNTheme changeCurrentThemeTo:[MNTheme getThemeFromIndex:(indexPath.row + self.frontCameraOffset + self.backCameraOffset)]];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        // 사진 설정하는 화면을 띄움
        // 사진 유료 잠금 확인 둘 중 하나만 풀렸어도 사용하게 해 준다.
        // 취소 - 무료로 사용가능
//        if (([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_PHOTO_PORTRAIT] || [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_PHOTO_LANDSCAPE]) == NO) {
//            [MNUnlockManager showUnlockControllerWithProductID:STORE_PRODUCT_ID_THEME_PHOTO_PORTRAIT withController:self];
//            [self.tableView reloadData];
//        }else{
            UIStoryboard *storyboard;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPad" bundle:[NSBundle mainBundle]];
            }else{
                storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle:[NSBundle mainBundle]];
            }
            MNPhotoThemeDetailController *photoThemeDetailController = [storyboard instantiateViewControllerWithIdentifier:@"MNPhotoThemeDetailController"];
            photoThemeDetailController.MNDelegate = self;
            [MNTheme changeCurrentThemeTo:MNThemeTypePhoto];
            [self.navigationController pushViewController:photoThemeDetailController animated:YES];
//        }
    }
}

/*
#pragma mark - prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"themeController_push_photoDetailController"])
    {
        MNPhotoThemeDetailController *photoThemeDetailController = segue.destinationViewController;
        photoThemeDetailController.MNDelegate = self;
    }
}
 */


#pragma mark - MNPhotoThemeDetailController delegate method

- (void)photoThemeDetailControllerDidSave:(MNPhotoThemeDetailController *)photoThemeDetailController {
    [MNTheme changeCurrentThemeTo:MNThemeTypePhoto];
}

@end
