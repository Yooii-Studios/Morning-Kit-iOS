//
//  MNWidgetView.m
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 21..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNWidgetView.h"
#import "MNDefinitions.h"
#import "MNTheme.h"
#import "Reachability.h"
#import "MNRoundRectedViewMaker.h"
#import "Flurry.h"
#include <netinet/in.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <QuartzCore/QuartzCore.h>

@implementation MNWidgetView

// must have to be called
- (const void)initWithDictionary:(NSMutableDictionary *)dictionary
{
    self.widgetDictionary = dictionary;
    self.type = [[dictionary objectForKey:@"Type"] integerValue];
    self.pos = [(NSNumber *)[dictionary objectForKey:@"Pos"] integerValue];
    self.backgroundColor = [UIColor clearColor];
    [self initWidgetView];
    [self initReachable];
    [self refreshWidgetView];
}

// 각 위젯별 커스텀 생성자
- (void)initWidgetView
{
    
}

// 오버라이딩 X
- (const void)refreshWidgetView
{
    if (self.isUsingNetwork)
    {
        [self.loadingDelegate startAnimation];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            // 네트워크 체크
            if (self.reach.isReachable == YES)
            {
//                NSLog(@"network available");
                [self doWidgetLoadingInBackground];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 애니메이션 중지
                    [self.loadingDelegate stopAnimation];
                    
                    // UI 업데이트
                    [self updateUI];
                    [self initThemeColor];
                    [self.delegate needToArchive];
                });
            }
            else
            {
//                NSLog(@"network not available");
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 애니메이션 중지
                    [self.loadingDelegate stopAnimation];
                    
                    // 네트워크 불가 이미지
                    [self.loadingDelegate showNetworkFail];
                    [self processOnNoNetwork];
                });
            }
        });
    }
    else
    {
        [self doWidgetLoadingInBackground];
        [self.loadingDelegate stopAnimation];
        [self updateUI];
        [self initThemeColor];
    }
}

- (void)onLanguageChanged
{
    
}

// 백그라운드 처리 구현부
- (void)doWidgetLoadingInBackground
{
    
}

// UI 스레드 업데이트 구현부
- (void)updateUI
{
    
}

// 위젯 클릭시 처리 
- (void)widgetClicked
{
    
}

- (void)processOnNoNetwork
{
//    [self.loadingDelegate stopAnimation];
}

// 각 방향에 따라 처리, UIInterfaceOrientationPortraitUpsideDown는 대응하지 않는데 윗단에서 이 방향이 빼고 들어와짐.
- (void)onRotationWithOrientation:(UIInterfaceOrientation)orientation {
    
}

- (const void)initReachable
{
    self.reach = [Reachability reachabilityForInternetConnection];
    
    // set the blocks
    if (self.isUsingNetwork) {
        
        __weak typeof(self) weakSelf = self;
        self.reach.reachableBlock = ^(Reachability*reach)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.loadingDelegate startAnimation];
            });
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [weakSelf doWidgetLoadingInBackground];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 애니메이션 중지
                    [weakSelf.loadingDelegate stopAnimation];
                    
                    // UI 업데이트
                    [weakSelf updateUI];
                    [weakSelf.delegate needToArchive];
                });
            });
        };
        
        self.reach.unreachableBlock = ^(Reachability*reach)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 애니메이션 중지
                [weakSelf.loadingDelegate stopAnimation];
                
                // 네트워크 불가 이미지
                [weakSelf.loadingDelegate showNetworkFail];
                [weakSelf processOnNoNetwork];
            });
        };

        // start the notifier which will cause the reachability object to retain itself!
        [self.reach startNotifier];
    }
}

- (void)logEventOnFlurry
{
    NSDictionary *param;
    
    switch ([self.widgetDictionary[@"Type"] integerValue])
    {
        case WEATHER:
            param = [NSDictionary dictionaryWithObject:@"Weather" forKey:@"Type"];
            break;
        case CALENDAR:
            param = [NSDictionary dictionaryWithObject:@"Calendar" forKey:@"Type"];
            break;
        case DATE_COUNTDOWN:
            param = [NSDictionary dictionaryWithObject:@"Date Countdown" forKey:@"Type"];
            break;
        case WORLDCLOCK:
            param = [NSDictionary dictionaryWithObject:@"World Clock" forKey:@"Type"];
            break;
        case FLICKR:
            param = [NSDictionary dictionaryWithObject:@"Flickr" forKey:@"Type"];
            break;
        case QUOTES:
            param = [NSDictionary dictionaryWithObject:@"Quotes" forKey:@"Type"];
            break;
        case MEMO:
            param = [NSDictionary dictionaryWithObject:@"Memo" forKey:@"Type"];
            break;
        case EXCHANGE_RATE:
            param = [NSDictionary dictionaryWithObject:@"Exchange Rate" forKey:@"Type"];
            break;
            
        default:
            break;
    }
    
    [Flurry logEvent:@"Widget" withParameters:param];
}

- (void)initThemeColor
{
//    [self.loadingDelegate setThemeColor:[MNTheme getForwardBackgroundUIColor]];
//    self.superview.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
}

@end
