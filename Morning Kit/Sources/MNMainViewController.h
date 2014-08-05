//
//  MNMainViewController.h
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 30..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

// GAD
#import "GADBannerView.h"

#import "MNWidgetWindowView.h"
#import "MNMainAlarmTableView.h"
#import "MNAlarmPreferenceController.h"
#import "MNAlarmScrollItemView.h"
#import "MNAlarmAddItemView.h"
#import "MNWidgetModalControllerFactory.h"
#import "MNConfigureTabBarController.h"
#import "SKDynamicStatusBarLineView.h"

// Theme
#import "SKMirrorSceneryView.h"
#import "SKWaterLilyTheme.h"

// Tutorial
#import "SKTutorialView.h"
#import "SKTutorialView2.h"


@interface MNMainViewController : UIViewController <UITableViewDelegate, MNAlarmPreferenceControllerDelegate, MNMainAlarmTableViewDelegate, MNWidgetViewClickDelegatebyWidgetWindowView, UIAlertViewDelegate, MNAlarmScrollItemViewDelegate, MNWidgetModalViewDelegate, MNAlarmAddItemViewDelegate, SKTutorialViewDelegate, SKTutorialView2Delegate, SKStoreProductViewControllerDelegate>

//// View ////
// for iOS 7.0
@property (strong, nonatomic) SKDynamicStatusBarLineView            *dynamicStatusBarLineView;

// ScrollView
@property (weak, nonatomic) IBOutlet UIScrollView                   *scrollView;
@property (weak, nonatomic) IBOutlet SKMirrorSceneryView            *mirrorSceneryCameraView;
@property (strong, nonatomic) UIImageView                           *photoThemeImageView;
@property (weak, nonatomic) IBOutlet MNWidgetWindowView             *widgetWindowView;
@property (weak, nonatomic) IBOutlet MNMainAlarmTableView           *alarmTableView;

// ButtonView
@property (weak, nonatomic) IBOutlet UIView                         *buttonContainerView;
@property (weak, nonatomic) IBOutlet UIView                         *buttonBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton                       *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton                       *configureButton;

// AdmobView
@property (strong, nonatomic) GADBannerView                         *GADbannerView;
@property (weak, nonatomic) IBOutlet UIView                         *admobView;
/////////////

// Data
@property (strong, atomic)    NSMutableArray                        *alarmList;
@property (strong, atomic)    MNAlarm                               *alarmToNotify;
@property (atomic)            NSInteger                             selectedRow;
@property (strong, nonatomic) NSMutableArray                        *widgetDictionaryArray;

// Songs
@property (strong, nonatomic) MPMusicPlayerController               *musicPlayer;

// Ringtones
@property (strong, nonatomic) AVAudioPlayer                         *ringtonePlayer;

// Rotation
@property (nonatomic)         UIInterfaceOrientation                previousOrientation;

// Tutorial
@property (strong, nonatomic) SKTutorialView                        *tutorialView;
@property (strong, nonatomic) SKTutorialView2                       *tutorialView2;

@property (weak, nonatomic)   MNConfigureTabBarController           *configureTabBarController;

// Design Theme
@property (strong, nonatomic) SKWaterLilyTheme                      *waterLilyTheme;

// 버그 임시 해결
@property (nonatomic)         BOOL                                  viewWillLayoutSubviewsNeedToBeCalled;

- (IBAction)refreshButtonClicked:(id)sender;

// 알람이 있을 경우 appDelegate로 부터 alarmID를 받아 필요한 일 처리
- (void)invokeAlarmWithAlarmID:(int)alarmID;

@end
