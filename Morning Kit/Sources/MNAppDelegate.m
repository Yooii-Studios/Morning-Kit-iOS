//
//  MNAppDelegate.m
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 11..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNAppDelegate.h"
#import <MediaPlayer/MPMusicPlayerController.h>
#import "MNMainViewController.h"
#import "Flurry.h"
#import "MNDefinitions.h"
#import "MNStoreManager.h"
#import "MNAlarmListProcessor.h"
#import "MNAlarm.h"

#define ALARM_START_ON_FIRST_LOAD_DEBUG 0
//#define ALARM_START_ON_FIRST_LOAD_DEBUG 1

//#import <FacebookSDK/FacebookSDK.h>

@implementation MNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    NSLog(@"%@ / didFinishLaunchingWithOptions", [self class]);
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        [application setStatusBarStyle:UIStatusBarStyleLightContent];
//        self.window.clipsToBounds =YES;
//        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
//        
//        //Added on 19th Sep 2013
//        self.window.bounds = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height);
//    }
    
//    if ([[UIDevice currentDevice].systemVersion floatValue] < 7)
//    {
//        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    }
//    else
//    {
//        // handling statusBar (iOS7)
//        application.statusBarStyle = UIStatusBarStyleLightContent;
//        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
//        self.window.clipsToBounds = YES;
//        
//        // handling screen rotations for statusBar (iOS7)
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
//    }
    
    // 알림 센터 사운드 체크 여부를 묻기 - 제대로 작동하지 않는다. 
//    NSUInteger types = [application enabledRemoteNotificationTypes];
//    NSInteger isAlertOn = types & UIRemoteNotificationTypeAlert;
//    NSInteger isBadgeOn = types & UIRemoteNotificationTypeBadge;
//    NSInteger isSoundOn = types & UIRemoteNotificationTypeSound;
//    
//    if (!(isAlertOn && isBadgeOn && isSoundOn)) {
//        UIRemoteNotificationType notiType = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
//        
////        [application unregisterForRemoteNotifications];
//        [application registerForRemoteNotificationTypes:notiType];
//    }
    
    // Flurry initalization
    [Flurry startSession:@FLURRY_APPLICATION_KEY];
    
    // UILocalNotification
    UILocalNotification *alarmLocalNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (alarmLocalNotification) {
        // 알람이 울릴 때 alarmID를 얻어내서, Array에서 검색 한 뒤 알람의 스위치를 바꿔주기
        [self application:application didReceiveLocalNotification:alarmLocalNotification];
        [self invokeAlarmWithNotification:alarmLocalNotification];
    }else{
        // 노티피케이션을 안 눌렀을 때에도 확인가능하게 점검
        [self checkThereIsANotification:application];
    }
    
    // 알람 센터의 알람 전부 없애줌
    application.applicationIconBadgeNumber = 0;
    
    // 앱이 새로 켜질 때는 항상 기존에 켜진 알람들을 다시 켜주자(노티피케이션 끝나고)
    NSMutableArray *alarmList = [MNAlarmListProcessor loadAlarmList];
    for (MNAlarm *alarm in alarmList) {
        if (alarm.isAlarmOn) {
            if (ALARM_START_ON_FIRST_LOAD_DEBUG) {
                [alarm startAlarmAndIsAlarmToastNeeded:YES withDelay:0];
            }else{
                [alarm startAlarmAndIsAlarmToastNeeded:NO withDelay:0];
            }
        }
    }
    return YES;
}

// 체크위해 사용, 푸시 서버 사용을 안해서 콜백이 안됨, 사용불가.
// [application registerForRemoteNotificationTypes:notiType];
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
//}
//
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"%@", error.localizedDescription);
//    NSLog(@"didFailToRegisterForRemoteNotificationsWithError");
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
//    NSLog(@"applicationWillResignActive");
    
//    [[MPMusicPlayerController iPodMusicPlayer] stop];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
//    NSLog(@"applicationWillEnterForeground");
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // 로컬 노티피케이션이 있을 때 앱을 누르고 들어간다면 확인하게 점검
    // 여기서 문제상황 발생: 백그라운드에 있다가 알람이 울릴 때 알림을 눌러서 들어오면 didReceiveLocalNotification가 실행되기 때문에 아래 메서드와 함께 두 번 실행이 된다.
    // 앱만 누르는 경우에는 didReceiveLocalNotification가 발생하지 않아서 아래 함수를 통해 알람을 한 번만 울리게 할 수 있다.
    // didReceiveLocalNotification 에서 foreground 일때만 처리를 하게 하고, 아래 메서드에서는 직접 알람을 울리게 구현한다.
    [self checkThereIsANotification:application];
    
    // 위젯 테마를 제대로 맞추어줌
    MNMainViewController *mainViewController = (MNMainViewController *)self.window.rootViewController;
    if (mainViewController && [mainViewController isMemberOfClass:[MNMainViewController class]]) {
        [mainViewController.widgetWindowView initThemeColor];
        // 다시 포어그라운드로 들어오면 애니메이션 다시 시작해주기
        if (mainViewController.widgetWindowView.isWidgetCoverOn) {
            [mainViewController.widgetWindowView startTwinkleAnimation];
        }
    }
    
    // 24시간제 확인해서 적용하기
    if(self.alarmDelegate)
        [self.alarmDelegate MNAlarmListShouldBeReloaded];

    // 알람 센터의 알람 전부 없애줌
    //    NSLog(@"applicationIconBadgeNumber: %d", application.applicationIconBadgeNumber);
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    NSLog(@"applicationDidBecomeActive");
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Facebook
//    [FBSession.activeSession close];
}

#pragma mark - custom

// 현재 이용하지 않음
/*
- (void)resetAppToFirstController {
    
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        NSLog(@"Loading an iPhone storyboard");
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle:[NSBundle mainBundle]];
    }else{
        NSLog(@"Loading an iPad storyboard");
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPad" bundle:[NSBundle mainBundle]];
    }
    
    MNMainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MNMainViewController"];
    self.window.rootViewController = mainViewController;
}
 */

#pragma mark - Local Notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    NSLog(@"%@ / didReceiveLocalNotification", [self class]);
//    NSArray *alarmLocalNotifications = [application scheduledLocalNotifications];
//    NSLog(@"number of notifications: %d", alarmLocalNotifications.count);
    
//    NSNumber *alarmID_NSNumber = [notification.userInfo objectForKey:@"alarmID"];
//    NSInteger alarmID = [alarmID_NSNumber intValue];
//    NSLog(@"didReceiveLocalNotification / alarm ID: %d", alarmID);
//    NSString *applicationState;
    
    // 앱이 Foreground에 있다면 이 분기로 들어감
//    NSLog(@"state: %d", application.applicationState);
    if (application.applicationState == UIApplicationStateActive ) {
//        NSLog(@"UIApplicationStateActive");
//        applicationState = @"UIApplicationStateActive";
        
        // 알람이 울릴 때 alarmID를 얻어내서, Array에서 검색 한 뒤 알람의 스위치를 바꿔주기.
        [self invokeAlarmWithNotification:notification];
    }else if(application.applicationState == UIApplicationStateInactive) {
        // Background에서 들어온다면(앱이 죽지 않은 상태에서) 
//        NSLog(@"UIApplicationStateInactive");
//        [self invokeAlarmWithNotification:notification];
    }
    /*
    // 앱이 Background에 있다면 이 아래 분기로 들어감
    else if(application.applicationState == UIApplicationStateInactive) {
        // Background에서 Foreground로 올 경우는 applicationWillEnterForeground 여기에서 처리하도록 한다. 
        NSLog(@"UIApplicationStateInactive");
        applicationState = @"UIApplicationStateInactive";
    }else if(application.applicationState == UIApplicationStateBackground) {
        NSLog(@"UIApplicationStateBackground");
        applicationState = @"UIApplicationStateBackground";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ApplicationState" message:applicationState delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alertView show];
    */
}

- (void)invokeAlarmWithNotification:(UILocalNotification *)notification {
    
    NSNumber *alarmID_NSNumber = [notification.userInfo objectForKey:@"alarmID"];
    NSInteger alarmID = [alarmID_NSNumber intValue];
//    NSLog(@"%@ / alarmToInvoke: %d", [self class], alarmID);
//    [NSString stringWithFormat:@"alarmToInvoke: %d", alarmID];
    
    // mainViewController를 얻어내어 알람을 알리게 지시
    MNMainViewController *mainViewController = (MNMainViewController *)self.window.rootViewController;
    [mainViewController invokeAlarmWithAlarmID:alarmID];
}

// 중복 알람 검사를 해내자
- (void)checkThereIsANotification:(UIApplication *)application
{
    // local notification 을 보고 들어왔는지 체크 한다.
    NSArray *alarmLocalNotifications = [application scheduledLocalNotifications];
//    NSLog(@"number of notifications: %d", alarmLocalNotifications.count);
    
    NSMutableArray *notificationsToBeInvoked = [NSMutableArray array];
    for (UILocalNotification *alarmLocalNotification in alarmLocalNotifications) {
//        NSLog(@"fireDate timeIntervalSinceNow: %lf", alarmLocalNotification.fireDate.timeIntervalSinceNow);
//        NSNumber *alarmID_NSNumber = [alarmLocalNotification.userInfo objectForKey:@"alarmID"];
//        NSInteger alarmID = [alarmID_NSNumber intValue];
//        NSLog(@"check alarmID: %d", alarmID);
        
        if (alarmLocalNotification.fireDate.timeIntervalSinceNow <= 0) {
//            NSLog(@"there is a local notification");
            [notificationsToBeInvoked addObject:alarmLocalNotification];
//            [self invokeAlarmWithNotification:alarmLocalNotification];
//            break;
        }
    }

    // 혹시나 같은 시간에 알람들을 설정해 놓았으면 다 같이 울리게 해 주어야 한다. 스누즈는 시간대가 다르기에 상관없을 것 같고, 같은 알람에 속한 반복 노티인지만 확인해서 한 알람당 한 번만 울리게 해보자. 그리고 앱 바깥에서 울릴 때만 해당되는 이야기이다. 앱 안에서는 didReceiveLocalNotification에서 잘 처리하고 있음.
    NSMutableArray *alarmList = [MNAlarmListProcessor loadAlarmList];
    NSMutableArray *invokedAlarmList = [NSMutableArray array];
    
    for (UILocalNotification *alarmLocalNotification in notificationsToBeInvoked) {
        NSNumber *alarmID_NSNumber = [alarmLocalNotification.userInfo objectForKey:@"alarmID"];
        NSInteger alarmID = [alarmID_NSNumber intValue];
        
        MNAlarm *invokedAlarm = [MNAlarmListProcessor alarmWithAlamrID:alarmID inAlarmList:alarmList];
        if (invokedAlarm) {
            // 만약 해당 알람이 리스트에 없다면 울려 주고 리스트에 저장하며, 미리 들어가 있다면 같은 알람을 울려 주는 것이므로 패스한다.
            if ([MNAlarmListProcessor alarmWithAlamrID:alarmID inAlarmList:invokedAlarmList] == nil) {
                [self invokeAlarmWithNotification:alarmLocalNotification];
                [invokedAlarmList addObject:invokedAlarm];
            }
        }
    }
}

/*
#pragma mark - Facebook

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBSession.activeSession handleOpenURL:url];
}
*/

@end
