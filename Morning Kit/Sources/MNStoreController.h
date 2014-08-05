//
//  MNViewController.h
//  MNStoreControllerProj
//
//  Created by Wooseong Kim on 13. 7. 8..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNStoreProductBuyButton.h"
#import "MNStoreManager.h"
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, MNStoreTabType) {
    MNStoreTabTypeFunction = 0,
    MNStoreTabTypeWidget,
    MNStoreTabTypeTheme,
};

@protocol MNStoreControllerDelegate <NSObject>

- (void)doneButtonClicked;

@end

@interface MNStoreController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, MNStoreManagerDelegate> //, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSInteger currentlySelectedTabIndex;

@property (nonatomic, strong) IBOutlet UIView *upgradeToProBackgroundView;
@property (nonatomic, strong) IBOutlet UIImageView *upgradeToProImageView;
@property (nonatomic, strong) IBOutlet UILabel *upgradeToProLabel;
@property (nonatomic, strong) IBOutlet UILabel *upgradeToProDetailLabel;
@property (nonatomic, strong) IBOutlet UILabel *upgradePriceLabel;
@property (nonatomic, strong) IBOutlet MNStoreProductBuyButton *upgradeToProBuyButton;
@property (nonatomic, strong) IBOutlet MNStoreProductBuyButton *upgradeBackgroundButton;
//@property (nonatomic, strong) IBOutlet UIButton *upgradeToProBuyButton;

@property (nonatomic, strong) IBOutlet UIImageView *dividingBar_func_widget;
@property (nonatomic, strong) IBOutlet UIImageView *dividingBar_widget_theme;
@property (nonatomic, strong) IBOutlet UIButton *functionTabButton;
@property (nonatomic, strong) IBOutlet UIButton *widgetTabButton;
@property (nonatomic, strong) IBOutlet UIButton *themeTabButton;
//@property (nonatomic, strong) IBOutlet UIImageView *arrowImageView;

@property (nonatomic, strong) IBOutlet UICollectionView *productCollectinView;

@property (nonatomic) BOOL isDebugMode;
@property (nonatomic) BOOL isBuying;

@property (strong, nonatomic) MBProgressHUD *hud;

- (IBAction)doneButtonClicked:(id)sender;
- (IBAction)restoreButtonClicked:(id)sender;

@property (strong, nonatomic) id<MNStoreControllerDelegate> delegate;

// 개발용
@property (nonatomic, strong) IBOutlet UIButton *appStoreToggleButton;
@property (nonatomic, strong) IBOutlet UIButton *resetButton;
- (IBAction)resetButtonClicked:(id)sender;
- (IBAction)toggleDebugButtonClicked:(id)sender;

@end
