//
//  MNConfigureTabBarController.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 19..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNConfigureTabBarController.h"
#import "MNTheme.h"
#import "MNDefinitions.h"
#import "Flurry.h"

@interface MNConfigureTabBarController ()

@end

@implementation MNConfigureTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
//    NSLog(@"viewWillDisapper");
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
//    NSLog(@"viewWillAppear");
//    NSLog(@"MNConfigureTabBarController viewWillAppear");
    [super viewWillAppear:animated];
    [MNTheme setThemeForConfigure];
//    self.view.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
}

- (void)setLocalizedTabName
{
    // 현재 언어에 맞는 탭 이름 설정하기
    [[self.viewControllers objectAtIndex:0] setTitle:MNLocalizedString(@"tab_widget", @"위젯")];
    [[self.viewControllers objectAtIndex:2] setTitle:MNLocalizedString(@"tab_theme", @"세팅")];
    [[self.viewControllers objectAtIndex:3] setTitle:MNLocalizedString(@"tab_info", @"인포")];
    
    BOOL hasFullVersion = [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_FULL_VERSION];
    if (hasFullVersion) {
        [[self.viewControllers objectAtIndex:1] setTitle:MNLocalizedString(@"tab_alarm", @"알람")];
    } else {
        [[self.viewControllers objectAtIndex:1] setTitle:MNLocalizedString(@"info_store", @"스토어")];
    }
}

- (void)viewWillLayoutSubviews {
    // iOS 7 이상이면 네비게이션 탭 변경
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.translucent = NO;
        
        // 타이틀
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeFont : [UIFont fontWithName:@"helvetica-bold" size:iOS7_NAV_TITLE_FONT_SIZE]};
        
        self.navigationController.navigationBar.tintColor = [MNTheme getNavigationTintColor_iOS7];
        self.navigationController.navigationBar.barTintColor = [MNTheme getNavigationBarTintBackgroundColor_iOS7];
    }
}

- (void)viewDidLoad
{
//    NSLog(@"MNConfigureTabBarController viewDidLoad");
    [super viewDidLoad];
    
    [MNTheme setThemeForConfigure];
    
	// Do any additional setup after loading the view.
    self.delegate = self;
    self.settingController = (MNConfigureSettingController *)[(UINavigationController *)[self.viewControllers objectAtIndex:2] topViewController];
    
    // 셋팅 델리게이트
    self.settingController.delegate = self;
    // 알람 델리게이트
    ((MNConfigureAlarmController *)[[self.viewControllers objectAtIndex:1] topViewController]).delegate = self;
    // 인포 델리게이트
    ((MNConfigureInfoController *)[[self.viewControllers objectAtIndex:3] topViewController]).delegate = self;
    
    // iOS 7 이상이면 네비게이션 탭 변경 - 여기서 미리 네비게이션바의 색을 전부 설정해줘야 이상이 없음.
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        for (UINavigationController *navigationController in self.viewControllers) {
            navigationController.navigationBar.translucent = NO;
            
            // 타이틀
            navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeFont : [UIFont fontWithName:@"helvetica-bold" size:iOS7_NAV_TITLE_FONT_SIZE]};
            
            navigationController.navigationBar.tintColor = [MNTheme getNavigationTintColor_iOS7];
            navigationController.navigationBar.barTintColor = [MNTheme getNavigationBarTintBackgroundColor_iOS7];
        }
    }
    
    [self setLocalizedTabName];
    
    BOOL hasFullVersion = [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_FULL_VERSION];
    if (!hasFullVersion) {
        // 스토어 컨트롤러를 동적으로 추가 및 알람 탭 삭제
        NSMutableArray *newViewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
        
        // 스토어
        UIStoryboard *storyboard;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            storyboard = [UIStoryboard storyboardWithName:@"IAPStoryboard_iPad" bundle:[NSBundle mainBundle]];
        }else{
            storyboard = [UIStoryboard storyboardWithName:@"IAPStoryboard" bundle:[NSBundle mainBundle]];
        }
        UINavigationController *storeNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"Nav_MNStoreController"];
        storeNavigationController.tabBarItem.title = MNLocalizedString(@"info_store", @"스토어");
        storeNavigationController.tabBarItem.image = [UIImage imageNamed:@"m_tab_store"];
        
        // 알람 - 스토어 탭 교체
        [newViewControllers replaceObjectAtIndex:1 withObject:storeNavigationController];
        self.viewControllers = newViewControllers;
        
        ((MNStoreController *)storeNavigationController.topViewController).delegate = self;
        
        // Store Flurry
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *param = [NSDictionary dictionaryWithObject:@"Info" forKey:@"From"];
            
            [Flurry logEvent:@"Store" withParameters:param];
        });
    }
    self.selectedIndex = self.tabBarIndexShouldBeSelected;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TabBarController delegate method

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    NSLog(@"selctedViewController: %@", [((UINavigationController *)viewController) topViewController]);
//    NSLog(@"selectedIndex: %d", self.selectedIndex);
    
    // 눌러진 탭바 index를 기억하자
    [[NSUserDefaults standardUserDefaults] setInteger:self.selectedIndex forKey:LAST_SELECTED_TAB_INDEX];
    
    // 테마 탭에서 다른 곳으로 넘어갈 때 설정 중인 테마를 확정
    if (self.previouslySelectedIndex == 2 && self.selectedIndex != 2) {
        [MNTheme changeCurrentThemeTo:[MNTheme getCurrentlySelectedTheme]];
        [MNTheme sharedTheme].archivedOriginalThemeType = [MNTheme getCurrentlySelectedTheme];
    }
    
    if (self.previouslySelectedIndex == 0 && self.selectedIndex != 0) {
//        NSLog(@"check widgetController");
        self.widgetController = (MNConfigureWidgetController *)[[self.viewControllers objectAtIndex:0] topViewController];
    
        // 내가 생각하고 원했던 클래스일 경우만 tabChanged 를 실행하기 
        if (self.widgetController && [self.widgetController isMemberOfClass:[MNConfigureWidgetController class]] && [self.widgetController respondsToSelector:@selector(tabChanged)]) {
//            NSLog(@"self.widgetController toggleed");
            [self.widgetController tabChanged];
//            NSLog(@"after tabChanged");
        }
    }
    
    self.previouslySelectedIndex = self.selectedIndex;
}


#pragma mark - rotate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    return NO;
}


// for over iOS 6.0
- (BOOL)shouldAutorotate {
    return YES;
}


// 패드는 뒤집힌 상태에서도 사용할 수 있게 해주기

// Tell the system which initial orientation we want to have
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationPortrait;
    }else{
        if(self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            return UIInterfaceOrientationPortraitUpsideDown;
        }
        return UIInterfaceOrientationPortrait;
    }
}


// Tell the system what we support
-(NSUInteger)supportedInterfaceOrientations
{
    // return UIInterfaceOrientationMaskLandscapeRight;
    // return UIInterfaceOrientationMaskAll;
//    return UIInterfaceOrientationMaskPortrait;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
    }
}

#pragma mark - MNConfigureSettingControllerDelegate method

- (void)doneButtonClicked
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [MNTheme setThemeForMain];
//    });
    [self.widgetController saveCurrentDictionaryArray];
}

#pragma mark - MNConfigureTabBarControllerDelegate method

- (void)languageDidChanged {
    [self setLocalizedTabName];
}

@end
