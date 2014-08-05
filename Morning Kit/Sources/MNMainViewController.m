//
//  MNMainViewController.m
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 30..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNMainViewController.h"
#import "MNAlarmListProcessor.h"
#import "MNDefinitions.h"
#import "MNWidgetViewFactory.h"
#import "MNAlarmProcessor.h"
#import "MNWidgetMatrixLoadSaver.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MNAlarmSoundProcessor.h"
#import "MNTheme.h"
#import "MNPhotoTheme.h"
#import "MNHalfRoundedRectMaker.h"
#import "MNEffectSoundPlayer.h"
#import "MNWidgetMatrix.h"
#import "MNLanguage.h"
#import "MNPortraitNavigationController.h"
#import "MNAlarmMessageMaker.h"
#import "MNTranslucentFont.h"
#import "MNUnlockController.h"
#import "MNUnlockManager.h"
#import "MNStoreController.h"
#import "MNConfigureAlarmController.h"
#import "Flurry.h"
#import "JLToast.h"
#import "MNAppStoreRateManager.h"
#import "MNRefreshDateChecker.h"
//#import <ConnectorSDK/CNConnector.h>

//#define PROXIMITY_SENSOR_ON 1
#define PROXIMITY_SENSOR_ON 0

@interface MNMainViewController ()

@end

@implementation MNMainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - init views

- (void)initGADbannerView
{
    // about Google AdMob
    //    self.GADbannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    /* 기존 메인 컨트롤러에 붙이는 것에서 admobView로 붙임
    self.GADbannerView = [[GADBannerView alloc] initWithFrame:
                          CGRectMake(0.0,
                                     self.view.frame.size.height - GAD_SIZE_320x50.height,  // origin이 아래쪽 끝임.
                                     GAD_SIZE_320x50.width,
                                     GAD_SIZE_320x50.height
                                     )];
    */
    self.GADbannerView = [[GADBannerView alloc] initWithFrame:
                          CGRectMake(0.0, 0.0,
                                     GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    self.GADbannerView.adUnitID = ADMOB_KEY;
    self.GADbannerView.rootViewController = self;
    
    // attach to admobView
    [self.admobView addSubview:self.GADbannerView];
    self.admobView.backgroundColor = [UIColor blackColor];
    
    // if Testing
    GADRequest *request = [GADRequest request];
#if TARGET_IPHONE_SIMULATOR
//    request.testing = YES;
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
#endif
    [self.GADbannerView loadRequest:request];
}

- (void)initButtonView {
    // 기존 전부 round 처리하는 메서드
//    self.buttonView.layer.cornerRadius = 8;
    
    // 위쪽만 round 처리
    self.buttonBackgroundView = [MNHalfRoundedRectMaker makeUpperHalfRoundedView:self.buttonBackgroundView];
    
    // 라운드 처리된 백그라운드뷰를 뒤로 보낸다.
    [self.view sendSubviewToBack:self.buttonBackgroundView];
    
    // 이것을 추가하면 클릭시 빛나는 효과도 같힌다.
//    self.buttonView.layer.masksToBounds = NO;
}

- (void)initWidgetWindow {
    self.widgetDictionaryArray = [MNWidgetMatrixLoadSaver loadWidgetMatrix];
    
    [self.widgetWindowView initWithWidgetMatrix:self.widgetDictionaryArray];
    self.widgetWindowView.delegate = self;
//    self.widgetWindowView.backgroundColor = [UIColor redColor];
    
    // 위젯 커버 애니메이션 주기(풀버전이 아닐 경우에만)
    if (self.widgetWindowView.isWidgetCoverOn) {
        [self.widgetWindowView startTwinkleAnimation];
    }
}

- (void)initAlarmListTableView {
//    NSLog(@"%@ / initAlarmListTableView", [self class]);
    
    // Configure에서 설정했을 수도 있기 때문에 viewWillAppear에서 항상 새로 읽어 줌
    self.alarmTableView.alarmList = [MNAlarmListProcessor loadAlarmList];
    
    // UITableView의 초기화를 위해 dataSource와 delegate를 설정
    [self.alarmTableView initWithAlarmList:self.alarmTableView.alarmList withDelegate:self];
    
//    self.alarmTableView.backgroundView.backgroundColor = [UIColor blueColor];
}

- (void)initThemeSetting {
    // 테마 확인
    MNThemeType themeType = [MNTheme getCurrentlySelectedTheme];
    
    if (themeType == MNThemeTypeMirror || themeType == MNThemeTypeScenery) {
        
        // 사진테마 이미지뷰가 남아 있다면 정리
        if (self.photoThemeImageView != nil) {
            [self.photoThemeImageView removeFromSuperview];
            self.photoThemeImageView.image = nil;
            self.photoThemeImageView = nil;
        }
        
        // 시뮬레이터라면 themeType classic으로 변경
#if TARGET_IPHONE_SIMULATOR
//        NSLog(@"Running in Simulator - no app store or giro");
        [MNTheme changeCurrentThemeTo:MNThemeTypeClassicGray];
        [self initThemeSetting]; // 클래식으로 변경하고 한번 더 초기화해줌
#else
//        NSLog(@"Running on the Device");
        if (self.mirrorSceneryCameraView != nil) {
            self.mirrorSceneryCameraView.alpha = 1;
            [self.mirrorSceneryCameraView destroyView];
            if (themeType == MNThemeTypeMirror) {
                self.mirrorSceneryCameraView.isUsingFrontFacingCamera = YES;
            }else{
                self.mirrorSceneryCameraView.isUsingFrontFacingCamera = NO;
            }
            [self.mirrorSceneryCameraView initializeAfterViewDidLoad];
        }
#endif
    }else if(themeType == MNThemeTypePhoto || themeType == MNThemeTypeWaterLily) {
        // 미러뷰가 남아 있다면 정리
        if (self.mirrorSceneryCameraView != nil) {
            [self.mirrorSceneryCameraView destroyView];
            self.mirrorSceneryCameraView.alpha = 0;
        }
        
        // 포토 이미지뷰 세팅
        if (self.photoThemeImageView != nil) {
            [self.photoThemeImageView removeFromSuperview];
            self.photoThemeImageView = nil;
        }
        
        if (themeType == MNThemeTypePhoto) {
            self.photoThemeImageView = [[UIImageView alloc] initWithImage:[MNPhotoTheme getArchivedPortraitImage]];
        }else{
            if (!self.waterLilyTheme) {
                self.waterLilyTheme = [[SKWaterLilyTheme alloc] init];
            }
            self.photoThemeImageView = [[UIImageView alloc] initWithImage:self.waterLilyTheme.portraitWaterLilyImage];
        }
        
//        NSLog(@"%@", NSStringFromCGRect(photoImageView.frame));
        self.photoThemeImageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.photoThemeImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:self.photoThemeImageView];
        [self.view sendSubviewToBack:self.photoThemeImageView];     // 맨 뒤로 보냄
    }else{
        // 특수한 테마가 아닌 Classic, SkyBlue, Cobalt Blue 테마.
        
        // 미러테마 뷰가 남아 있다면 정리
        if (self.mirrorSceneryCameraView != nil) {
            [self.mirrorSceneryCameraView destroyView];
            self.mirrorSceneryCameraView.alpha = 0;
        }
        // 사진테마 이미지뷰가 남아 있다면 정리
        if (self.photoThemeImageView != nil) {
            self.photoThemeImageView.image = nil;
            [self.photoThemeImageView removeFromSuperview];
            self.photoThemeImageView = nil;
        }
    }
    
    // 기본적인 색 변경
    self.scrollView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    self.view.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    // 버튼뷰 색상 변경(반투명, 불투명)
    self.buttonBackgroundView = [MNHalfRoundedRectMaker makeUpperHalfRoundedView:self.buttonBackgroundView];
    
    // 버튼들 테마 적용
    [self.refreshButton setImage:[UIImage imageNamed:[MNTheme getRefreshButtonResourceName]] forState:UIControlStateNormal];
    [self.configureButton setImage:[UIImage imageNamed:[MNTheme getConfigureButtonResourceName]] forState:UIControlStateNormal];
}

- (void)initScrollView {
    self.scrollView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    self.scrollView.delaysContentTouches = NO;
//    self.scrollView.backgroundColor = [UIColor blueColor];
}

- (void)initEffectSounds {
    [MNEffectSoundPlayer initAllEffectSounds];
}

- (void)initFlurry
{
    // Flurry
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // isFullVersion
        NSMutableDictionary *params = [NSMutableDictionary dictionary];        
        BOOL isFullVersion = [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_FULL_VERSION];
        if (isFullVersion)
            [params setObject:@"Full Version" forKey:@"Version"];
        else
            [params setObject:@"Free Version" forKey:@"Version"];
        [Flurry logEvent:@"Morning Launched" withParameters:params];
        
        // Theme
        NSMutableDictionary *params2 = [NSMutableDictionary dictionary];
        [params2 setObject:[MNTheme getCurrentThemeNameForFlurry] forKey:@"ThemeType"];
        [Flurry logEvent:@"Theme" withParameters:params2];
        // Language
        NSMutableDictionary *params3 = [NSMutableDictionary dictionary];
        [params3 setObject:[MNLanguage getCurrentLanguage] forKey:@"Language"];
        [Flurry logEvent:@"Language" withParameters:params3];
        // Alarm
        NSMutableDictionary *params4 = [NSMutableDictionary dictionary];
        self.alarmTableView.alarmList = [MNAlarmListProcessor loadAlarmList];
        [params4 setObject:[NSNumber numberWithInt:self.alarmTableView.alarmList.count] forKey:@"Number of Alarms"];
        [Flurry logEvent:@"Ålaram" withParameters:params4];
        // Widget
        [self.widgetWindowView logEventOnFlurry];
        // Device Version
        [Flurry logEvent:@"Device Info" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:[[UIDevice currentDevice] systemVersion], @"Version", nil]];    });
}

// 얼굴 인식 센서 실행해주기
- (void)initProximitySensor {
    // Enabled monitoring of the sensor
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    if ([UIDevice currentDevice].proximityState == NO) {
//        NSLog(@"The device doesn't have a priximity sensor.");
    }else{
        // Set up an observer for proximity changes
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)
                                                     name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
}

- (void)initDynamicStatusBarLineView {
    self.dynamicStatusBarLineView = [[SKDynamicStatusBarLineView alloc] initWithScrollView:self.scrollView];
}

- (void)showRateMessage {
    UIAlertView *rateMessageView = [[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", nil) message:MNLocalizedString(@"rate_it_contents", nil) delegate:self cancelButtonTitle:MNLocalizedString(@"rate_it_no_thanks", nil) otherButtonTitles:MNLocalizedString(@"rate_it_rate", nil), nil];
    
    rateMessageView.tag = -100;
    [rateMessageView show];
}

- (void)increaseLaunchCount {
    
    // 테스트
//    [userDefaults setBool:NO forKey:MORNING_RATE_IT_MESSAGE_USED];
//    morningLaunchCount = 10;
    
    // 조건 검사
    // 커버가 없는 이후로 변경함.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:STORE_PRODUCT_ID_NO_WIDGET_COVER] && [MNRefreshDateChecker isDateOverThanLimitDate]) {
        NSInteger morningLaunchCount = [userDefaults integerForKey:MORNING_LAUNCH_COUNT];
        morningLaunchCount += 1;
        
        if ((morningLaunchCount == 10 || morningLaunchCount == 40) && [userDefaults boolForKey:MORNING_RATE_IT_MESSAGE_USED] == NO) {
            [self showRateMessage];
            [userDefaults setBool:YES forKey:MORNING_RATE_IT_MESSAGE_USED];
        }
        [userDefaults setInteger:morningLaunchCount forKey:MORNING_LAUNCH_COUNT];
    }
//    NSLog(@"morningLaunchCount: %d", morningLaunchCount);
}


#pragma mark - View Cycle

// didLoad 다음에 willAppear
- (void)viewDidLoad
{
    // 특정 날짜 지나면 바로 커버 벗겨주기(이사님 요청사항)
    [self increaseWidgetCoverRefreshLimit];
    
    // Appearance 수정
    // iOS 7 이상이면 Appearance 수정
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        //        [[UINavigationBar appearance] setTranslucent:NO];
        [[UINavigationBar appearance] setBarTintColor:[MNTheme getNavigationBarTintBackgroundColor_iOS7]];
        [[UIBarButtonItem appearance] setTintColor:[MNTheme getNavigationTintColor_iOS7]];
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeFont : [UIFont fontWithName:@"helvetica-bold" size:iOS7_NAV_TITLE_FONT_SIZE]}];
        
        //        self.navigationController.navigationBar.translucent = NO;
        //        //        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        //
        //        // 타이틀
        //        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeFont : [UIFont fontWithName:@"helvetica-bold" size:iOS7_NAV_TITLE_FONT_SIZE]};
    }
    
//    NSLog(@"viewDidLoad");
    
    // iOS 7에서 제대로 되나 테스트하기 - 제대로 됨. 아래 구문으로 분기 빼올 수 있음
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        [[[UIAlertView alloc] initWithTitle:@"Mornint Kit" message:[NSString stringWithFormat:@"iOS Version: %@, over 7.0", [[UIDevice currentDevice] systemVersion]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    }else{
//        [[[UIAlertView alloc] initWithTitle:@"Mornint Kit" message:[NSString stringWithFormat:@"iOS Version: %@", [[UIDevice currentDevice] systemVersion]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    }
    
    // 언어 체크 - 첫 실행시 기기 언어와 연동해서 설정해줌.
    [MNLanguage checkCurrentLanguage];
    
    // 커넥터에서 체크
//    [CNConnector handOverExecuteDate:[NSDate date]];
    
    [super viewDidLoad];

    [self initGADbannerView];
    [self initWidgetWindow];
    [self initButtonView];
    [self initScrollView];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self initDynamicStatusBarLineView];
        [self.view addSubview:self.dynamicStatusBarLineView];
        [self.view bringSubviewToFront:self.dynamicStatusBarLineView];
    }
    [self initEffectSounds];
    [self increaseLaunchCount];
    
    self.previousOrientation = UIInterfaceOrientationPortrait;
    
    [self checkTutorialIfNeeded];
    
    [self initFlurry];
    
    // 크레딧에서 설정한 값과 폰이어야지만 활성화. 기본은 비활성화로. 
//    if (PROXIMITY_SENSOR_ON) {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_FACE_SENSOR_USING] && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self initProximitySensor];
    }
    
    // 언어 설정 체크
//    NSArray *languageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
//    NSLog(@"%@", [languageArray objectAtIndex:0]);
    
//    [self.widgetWindowView registerClass:[MNWidgetViewSlot class] forCellWithReuseIdentifier:@"WidgetSlot"];
    
    // if Distribute
//    [self.GADbannerView loadRequest:[GADRequest request]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    /*
    // 테마 확인
    MNThemeType themeType = [MNTheme getCurrentlySelectedTheme];
    
    if (themeType == MNThemeTypeMirror || themeType == MNThemeTypeScenery) {
        
        // 사진테마 이미지뷰가 남아 있다면 정리
        if (self.photoThemeImageView != nil) {
            [self.photoThemeImageView removeFromSuperview];
            self.photoThemeImageView.image = nil;
            self.photoThemeImageView = nil;
        }
        
        // 시뮬레이터라면 themeType classic으로 변경
#if TARGET_IPHONE_SIMULATOR
        //        NSLog(@"Running in Simulator - no app store or giro");
        [MNTheme changeCurrentThemeTo:MNThemeTypeClassicGray];
        [self initThemeSetting]; // 클래식으로 변경하고 한번 더 초기화해줌
#else
        //        NSLog(@"Running on the Device");
        if (self.mirrorSceneryCameraView != nil) {
            self.mirrorSceneryCameraView.alpha = 1;
            [self.mirrorSceneryCameraView destroyView];
            if (themeType == MNThemeTypeMirror) {
                self.mirrorSceneryCameraView.isUsingFrontFacingCamera = YES;
            }else{
                self.mirrorSceneryCameraView.isUsingFrontFacingCamera = NO;
            }
            [self.mirrorSceneryCameraView initializeAfterViewDidLoad];
        }
#endif
     */
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    MNThemeType currentThemeType = [MNTheme getCurrentlySelectedTheme];
    if (currentThemeType == MNThemeTypeMirror || currentThemeType == MNThemeTypeScenery || currentThemeType == MNThemeTypePhoto) {
        // 폰트 색에 따라 스테이터스 바 색을 변경
        if([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeBlack) {
            return UIStatusBarStyleDefault;
        }else{
            return UIStatusBarStyleLightContent;
        }
    }else if(currentThemeType == MNThemeTypeClassicGray || currentThemeType == MNThemeTypeSkyBlue) {
        // 흰색 스테이터스 바
        return UIStatusBarStyleLightContent;

    }else{
        // 검정색 스테이터스 바
        return UIStatusBarStyleDefault;
    }
}

// 새로 화면이 보일 때마다 갱신을 해 주기.
- (void)viewWillAppear:(BOOL)animated {
//    NSLog(@"viewWillApper");
    [super viewWillAppear:animated];
    
//    [self setNeedsStatusBarAppearanceUpdate];
    
    self.viewWillLayoutSubviewsNeedToBeCalled = YES;
    
    [self initThemeSetting];
    
    // 알람 테이블 초기화
    [self initAlarmListTableView];
    [self.alarmTableView reloadData];
    
    // 위젯윈도우 리로딩
    [self checkWidgetMatrix];
    [self.widgetWindowView checkWidgetMatrix];
    [self.widgetWindowView initThemeColor];
    if (self.widgetWindowView.isWidgetCoverOn) {
        [self.widgetWindowView refreshWidgetCoverImage];
    }
    [self.widgetWindowView onLanguageChanged];
    
    // 풀버전 구매가 되었다면, 애니메이션 취소해주자. 커버도 모두 벗겨주어야 한다.
    // 처음부터 풀버전 구매가 된 경우와, 앱 켠 상태에서 무료 -> 풀버전 구매하고 다시 돌아올 경우 두 가지가 있다.
    if ([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_NO_WIDGET_COVER] && [MNRefreshDateChecker isDateOverThanLimitDate]) {
        // 1. 중간에 풀버전 구매를 해서 다시 돌아올 경우
        if (self.widgetWindowView.isWidgetCoverOn == YES) {
            
            // 위젯 커버 벗겨주고 모두 리프레시를 해주자
            self.widgetWindowView.isWidgetCoverOn = NO;
            [self.widgetWindowView removeAllWidgetCover];
            [self.widgetWindowView refreshAll];
        }
        // 2. 처음부터 풀버전 구매가 된 경우는 따로 건드릴 필요가 없다.
        
    }else{
        // 위젯 애니메이션이 돌고 있었다면, 멈추고 다시 돌려주자.
        if (self.widgetWindowView.isWidgetCoverOn && self.widgetWindowView.isWidgetWindowDoingCoverAnimation) {
//            [self.widgetWindowView stopTwinkleAnimation];
            [self.widgetWindowView startTwinkleAnimation];
        }
    }
    
    // 스크롤뷰 frame 조정
    [self adjustScrollViewFrame];
    
    // 설정탭에서 빠져나오면 포인터 없애주기
    self.configureTabBarController = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.widgetWindowView.isWidgetCoverOn && self.widgetWindowView.isWidgetWindowDoingCoverAnimation) {
//        [self.widgetWindowView cancelWidgetWindowAnimation];
        [self.widgetWindowView stopTwinkleAnimation];
    }
    
    self.viewWillLayoutSubviewsNeedToBeCalled = NO;
//    [MNWidgetMatrixLoadSaver saveWidgetMatrix:self.widgetDictionaryArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Tutorial

- (void)checkTutorialIfNeeded
{
    // 튜토리얼을 보여주어야 하면 보여주기
    NSNumber *isTutorialAlreadyShown = [[NSUserDefaults standardUserDefaults] objectForKey:THEME_TUTORIAL_USED];
    if (isTutorialAlreadyShown == nil || isTutorialAlreadyShown.boolValue == NO) {
//        NSLog(@"show a tutorial 2");
        // 강제로 status bar 방향을 세로로 만들기
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        
        // 튜토리얼 보여주기
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            // status bar 높이만큼 빼 준다.
            CGRect viewFrame = self.view.bounds;
            viewFrame.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height;
            viewFrame.size.height -= [UIApplication sharedApplication].statusBarFrame.size.height;
            self.tutorialView2 = [[SKTutorialView2 alloc] initWithFrame:viewFrame];
//            self.tutorialView2.backgroundColor = [UIColor redColor];
            
//            self.tutorialView2 = [[SKTutorialView2 alloc] initWithFrame:self.view.bounds];
        }else{
            self.tutorialView2 = [[SKTutorialView2 alloc] initWithFrame:self.view.bounds];
        }
        self.tutorialView2.SKDelegate = self;
        [self.view addSubview:self.tutorialView2];
        [self.view bringSubviewToFront:self.tutorialView2];
    }
}

- (void)SKTutorialView2DelegateDoneTutorial {
//    NSLog(@"show a tutorial 1");
    [self.tutorialView2 removeFromSuperview];
    self.tutorialView2 = nil;
    
    self.tutorialView = [[SKTutorialView alloc] initWithFrame:self.view.bounds];
    self.tutorialView.SKDelegate = self;
    [self.view addSubview:self.tutorialView];
    [self.view bringSubviewToFront:self.tutorialView];
    
    // 2개일 때만 삭제해주면 될듯. 
    if (self.alarmTableView.alarmList.count == 2) {
        [self.alarmTableView.alarmList removeObjectAtIndex:self.alarmTableView.alarmList.count-1];
        [MNAlarmListProcessor saveAlarmList:self.alarmTableView.alarmList];
        [self.alarmTableView reloadData];
    }
    
    // 기획 추가: 일정이 하나도 없다면, 다시 명언 위젯으로 교체해주기.
//    [self.widgetWindowView checkScheduleOfReminderWidgetOnTutorial];
}


#pragma mark - SKTutorialView Delegate method

- (void)SKTutorialViewDelegateDidConfirm:(MNThemeType)themeType {
    // 설정한 대로 현재 테마를 설정해주고 재부팅하기
    [MNTheme changeCurrentThemeTo:themeType];
    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:THEME_TUTORIAL_USED];
    
    [self viewWillAppear:NO];
    
//    [UIViewController attemptRotationToDeviceOrientation];
//    [self viewWillLayoutSubviews];
//    [self viewDidLayoutSubviews];
//    [self shouldAutorotate];
//    [self supportedInterfaceOrientations];
//    [self.view setNeedsDisplay];
    
    self.tutorialView = nil;
    
    // 날씨가 있기 때문에 위젯을 한번 더 로딩해줌
    [self.widgetWindowView refreshAll];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}


#pragma mark - rotation handler method

- (void)viewDidLayoutSubviews {
    
    // 화면이 다시 보일 경우만 적용하고, 화면이 사라질 때는 적용하지 않게 만들기
    if (self.viewWillLayoutSubviewsNeedToBeCalled == NO) {
        return;
    }else{
        self.viewWillLayoutSubviewsNeedToBeCalled = NO;
    }
    
    if ([MNTheme getCurrentlySelectedTheme] == MNThemeTypeMirror || [MNTheme getCurrentlySelectedTheme] == MNThemeTypeScenery) {
        if (self.mirrorSceneryCameraView) {
            [self.mirrorSceneryCameraView adjustLayerFrame];
        }
    }
}

// 회전시 처리는 iOS5, 6 여기서 다 함.
- (void)viewWillLayoutSubviews {
//    NSLog(@"main viewWillLayoutSubviews");
//    NSLog(@"current orientation: %d", self.interfaceOrientation);
    
    // 화면이 다시 보일 경우만 적용하고, 화면이 사라질 때는 적용하지 않게 만들기 
    if (self.viewWillLayoutSubviewsNeedToBeCalled == NO ) { //&& self.previousOrientation == self.interfaceOrientation) {
        // 폰은 PortraitUpsideDown에는 대응하지 않는다. 패드는 다 대응
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && self.interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) ||
            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
            
            // 버튼뷰를 회전 방향에 따라 처리
            [self adjustButtonViewOnOrientation:self.interfaceOrientation];
            
            // 스크롤뷰를 회전 방향에 따라 처리
            [self adjustScrollViewFrame];
        }
        return;
    }else{
//        self.viewWillLayoutSubviewsNeedToBeCalled = NO;
    }

    // 폰은 PortraitUpsideDown에는 대응하지 않는다. 패드는 다 대응
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && self.interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) ||
        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
        
        // 버튼뷰를 회전 방향에 따라 처리
        [self adjustButtonViewOnOrientation:self.interfaceOrientation];

        // 스크롤뷰를 회전 방향에 따라 처리
        [self adjustScrollViewFrame];

        // 각 테마에 따라 회전에 대응
        MNThemeType themeType = [MNTheme getCurrentlySelectedTheme];
//        NSLog(@"Theme Type for configure: %d", [MNTheme sharedTheme].isThemeForConfigure);
        
        if (themeType == MNThemeTypePhoto) {
            // 사진 회전 처리
            self.photoThemeImageView.frame = self.view.bounds;
            if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                [self.photoThemeImageView setImage:[MNPhotoTheme getArchivedPortraitImage]];
            }else{
                [self.photoThemeImageView setImage:[MNPhotoTheme getArchivedLandscapeImage]];
            }
        }else if(themeType == MNThemeTypeWaterLily) {
            self.photoThemeImageView.frame = self.view.bounds;
            if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                [self.photoThemeImageView setImage:self.waterLilyTheme.portraitWaterLilyImage];
            }else{
                [self.photoThemeImageView setImage:self.waterLilyTheme.landscapeWaterLilyImage];
            }
        }else if(themeType == MNThemeTypeMirror || themeType == MNThemeTypeScenery) {
            // 카메라 관련 처리
            // I tested it on iPhone 5, so if you want to get a precise scale, you should test on several devices
//            self.mirrorSceneryCameraView.backgroundColor = [UIColor redColor];
//            [self.mirrorSceneryCameraView layoutSubviews];
//            [self.mirrorSceneryCameraView viewWillRotateToInterfaceOrientation:self.interfaceOrientation withParentView:self.view];
        }

        // 위젯 뷰 조절
        [self.widgetWindowView setFrameOnRotation:self.interfaceOrientation];
        
        // 위젯에 콜백
        [self.widgetWindowView onRotation];
    }
    
    // 화면 전환 변경해주기
    self.previousOrientation = self.interfaceOrientation;
    
//    CGRect bounds = [UIScreen mainScreen].bounds;
//    
//    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
//        
//        
//        self.photoThemeImageView.frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.height, bounds.size.width);
//    }else{
//        self.photoThemeImageView.frame = bounds;
//    }
}


- (void)adjustScrollViewFrame {
//    NSLog(@"adjustScrollViewFrame");
    
    // applicationFrame은 Portrait에서 (320, 460), Landscape에서 (300, 480) size를 반환한다. 동적 프레임 조절에 유리한듯
    float rateOfWidgetMatrix = 0.5 * [MNWidgetMatrix getCurrentMatrixType];
    
    CGRect mainScreenBounds = [UIScreen mainScreen].applicationFrame;
    CGRect newScrollViewFrame = self.scrollView.frame;
    newScrollViewFrame.origin.x = 0;
    newScrollViewFrame.origin.y = 0;
    
    CGRect newWidgetWindowViewFrame = self.widgetWindowView.frame;
    newWidgetWindowViewFrame.origin.x = 0;
    newWidgetWindowViewFrame.origin.y = 0;
    newWidgetWindowViewFrame.size.height = WIDGET_WINDOW_HEIGHT_UNIVERSIAL * rateOfWidgetMatrix ;
    
    if ([MNWidgetMatrix getCurrentMatrixType] == 1) {
        newWidgetWindowViewFrame.size.height += 1;
    }
    
    // 알람 컨턴츠 높이를 구해 scrollView frame 높이를 정하기
    // 알람테이블뷰 content 높이 = '알람 추가 셀' 1개 높이 + '알람 셀'수 * 높이(기본높이에 패딩추가 계산)
    CGRect newAlarmTableViewFrame = self.alarmTableView.frame;
    CGFloat alarmTableViewContentHeight = ((self.alarmTableView.alarmList.count) * (ALARM_ITEM_HEIGHT + PADDING_INNER * 2)) + (ALARM_ITEM_HEIGHT + PADDING_INNER + PADDING_BOUNDARY) * rateOfWidgetMatrix;
    
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        // Portrait 방향에 대한 처리
        // 기존 스크롤뷰 크기는 320 457
        // 사이즈 조정하고, 만약 알람이 스크롤 되지 않을 정도라면 원래 사이즈보다 1 크게 만들어 스크롤 되게 만들기
        
        //// alarmTableView frame ////
//        self.widgetWindowView.backgroundColor = [UIColor redColor];
        newAlarmTableViewFrame.origin.y = newWidgetWindowViewFrame.size.height;
        newAlarmTableViewFrame.size.width = mainScreenBounds.size.width;
        // 계산으로 높이를 동적으로 구하기. 스크린높이(460에서 고정 값을 전부 빼줌)
        
        // 추가: 광고 삭제 구매 확인
        NSInteger GADViewHeight = GAD_VIEW_HEIGHT_UNIVERSIAL;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_NO_AD]) {
            GADViewHeight = 0;
        }
        
        newAlarmTableViewFrame.size.height = mainScreenBounds.size.height - WIDGET_WINDOW_HEIGHT_UNIVERSIAL - BUTTON_VIEW_HEIGHT_PORTRAIT_UNIVERSIAL - GADViewHeight; // 50 = GADView 높이(Portrait)
        
        //// widgetWindowView frame ////
        CGFloat widgetWindowViewHeight = WIDGET_WINDOW_HEIGHT_UNIVERSIAL;   // 아이폰은 세로모드 216 고정. 나중에 아이패드 따로 만들어줌
        newWidgetWindowViewFrame.size.width = mainScreenBounds.size.width;
        
        //// scrollView frame ////
        newScrollViewFrame.size.width = mainScreenBounds.size.width;
        newScrollViewFrame.size.height = mainScreenBounds.size.height - GADViewHeight; // 50 = GADView 높이(Portrait)
        CGFloat scrollViewHeight = newScrollViewFrame.size.height;
        
        // 알람 컨텐츠 높이가 스크롤뷰보다 클 경우
        if (widgetWindowViewHeight + alarmTableViewContentHeight + self.buttonContainerView.frame.size.height > scrollViewHeight) {
            //        NSLog(@"scrollView height < scrollView content height");
            // 전체 스크롤 길이에 최상단 중간 패딩 3을 더해 준다.
            // 변경(2013.04.21): MNRoundRectedViewMaker 도입, contentSize는 딱 두 뷰의 height 만 더하고, 제일 아래쪽에 2픽셀만 높여주면 될듯
            self.scrollView.contentSize = CGSizeMake(mainScreenBounds.size.width,
                                                     widgetWindowViewHeight + alarmTableViewContentHeight + self.buttonContainerView.frame.size.height);
            
            newAlarmTableViewFrame.size.height = alarmTableViewContentHeight;
        }else{
            self.scrollView.contentSize = CGSizeMake(mainScreenBounds.size.width, scrollViewHeight);
        }
    
        // alarmTable
        self.alarmTableView.frame = newAlarmTableViewFrame;
//        NSLog(@"alarmTableView: %@", NSStringFromCGRect(self.alarmTableView.frame));
        self.alarmTableView.alpha = 1;
        
        // widgetWindowView
        self.widgetWindowView.frame = newWidgetWindowViewFrame;
//        NSLog(@"widgetWindowView: %@", NSStringFromCGRect(self.widgetWindowView.frame));
        
        // scrollView
        self.scrollView.frame = newScrollViewFrame;
        self.scrollView.scrollEnabled = YES;
        
    }else{
        // Landscape 방향에 대한 처리

        // 광고 구매 확인
        BOOL isGADBannerViewToBeHide = NO;
        isGADBannerViewToBeHide = [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_NO_AD];
        
        // WidgetWindowView
        newWidgetWindowViewFrame.size.width = mainScreenBounds.size.height;
        if (isGADBannerViewToBeHide) {
            newWidgetWindowViewFrame.size.height = mainScreenBounds.size.width - BUTTON_VIEW_HEIGHT_PORTRAIT_UNIVERSIAL;
        }else{
            newWidgetWindowViewFrame.size.height = mainScreenBounds.size.width - BUTTON_VIEW_HEIGHT_LANDSCAPE_UNIVERSIAL;
        }
        self.widgetWindowView.frame = newWidgetWindowViewFrame;
        
        // AlarmTableView
        newAlarmTableViewFrame.origin.y = newWidgetWindowViewFrame.size.height;
        newAlarmTableViewFrame.size.width = mainScreenBounds.size.height;
        newAlarmTableViewFrame.size.height = alarmTableViewContentHeight;
        self.alarmTableView.frame = newAlarmTableViewFrame;
        self.alarmTableView.alpha = 0;
        
        // ScrollView
        newScrollViewFrame.size.width = mainScreenBounds.size.height;
        if (isGADBannerViewToBeHide) {
            newScrollViewFrame.size.height = mainScreenBounds.size.width - BUTTON_VIEW_HEIGHT_PORTRAIT_UNIVERSIAL;
        }else{
            newScrollViewFrame.size.height = mainScreenBounds.size.width - BUTTON_VIEW_HEIGHT_LANDSCAPE_UNIVERSIAL;
        }

        self.scrollView.frame = newScrollViewFrame;
        self.scrollView.contentSize = newScrollViewFrame.size;
        self.scrollView.scrollEnabled = NO;
    }
//    NSLog(@"reload alarmTable");
    // 위젯 커버가 없을 때는 기존과 같이 무조건 이것을 실행해야 한다. 커버가 있을 때만 만약 (뷰가 새로 읽어져야 할 필요가 있을때만 reloadData를 한다)를 체크할 것
    // 이렇게 하니까 앱이 켜진 상태에서 위젯 커버를 벗기니 화이트 색이 나옴. 그냥 뷰가 읽어져야 할 필요가 있는가만 확인. 
//    if (self.widgetWindowView.isWidgetCoverOn == NO || self.viewWillLayoutSubviewsNeedToBeCalled == YES) {
    if (self.viewWillLayoutSubviewsNeedToBeCalled == YES) {
        [self.alarmTableView reloadData];
    }
    
    // iOS 7.0 대응
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        //        NSLog(@"%f", [UIApplication sharedApplication].statusBarFrame.size.height);
        
        // 스크롤뷰를 아래로 statusBar 만큼 내리기
        CGRect newScrollViewFrame = self.scrollView.frame;
        CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
        if (statusBarFrame.size.height == 40.f) {
            statusBarFrame.size.height = 20.f;
        }
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            newScrollViewFrame.origin.y += statusBarFrame.size.height;
        }else{
            newScrollViewFrame.origin.y += statusBarFrame.size.width;
        }
        self.scrollView.frame = newScrollViewFrame;
    }
}

- (void)adjustButtonViewOnOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    CGRect newFrame;
    CGRect mainScreenBounds = [UIScreen mainScreen].applicationFrame;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 수정: 광고 삭제 구매를 한 경우, 광고뷰를 없애 주기
    // 먼저 배너뷰의 높이를 정해 주기
    CGFloat GADBannerViewHeight;
    BOOL isGADBannerViewNeedToBeHide = NO;
    // 광고 삭제 구매 체크
    if ([userDefaults boolForKey:STORE_PRODUCT_ID_NO_AD]) {
        GADBannerViewHeight = 0;
        isGADBannerViewNeedToBeHide = YES;
    }else{
        GADBannerViewHeight = self.GADbannerView.frame.size.height;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            // Portrait 에 맞게 조정
            newFrame = self.buttonBackgroundView.frame;
            newFrame.size.width = mainScreenBounds.size.width - newFrame.origin.x * 2;
            newFrame.size.height = BUTTON_VIEW_HEIGHT_PORTRAIT;
            newFrame.origin.y = mainScreenBounds.size.height - newFrame.size.height - GADBannerViewHeight; // 20은 status bar 높이
            
            if (isGADBannerViewNeedToBeHide) {
                self.admobView.alpha = 0;
            }else{
                // admob 표시하고 광고뷰 admob다시 옮김
                if (self.admobView.alpha != 1) {
                    self.admobView.alpha = 1;
                    CGRect newGADframe = self.admobView.frame;
                    newGADframe.size = CGSizeMake(320, 50);
                    newGADframe.origin.x = 0;
                    //            newGADframe.origin.y = mainScreenBounds.size.height - newGADframe.size.height;
                    newGADframe.origin.y = 0;
                    self.GADbannerView.frame = newGADframe;
                    
                    [self.GADbannerView removeFromSuperview];
                    [self.admobView addSubview:self.GADbannerView];
                }                
            }
            
            // 버튼들 간격 좁혀 주기
            if ((self.previousOrientation == UIInterfaceOrientationLandscapeLeft) || (self.previousOrientation == UIInterfaceOrientationLandscapeRight)) {
                CGRect newRefreshButtonFrame = self.refreshButton.frame;
                newRefreshButtonFrame.origin.x -= BUTTON_OFFSET;
                self.refreshButton.frame = newRefreshButtonFrame;
                
                CGRect newConfigureButtonFrame = self.configureButton.frame;
                newConfigureButtonFrame.origin.x += BUTTON_OFFSET;
                self.configureButton.frame = newConfigureButtonFrame;
            }
        }else{
            // Landscape 에 맞게 조정
            newFrame = self.buttonBackgroundView.frame;
            newFrame.size.width = mainScreenBounds.size.height - newFrame.origin.x * 2;
            newFrame.size.height = BUTTON_VIEW_HEIGHT_LANDSCAPE; // 50 + 12(위아래 패딩 6씩)
            newFrame.origin.y = mainScreenBounds.size.width - newFrame.size.height; // 20은 status bar 높이
            
            if (isGADBannerViewNeedToBeHide) {
                self.admobView.alpha = 0;
                newFrame.size.height = BUTTON_VIEW_HEIGHT_PORTRAIT;
                newFrame.origin.y = mainScreenBounds.size.width - newFrame.size.height; // 20은 status bar 높이
            }else{
                // admobView 가리고 광고뷰를 buttonView에 대입
                if (self.admobView.alpha != 0) {
                    self.admobView.alpha = 0;
                    CGRect newGADframe = self.GADbannerView.frame;
                    newGADframe.origin.x = newFrame.size.width/2 - newGADframe.size.width/2;
                    newGADframe.origin.y = 6;
                    newGADframe.size = CGSizeMake(320, 50);
                    self.GADbannerView.frame = newGADframe;
                    
                    [self.GADbannerView removeFromSuperview];
                    [self.buttonContainerView addSubview:self.GADbannerView];
                }
            }
            
            // 버튼들 간격 조금더 넓혀 주기
            if (self.previousOrientation == UIInterfaceOrientationPortrait || self.previousOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                CGRect newRefreshButtonFrame = self.refreshButton.frame;
                newRefreshButtonFrame.origin.x += BUTTON_OFFSET;
                self.refreshButton.frame = newRefreshButtonFrame;
                
                CGRect newConfigureButtonFrame = self.configureButton.frame;
                newConfigureButtonFrame.origin.x -= BUTTON_OFFSET;
                self.configureButton.frame = newConfigureButtonFrame;
            }
        }
    }else{
        // 패드에서는 무조건 아래쪽에 합침
        // Landscape 에 맞게 조정
        newFrame = self.buttonBackgroundView.frame;
        
        // 광고 삭제 구매되었으면
        if (isGADBannerViewNeedToBeHide) {
            newFrame.size.height = BUTTON_VIEW_HEIGHT_PORTRAIT_UNIVERSIAL;
        }else{
            newFrame.size.height = BUTTON_VIEW_HEIGHT_LANDSCAPE_UNIVERSIAL; // 50 + 12(위아래 패딩 6씩)
        }
        
        if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            newFrame.size.width = mainScreenBounds.size.width - newFrame.origin.x * 2;
            newFrame.origin.y = mainScreenBounds.size.height - newFrame.size.height; // 20은 status bar 높이
        }else{
            newFrame.size.width = mainScreenBounds.size.height - newFrame.origin.x * 2;
            newFrame.origin.y = mainScreenBounds.size.width - newFrame.size.height; // 20은 status bar 높이
        }
        
        // admobView 가리고 광고뷰를 buttonView에 대입
        if (isGADBannerViewNeedToBeHide) {
            self.GADbannerView.alpha = 0;
        }else{
            self.GADbannerView.alpha = 1;
        }
        self.admobView.alpha = 0;
        CGRect newGADframe = self.GADbannerView.frame;
        newGADframe.origin.x = newFrame.size.width/2 - newGADframe.size.width/2;
        newGADframe.origin.y = 6;
        newGADframe.size = CGSizeMake(320, 50);
        self.GADbannerView.frame = newGADframe;
        
        [self.GADbannerView removeFromSuperview];
        [self.buttonContainerView addSubview:self.GADbannerView];
    }
    
    self.buttonBackgroundView.frame = newFrame;
    self.buttonBackgroundView = [MNHalfRoundedRectMaker makeUpperHalfRoundedView:self.buttonBackgroundView];
    
    self.buttonContainerView.frame = newFrame;
    [self.view bringSubviewToFront:self.buttonContainerView];
    
    // 튜토리얼 뷰가 존재하면 제일 앞으로
    if (self.tutorialView) {
        [self.view bringSubviewToFront:self.tutorialView];
    }
    if (self.tutorialView2) {
        [self.view bringSubviewToFront:self.tutorialView2];
    }
    
    // iOS 7.0 대응
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
//        NSLog(@"%f", [UIApplication sharedApplication].statusBarFrame.size.height);
        
        // 버튼뷰를 아래로 20만큼 내리기
        CGRect newButtonViewFrame = self.buttonBackgroundView.frame;
        CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
        if (statusBarFrame.size.height == 40.f) {
            statusBarFrame.size.height = 20.f;
        }
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            newButtonViewFrame.origin.y += statusBarFrame.size.height;
        }else{
            newButtonViewFrame.origin.y += statusBarFrame.size.width;
        }
        self.buttonBackgroundView.frame = newButtonViewFrame;
        self.buttonContainerView.frame = newButtonViewFrame;
    }
}


#pragma mark - rotate

/*
// iOS 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) {
            //        [self adjustButtonViewOnOrientation:interfaceOrientation];
            return YES;
        }
        return NO;
    }else{
        return YES;
    }
    // Return YES for supported orientations
}
 */

// iOS 6
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    if ([MNTheme getCurrentlySelectedTheme] == MNThemeTypeMirror || [MNTheme getCurrentlySelectedTheme] == MNThemeTypeScenery) {
//        if (self.mirrorSceneryCameraView) {
//            self.mirrorSceneryCameraView.backgroundColor = [UIColor redColor];
////            [self.mirrorSceneryCameraView layoutSubviews];
//            [self.mirrorSceneryCameraView viewWillRotateToInterfaceOrientation:toInterfaceOrientation withParentView:self.view];
//        }
//    }
//}

- (BOOL)shouldAutorotate {
    NSNumber *isTutorialAlreadyShown = [[NSUserDefaults standardUserDefaults] objectForKey:THEME_TUTORIAL_USED];
    if (isTutorialAlreadyShown && isTutorialAlreadyShown.boolValue == YES) {
        self.viewWillLayoutSubviewsNeedToBeCalled = YES;
        return YES;
    }else{
        return NO;
    }
}


// Tell the system which initial orientation we want to have
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait;
//}

// Tell the system what we support
-(NSUInteger)supportedInterfaceOrientations
{
    // return UIInterfaceOrientationMaskLandscapeRight;
//    return UIInterfaceOrientationMaskAll;
//    if (self.interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) {
//        [self adjustButtonViewOnOrientation:self.interfaceOrientation];
//    }
    
    // 튜토리얼 중에는 무조건 세로만, 튜토리얼 후에는 가로도 가능하게.
    NSNumber *isTutorialAlreadyShown = [[NSUserDefaults standardUserDefaults] objectForKey:THEME_TUTORIAL_USED];
    if (isTutorialAlreadyShown && isTutorialAlreadyShown.boolValue == YES) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }else{
            return UIInterfaceOrientationMaskAll;
        }
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}


#pragma mark - refresh

-(IBAction)refreshButtonClicked:(id)sender {
    // 테스트: 알람 공지 메시지 초기화해주자, 나중엔 주석처리 필요 
//    [MNAlarmProcessor resetAlarmGuideMessage];
    
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_REFRESH];
    
    // 기존 기획 추가: 투명 테마일 경우 폰트 색상을 토글시켜준다.
    switch ([MNTheme getCurrentlySelectedTheme]) {
        case MNThemeTypeMirror:
        case MNThemeTypeScenery:
        case MNThemeTypePhoto:
            [MNTranslucentFont toggleFontType];
            break;
        default:
            break;
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
    
    [self.alarmTableView reloadData];
    
    // 다시 위젯 커버 애니메이션 주기(풀버전이 아닐 경우에만)
    // 위젯 커버 애니메이션 주기(풀버전이 아닐 경우에만)
    if (self.widgetWindowView.isWidgetCoverOn) {
        
        // 위젯 커버 색 변경해주기
        [self.widgetWindowView refreshWidgetCoverImage];
        // 임시로 해결했다가 다시 돌림. 근본적인 원인 해결하자.
//        if (self.widgetWindowView.isWidgetWindowDoingCoverAnimation == NO) {
            [self.widgetWindowView startTwinkleAnimation];
//        }
    
        // 2013년 9월 24일 이후라면 이 기능을 켜 주기
        // 20번 리프레시 누르면 위젯 커버 풀어주기
        [self increaseWidgetCoverRefreshLimit];
    }
    
    // 위젯 리프레시
    [self.widgetWindowView refreshAll];
}

- (void)increaseWidgetCoverRefreshLimit {
    if ([MNRefreshDateChecker isDateOverThanLimitDate]) {
        //             NSLog(@"date is over than targetDate(2013/09/24)");
        
        // 커버가 벗겨져 있다면 따로 로직 필요없음
        if ([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_NO_WIDGET_COVER]) {
            return;
        }else{
            NSInteger refreshCounter = [[NSUserDefaults standardUserDefaults] integerForKey:@"refreshCounter"];
            refreshCounter += 1;
            //        refreshCounter = 0;
            [[NSUserDefaults standardUserDefaults] setInteger:refreshCounter forKey:@"refreshCounter"];
            //        NSLog(@"refreshCounter: %d", refreshCounter);
            
            if (refreshCounter >= WIDGET_COVER_REFRESH_LIMIT) {
                // 위젯 커버 벗겨주고 모두 리프레시를 해주자
                self.widgetWindowView.isWidgetCoverOn = NO;
                [self.widgetWindowView removeAllWidgetCover];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:STORE_PRODUCT_ID_NO_WIDGET_COVER];
            }
        }
    }
}

#pragma mark - Widget Matrix Method

- (void)checkWidgetMatrix
{
    // 새로 불러오기
    NSMutableArray *newMatrix = [[MNWidgetMatrixLoadSaver loadWidgetMatrix] mutableCopy];
    
    // 새로운 위젯 매트릭스와 기존 위젯 매트릭스를 타입으로 비교
    for (int i=0; i<[newMatrix count]; i++) {
        int type = [[(NSMutableDictionary *)[self.widgetDictionaryArray objectAtIndex:i] objectForKey:@"Type"] integerValue];
        int newType = [[(NSMutableDictionary *)[newMatrix objectAtIndex:i] objectForKey:@"Type"] integerValue];
        
        if (type != newType) {
            // widget matrix 변경해주고 다시 아카이브
            [self.widgetDictionaryArray replaceObjectAtIndex:i withObject:[newMatrix objectAtIndex:i]];
            [MNWidgetMatrixLoadSaver saveWidgetMatrix:self.widgetDictionaryArray];
            [self.widgetWindowView loadNewWidgetWithCoverAtIndex:i];
        }
    }
}

#pragma mark - Prepare For Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*
    if ([[segue identifier] isEqualToString:@"MainAlarmPreferenceSegue_Add"])
    {
        [MNEffectSoundPlayer playEffectSoundWithName:VIEW_CLICK_SOUND_NAME];
        UINavigationController *navigationController = segue.destinationViewController;
        MNAlarmPreferenceController *alarmPreferenceController = (MNAlarmPreferenceController *)navigationController.topViewController;
        alarmPreferenceController.MNDelegate = self;
        alarmPreferenceController.isAlarmNew = YES;
    }else if([[segue identifier] isEqualToString:@"MainAlarmPreferenceSegue_Edit"]){
        UINavigationController *navigationController = segue.destinationViewController;
        MNAlarmPreferenceController *alarmPreferenceController = (MNAlarmPreferenceController *)navigationController.topViewController;
        alarmPreferenceController.MNDelegate = self;
        alarmPreferenceController.isAlarmNew = NO;
        self.selectedRow = [self.alarmTableView indexPathForSelectedRow].row;
        alarmPreferenceController.alarmInPreference = [self.alarmTableView.alarmList objectAtIndex:self.selectedRow];
    }
    // 기존 기획은 존재하는 알람들을 클릭하면 설정 화면으로 넘어가는 것이였지만 바로 수정으로 변경
    else if([[segue identifier] isEqualToString:@"configureTabBar_from_alarmItemCell"]){
        MNConfigureTabBarController *tabBarController = segue.destinationViewController;
        tabBarController.tabBarIndexShouldBeSelected = 1;
        
    }else if([[segue identifier] isEqualToString:@"configureTabBar_from_configureButton"]){
        // 세팅 화면으로 전환
        [MNEffectSoundPlayer playEffectSoundWithName:SETTING_SOUND_NAME];
        MNConfigureTabBarController *tabBarController = segue.destinationViewController;
        tabBarController.tabBarIndexShouldBeSelected = 0;
    }
    */
     
    if([[segue identifier] isEqualToString:@"configureTabBar_from_configureButton"]){
        // 세팅 화면으로 전환
        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [MNWidgetMatrixLoadSaver saveWidgetMatrix:self.widgetDictionaryArray];
            [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_SETTING];
            
            MNConfigureTabBarController *tabBarController = segue.destinationViewController;
            
            // 수정: 최근에 있었던 탭바를 기억해주자.
            dispatch_async(dispatch_get_main_queue(), ^{
                tabBarController.tabBarIndexShouldBeSelected = [[NSUserDefaults standardUserDefaults] integerForKey:LAST_SELECTED_TAB_INDEX];
            });
        });
         */
        
        [MNWidgetMatrixLoadSaver saveWidgetMatrix:self.widgetDictionaryArray];
        [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_SETTING];
        
        MNConfigureTabBarController *tabBarController = segue.destinationViewController;
        
        // 수정: 최근에 있었던 탭바를 기억해주자.
        tabBarController.tabBarIndexShouldBeSelected = [[NSUserDefaults standardUserDefaults] integerForKey:LAST_SELECTED_TAB_INDEX];
        
        // 설정으로 가도 리프레시 풀리게
        [self increaseWidgetCoverRefreshLimit];
    }
}


#pragma mark - alarmPreference Delegate Method

- (void)MNAlarmPreferenceControllerDidSaveAlarm:(MNAlarmPreferenceController *)controller {
    
    /*
    // 알람 저장 부분을 디스패치로 구현해봄
    dispatch_async(dispatch_get_main_queue(), ^{
        // 변경사항 저장 - 리팩토링, 로직을 모델로 전부 이전 - 소팅은 자동으로 됨
        if (controller.isAlarmNew) {
            [MNAlarmListProcessor addAlarm:controller.alarmInPreference intoAlarmList:self.alarmTableView.alarmList];
        }else{
            [MNAlarmListProcessor replaceAlarm:controller.alarmInPreference atIndex:self.selectedRow inAlarmList:self.alarmTableView.alarmList];
        }
        
        // 알람 아카이빙
        [MNAlarmListProcessor saveAlarmList:self.alarmTableView.alarmList];
        
        // 뷰 리로드
        [self.alarmTableView reloadData];
    });
    */

    if (controller.isAlarmNew) {
        [MNAlarmListProcessor addAlarm:controller.alarmInPreference intoAlarmList:self.alarmTableView.alarmList];
    }else{
        [MNAlarmListProcessor replaceAlarm:controller.alarmInPreference atIndex:self.selectedRow inAlarmList:self.alarmTableView.alarmList];
        
//        for (NSNumber *repeatDayOfWeek in controller.alarmInPreference.alarmRepeatDayOfWeek) {
//            NSLog(@"repeat : %@", [repeatDayOfWeek boolValue]? @"YES" : @"NO");
            
//            if (repeatDayOfWeek.boolValue == YES) {
//                self.alarmInPreference.isRepeatOn = YES;
//            }
//        }
    }
    
    [MNAlarmListProcessor saveAlarmList:self.alarmTableView.alarmList];
    [self.alarmTableView reloadData];
}


#pragma mark - MNMainAlarmTableView delegate method

// 알람테이블뷰에서 클릭이 넘어오면 메인 알람 리스트에서 알람 on/off 해 주고, archive 하고, 테이블 리로드
- (void)alarmItemSwitchClicked:(int)index {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [MNAlarmProcessor processAlarmSwitchButtonTouchAction:self.alarmTableView.alarmList atIndex:index];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.alarmTableView reloadData];
//        });
    });
//    [MNAlarmProcessor processAlarmSwitchButtonTouchAction:self.alarmTableView.alarmList atIndex:index];
}

#pragma mark - MNAlarmAddItem delegate method

- (void)alarmAddItemClickedToPresentAlarmPreferenceModalController {
    
    [MNAlarmProcessor checkAlarmGuideMessage];
    
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK];
    
    if (self.alarmTableView.alarmList.count >= ALARM_NUMBER_UNLOCK_LIMIT && [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_MORE_ALARM_DECKS] == NO) {
        [MNUnlockManager showUnlockControllerWithProductID:STORE_PRODUCT_ID_MORE_ALARM_DECKS withController:self];
        return;
    }
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        NSLog(@"Loading an iPhone storyboard");
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle:[NSBundle mainBundle]];
    }else{
//        NSLog(@"Loading an iPad storyboard");
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPad" bundle:[NSBundle mainBundle]];
    }
    
    // Navigation instantiation from storyboard
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"AlarmPreferenceNavigationController"];
    
    // AlarmPreferenceController initialization
    MNAlarmPreferenceController *alarmPreferenceController = (MNAlarmPreferenceController *)navigationController.topViewController;
    alarmPreferenceController.MNDelegate = self;
    alarmPreferenceController.isAlarmNew = YES;
    
    // 알람 추가로 가도 리프레시 풀리게
    [self increaseWidgetCoverRefreshLimit];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - MNAlarmScrollItemView delegate method

- (void)alarmItemClickedToPresentAlarmPreferenceModalController:(int)index {
//    NSLog(@"alarmItemClickedToPresentAlarmPreferenceModalController");
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK];
    
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        NSLog(@"Loading an iPhone storyboard");
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle:[NSBundle mainBundle]];
    }else{
//        NSLog(@"Loading an iPad storyboard");
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPad" bundle:[NSBundle mainBundle]];
    }
    
    // Navigation instantiation from storyboard
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"AlarmPreferenceNavigationController"];
    
    // AlarmPreferenceController initialization
    MNAlarmPreferenceController *alarmPreferenceController = (MNAlarmPreferenceController *)navigationController.topViewController;
    alarmPreferenceController.MNDelegate = self;
    alarmPreferenceController.isAlarmNew = NO;
    self.selectedRow = index;
    alarmPreferenceController.alarmInPreference = [self.alarmTableView.alarmList objectAtIndex:self.selectedRow];
    
    // 알람 설정으로 가도 리프레시 풀리게
    [self increaseWidgetCoverRefreshLimit];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

// Swipe 되면 그 인덱스 알람 취소하고 삭제해주기 - 인덱스에서 ID로 변경
- (void)alarmItemHadSwipedToBeRemovedWithAlarmID:(NSInteger)alarmID {
//    NSLog(@"%d", alarmID);
//    NSLog(@"%d", self.alarmTableView.alarmList.count);
//    NSLog(@"%d", self.alarmTableView.alarmList.count);
    
    // 디스패치를 써서 구현 - DISPATCH_QUEUE_SERIAL 을 사용하면 순차적이기에 크래쉬가 나지 않는다
//    dispatch_queue_t dQueue = dispatch_get_global_queue(DISPATCH_QUEUE_SERIAL, 0);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_SERIAL, 0), ^{
        [MNAlarmListProcessor removeAlarmWithAlarmID:alarmID fromAlarmList:self.alarmTableView.alarmList];
//        [MNAlarmListProcessor removeAlarmAtIndex:index fromAlarmList:self.alarmTableView.alarmList];
        
        // 변경한 알람 저장
        [MNAlarmListProcessor saveAlarmList:self.alarmTableView.alarmList];
        
        // UI 처리
        dispatch_async(dispatch_get_main_queue(), ^{
            // 알람 테이블뷰 재로딩
            [self.alarmTableView reloadData];
            
            // 스크롤뷰 높이 재조정
            [self adjustScrollViewFrame];
        });
    });
    
    /*
    // 알람 ID로 삭제 
    [MNAlarmListProcessor removeAlarmWithAlarmID:alarmID fromAlarmList:self.alarmTableView.alarmList];
    
    // 변경한 알람 저장
    [MNAlarmListProcessor saveAlarmList:self.alarmTableView.alarmList];
    
    // 알람 테이블뷰 재로딩
    [self.alarmTableView reloadData];
//    NSLog(@"%d", self.alarmTableView.alarmList.count);
    
    // 스크롤뷰 높이 재조정
    [self adjustScrollViewFrame];
     */
}

/*
- (void)alarmItemHadSwipedToBeRemoved:(int)index {
    
    // 디스패치를 써서 구현
    dispatch_queue_t dQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dQueue, ^{
        [MNAlarmListProcessor removeAlarmAtIndex:index fromAlarmList:self.alarmTableView.alarmList];
        
        // 변경한 알람 저장
        [MNAlarmListProcessor saveAlarmList:self.alarmTableView.alarmList];
        
        // UI 처리
        dispatch_async(dispatch_get_main_queue(), ^{
            // 알람 테이블뷰 재로딩
            [self.alarmTableView reloadData];
            
            // 스크롤뷰 높이 재조정
            [self adjustScrollViewFrame];
        });
    });
//    dispatch_release(dQueue);
}
*/

#pragma mark - Alarm Invokation

- (void)invokeAlarmWithAlarmID:(int)alarmID {   
    // notification 을 발생시킨 알람 검색
    // 설정탭에서 추가했을 수도 있기에 무조건 로딩을 새로하기
//    if (self.alarmTableView.alarmList == nil) {
//        self.alarmTableView.alarmList = [MNAlarmListProcessor loadAlarmList];
//    }
    
    
    // 리스트 새로 로드
    // 앱이 첫 시작되어 AppDelegate에서 넘어 올 때에는 self.alarmTableView 초기화가 되어있지 않음
    // 따라서 여기서는 alarmTableView에 의존하지 않고 최신의 알람 리스트를 불러와서 무조건 처리한다.
    MNAlarm* alarmToNotify;
    
    NSMutableArray *alarmList = [MNAlarmListProcessor loadAlarmList];
    alarmToNotify = [MNAlarmListProcessor alarmWithAlamrID:alarmID inAlarmList:alarmList];
    
    // 기존 alarmTableView를 쓰던 코드
    /*
    if (self.alarmTableView) {
        self.alarmTableView.alarmList = [MNAlarmListProcessor loadAlarmList];
        alarmToNotify = [MNAlarmListProcessor alarmWithAlamrID:alarmID inAlarmList:self.alarmTableView.alarmList];
    }else{
        NSMutableArray *alarmList = [MNAlarmListProcessor loadAlarmList];
        alarmToNotify = [MNAlarmListProcessor alarmWithAlamrID:alarmID inAlarmList:alarmList];
    }
     */
    
    if (alarmToNotify != nil) {
        self.alarmToNotify = alarmToNotify;
        // UIAlertView 생성. tag를 alarmID로 설정
        //        NSString *alarmMessage = [NSString stringWithFormat:@"%@\n%@", alarmToNotify.alarmLabel, [alarmToNotify.alarmDate descriptionWithLocale:[NSLocale currentLocale]]];
        NSString *alarmMessage = [MNAlarmMessageMaker makeAlarmMessageWithDate:alarmToNotify.alarmDate withLabel:alarmToNotify.alarmLabel];
        
        UIAlertView *alertView;
        
        if (alarmToNotify.isSnoozeOn) {
            // Snooze 왼쪽, Dismiss 오른쪽
            alertView = [[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", @"") message:alarmMessage delegate:self cancelButtonTitle:MNLocalizedString(@"alarm_wake_snooze", @"") otherButtonTitles:MNLocalizedString(@"alarm_wake_dismiss", @""), nil];
            alertView.tag = alarmID;
        }else{
            // Dismiss 버튼 하나
            alertView = [[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", @"") message:alarmMessage delegate:self cancelButtonTitle:MNLocalizedString(@"alarm_wake_dismiss", @"") otherButtonTitles:nil];
            alertView.tag = alarmID;
        }
        alertView.delegate = self;
        [alertView show];
        
        // 기존 소스: 무조건 둘다 보여줌
        /*
        // Snooze 왼쪽, Dismiss 오른쪽
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", @"") message:alarmMessage delegate:self cancelButtonTitle:MNLocalizedString(@"alarm_wake_snooze", @"") otherButtonTitles:MNLocalizedString(@"alarm_wake_dismiss", @""), nil];
        alertView.tag = alarmID;
        [alertView show];
        */
    }else{
        self.alarmToNotify = nil;
    }
    
    // 일단 메시지부터 띄우기
    dispatch_async(dispatch_get_main_queue(), ^{
        // 앱이 켜져 있는 상태여서 alarmTableView가 있다면 새로 로딩을 한번 해주기
        if (self.alarmTableView) {
            self.alarmTableView.alarmList = [MNAlarmListProcessor loadAlarmList];
        }
    });
    
    // 반복 알람 때문에 쌓인 모든 노티피케이션을 지우고, on을 체크해서 on인 알람들 다시 알람 켜 주기
    // 문제는 스누즈가 다 지워진다 - 나중에 해결 필요(변수 추가해서 일단 해결 시도)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *localNotification in localNotifications) {
            NSNumber *isSnoozeAlarm = [localNotification.userInfo objectForKey:@"isSnoozeAlarm"];
            // 스누즈 알람이 아니라면 전부 지워주고 새로 등록
            if (isSnoozeAlarm == nil) {
                //            NSLog(@"this is not a snooze alarm");
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }else{
                // 스누즈 알람이라면, 기존 스누즈 알람을 삭제
                //            NSLog(@"this is a snooze alarm");
                NSNumber *alarmID_NSNumber = [localNotification.userInfo objectForKey:@"alarmID"];
                NSInteger alarmID = [alarmID_NSNumber intValue];
                if (alarmToNotify.alarmID+7 == alarmID) {
                    [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
                }
            }
        }
        //    [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        // 켜져있는 알람 다시 켜 주기
        for (MNAlarm *alarm in alarmList) {
            if (alarm.isAlarmOn) {
                [alarm startAlarmAndIsAlarmToastNeeded:NO withDelay:0];
            }
        }
    });
    
    // 기존 alarmTableView를 쓰던 코드
    /*
     [[UIApplication sharedApplication] cancelAllLocalNotifications];
     for (MNAlarm *alarm in self.alarmTableView.alarmList) {
        if (alarm.isAlarmOn) {
            [alarm startAlarmAndIsAlarmToastNeeded:NO withDelay:0];
        }
        if (alarm.isSnoozeScheduled) {
            [alarm snoozeAlarm];
        }
     }
     */
}

#pragma mark - Vibrate

void MyAudioServicesSystemSoundCompletionProc (SystemSoundID  ssID, void *clientData) {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    });
    
    /*
    if (iShouldKeepBuzzing) { // Your logic here...
        
    } else {
        //Unregister, so we don't get called again...
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    } 
     */
}

#pragma mark - SKStoreProductViewController delegate method

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    //    NSLog(@"productViewControllerDidFinish");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Alarm UIAlertView Delegate Mehtods

// after animation - UI를 보여주고 재생한다. 일단 그것때문에 음악이 꺼졌으니. 
- (void)didPresentAlertView:(UIAlertView *)alertView {
//    NSLog(@"didPresentAlertView");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_SERIAL, 0), ^{
        // 음악 재생
        //        NSLog(@"%d", alarmToNotify.alarmSound.alarmSoundType);
        switch (self.alarmToNotify.alarmSound.alarmSoundType) {
            case MNAlarmSoundTypeVibrate:
                // 진동 울리기 - 계속 울려 줌
                AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL);
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                break;
                
            case MNAlarmSoundTypeRingtone: {
                //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                //
                //                });
                self.ringtonePlayer = [MNAlarmSoundProcessor playAlarmRingtone:self.alarmToNotify.alarmSound];
                break;
            }
            case MNAlarmSoundTypeSong: {
                //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                //
                //                });
                self.musicPlayer = [MNAlarmSoundProcessor playAlarmSong:self.alarmToNotify.alarmSound];
                break;
            }
            default:
                break;
        }
        self.alarmToNotify = nil;
    });
    
    // 소리 재생 후 알람 끌 당시의 최상위 컨트롤러가 알람 설정탭 컨트롤러면 그 테이블뷰도 재로딩 해주기 위한 처리
    /*
    id rootVC = [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] nextResponder];
    NSLog(@"rootVC: %@", [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0]);
    
    for (id object in [[[UIApplication sharedApplication] keyWindow] subviews]) {
//        NSLog(@"object: %@", [object class]);
    }
    NSLog(@"rootVC: %@", [rootVC class]);
    NSLog(@"rootVC: %@", [rootVC nextResponder]);
    NSLog(@"rootVC: %@", [[rootVC nextResponder] nextResponder]);
    NSLog(@"rootVC: %@", [[[rootVC nextResponder] nextResponder] nextResponder]);
    NSLog(@"rootVC: %@", [[[[rootVC nextResponder] nextResponder] nextResponder] nextResponder]);
    NSLog(@"rootVC: %@", [[[[[rootVC nextResponder] nextResponder] nextResponder] nextResponder] nextResponder]);
    NSLog(@"rootVC: %@", [[UIApplication sharedApplication] keyWindow].rootViewController);
    NSLog(@"rootVC: %@", [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] nextResponder]);
    NSLog(@"%@", [[alertView nextResponder] class]);
    NSLog(@"%@", [[[alertView nextResponder] nextResponder] class]);
    if ([rootVC isMemberOfClass:[MNConfigureTabBarController class]]) {
//        NSLog(@"rootVC: %@", [rootVC class]);
        // 일단 저장부터 하고, 버튼 터치시 따로 처리
        self.configureTabBarController = (MNConfigureTabBarController *)rootVC;
    }
     */
};

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // Rate AlertView 처리
    if (alertView.tag == -100) {
        if (buttonIndex == 1) { // 오른쪽 버튼
            [MNAppStoreRateManager presentAppStoreControllerWithMorningKitWithController:self];
        }else{
            // 10회에 Rate Later를 눌렀다면 40회에 다시 보여주기 위함
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MORNING_RATE_IT_MESSAGE_USED];
        }
    }
//    NSLog(@"alertView tag and alarmID: %d", alertView.tag);
    
    MNAlarm* alarmToHandle = [MNAlarmListProcessor alarmWithAlamrID:alertView.tag inAlarmList:self.alarmTableView.alarmList];
//    NSLog(@"alarmToHandle alarmID: %d", alarmToHandle.alarmID);
    
    // 스누즈가 꺼져 있다면 캔슬 버튼 -> 취소 버튼
    if (alarmToHandle.isSnoozeOn == NO) {
        buttonIndex += 1;
    }
    if (buttonIndex == SNOOZE_BUTTON) {
//        NSLog(@"alertView ButtonIndex: SNOOZE");
        [alarmToHandle performSelectorOnMainThread:@selector(snoozeAlarm) withObject:nil waitUntilDone:NO]; // Toast 때문에 이렇게 고침
//        [alarmToHandle snoozeAlarm];
    }else if(buttonIndex == DISMISS_BUTTON) {
//        NSLog(@"alertView ButtonIndex: DISMISS");
        // 반복이 아닐 경우만 멈추기 - 반복은 나머지 날짜 것들도 남아 있어야 한다.
        if (alarmToHandle.isRepeatOn == NO) {
            [alarmToHandle stopAlarm];
        }
        // 반복 알람이면 다음주를 위해 다시 알람을 설정해주어야 한다.
        if (alarmToHandle.isRepeatOn == YES) {
//            [alarmToHandle startAlarm];
            [alarmToHandle performSelectorOnMainThread:@selector(startAlarmWithDelay:) withObject:[NSNumber numberWithFloat:1.0f] waitUntilDone:NO]; // Toast 때문에 이렇게 고침
//            [alarmToHandle performSelectorInBackground:@selector(startAlarm) withObject:nil];
//            [[JLToast makeText:@"start repeat alarm"] show];
//            [alarmToHandle startAlarmAndIsAlarmToastNeeded:YES];
        }
    }
    
    // 변경한 알람 저장
    [MNAlarmListProcessor saveAlarmList:self.alarmTableView.alarmList];
    
    // 알람 테이블뷰 재로딩
    [self.alarmTableView reloadData];
    
    // 예외상황: 현재 최상위 컨트롤러가 알람 설정탭이면 UI 갱신해주기
    // 노티피케이션을 이용해 해결하려고 생각중.
    [[NSNotificationCenter defaultCenter] postNotificationName:CONFIGURE_ALARM_OBSERVER_NAME object:nil];
    /*
    if (self.configureTabBarController && self.configureTabBarController.selectedIndex == 1) {
        //            NSLog(@"alarm tab");
        if ([[[self.configureTabBarController.viewControllers objectAtIndex:1] topViewController] isMemberOfClass:[MNConfigureAlarmController class]]) {
            MNConfigureAlarmController *configureAlarmController = (MNConfigureAlarmController *)[[self.configureTabBarController.viewControllers objectAtIndex:1] topViewController];
            configureAlarmController.alarmTableView.alarmList = [MNAlarmListProcessor loadAlarmList];
            [configureAlarmController.tableView reloadData];
        }
    }
     */
    
    // 사운드 정지
    switch (alarmToHandle.alarmSound.alarmSoundType) {
        case MNAlarmSoundTypeVibrate:
            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
            break;
            
        case MNAlarmSoundTypeRingtone:
            [MNAlarmSoundProcessor stopPlayingAlarmRingtoneWithPlayer:self.ringtonePlayer];
            break;
            
        case MNAlarmSoundTypeSong:
            [MNAlarmSoundProcessor stopPlayingAlarmSongWithPlayer:self.musicPlayer];
            break;
            
        default:
            break;
    }
    
    // 사운드 볼륨 벨소리로 다시 바꿔줌 - 아직 못찾음 - 벨소리를 AVAudioPlayer를 가지고 해결함.
}

#pragma mark - MNWidgetViewClickedByWidgetWindowView delegate method

- (void)widgetClicked:(int)index
{
    MNWidgetModalController *modal = [MNWidgetModalControllerFactory getModalControllerWithDictionary:self.widgetDictionaryArray[index]];
    modal.delegate = self;
 
    MNPortraitNavigationController *navCont = [[MNPortraitNavigationController alloc] initWithRootViewController:modal];
    [navCont.navigationBar setBarStyle:UIBarStyleBlack];
    
    // 위젯 모달 화면 들어가도 커버 풀리게 구현
    [self increaseWidgetCoverRefreshLimit];
    
    [self presentViewController:navCont animated:YES completion:NULL];
}

- (void)needToArchive
{
    [MNWidgetMatrixLoadSaver saveWidgetMatrix:self.widgetDictionaryArray];
}

#pragma mark - MNWidgetModalControllerDelegate delegate method

- (void)reloadWidgetIndex:(NSInteger)index
{
    [MNWidgetMatrixLoadSaver saveWidgetMatrix:self.widgetDictionaryArray];
    [self.widgetWindowView reloadWidgetIndex:index];
}

- (void)widgetChangedOnModalView:(int)index
{
    [MNWidgetMatrixLoadSaver saveWidgetMatrix:self.widgetDictionaryArray];
    [self.widgetWindowView loadNewWidgetAtIndex:index];
}


#pragma mark - Proximity Sensor

- (void)sensorStateChange:(NSNotificationCenter *)notification
{
    /*
    if ([[UIDevice currentDevice] proximityState] == YES)
        NSLog(@"Device is close to user.");
    else
        NSLog(@"Device is ~not~ closer to user.");
     */
}

@end
