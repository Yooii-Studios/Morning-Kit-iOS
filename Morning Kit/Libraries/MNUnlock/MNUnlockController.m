//
//  MNUnlockController.m
//  MNStoreControllerProj
//
//  Created by Wooseong Kim on 13. 7. 9..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import "MNUnlockController.h"
#import <QuartzCore/QuartzCore.h>
#import "MNStoreButtonMaker.h"
#import "MNUnlockItemCellMaker.h"
#import "MNUnlockButton.h"
#import "MNUnlockItemCell.h"
#import "MNEffectSoundPlayer.h"
#import "MNDefinitions.h"
#import "MNAppStoreRateManager.h"

#define UNLOCK_TABLE_VIEW_RADIUS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 31 : 15)
#define DESCRIPTION_FONT_SIZE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 15 : 27)

#define UNLOCK_DEBUG 0

@interface MNUnlockController ()

@end

@implementation MNUnlockController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initHUD {
    // HUD 초기화
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.hud.dimBackground = YES;
    [self.view addSubview:self.hud];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//        });
//    });
}

- (void)initTableView {
    // 테이블뷰
    self.unlockItemTableView.dataSource = self;
    self.unlockItemTableView.delegate = self;
    self.unlockItemTableView.backgroundColor = UIColorFromHexCode(0x434343);
    self.unlockItemTableView.layer.cornerRadius = UNLOCK_TABLE_VIEW_RADIUS;
    self.unlockItemTableView.layer.shouldRasterize = YES;
    self.unlockItemTableView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    // 테이블 뒷배경뷰
    //    /*
    self.unlockTableBackgroundView.backgroundColor = UIColorFromHexCode(0x434343);
    self.unlockTableBackgroundView.layer.cornerRadius = UNLOCK_TABLE_VIEW_RADIUS;

    
    // 퍼포먼스 향상법
    //    self.unlockTableBackgroundView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.unlockTableBackgroundView.bounds cornerRadius:UNLOCK_TABLE_VIEW_RADIUS].CGPath;
    self.unlockTableBackgroundView.layer.shouldRasterize = YES;
    self.unlockTableBackgroundView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    //    */
    //    NSLog(@"%@", NSStringFromCGRect(self.unlockTableBackgroundView.layer.bounds));
    //    NSLog(@"%@", NSStringFromCGRect(self.unlockTableBackgroundView.bounds));
    //    NSLog(@"%@", NSStringFromCGRect(self.unlockItemTableView.bounds));
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.unlockTableBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.unlockTableBackgroundView.layer.shadowOpacity = 0.5f;
        self.unlockTableBackgroundView.layer.shadowOffset = CGSizeMake(0, 0);
        self.unlockTableBackgroundView.layer.shadowRadius = 3.0f;
    }
}

- (void)initDescriptionLabel {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 설명 레이블
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:MNLocalizedString(@"unlock_description", nil)]; //@"이 기능을 Unlock하는 다양한 방법이 있습니다. 물론 무료로도 가능합니다."];
        NSInteger fontSize;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            fontSize = DESCRIPTION_FONT_SIZE;
        }else{
            fontSize = DESCRIPTION_FONT_SIZE;
        }
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize] range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
        
        NSRange unlockRange = [attributedString.string rangeOfString:MNLocalizedString(@"unlock_description_highlight", nil)]; // @"Unlock"];
        [attributedString enumerateAttributesInRange:unlockRange options:NSWidthInsensitiveSearch | NSAnchoredSearch | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0x00ccff) range:unlockRange];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.descriptionLabel.attributedText = attributedString;
        });
    });
}

- (void)initInnerShadowLayer {
    if (self.innerShadowLayer) {
        [self.innerShadowLayer removeFromSuperlayer];
        self.innerShadowLayer = nil;
    }
    
    /*
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     self.innerShadowLayer = [[SKInnerShadowLayer alloc] init];
     // 위/아래 그라데이션
     self.innerShadowLayer.colors = (@[ (id)[UIColor clearColor].CGColor,
     (id)[UIColor clearColor].CGColor]);
     
     self.innerShadowLayer.frame = self.unlockTableBackgroundView.frame;
     self.innerShadowLayer.cornerRadius = UNLOCK_TABLE_VIEW_RADIUS;
     
     self.innerShadowLayer.innerShadowOpacity = 0.7f;
     self.innerShadowLayer.innerShadowColor = [UIColor blackColor].CGColor;
     
     self.innerShadowLayer.shouldRasterize = YES;
     self.innerShadowLayer.rasterizationScale = [UIScreen mainScreen].scale;
     
     //	self.innerShadowLayer.borderColor = [MNTheme getForwardBackgroundUIColor].CGColor;
     //    self.innerShadowLayer.borderColor = [UIColor blackColor].CGColor;
     //    self.innerShadowLayer.borderColor = [MNTheme getForwardBackgroundUIColor].CGColor;
     //	self.innerShadowLayer.borderWidth = 1.0f;
     
     // 내가 초기화
     self.innerShadowLayer.innerShadowOffset = CGSizeMake(0, 0);
     
     dispatch_async(dispatch_get_main_queue(), ^{
     [self.view.layer addSublayer:self.innerShadowLayer];
     [self.view setNeedsDisplay];
     });
     });
     */
    
    if (self.innerShadowLayer) {
        [self.innerShadowLayer removeFromSuperlayer];
        self.innerShadowLayer = nil;
    }
    self.innerShadowLayer = [[SKInnerShadowLayer alloc] init];
    // 위/아래 그라데이션
    self.innerShadowLayer.colors = (@[ (id)[UIColor clearColor].CGColor,
                                    (id)[UIColor clearColor].CGColor]);
	
	self.innerShadowLayer.frame = self.unlockTableBackgroundView.frame;
	self.innerShadowLayer.cornerRadius = UNLOCK_TABLE_VIEW_RADIUS;
    
	self.innerShadowLayer.innerShadowOpacity = 0.7f;
	self.innerShadowLayer.innerShadowColor = [UIColor blackColor].CGColor;
    
    self.innerShadowLayer.shouldRasterize = YES;
    self.innerShadowLayer.rasterizationScale = [UIScreen mainScreen].scale;
    
    //	self.innerShadowLayer.borderColor = [MNTheme getForwardBackgroundUIColor].CGColor;
    //    self.innerShadowLayer.borderColor = [UIColor blackColor].CGColor;
    //    self.innerShadowLayer.borderColor = [MNTheme getForwardBackgroundUIColor].CGColor;
    //	self.innerShadowLayer.borderWidth = 1.0f;
    
    // 내가 초기화
    self.innerShadowLayer.innerShadowOffset = CGSizeMake(0, 0);
	
	[self.view.layer addSublayer:self.innerShadowLayer];
}

- (void)checkWhetherNeedShowingUnlockLabel {
    //    NSLog(@"checkWhetherNeedShowingUnlockLabel");
    if (self.needShowUnlockLabel) {
        self.needShowUnlockLabel = NO;
        [self performSelectorOnMainThread:@selector(showUnlockedDescriptionLabel) withObject:nil waitUntilDone:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initInnerShadowLayer];
    
    self.title = MNLocalizedString(@"unlock_notice", nil);
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//
//    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // iOS 7 이상이면 네비게이션 탭 변경
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barTintColor = UIColorFromHexCode(0x252525);
        self.navigationItem.rightBarButtonItem.tintColor = nil;
        
        // 타이틀
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeFont : [UIFont fontWithName:@"helvetica-bold" size:iOS7_NAV_TITLE_FONT_SIZE]};
    }
    
    [self initReachable];
	// Do any additional setup after loading the view.
    
//    NSLog(@"%@", self.productID);
    
    self.view.backgroundColor = UIColorFromHexCode(0x333333);
    
    [self initHUD];
    [self initDescriptionLabel];
    [self initTableView];
    self.needShowUnlockLabel = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkWhetherNeedShowingUnlockLabel) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.navigationItem.rightBarButtonItem.title = MNLocalizedString(@"done", "완료");
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
    
    // 테스트 시 리셋 버튼 보여주기
    if (UNLOCK_DEBUG) {
        self.resetButton.alpha = 1;
    }else{
        self.resetButton.alpha = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Done

- (IBAction)doneButtonClicked:(id)sender {
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK_CLOSE];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Unlock Item Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
    //    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"unlockItemCell";
    MNUnlockItemCell *unlockItemCell;
    
    // Configure the cell...
    if (indexPath.row == MNUnlockTypeUseMorningKit10Times) {
        unlockItemCell = [tableView dequeueReusableCellWithIdentifier:@"unlockItemCell_UseApp"];
    }else{
        unlockItemCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    //    unlockItemCell.clipsToBounds = NO;
    
    [MNUnlockItemCellMaker initUnlockItemCell:unlockItemCell withRow:indexPath.row withUnlockController:self];
    
    return unlockItemCell;
}


#pragma mark - Unlock Item Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self unlockInvokedAtIndex:indexPath.row];
}

#pragma mark - Unlock Button target action method

- (void)unlockInvokedAtIndex:(MNUnlockType)unlockType {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 인터넷 테스트 - 10회 사용만 제외
    if (unlockType != MNUnlockTypeUseMorningKit10Times) {
        if (self.reach.isReachable == NO) {
            [[[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", nil) message:MNLocalizedString(@"no_network_connection", nil) delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
            return;
        }
    }
    
    switch (unlockType) {
        case MNUnlockTypeBuyFullVersion:
            self.isBuying = YES;
            [MNStoreManager buyItemWithItemID:STORE_PRODUCT_ID_FULL_VERSION withDelegate:self];
            [self.hud show:YES];
            break;
            
        case MNUnlockTypeBuyThisItemOnly:
            if (self.productID) {
                self.isBuying = YES;
                [MNStoreManager buyItemWithItemID:self.productID withDelegate:self];
                [self.hud show:YES];
            }else{
//                NSLog(@"Unlock button: productID is nil");
            }
            break;
            
        case MNUnlockTypeReview: {
            [userDefaults setBool:YES forKey:UNLOCK_REVIEW];
            [userDefaults setBool:YES forKey:self.productID];
            
            [MNAppStoreRateManager presentAppStoreControllerWithMorningKitWithController:self];
//            self.needShowUnlockLabel = YES;
            break;
        }
        case MNUnlockTypeConnector:
            [userDefaults setBool:YES forKey:UNLOCK_CONNECTOR];
            [userDefaults setBool:YES forKey:self.productID];
            [self performSelector:@selector(showUnlockedDescriptionLabel) withObject:nil afterDelay:0.5];
            break;
            
        case MNUnlockTypeUseMorningKit10Times:
            [userDefaults setBool:YES forKey:UNLOCK_USE_MORNING_10];
            [userDefaults setBool:YES forKey:self.productID];
            [self performSelector:@selector(showUnlockedDescriptionLabel) withObject:nil afterDelay:0.5];
            break;
            
        case MNUnlockTypeFaceBookLike:
            // 페이스북 앱이 있으면 무조건 여기서 열린다. 따라서 팬 페이지ID를 알아놓았다가 무조건 여기서 열기
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://profile/652380814790935"]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/652380814790935"]];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/YooiiMooii"]];
            }
            [userDefaults setBool:YES forKey:UNLOCK_FACEBOOK_LIKE];
            [userDefaults setBool:YES forKey:self.productID];
            self.needShowUnlockLabel = YES;
            break;
            
        case MNUnlockTypeTwitterFollow:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://twitter.com/YooiiStudios"]];
            [userDefaults setBool:YES forKey:UNLOCK_TWITTER_FOLLOW];
            [userDefaults setBool:YES forKey:self.productID];
            self.needShowUnlockLabel = YES;
            break;
    }
    
    [self.unlockItemTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self.unlockItemTableView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
}

- (void)unlockButtonClicked:(MNUnlockButton *)unlockButton {
    //    NSLog(@"unlockButtonClicked: %d", unlockButton.unlockType);
    
    [self unlockInvokedAtIndex:unlockButton.unlockType];
}

- (void)showUnlockedDescriptionLabel {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *productString = [self getProductIDString];

        // 설명 레이블
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ : %@", productString, MNLocalizedString(@"unlock_unlocked", nil)]];
        NSInteger fontSize;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            fontSize = 19;
        }else{
            fontSize = 35;
        }
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize] range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
        
        NSRange unlockRange = [attributedString.string rangeOfString:productString];
        [attributedString enumerateAttributesInRange:unlockRange options:NSWidthInsensitiveSearch | NSAnchoredSearch | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0x00ccff) range:unlockRange];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
            self.descriptionLabel.attributedText = attributedString;
            
            [UIView animateWithDuration:0.3 delay:0.6 options:UIViewAnimationOptionTransitionNone animations:^{
                [self.descriptionLabel setTransform:CGAffineTransformMakeScale(1.2f, 1.2f)];
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                    [self.descriptionLabel setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
                }completion:^(BOOL finished) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }];
        });
    });
}

#pragma mark - MNStoreManager Delegate Methods

- (void)MNStoreManagerBoughtItem:(NSString *)productID {
    self.isBuying = NO;
    
    // 구입한 아이템 저장
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:productID];
    
    // 사진(세로)나 사진(가로) 구매면 나머지 사진 테마를 구매해주기
    if ([productID isEqualToString:STORE_PRODUCT_ID_THEME_PHOTO_PORTRAIT] || [productID isEqualToString:STORE_PRODUCT_ID_THEME_PHOTO_LANDSCAPE]) {
        self.productID = STORE_PRODUCT_ID_THEME_PHOTO;
        [userDefaults setBool:YES forKey:STORE_PRODUCT_ID_THEME_PHOTO_PORTRAIT];
        [userDefaults setBool:YES forKey:STORE_PRODUCT_ID_THEME_PHOTO_LANDSCAPE];
    }
    
    // 풀버전 구매면 모두 다 구매해주기
    if ([productID isEqualToString:STORE_PRODUCT_ID_FULL_VERSION]) {
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
    }
    
    //    [self.hud hide:NO];
    [self.hud hide:YES afterDelay:0.5];
    [self.unlockItemTableView reloadData];
    [self showUnlockedDescriptionLabel];
}

- (void)MNStoreManagerFinishTransactions { // 애니메이션 취소용
    self.isBuying = NO;
    [self.hud hide:YES afterDelay:0.5];
    [self.unlockItemTableView reloadData];
}


#pragma mark - Reset(DEBUG)

- (IBAction)resetButtonClicked:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:STORE_PRODUCT_ID_FULL_VERSION];
    [userDefaults setBool:NO forKey:self.productID];
    
    [userDefaults setBool:NO forKey:UNLOCK_REVIEW];
    [userDefaults setBool:NO forKey:UNLOCK_CONNECTOR];
    [userDefaults setBool:NO forKey:UNLOCK_USE_MORNING_10];
    [userDefaults setBool:NO forKey:UNLOCK_FACEBOOK_LIKE];
    [userDefaults setBool:NO forKey:UNLOCK_TWITTER_FOLLOW];
    
    [self.unlockItemTableView reloadData];
}


#pragma mark - SKStoreProductViewController delegate method

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    //    NSLog(@"productViewControllerDidFinish");
    [self dismissViewControllerAnimated:YES completion:nil];
    self.needShowUnlockLabel = YES;
    [self checkWhetherNeedShowingUnlockLabel];
}

#pragma mark - Product Name

- (NSString *)getProductIDString {
    //    NSLog(@"%@", self.productID);
    
    if ([self.productID isEqualToString:STORE_PRODUCT_ID_MORE_ALARM_DECKS]) {
        return MNLocalizedString(@"store_item_more_alarm_slots", nil); // @"More Alarm Decks";
    }else if([self.productID isEqualToString:STORE_PRODUCT_ID_MORE_MATRIX]) {
        return MNLocalizedString(@"store_item_matrix", nil); // @"More Matrix";
    }else if([self.productID isEqualToString:STORE_PRODUCT_ID_THEME_PHOTO]) {
        return MNLocalizedString(@"setting_theme_photo", nil); // @"Photo";
    }else if([self.productID isEqualToString:STORE_PRODUCT_ID_THEME_PHOTO_PORTRAIT]) {
        return MNLocalizedString(@"setting_theme_photo_portrait", nil); // @"Photo(Portrait)";
    }else if([self.productID isEqualToString:STORE_PRODUCT_ID_THEME_PHOTO_LANDSCAPE]) {
        return MNLocalizedString(@"setting_theme_photo_landscape", nil); // @"Photo(Landscape)";
    }else if([self.productID isEqualToString:STORE_PRODUCT_ID_THEME_SKY_BLUE]) {
        return MNLocalizedString(@"setting_theme_color_skyblue", nil); // @"Skyblue";
    }else if([self.productID isEqualToString:STORE_PRODUCT_ID_THEME_CLASSIC_WHITE]){
        return MNLocalizedString(@"setting_theme_color_classic_white", nil);
    }else if([self.productID isEqualToString:STORE_PRODUCT_ID_WIDGET_DATE_COUNTDOWN]) {
        NSString *dateCountdown = MNLocalizedString(@"date_calculator", nil);
        dateCountdown = [dateCountdown stringByReplacingOccurrencesOfString:@"\n" withString:@" "]; // 영어는 줄 띄우기 없앰
        return dateCountdown; // @"Date Countdown";
    }else if([self.productID isEqualToString:STORE_PRODUCT_ID_WIDGET_MEMO]) {
        return MNLocalizedString(@"memo", nil); // @"Memo";
    }
    return nil;
}

#pragma mark - Reachability Method

- (const void)initReachable
{
    self.reach = [Reachability reachabilityForInternetConnection];
    
    self.reach.reachableBlock = ^(Reachability*reach)
    {
        
    };
    
    self.reach.unreachableBlock = ^(Reachability*reach)
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", nil) message:MNLocalizedString(@"no_network_connection", nil) delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
//        });
    };
    
    // start the notifier which will cause the reachability object to retain itself!
    [self.reach startNotifier];
}

@end
