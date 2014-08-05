//
//  MNPhotoThemeDetailController.m
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 16..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNPhotoThemeDetailController.h"
#import "MNPhotoTheme.h"
#import "MNTheme.h"
#import "MNDefinitions.h"
#import "MNRoundRectedViewMaker.h"
#import <QuartzCore/QuartzCore.h>
#import "MNEffectSoundPlayer.h"
#import "MNStoreController.h"
#import "MNUnlockManager.h"

#define IS_PHOTO_THEME_OPEN_FIRST_TIME @"isPhotoThemeOpenForTheFirstTime"

@interface MNPhotoThemeDetailController ()

@end

@implementation MNPhotoThemeDetailController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initThemeStuff
{
    // 테이블뷰 배경
    self.tableView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    // 각 테이블셀 테마 적용
    // portrait
    self.portraitCell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    UIView *portraitBackgroundView = [self.portraitCell viewWithTag:300];
    portraitBackgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:portraitBackgroundView inSuperView:self.portraitCell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    UIImageView *portrait_dividingBar = (UIImageView *)[portraitBackgroundView viewWithTag:105];
    portrait_dividingBar.image = [UIImage imageNamed:[MNTheme getAlarmDividingBarOnResourceName]];
    
    UILabel *portrait_label = (UILabel *)[portraitBackgroundView viewWithTag:101];
    portrait_label.text = MNLocalizedString(@"setting_theme_photo_portrait", @"사진(세로)");
    portrait_label.textColor = [MNTheme getMainFontUIColor];
    
    UIImageView *portrait_locker_imageView = (UIImageView *)[portraitBackgroundView viewWithTag:501];
    portrait_locker_imageView.image = [UIImage imageNamed:[MNTheme getSettingLockerImageResourceName]];

    // landscape
    self.landscapeCell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    self.landscapeCell.contentView.layer.masksToBounds = YES;
    UIView *landscapeBackgroundView = [self.landscapeCell viewWithTag:300];
    landscapeBackgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:landscapeBackgroundView inSuperView:self.landscapeCell.contentView isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    UIImageView *landscape_dividingBar = (UIImageView *)[landscapeBackgroundView viewWithTag:105];
    landscape_dividingBar.image = [UIImage imageNamed:[MNTheme getAlarmDividingBarOnResourceName]];
    
    UILabel *landscape_label = (UILabel *)[landscapeBackgroundView viewWithTag:101];
    landscape_label.text = MNLocalizedString(@"setting_theme_photo_landscape", @"사진(가로)");
    landscape_label.textColor = [MNTheme getMainFontUIColor];
    
    UIImageView *landscape_locker_imageView = (UIImageView *)[landscapeBackgroundView viewWithTag:501];
    landscape_locker_imageView.image = [UIImage imageNamed:[MNTheme getSettingLockerImageResourceName]];
    
    // 이미지뷰 테마 적용
    self.portraitImageView.superview.layer.cornerRadius = ROUNDED_CORNER_RADIUS;
    self.portraitImageView.superview.layer.masksToBounds = YES;
    self.landscapeImageView.superview.layer.cornerRadius = ROUNDED_CORNER_RADIUS;
    self.landscapeImageView.superview.layer.masksToBounds = YES;
    
    // 유료 잠금 -> 무료로 품
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_PHOTO_PORTRAIT] == NO) {
//        self.portraitCell.isCellUnlocked = NO;
//        portraitBackgroundView.backgroundColor = [MNTheme getLockedBackgroundUIColor];
//        portrait_locker_imageView.alpha = 1;
//    }else{
        self.portraitCell.isCellUnlocked = YES;
        portraitBackgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
        portrait_locker_imageView.alpha = 0;
//    }
    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_PHOTO_LANDSCAPE] == NO) {
//        self.landscapeCell.isCellUnlocked = NO;
//        landscapeBackgroundView.backgroundColor = [MNTheme getLockedBackgroundUIColor];
//        landscape_locker_imageView.alpha = 1;
//    }else{
        self.landscapeCell.isCellUnlocked = YES;
        landscapeBackgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
        landscape_locker_imageView.alpha = 0;
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = MNLocalizedString(@"setting_theme_photo", @"title");
    
    self.tableView.delaysContentTouches = NO;
    
    self.tableView.contentInset = UIEdgeInsetsMake(CONTENT_INSET_TOP, 0, 0, 0);
    
    // 테마 설정
    [self initThemeStuff];
    
    // nil 이든 아니든 이미지를 불러와서 설정해주기
    [self.portraitImageView setImage:[MNPhotoTheme getArchivedPortraitImage]];
    [self.landscapeImageView setImage:[MNPhotoTheme getArchivedLandscapeImage]];
    
    // 네비게이션 탭 색깔 적용
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.barTintColor = [MNTheme getNavigationBarTintBackgroundColor_iOS7];
        self.navigationController.navigationBar.tintColor = [MNTheme getNavigationTintColor_iOS7];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.navigationItem.rightBarButtonItem.title = MNLocalizedString(@"done", "완료");
//    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self initThemeStuff];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 백 버튼이 done 버튼을 누른 것과 같은 효과를 낼 수 있게 구현하는 것으로 수정.
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK_CLOSE];
    
    if (self.MNDelegate != nil) {
        [self.MNDelegate photoThemeDetailControllerDidSave:self];
    }
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
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
    
    // 유료 잠금 -> 무료로
//    if (indexPath.row == 0 && [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_PHOTO_PORTRAIT] == NO) {
//        [MNUnlockManager showUnlockControllerWithProductID:STORE_PRODUCT_ID_THEME_PHOTO_PORTRAIT withController:self];
//        [self initThemeStuff];
//        return;
//    }else if (indexPath.row == 1 && [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_THEME_PHOTO_LANDSCAPE] == NO) {
//        [MNUnlockManager showUnlockControllerWithProductID:STORE_PRODUCT_ID_THEME_PHOTO_LANDSCAPE withController:self];
//        [self initThemeStuff];
//        return;
//    }
    
    if (indexPath.row == 0) {
        // Portrait 사진 설정
//        NSLog(@"Portrait 사진 설정");
        self.selectedPhotoCropOrientation = SKPhotoCropOrientationPortrait;
    }else{
        // Landscape 사진 설정
//        NSLog(@"Landscape 사진 설정");
        self.selectedPhotoCropOrientation = SKPhotoCropOrientationLandscape;
    }
    
    // initialize imagePicker
    MNImagePickerController *imagePickerController = [[MNImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.delegate = self;
    //    imagePickerController.allowsEditing = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        [self presentModalViewController:imagePickerController animated:YES];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            imagePickerController.navigationBar.translucent = NO;
        }
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else{
        // in iPad, UIImagePickerController must be presented via UIPopoverController
        // iPad에서의 처리는 좀 더 고민을 해 보기로 한다.
        /*
        CGRect arrow = CGRectMake(180, 920, 0.0f, 0.0f);
        self.imagePopoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        self.imagePopoverController.delegate = self;
        [self.imagePopoverController presentPopoverFromRect:arrow
                                                     inView:self.view
                                   permittedArrowDirections:UIPopoverArrowDirectionDown
                                                   animated:YES];
         */
        
        CGRect arrow = CGRectMake(0, 0, 320, 480);
        self.imagePopoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            imagePickerController.navigationBar.translucent = NO;
            
            // 타이틀
            imagePickerController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor blackColor]};
        }
        
        self.imagePopoverController.delegate = self;
        [self.imagePopoverController presentPopoverFromRect:arrow
                                                     inView:self.view
                                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                                   animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation Item Handler

- (IBAction)doneButtonClicked:(id)sender {
//    NSLog(@"%@/doneButtonClicked", [self class]);
    
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK_CLOSE];
    
    if (self.MNDelegate != nil) {
        [self.MNDelegate photoThemeDetailControllerDidSave:self];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Customized SK Image Picker
    // initialize photoScaleViewController
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"SKPhotoPicker_iPad" bundle:[NSBundle mainBundle]];
    }else{
        storyboard = [UIStoryboard storyboardWithName:@"SKPhotoPicker_iPhone" bundle:[NSBundle mainBundle]];
    }
    SKPhotoScaleCropViewController *photoScaleViewController = [storyboard instantiateViewControllerWithIdentifier:@"SKPhotoScaleViewController"];
    
    photoScaleViewController.originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    photoScaleViewController.SKDelegate = self;
    photoScaleViewController.photoCropOrientation = self.selectedPhotoCropOrientation;
    
    // push controller without navigation bar(initialized in photoScaleViewContoller's viewWillAppear)
    [picker pushViewController:photoScaleViewController animated:YES];
    
    // 첫 실행시 알림 메시지를 띄워주기
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_PHOTO_THEME_OPEN_FIRST_TIME] == NO) {
        [[[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", nil) message:MNLocalizedString(@"photo_theme_first_open_notice", nil) delegate:self cancelButtonTitle:MNLocalizedString(@"ok", nil) otherButtonTitles:nil] show];
    }
}

#pragma mark - UIAlertView Delegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_PHOTO_THEME_OPEN_FIRST_TIME];
}

#pragma mark - SKPhotoScaleViewController delegate method

- (void)SKPhotoScaleCropViewControllerDidCropping:(SKPhotoScaleCropViewController *)photoScaleCropViewController {
//    NSLog(@"SKPhotoScaleCropViewControllerDidCropping");
    
    if (self.selectedPhotoCropOrientation == SKPhotoCropOrientationPortrait) {
        [self.portraitImageView setImage:photoScaleCropViewController.cropedImage];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [MNPhotoTheme archivePortraitImage:photoScaleCropViewController.cropedImage];
        });
    }else{
        [self.landscapeImageView setImage:photoScaleCropViewController.cropedImage];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [MNPhotoTheme archiveLandscapeImage:photoScaleCropViewController.cropedImage];
        });
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.imagePopoverController dismissPopoverAnimated:YES];
    }
    
    // 사진 크롭을 했으면 done 버튼 누른 것과 같은 효과를 내기
    [self doneButtonClicked:nil];
}

@end
