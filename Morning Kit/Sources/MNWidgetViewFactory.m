//
//  MNWidgetViewFactory.m
//  Morning Kit
//
//  Created by Yong Bin Bae on 13. 1. 5..
//  Copyright (c) 2013년 Yooii. All rights reserved.
//

#import "MNWidgetViewFactory.h"
//#import "MNWidgetView.h"

#import "MNWidgetFlickrView.h"
#import "MNWidgetExchangeRateView.h"
#import "MNWidgetCalendarView.h"
#import "MNWidgetMemoView.h"
#import "MNWidgetWeatherView.h"
#import "MNWidgetWorldClockView.h"
#import "MNWidgetDateCountdownView.h"
#import "MNWidgetQuotesView.h"
#import "MNDefinitions.h"
#import "MNRoundRectedViewMaker.h"
#import "MNWidgetMatrix.h"
#import "Flurry.h"
#import "MNStoreManager.h"
#import "MNRefreshDateChecker.h"

#define WEATHER_WIDGET_NIB_NAME ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNWidgetWeatherView_iPad" : @"MNWidgetWeatherView")
#define WORLD_CLOCK_WIDGET_NIB_NAME ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNWidgetWorldClockView_iPad" : @"MNWidgetWorldClockView_iPhone")
#define MEMO_WIDGET_NIB_NAME @"MNWidgetMemoView"
#define CALENDAR_WIDGET_NIB_NAME ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNWidgetCalendarView_iPad" : @"MNWidgetCalendarView")
#define FLICKR_WIDGET_NIB_NAME @"MNWidgetFlickrView_iPhone"
#define QUOTES_WIDGET_NIB_NAME ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNWidgetQuotesView_iPad" : @"MNWidgetQuotesView_iPhone")
#define EXCHANGE_RAGTES_WIDGET_NIB_NAME ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNWidgetExchangeRateView_iPad" : @"MNWidgetExchangeRateView")
#define DATE_COUNTDOWN_WIDGET_NIB_NAME ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNWidgetDateCountdownView_iPad" : @"MNWidgetDateCountdownView")
#define REMINDER_WIDGET_NIB_NAME @"MNWidgetReminderView"//((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNWidgetReminderView_iPad" : @"MNWidgetReminderView")

// 0 0 156 94
// 159 0 155 94
// 0 97 156 94
// 159 97 156 94

@implementation MNWidgetViewFactory

//+ (MNWidgetSlotView*) getWidgetViewWithWidgetCover:(NSMutableDictionary *)dict withPos:(NSInteger)_pos {
//    MNWidgetSlotView* parentView = [MNWidgetViewFactory getWidgetView:dict withPos:_pos];
//    
//
//    return parentView;
//    
//}

/*
+ (MNWidgetSlotView*) getWidgetView:(NSMutableDictionary *)dict withPos:(NSInteger)_pos
{
    MNWidgetView* view = NULL;
    
    CGRect widgetRect_port[4];
    
    // 수치에 맞게 정확하게 수정 by 우성
    // 매트릭스 2*1 이면 1행 윗 패딩은 4, 아랫 패딩은 2.
    // 매트릭스 2*2 이면 1행 윗 패딩은 4, 아랫 패딩은 2, 2행 윗 패딩은 2, 아랫 패딩은
    CGFloat widgetParentViewWidth = WIDGET_WIDTH + PADDING_BOUNDARY + PADDING_INNER;
    CGFloat widgetParentViewHeightWithBoundary = WIDGET_HEIGHT + PADDING_BOUNDARY + PADDING_INNER;
    CGFloat widgetParentViewHeightWithoutBoundary = WIDGET_HEIGHT + PADDING_INNER + PADDING_INNER;
    
    // 매트릭스 2*1이면 높이 전부 WithBoundary 선택
    // 매트릭스 2*2이면 위쪽만 WithBoundary 선택
    widgetRect_port[0] = CGRectMake(0, 0, widgetParentViewWidth, widgetParentViewHeightWithBoundary);
    widgetRect_port[1] = CGRectMake(widgetParentViewWidth, 0, widgetParentViewWidth, widgetParentViewHeightWithBoundary);
    widgetRect_port[2] = CGRectMake(0, widgetParentViewHeightWithBoundary, widgetParentViewWidth, widgetParentViewHeightWithoutBoundary);
    widgetRect_port[3] = CGRectMake(widgetParentViewWidth, widgetParentViewHeightWithBoundary, widgetParentViewWidth, widgetParentViewHeightWithoutBoundary);
    
    [dict setObject:[NSNumber numberWithInteger:_pos] forKey:@"Pos"];
    
    MNWidgetSlotView* parentView = [[MNWidgetSlotView alloc] initWithFrame:widgetRect_port[_pos]];
    
    switch ([(NSNumber *)[dict objectForKey:@"Type"] integerValue]) {
        case WEATHER:
            parentView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:WEATHER_WIDGET_NIB_NAME owner:self options:nil] objectAtIndex:0];
            parentView.WidgetView.isUsingNetwork = YES;
            break;
            
        case WORLDCLOCK:
            parentView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:WORLD_CLOCK_WIDGET_NIB_NAME owner:nil options:nil] objectAtIndex:0];
            parentView.WidgetView.isUsingNetwork = NO;
            break;
            
        case MEMO:
            parentView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:MEMO_WIDGET_NIB_NAME owner:nil options:nil] objectAtIndex:0];
            parentView.WidgetView.isUsingNetwork = NO;
            break;
            
        case CALENDAR:
            parentView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:CALENDAR_WIDGET_NIB_NAME owner:nil options:nil] objectAtIndex:0];
            parentView.WidgetView.isUsingNetwork = NO;
            break;
            
        case FLICKR:
            parentView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:@"MNWidgetFlickrView_iPhone" owner:nil options:nil] objectAtIndex:0];
            parentView.WidgetView.isUsingNetwork = YES;
            break;
            
        case QUOTES:            
            parentView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:QUOTES_WIDGET_NIB_NAME owner:nil options:nil] objectAtIndex:0];
            parentView.WidgetView.isUsingNetwork = NO;
            break;
            
        case EXCHANGE_RATE:
            parentView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:EXCHANGE_RAGTES_WIDGET_NIB_NAME owner:nil options:nil] objectAtIndex:0];
            parentView.WidgetView.isUsingNetwork = YES;          
            break;
            
        case DATE_COUNTDOWN:
            parentView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:DATE_COUNTDOWN_WIDGET_NIB_NAME owner:nil options:nil] objectAtIndex:0];
            parentView.WidgetView.isUsingNetwork = NO;
            break;
            
        default:
            // couldn't happen
            view = [[MNWidgetView alloc] initWithFrame:widgetRect_port[_pos]];  
            break;
    }
    
    BOOL left, top, right, bottom;
    
    switch (_pos) {
        case 0:
            left = YES;
            right = NO;
            top = YES;
            bottom = NO;
            break;
        case 1:
            left = NO;
            right = YES;
            top = YES;
            bottom = NO;
            break;
        case 2:
            left = YES;
            right = NO;
            top = NO;
            bottom = NO;
            break;
        case 3:
            left = NO;
            right = YES;
            top = NO;
            bottom = NO;
            break;
            
        default:
            left = NO, top = NO, right = NO, bottom = NO;
            break;
    }
    
    [parentView initBackgroundView:_pos];
    
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:parentView.widgetBackgroundView inSuperView:parentView isLeftBoundary:left isTopBoundary:top isRightBoundary:right isBottomBoundary:bottom];
    
    [parentView initLoadingView:_pos];
    
    parentView.WidgetView.loadingDelegate = parentView;
    [parentView addSubview:parentView.WidgetView];
    [parentView.WidgetView initWithDictionary:dict];
    
    // 풀버전을 구매하지 않았으면 커버를 추가하기
    if ([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_FULL_VERSION] == NO) {
        
        // 모든 로딩이 끝나고 커버 뷰를 추가 by 우성 (풀버전 없을 경우만)
//        [parentView initCoverView:_pos];
        
//        parentView.coverView.alpha = 0;
//        parentView.WidgetView.alpha = 1.0f;
//        parentView.LoadingView.alpha = 1.0f;
    }
    return parentView;
}
*/

// 래핑 한번 더 함
+ (MNWidgetSuperSlotView *) getWidgetSuperSlotView:(NSMutableDictionary *)dict withPos:(NSInteger)_pos {
    
    NSInteger widgetType = [(NSNumber *)[dict objectForKey:@"Type"] integerValue];
    
    MNWidgetView* view = nil;
    
    CGRect widgetRect_port[4];
    
    // 수치에 맞게 정확하게 수정 by 우성
    // 매트릭스 2*1 이면 1행 윗 패딩은 4, 아랫 패딩은 2.
    // 매트릭스 2*2 이면 1행 윗 패딩은 4, 아랫 패딩은 2, 2행 윗 패딩은 2, 아랫 패딩은
    CGFloat widgetParentViewWidth = WIDGET_WIDTH + PADDING_BOUNDARY + PADDING_INNER;
    CGFloat widgetParentViewHeightWithBoundary = WIDGET_HEIGHT + PADDING_BOUNDARY + PADDING_INNER;
    CGFloat widgetParentViewHeightWithoutBoundary = WIDGET_HEIGHT + PADDING_INNER + PADDING_INNER;
    
    // 매트릭스 2*1이면 높이 전부 WithBoundary 선택
    // 매트릭스 2*2이면 위쪽만 WithBoundary 선택
    widgetRect_port[0] = CGRectMake(0, 0, widgetParentViewWidth, widgetParentViewHeightWithBoundary);
    widgetRect_port[1] = CGRectMake(widgetParentViewWidth, 0, widgetParentViewWidth, widgetParentViewHeightWithBoundary);
    widgetRect_port[2] = CGRectMake(0, widgetParentViewHeightWithBoundary, widgetParentViewWidth, widgetParentViewHeightWithoutBoundary);
    widgetRect_port[3] = CGRectMake(widgetParentViewWidth, widgetParentViewHeightWithBoundary, widgetParentViewWidth, widgetParentViewHeightWithoutBoundary);
    
    [dict setObject:[NSNumber numberWithInteger:_pos] forKey:@"Pos"];

    MNWidgetSuperSlotView *widgetSuperSlotView = [[MNWidgetSuperSlotView alloc] initWithFrame:widgetRect_port[_pos]];
    widgetSuperSlotView.pos = _pos;
    widgetSuperSlotView.widgetType = widgetType;
//    widgetSuperSlotView.backgroundColor = [UIColor clearColor];
    
//    MNWidgetSlotView *parentView = [[MNWidgetSlotView alloc] init];
//    MNWidgetSlotView *parentView =
    widgetSuperSlotView.widgetSlotView = [[MNWidgetSlotView alloc] initWithFrame:CGRectMake(0, 0, widgetRect_port[_pos].size.width, widgetRect_port[_pos].size.height)];
//    widgetSuperSlotView.widgetSlotView = [[MNWidgetSlotView alloc] init];
    [widgetSuperSlotView addSubview:widgetSuperSlotView.widgetSlotView];
    

    switch (widgetType) {
        case WEATHER:
            widgetSuperSlotView.widgetSlotView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:WEATHER_WIDGET_NIB_NAME owner:self options:nil] objectAtIndex:0];
            widgetSuperSlotView.widgetSlotView.WidgetView.isUsingNetwork = YES;
            break;
            
        case WORLDCLOCK:
            widgetSuperSlotView.widgetSlotView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:WORLD_CLOCK_WIDGET_NIB_NAME owner:nil options:nil] objectAtIndex:0];
            widgetSuperSlotView.widgetSlotView.WidgetView.isUsingNetwork = NO;
            break;
            
        case MEMO:
            widgetSuperSlotView.widgetSlotView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:MEMO_WIDGET_NIB_NAME owner:nil options:nil] objectAtIndex:0];
            widgetSuperSlotView.widgetSlotView.WidgetView.isUsingNetwork = NO;
            break;
            
        case CALENDAR:
            widgetSuperSlotView.widgetSlotView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:CALENDAR_WIDGET_NIB_NAME owner:nil options:nil] objectAtIndex:0];
            widgetSuperSlotView.widgetSlotView.WidgetView.isUsingNetwork = NO;
            break;
            
        case FLICKR:
            widgetSuperSlotView.widgetSlotView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:@"MNWidgetFlickrView_iPhone" owner:nil options:nil] objectAtIndex:0];
            widgetSuperSlotView.widgetSlotView.WidgetView.isUsingNetwork = YES;
            break;
            
        case QUOTES:
            widgetSuperSlotView.widgetSlotView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:QUOTES_WIDGET_NIB_NAME owner:nil options:nil] objectAtIndex:0];
            widgetSuperSlotView.widgetSlotView.WidgetView.isUsingNetwork = NO;
            break;
            
        case EXCHANGE_RATE:
            widgetSuperSlotView.widgetSlotView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:EXCHANGE_RAGTES_WIDGET_NIB_NAME owner:nil options:nil] objectAtIndex:0];
            widgetSuperSlotView.widgetSlotView.WidgetView.isUsingNetwork = YES;
            break;
            
        case DATE_COUNTDOWN:
            widgetSuperSlotView.widgetSlotView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:DATE_COUNTDOWN_WIDGET_NIB_NAME owner:nil options:nil] objectAtIndex:0];
            widgetSuperSlotView.widgetSlotView.WidgetView.isUsingNetwork = NO;
            break;
            
        case REMINDER:
            widgetSuperSlotView.widgetSlotView.WidgetView = [[[NSBundle mainBundle] loadNibNamed:REMINDER_WIDGET_NIB_NAME owner:nil options:nil] objectAtIndex:0];
            widgetSuperSlotView.widgetSlotView.WidgetView.isUsingNetwork = NO;
            break;
            
        default:
            // couldn't happen
            view = [[MNWidgetView alloc] initWithFrame:widgetRect_port[_pos]];
            break;
    }
    
    BOOL left, top, right, bottom;
    
    switch (_pos) {
        case 0:
            left = YES;
            right = NO;
            top = YES;
            bottom = NO;
            break;
        case 1:
            left = NO;
            right = YES;
            top = YES;
            bottom = NO;
            break;
        case 2:
            left = YES;
            right = NO;
            top = NO;
            bottom = NO;
            break;
        case 3:
            left = NO;
            right = YES;
            top = NO;
            bottom = NO;
            break;
            
        default:
            left = NO, top = NO, right = NO, bottom = NO;
            break;
    }
    
//    [MNRoundRectedViewMaker makeRoundRectedViewWithoutShadowFromOriginalView:widgetSuperSlotView.widgetSlotView inSuperView:widgetSuperSlotView isLeftBoundary:left isTopBoundary:top isRightBoundary:right isBottomBoundary:bottom];
//    widgetSuperSlotView.widgetSlotView.WidgetView.frame = [MNRoundRectedViewMaker getRectFromOriginalView:widgetSuperSlotView.widgetSlotView inSuperView:widgetSuperSlotView isLeftBoundary:left isTopBoundary:top isRightBoundary:right isBottomBoundary:bottom];
    
    // 백그라운드 설정 -> superSlotView으로 이동 필요
//    [parentView initBackgroundView:_pos];
    [widgetSuperSlotView initBackgroundView:_pos];
//    widgetSuperSlotView.widgetBackgroundView.backgroundColor = [UIColor redColor];
    
//    parentView.frame = [MNRoundRectedViewMaker getRectFromOriginalView:parentView inSuperView:widgetSuperSlotView isLeftBoundary:left isTopBoundary:top isRightBoundary:right isBottomBoundary:bottom];
    
//    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:widgetSuperSlotView.widgetBackgroundView inSuperView:widgetSuperSlotView isLeftBoundary:left isTopBoundary:top isRightBoundary:right isBottomBoundary:bottom];
    
    // 로딩뷰는 그대로 슬롯뷰에 존재
    [widgetSuperSlotView.widgetSlotView initLoadingView:_pos];
    
    widgetSuperSlotView.widgetSlotView.WidgetView.loadingDelegate = widgetSuperSlotView.widgetSlotView;
    [widgetSuperSlotView.widgetSlotView addSubview:widgetSuperSlotView.widgetSlotView.WidgetView];
    widgetSuperSlotView.widgetSlotView.LoadingView.frame = [MNRoundRectedViewMaker getRectFromOriginalView:widgetSuperSlotView.widgetSlotView inSuperView:widgetSuperSlotView isLeftBoundary:left isTopBoundary:top isRightBoundary:right isBottomBoundary:bottom];
    
    [widgetSuperSlotView.widgetSlotView.WidgetView initWithDictionary:dict];
    
    // 풀버전을 구매하지 않았으면 커버를 추가하기
    // -> '노 커버 아이템을 구매하지 않았으면으로 변경
    // -> '특정 날짜가 지나지 않았으면 무조건 커버 사용, 날짜가 지났으면 구매 여부를 확인
    
    // 구매를 했는데, 특정 날짜가 지났을 경우에만 커버를 풀어 주기. 그 외에는 무조건 커버를 씌움
    if (([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_NO_WIDGET_COVER] && [MNRefreshDateChecker isDateOverThanLimitDate]) == NO) {
        // 모든 로딩이 끝나고 커버 뷰를 추가 by 우성 (풀버전 없을 경우만) -> superSlotView로 이동 필요
        //        [parentView initCoverView:_pos];
        
        [widgetSuperSlotView initCoverView:_pos];
        widgetSuperSlotView.widgetCoverView.frame = [MNRoundRectedViewMaker getRectFromOriginalView:widgetSuperSlotView.widgetSlotView inSuperView:widgetSuperSlotView isLeftBoundary:left isTopBoundary:top isRightBoundary:right isBottomBoundary:bottom];
        //        widgetSuperSlotView.widgetSlotView.alpha = 0;
        //        widgetSuperSlotView.widgetSlotView.WidgetView.backgroundColor = [UIColor clearColor];
        //        widgetSuperSlotView.widgetSlotView.WidgetView.backgroundColor = [UIColor clearColor];
        
        //        parentView.coverView.alpha = 0;
        //        parentView.WidgetView.alpha = 1.0f;
        //        parentView.LoadingView.alpha = 1.0f;
    }
    return widgetSuperSlotView;
}

@end