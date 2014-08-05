//
//  MNViewController.m
//  MNStoreControllerProj
//
//  Created by Wooseong Kim on 13. 7. 8..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import "MNStoreController.h"
#import <QuartzCore/QuartzCore.h>
#import "MNStoreButtonMaker.h"
#import "MNStoreProductCellMaker.h"
#import "MNEffectSoundPlayer.h"
#import "MNDefinitions.h"
#import "Flurry.h"
#import "MNStoreProductCell.h"

#define NUMBER_OF_FUNCTION_PRODUCT_ITEM 2
#define NUMBER_OF_WIDGET_PRODUCT_ITEM 2
#define NUMBER_OF_THEME_PRODUCT_ITEM 2

#define STORE_PRODUCT_CELL_IDENTIFIER @"StoreProductCell"

#define STORE_DEBUG 0 
//#define STORE_DEBUG 1


@interface MNStoreController ()

@end

@implementation MNStoreController

- (void)viewDidAppear:(BOOL)animated {
//    NSLog(@"viewDidAppear");
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.upgradeToProBuyButton setTransform:CGAffineTransformMakeScale(1.2f, 1.2f)];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            [self.upgradeToProBuyButton setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [self.upgradePriceLabel setTransform:CGAffineTransformMakeScale(1.2f, 1.2f)];
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    [self.upgradePriceLabel setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
                }completion:^(BOOL finished) {
                }];
            }];
        }];
    }];
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
    
    self.isBuying = NO;
    
	// Do any additional setup after loading the view, typically from a nib.
    self.title = MNLocalizedString(@"info_store", @"상점");
    self.view.backgroundColor = UIColorFromHexCode(0x333333);
    
    // 풀버전 초기화
    self.view.backgroundColor = UIColorFromHexCode(0x333333);
    self.upgradeToProBackgroundView.backgroundColor = UIColorFromHexCode(0x333333);
    self.upgradeToProLabel.text = MNLocalizedString(@"store_buy_full_version", nil); // @"Buy a full version!";
    self.upgradeToProDetailLabel.text = MNLocalizedString(@"store_buy_full_version_description", nil);  // @"알람추가, 모든위젯, 모든기능, 모든테마를 사용하실 수 있습니다.";
    self.upgradeToProBuyButton.productID = STORE_PRODUCT_ID_FULL_VERSION;
    [self.upgradeToProBuyButton addTarget:self action:@selector(upgradeToProPriceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.upgradeBackgroundButton.productID = STORE_PRODUCT_ID_FULL_VERSION;
    [self.upgradeBackgroundButton addTarget:self action:@selector(upgradeToProPriceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.upgradePriceLabel.textColor = UIColorFromHexCode(0x00ccff);
    
    // 탭 버튼 초기화
    [self.functionTabButton setTitle:MNLocalizedString(@"store_tab_functions", nil) forState:UIControlStateNormal];
    self.functionTabButton.backgroundColor = UIColorFromHexCode(0x5b5b5b);
    [self.functionTabButton addTarget:self action:@selector(functionTabButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //    self.functionTabButton.titleLabel.text = @"기능";
    
    [self.widgetTabButton setTitle:MNLocalizedString(@"store_tab_widgets", nil) forState:UIControlStateNormal];
    self.widgetTabButton.backgroundColor = UIColorFromHexCode(0x5b5b5b);
    [self.widgetTabButton addTarget:self action:@selector(widgetTabButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.themeTabButton setTitle:MNLocalizedString(@"store_tab_themes", nil) forState:UIControlStateNormal];
    self.themeTabButton.backgroundColor = UIColorFromHexCode(0x5b5b5b);
    [self.themeTabButton addTarget:self action:@selector(themeTabButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // UICollectionView 초기화
    self.productCollectinView.dataSource = self;
    self.productCollectinView.delegate = self;
    self.productCollectinView.allowsMultipleSelection = NO;
    //    self.productCollectinView.layer.masksToBounds = NO;
    self.productCollectinView.clipsToBounds = NO;
    self.productCollectinView.backgroundColor = UIColorFromHexCode(0x333333);
    //    self.productCollectinView.contentSize = CGSizeMake(self.productCollectinView.frame.size.width, self.productCollectinView.frame.size.height+1);
    
    // 오른 네비게이션 바 버튼 초기화
    self.navigationItem.rightBarButtonItem.title = MNLocalizedString(@"done", @"Done");
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
    
    // 초기 화면 세팅 및 선택된 탭 버튼 이미지 씌워주기
    self.currentlySelectedTabIndex = 0;
    [self showSelectedTab];
    
    [self initHUD];
    
    [self refreshUI];
    
    // 개발용 세팅
    if (STORE_DEBUG) {
        self.appStoreToggleButton.alpha = 1;
        self.resetButton.alpha = 1;
        self.isDebugMode = YES;
    }else{
        self.appStoreToggleButton.alpha = 0;
        self.resetButton.alpha = 0;
        self.isDebugMode = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initHUD {
    // HUD 초기화
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:self.hud];
	
	self.hud.dimBackground = YES;
}


#pragma mark - refresh UI

- (void)refreshUI {
    // 풀버전 구매 확인
    if ([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_FULL_VERSION] == YES) {
//        [self.upgradeToProBuyButton setTitle:@"Purchased" forState:UIControlStateNormal];
        //        [MNStoreButtonMaker makeStoreOffButton:self.upgradeToProBuyButton];
        self.upgradePriceLabel.text = MNLocalizedString(@"store_purchased", nil); // @"Purchased";
        self.upgradeBackgroundButton.userInteractionEnabled = NO;
        self.upgradeToProBuyButton.userInteractionEnabled = NO;
    }else{
//        [self.upgradeToProBuyButton setTitle:@"$1.99" forState:UIControlStateNormal];
        //        [MNStoreButtonMaker makeStoreOnButton:self.upgradeToProBuyButton];
        self.upgradePriceLabel.text = @"$1.99";
        self.upgradeBackgroundButton.userInteractionEnabled = YES;
        self.upgradeToProBuyButton.userInteractionEnabled = YES;
    }
    // 기타 아이템 구매 확인은 전체 뷰 리로드만 하면 됨.
    [self.productCollectinView reloadData];
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (self.currentlySelectedTabIndex) {
        case MNStoreTabTypeFunction:
            return NUMBER_OF_FUNCTION_PRODUCT_ITEM;
            
        case MNStoreTabTypeWidget:
            return NUMBER_OF_WIDGET_PRODUCT_ITEM;
            
        case MNStoreTabTypeTheme:
            return NUMBER_OF_THEME_PRODUCT_ITEM;
    }
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MNStoreProductCell *productCell = [collectionView dequeueReusableCellWithReuseIdentifier:STORE_PRODUCT_CELL_IDENTIFIER forIndexPath:indexPath];
    
    // nil이라면 초기화
    //    if (productCell == nil) {
    //        NSLog(@"productCell is nil");
    //
    //        productCell = [[UICollectionViewCell alloc] init];
    //    }
    
    [MNStoreProductCellMaker initProductCell:productCell withTabIndex:self.currentlySelectedTabIndex withRow:indexPath.row
                         withStoreController:self];
    return productCell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"%@", indexPath);
    UICollectionViewCell *productItemCell = [collectionView cellForItemAtIndexPath:indexPath];
    MNStoreProductBuyButton *productBuyButton = (MNStoreProductBuyButton *)[productItemCell viewWithTag:103];
//    NSLog(@"%@", productBuyButton.productID);
    [self productBuyButtonClicked:productBuyButton];
}


#pragma mark - Tab Button Target Methods

- (void)showSelectedTab {
    // 선택된 탭을 제외하고 전부 회색으로 변경
    self.functionTabButton.backgroundColor = UIColorFromHexCode(0x5b5b5b);
    self.widgetTabButton.backgroundColor = UIColorFromHexCode(0x5b5b5b);
    self.themeTabButton.backgroundColor = UIColorFromHexCode(0x5b5b5b);
    
//    CGRect newArrayImageViewFrame = self.arrowImageView.frame;
    
    // 선택된 탭은 해당 아트를 대입
    switch (self.currentlySelectedTabIndex) {
        case MNStoreTabTypeFunction:
//            newArrayImageViewFrame.origin.x = self.functionTabButton.frame.origin.x;
//            self.arrowImageView.frame = newArrayImageViewFrame;
            self.functionTabButton.backgroundColor = UIColorFromHexCode(0x00cfff);

            [self.functionTabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.functionTabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            
//            self.widgetTabButton.titleLabel.textColor = UIColorFromHexCode(0xb3b3b3);
//            self.widgetTabButton.titleLabel.highlightedTextColor = UIColorFromHexCode(0xb3b3b3);
            [self.widgetTabButton setTitleColor:UIColorFromHexCode(0xb3b3b3) forState:UIControlStateNormal];
            [self.widgetTabButton setTitleColor:UIColorFromHexCode(0xb3b3b3) forState:UIControlStateHighlighted];
            
//            self.themeTabButton.titleLabel.textColor = UIColorFromHexCode(0xb3b3b3);
//            self.themeTabButton.titleLabel.highlightedTextColor = UIColorFromHexCode(0xb3b3b3);
            [self.themeTabButton setTitleColor:UIColorFromHexCode(0xb3b3b3) forState:UIControlStateNormal];
            [self.themeTabButton setTitleColor:UIColorFromHexCode(0xb3b3b3) forState:UIControlStateHighlighted];
            //            self.functionTabButton.imageView = nil;
            
            self.dividingBar_func_widget.alpha = 0;
            self.dividingBar_widget_theme.alpha = 1;
            break;
            
        case MNStoreTabTypeWidget:
//            newArrayImageViewFrame.origin.x = self.widgetTabButton.frame.origin.x;
//            self.arrowImageView.frame = newArrayImageViewFrame;
            self.widgetTabButton.backgroundColor = UIColorFromHexCode(0x00cfff);
            
            [self.functionTabButton setTitleColor:UIColorFromHexCode(0xb3b3b3) forState:UIControlStateNormal];
            [self.functionTabButton setTitleColor:UIColorFromHexCode(0xb3b3b3) forState:UIControlStateHighlighted];
            
            [self.widgetTabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.widgetTabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            
            [self.themeTabButton setTitleColor:UIColorFromHexCode(0xb3b3b3) forState:UIControlStateNormal];
            [self.themeTabButton setTitleColor:UIColorFromHexCode(0xb3b3b3) forState:UIControlStateHighlighted];
            
            self.dividingBar_func_widget.alpha = 0;
            self.dividingBar_widget_theme.alpha = 0;
            break;
            
        case MNStoreTabTypeTheme:
//            newArrayImageViewFrame.origin.x = self.themeTabButton.frame.origin.x;
//            self.arrowImageView.frame = newArrayImageViewFrame;
            self.themeTabButton.backgroundColor = UIColorFromHexCode(0x00cfff);
            
            [self.functionTabButton setTitleColor:UIColorFromHexCode(0xb3b3b3) forState:UIControlStateNormal];
            [self.functionTabButton setTitleColor:UIColorFromHexCode(0xb3b3b3) forState:UIControlStateHighlighted];
//            self.functionTabButton.titleLabel.textColor = UIColorFromHexCode(0xb3b3b3);
//            self.functionTabButton.titleLabel.highlightedTextColor = UIColorFromHexCode(0xb3b3b3);

            [self.widgetTabButton setTitleColor:UIColorFromHexCode(0xb3b3b3) forState:UIControlStateNormal];
            [self.widgetTabButton setTitleColor:UIColorFromHexCode(0xb3b3b3) forState:UIControlStateHighlighted];
//            self.widgetTabButton.titleLabel.textColor = UIColorFromHexCode(0xb3b3b3);
//            self.widgetTabButton.titleLabel.highlightedTextColor = UIColorFromHexCode(0xb3b3b3);
            
            [self.themeTabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.themeTabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//            self.themeTabButton.titleLabel.textColor = [UIColor whiteColor];
//            self.themeTabButton.titleLabel.highlightedTextColor = [UIColor whiteColor];
            
            self.dividingBar_func_widget.alpha = 1;
            self.dividingBar_widget_theme.alpha = 0;
            break;
    }
    
    // UICollectionView 리프레시
    [self.productCollectinView reloadData];
}

- (void)functionTabButtonClicked {
    //    NSLog(@"functionButtonClicked");
    
    self.currentlySelectedTabIndex = MNStoreTabTypeFunction;
    [self showSelectedTab];
}

- (void)widgetTabButtonClicked {
    //    NSLog(@"widgetButtonClicked");
    
    self.currentlySelectedTabIndex = MNStoreTabTypeWidget;
    [self showSelectedTab];
}

- (void)themeTabButtonClicked {
    //    NSLog(@"themeButtonClicked");
    
    self.currentlySelectedTabIndex = MNStoreTabTypeTheme;
    [self showSelectedTab];
}


#pragma mark - Upgrade Morning Kit Pro

- (void)upgradeToProPriceButtonClicked {
//    NSLog(@"upgradeToProPriceButtonClicked");
    
    self.isBuying = YES;
    
    if (self.isDebugMode) {
        [self MNStoreManagerBoughtItem:self.upgradeToProBuyButton.productID];
    }else{
        [MNStoreManager buyItemWithItemID:self.upgradeToProBuyButton.productID withDelegate:self];
    }
    
    [self refreshUI];
    [self.hud show:YES];
}


#pragma mark - Buy products

- (void)productBuyButtonClicked:(MNStoreProductBuyButton *)sender {
//    NSLog(@"productBuyButtonClicked");
    //    NSLog(@"productBuyButtonClicked: %@", sender.productID);
    //    NSLog(@"productBuyButtonClicked: %@", [sender valueForKey:@"productID"]);
    
    self.isBuying = YES;
    
    if (self.isDebugMode) {
        [self MNStoreManagerBoughtItem:sender.productID];
    }else{
        [MNStoreManager buyItemWithItemID:sender.productID withDelegate:self];
    }
    [self refreshUI];
    [self.hud show:YES];
}

- (void)restoreButtonClicked:(id)sender {
    
    self.isBuying = YES;
    
    if (self.isDebugMode == NO) {
        [MNStoreManager restorePurchasesWithDelegate:self];
    }
    
    [self refreshUI];
    [self.hud show:YES];
}

#pragma mark - MNStoreManager Delegate Methods

- (void)MNStoreManagerBoughtItem:(NSString *)productID {
    self.isBuying = NO;
    
    // 구입한 아이템 저장
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:productID];
    
    // 포토(세로)를 구매하면 포토(가로)도 구매처리해주기
    if ([productID isEqualToString:STORE_PRODUCT_ID_THEME_PHOTO_PORTRAIT]) {
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
    [self refreshUI];
}

- (void)MNStoreManagerRestoreItems {
    self.isBuying = NO;
    
    NSArray *purchasedItemIDs = [[NSUserDefaults standardUserDefaults] objectForKey:STORE_PURCHASED_ITEM_IDs];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (NSString *productID in purchasedItemIDs) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productID];
        
//        NSLog(@"Restored productID: %@", productID);
        
        // 포토(세로)를 구매하면 포토(가로)도 구매처리해주기
        if ([productID isEqualToString:STORE_PRODUCT_ID_THEME_PHOTO_PORTRAIT]) {
            [userDefaults setBool:YES forKey:STORE_PRODUCT_ID_THEME_PHOTO_LANDSCAPE];
        }
        
        // 풀버전 구매기록이 있다면 모두 구매처리하고 빠져나가기
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
            break;
        }
    }
    [self.hud hide:YES afterDelay:0.5];
    [self refreshUI];
}

- (void)MNStoreManagerFinishTransactions { // 애니메이션 취소용
    self.isBuying = NO;
    [self.hud hide:YES afterDelay:0.5];
    [self refreshUI];
}


#pragma mark - Done(Dismiss)

- (IBAction)doneButtonClicked:(id)sender {
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_SETTING];
    [self.delegate doneButtonClicked];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - DEBUG, Developer mode

- (IBAction)resetButtonClicked:(id)sender {
    // 모든 구매 목록 삭제
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:STORE_PRODUCT_ID_FULL_VERSION];
    [userDefaults removeObjectForKey:STORE_PRODUCT_ID_MORE_ALARM_DECKS];
    [userDefaults removeObjectForKey:STORE_PRODUCT_ID_MORE_MATRIX];
    [userDefaults removeObjectForKey:STORE_PRODUCT_ID_NO_AD];
    [userDefaults removeObjectForKey:STORE_PRODUCT_ID_THEME_PHOTO_LANDSCAPE];
    [userDefaults removeObjectForKey:STORE_PRODUCT_ID_THEME_PHOTO_PORTRAIT];
    [userDefaults removeObjectForKey:STORE_PRODUCT_ID_THEME_SKY_BLUE];
    [userDefaults removeObjectForKey:STORE_PRODUCT_ID_THEME_CLASSIC_WHITE];
    [userDefaults removeObjectForKey:STORE_PRODUCT_ID_UNLOCK_PHOTOS_OF_DEVELOPERS];
    [userDefaults removeObjectForKey:STORE_PRODUCT_ID_WIDGET_DATE_COUNTDOWN];
    [userDefaults removeObjectForKey:STORE_PRODUCT_ID_WIDGET_MEMO];
    [userDefaults removeObjectForKey:STORE_PRODUCT_ID_NO_WIDGET_COVER];
    
    [self refreshUI];
    
    // 리프레시 카운터 0으로 만들어서 다시 20번 리프레시 해야 위젯 커버 풀리게 변경
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"refreshCounter"];
}

- (IBAction)toggleDebugButtonClicked:(id)sender {
    self.isDebugMode = !self.isDebugMode;
    //    NSLog(@"%d", self.isDebugMode);
    
    if (self.isDebugMode) {
        [self.appStoreToggleButton setTitle:@"No App Store" forState:UIControlStateNormal];
    }else{
        [self.appStoreToggleButton setTitle:@"App Store" forState:UIControlStateNormal];
    }
}

@end
