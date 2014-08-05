//
//  MNWidgetWindowView.m
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 30..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNWidgetWindowView.h"
#import <QuartzCore/QuartzCore.h>
#import "MNDefinitions.h"
#import "MNRoundRectedViewMaker.h"
#import "MNWidgetMatrix.h"
#import "MNStoreController.h"
#import "MNRefreshDateChecker.h"
#import "MNWidgetReminderView.h"
#import "MNWidgetMatrixLoadSaver.h"

//#define ANIMATION_RATIO 1.333
#define ANIMATION_RATIO 1.333

@implementation MNWidgetWindowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:255.f green:255.f blue:255.f alpha:1.0f]];
//        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = NO;
    }
    return self;
}

- (void)initWithWidgetMatrix:(NSMutableArray *)matrix
{
    self.widgetMatrix = matrix;
    
    self.isWidgetCoverOn = YES;
    self.isWidgetWindowDoingCoverAnimation = NO;
    // 풀버전 구매가 되어 있으면 위젯 커버를 씌우지 않기
    // 노 커버 아이템으로 변경
    if ([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_NO_WIDGET_COVER] && [MNRefreshDateChecker isDateOverThanLimitDate]) {
        self.isWidgetCoverOn = NO;
    }
    
    [self loadWidget];
}

- (void)loadWidget
{
    for (int i=0; i < [MNWidgetMatrix getCurrentMatrixType] * 2; i++) {
        NSMutableDictionary *dict = [self.widgetMatrix objectAtIndex:i];
        // 기존 슬롯뷰
        //        m_Widgets[i] = [MNWidgetViewFactory getWidgetView:dict withPos:i];
        //        [self addSubview:m_Widgets[i]];
        //        m_Widgets[i].WidgetView.delegate = self;
        //        m_Widgets[i].MNWidgetSlotViewDelegate = self;
        
        // 새 슈퍼슬롯뷰
        m_SuperWidgetSlotViews[i] = [MNWidgetViewFactory getWidgetSuperSlotView:dict withPos:i];
        [self addSubview:m_SuperWidgetSlotViews[i]];
        m_SuperWidgetSlotViews[i].widgetSlotView.WidgetView.delegate = self;
//        m_SuperWidgetSlotViews[i].widgetSlotView.MNWidgetSlotViewDelegate = self;
        m_SuperWidgetSlotViews[i].MNWidgetSuperSlotViewDelegate = self;
    }
}

- (void)loadNewWidgetAtIndex:(int)index
{
    NSMutableDictionary *dict = [self.widgetMatrix objectAtIndex:index];
//    [m_Widgets[index] removeFromSuperview];
//    m_Widgets[index] = [MNWidgetViewFactory getWidgetView:dict withPos:index];
//    [self addSubview:m_Widgets[index]];
//    m_Widgets[index].WidgetView.delegate = self;
//    m_Widgets[index].MNWidgetSlotViewDelegate = self;
    
    [m_SuperWidgetSlotViews[index] removeFromSuperview];
    m_SuperWidgetSlotViews[index] = [MNWidgetViewFactory getWidgetSuperSlotView:dict withPos:index];
    [self addSubview:m_SuperWidgetSlotViews[index]];
    m_SuperWidgetSlotViews[index].widgetSlotView.WidgetView.delegate = self;
//    m_SuperWidgetSlotViews[index].widgetSlotView.MNWidgetSlotViewDelegate = self;
    m_SuperWidgetSlotViews[index].MNWidgetSuperSlotViewDelegate = self;
    
    if (self.isWidgetCoverOn) {
        // 모달에서 새 위젯을 만드는 경우이다. 위젯 커버를 보여주면 안된다.
        m_SuperWidgetSlotViews[index].widgetCoverView.alpha = 0;
//        m_Widgets[index].LoadingView.alpha = 1.0f;
//        m_Widgets[index].WidgetView.alpha = 1.0f;
    }
}

- (void)loadNewWidgetWithCoverAtIndex:(int)index
{
    NSMutableDictionary *dict = [self.widgetMatrix objectAtIndex:index];
//    [m_Widgets[index] removeFromSuperview];
//    m_Widgets[index] = [MNWidgetViewFactory getWidgetView:dict withPos:index];
//    [self addSubview:m_Widgets[index]];
//    m_Widgets[index].WidgetView.delegate = self;
//    m_Widgets[index].MNWidgetSlotViewDelegate = self;
    
    [m_SuperWidgetSlotViews[index] removeFromSuperview];
    m_SuperWidgetSlotViews[index] = [MNWidgetViewFactory getWidgetSuperSlotView:dict withPos:index];
    [self addSubview:m_SuperWidgetSlotViews[index]];
    m_SuperWidgetSlotViews[index].widgetSlotView.WidgetView.delegate = self;
//    m_SuperWidgetSlotViews[index].widgetSlotView.MNWidgetSlotViewDelegate = self;
    m_SuperWidgetSlotViews[index].MNWidgetSuperSlotViewDelegate = self;
    if (self.isWidgetCoverOn) {
        m_SuperWidgetSlotViews[index].widgetCoverView.alpha = 1.0f;
        m_SuperWidgetSlotViews[index].widgetSlotView.alpha = 0;
    }
}

- (void)reloadWidgetIndex:(NSInteger)index
{
    [m_SuperWidgetSlotViews[index].widgetSlotView.WidgetView refreshWidgetView];
}

- (void)refreshAll
{
    for (int i=0; i< [MNWidgetMatrix getCurrentMatrixType] * 2; i++) {
        [m_SuperWidgetSlotViews[i].widgetSlotView.WidgetView refreshWidgetView];
    }
    [self setShadowsOfWidgets];
}

- (void)initThemeColor
{
    for (int i=0; i< [MNWidgetMatrix getCurrentMatrixType] * 2; i++) {
        [m_SuperWidgetSlotViews[i] initThemeColor];
        [m_SuperWidgetSlotViews[i].widgetSlotView.WidgetView initThemeColor];
        [m_SuperWidgetSlotViews[i].widgetSlotView setThemeColor:nil];
    }
    
    [self setShadowsOfWidgets];
}

- (void)setShadowsOfWidgets {
    BOOL left, top, right, bottom;
    for (int i=0; i < [MNWidgetMatrix getCurrentMatrixType] * 2; i++) {
        switch (i) {
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
        
        // 새 위젯 백그라운드만 배경을 그려줌
//        [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:m_Widgets[i].widgetBackgroundView inSuperView:m_Widgets[i] isLeftBoundary:left isTopBoundary:top isRightBoundary:right isBottomBoundary:bottom];
//        [MNRoundRectedViewMaker makeRoundRectedViewWithoutShadowFromOriginalView:m_Widgets[i].WidgetView inSuperView:m_Widgets[i] isLeftBoundary:left isTopBoundary:top isRightBoundary:right isBottomBoundary:bottom];
//        [MNRoundRectedViewMaker makeRoundRectedViewWithoutShadowFromOriginalView:m_Widgets[i].LoadingView inSuperView:m_Widgets[i] isLeftBoundary:left isTopBoundary:top isRightBoundary:right isBottomBoundary:bottom];
//        if (self.isWidgetCoverOn) {
//            [MNRoundRectedViewMaker makeRoundRectedViewWithoutShadowFromOriginalView:m_Widgets[i].coverView inSuperView:m_Widgets[i] isLeftBoundary:left isTopBoundary:top isRightBoundary:right isBottomBoundary:bottom];
//        }
        
        [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:m_SuperWidgetSlotViews[i].widgetBackgroundView inSuperView:m_SuperWidgetSlotViews[i] isLeftBoundary:left isTopBoundary:top isRightBoundary:right isBottomBoundary:bottom];
        [MNRoundRectedViewMaker makeRoundRectedViewWithoutShadowFromOriginalView:m_SuperWidgetSlotViews[i].widgetCoverView inSuperView:m_SuperWidgetSlotViews[i] isLeftBoundary:left isTopBoundary:top isRightBoundary:right isBottomBoundary:bottom];
        [MNRoundRectedViewMaker makeRoundRectedViewWithoutShadowFromOriginalView:m_SuperWidgetSlotViews[i].widgetSlotView inSuperView:m_SuperWidgetSlotViews[i] isLeftBoundary:left isTopBoundary:top isRightBoundary:right isBottomBoundary:bottom];
    }
}

- (void)setFrameOnRotation:(UIInterfaceOrientation)orientation {
    CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
    CGRect newWidgetWindowViewFrame = self.frame;
//    NSLog(@"%@", NSStringFromCGRect(newWidgetWindowViewFrame));
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        // Portrait 대응
        newWidgetWindowViewFrame.size.width = applicationFrame.size.width;
        newWidgetWindowViewFrame.size.height = WIDGET_WINDOW_HEIGHT_UNIVERSIAL;
        self.frame = newWidgetWindowViewFrame;
        
        // 위젯 내부 뷰 위치 조절
        CGFloat widgetParentViewWidth = WIDGET_WIDTH + PADDING_BOUNDARY + PADDING_INNER;
        CGFloat widgetParentViewHeightWithBoundary = WIDGET_HEIGHT + PADDING_BOUNDARY + PADDING_INNER;
        CGFloat widgetParentViewHeightWithoutBoundary = WIDGET_HEIGHT + PADDING_INNER + PADDING_INNER;
        
//        NSLog(@"WIDGET_WINDOW_WIDTH_UNIVERSIAL: %f", WIDGET_WINDOW_WIDTH_UNIVERSIAL - PADDING_BOUNDARY*3);
//        NSLog(@"WIDGET_WIDTH: %f", WIDGET_WIDTH);
//        NSLog(@"WIDGET_WIDTH: %f", WIDGET_HEIGHT);
//        NSLog(@"PADDING_BOUNDARY: %f", PADDING_BOUNDARY);
//        NSLog(@"PADDING_INNER: %f", PADDING_INNER);
//        
//        NSLog(@"widgetParentViewWidth: %f", widgetParentViewWidth);
//        NSLog(@"widgetParentViewHeightWithBoundary: %f", widgetParentViewHeightWithBoundary);
//        NSLog(@"widgetParentViewHeightWithoutBoundary: %f", widgetParentViewHeightWithoutBoundary);
        
        
        CGRect widgetRect_port[4];
        
        // 매트릭스 2*1이면 높이 전부 WithBoundary 선택

        // 매트릭스 2*2이면 위쪽만 WithBoundary 선택
        widgetRect_port[0] = CGRectMake(0, 0, widgetParentViewWidth, widgetParentViewHeightWithBoundary);
        widgetRect_port[1] = CGRectMake(widgetParentViewWidth, 0, widgetParentViewWidth, widgetParentViewHeightWithBoundary);
        widgetRect_port[2] = CGRectMake(0, widgetParentViewHeightWithBoundary, widgetParentViewWidth, widgetParentViewHeightWithoutBoundary);
        widgetRect_port[3] = CGRectMake(widgetParentViewWidth, widgetParentViewHeightWithBoundary, widgetParentViewWidth, widgetParentViewHeightWithoutBoundary);
            
        for (int i=0; i< [MNWidgetMatrix getCurrentMatrixType] * 2; i++) {
            m_SuperWidgetSlotViews[i].frame = widgetRect_port[i];
            m_SuperWidgetSlotViews[i].widgetSlotView.frame = CGRectMake(0, 0, widgetRect_port[i].size.width, widgetRect_port[i].size.height);
            m_SuperWidgetSlotViews[i].widgetSlotView.WidgetView.frame = m_SuperWidgetSlotViews[i].widgetSlotView.frame;
            m_SuperWidgetSlotViews[i].widgetSlotView.LoadingView.frame = m_SuperWidgetSlotViews[i].widgetSlotView.frame;
//            m_SuperWidgetSlotViews[i].widgetSlotView.backgroundColor = [UIColor redColor];
//            m_SuperWidgetSlotViews[i].widgetCoverView.frame = widgetRect_port[i];

//            m_SuperWidgetSlotViews[i].widgetBackgroundView.frame = widgetRect_port[i];
            
//            NSLog(@"%@", NSStringFromCGRect(m_Widgets[i].frame));
        }
    }else{
        // Landscape 대응
        // 추가: 광고 무료 체크
        CGFloat buttonViewHeight = BUTTON_VIEW_HEIGHT_LANDSCAPE_UNIVERSIAL;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_NO_AD]) {
            buttonViewHeight = BUTTON_VIEW_HEIGHT_PORTRAIT_UNIVERSIAL;
        }
        
        newWidgetWindowViewFrame.size.width = applicationFrame.size.height;
        newWidgetWindowViewFrame.size.height = applicationFrame.size.width - buttonViewHeight - (PADDING_BOUNDARY-PADDING_INNER);
//        NSLog(@"%@", NSStringFromCGSize(newWidgetWindowViewFrame.size));
        self.frame = newWidgetWindowViewFrame;
//        self.backgroundColor = [UIColor blueColor];

        // 위젯 내부 뷰 위치 조절
        CGFloat widgetParentViewWidth = newWidgetWindowViewFrame.size.width/2;
        CGFloat widgetParentViewHeightWithBoundary = newWidgetWindowViewFrame.size.height/2;
//        CGFloat widgetParentViewHeightWithoutBoundary = WIDGET_HEIGHT + PADDING_INNER + PADDING_INNER;
        
        CGRect widgetRect_port[4];
        
        // 매트릭스 2*1이면 높이 전부 WithBoundary 선택
        if ([MNWidgetMatrix getCurrentMatrixType] == 1)
        {
            widgetRect_port[0] = CGRectMake(0, 0, widgetParentViewWidth, widgetParentViewHeightWithBoundary*2);
            widgetRect_port[1] = CGRectMake(widgetParentViewWidth, 0, widgetParentViewWidth, widgetParentViewHeightWithBoundary*2);
        }
        // 매트릭스 2*2이면 위쪽만 WithBoundary 선택
        else
        {
            widgetRect_port[0] = CGRectMake(0, 0, widgetParentViewWidth, widgetParentViewHeightWithBoundary);
            widgetRect_port[1] = CGRectMake(widgetParentViewWidth, 0, widgetParentViewWidth, widgetParentViewHeightWithBoundary);
            widgetRect_port[2] = CGRectMake(0, widgetParentViewHeightWithBoundary, widgetParentViewWidth, widgetParentViewHeightWithBoundary);
            widgetRect_port[3] = CGRectMake(widgetParentViewWidth, widgetParentViewHeightWithBoundary, widgetParentViewWidth, widgetParentViewHeightWithBoundary);
        }
        
        for (int i=0; i < [MNWidgetMatrix getCurrentMatrixType] * 2; i++) {
//            m_Widgets[i].frame = widgetRect_port[i];
            m_SuperWidgetSlotViews[i].frame = widgetRect_port[i];
            m_SuperWidgetSlotViews[i].widgetSlotView.frame = CGRectMake(0, 0, widgetRect_port[i].size.width, widgetRect_port[i].size.height);
            m_SuperWidgetSlotViews[i].widgetSlotView.WidgetView.frame = m_SuperWidgetSlotViews[i].widgetSlotView.frame;
            m_SuperWidgetSlotViews[i].widgetSlotView.LoadingView.frame = m_SuperWidgetSlotViews[i].widgetSlotView.frame;
//            m_SuperWidgetSlotViews[i].widgetBackgroundView.frame = widgetRect_port[i];
        }
    }
    
    [self setShadowsOfWidgets];
}

- (void)onLanguageChanged
{
    for (int i=0; i < [MNWidgetMatrix getCurrentMatrixType] * 2; i++) {
        [m_SuperWidgetSlotViews[i].widgetSlotView.WidgetView onLanguageChanged];
        [m_SuperWidgetSlotViews[i].widgetSlotView.LoadingView onLanguageChanged];
    }
}

- (void)onRotation
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    for (int i=0; i < [MNWidgetMatrix getCurrentMatrixType] * 2; i++)
    {
        if (m_SuperWidgetSlotViews[i].widgetSlotView.WidgetView != nil)
            [m_SuperWidgetSlotViews[i].widgetSlotView.WidgetView onRotationWithOrientation:orientation];
    }
}

- (void)checkWidgetMatrix
{
    if ([MNWidgetMatrix getCurrentMatrixType]*2 != self.subviews.count) {
        
        if ([MNWidgetMatrix getCurrentMatrixType] == 1)
        {
            [m_SuperWidgetSlotViews[2] removeFromSuperview];
            [m_SuperWidgetSlotViews[3] removeFromSuperview];
        }
        else
        {
            [self loadNewWidgetWithCoverAtIndex:2];
            [self loadNewWidgetWithCoverAtIndex:3];
        }
    }
}

- (void)logEventOnFlurry
{
    for (int i=0; i<[MNWidgetMatrix getCurrentMatrixType]*2; i++)
    {
        [m_SuperWidgetSlotViews[i].widgetSlotView.WidgetView logEventOnFlurry];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - Widget clicked delegate method

- (void)widgetClicked:(int)index
{
    [self.delegate widgetClicked:index];
}

- (void)needToArchive
{
    [self.delegate needToArchive];
}

#pragma mark - Widget Cover

- (void)removeAllWidgetCover {
    [self stopTwinkleAnimation];
    for (int i=0; i< [MNWidgetMatrix getCurrentMatrixType] * 2; i++) {
        m_SuperWidgetSlotViews[i].widgetCoverView.alpha = 0;
        [m_SuperWidgetSlotViews[i].widgetCoverView removeFromSuperview];
        m_SuperWidgetSlotViews[i].widgetSlotView.alpha = 1;
    }
}

#pragma mark - MNWidgetSlotViewDelegate method

- (void)widgetSlotvViewRemoveWidgetCover:(int)pos {
//    NSLog(@"widgetSlotvViewRemoveWidgetCover");
    [self stopTwinkleAnimationExceptPosition:pos];
//    [self stopTwinkleAnimation];
}

- (BOOL)isWidgetWindowDoingAnimation {
    if (self.isWidgetWindowDoingCoverAnimation) {
        return YES;
    }else{
        return NO;
    }
}

- (void)cancelWidgetWindowAnimation {
    self.isWidgetWindowDoingCoverAnimation = NO;
}

// 사용 안함
- (void)widgetSlotvViewTouchEnded:(int)pos {
//    [self stopTwinkleAnimation];
}

- (void)widgetSuperSlotViewDidWidgetCoverAnimation {
    for (int i=0; i< [MNWidgetMatrix getCurrentMatrixType] * 2; i++) {
        m_SuperWidgetSlotViews[i].isDoingWidgetCoverAnimation = NO;
    }
}

#pragma mark - WidgetCover Animation
- (void)refreshWidgetCoverImage {
    for (int i=0; i< [MNWidgetMatrix getCurrentMatrixType] * 2; i++) {
        [m_SuperWidgetSlotViews[i] refreshCoverView];
    }
}

- (void)startTwinkleAnimation {
//    [self.layer removeAllAnimations];
    [self stopTwinkleAnimation];
    
    self.isWidgetWindowDoingCoverAnimation = YES;
    
    NSInteger numberOfWidgets = [MNWidgetMatrix getCurrentMatrixType] * 2;
    
    // 4개가 번갈아 애니메이션 되는 것 무한 반복 하여야 한다.
    // 그리고 유저 입력을 받을 수 있어야 함.
    
    // 위젯 있는 만큼만 (2*1 or 2*2) 애니메이션을 주기
    for (int i=0; i < numberOfWidgets; i++) {
        
        [self performSelector:@selector(runTwinkleAnimationWithWidgetSuperSlotView:) withObject:m_SuperWidgetSlotViews[i] afterDelay:((2.2f) * ANIMATION_RATIO * i)];
    }
}

- (void)stopTwinkleAnimationExceptPosition:(NSInteger)pos {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
//    [self.layer removeAllAnimations];
    
//    for (int i=0; i< [MNWidgetMatrix getCurrentMatrixType] * 2; i++) {
//        if ((pos != i)) {
//            [UIView animateWithDuration:.01f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//    
//                [m_SuperWidgetSlotViews[i].layer removeAllAnimations];
//                [m_SuperWidgetSlotViews[i].widgetCoverView.layer removeAllAnimations];
//                [m_SuperWidgetSlotViews[i].widgetSlotView.layer removeAllAnimations];
//                
//                m_SuperWidgetSlotViews[i].isDoingWidgetCoverAnimation = YES;
//                m_SuperWidgetSlotViews[i].widgetCoverView.alpha = 1.0f;
//                m_SuperWidgetSlotViews[i].widgetSlotView.alpha = 0.f;
//                
////                m_SuperWidgetSlotViews[i].widgetCoverView.alpha = 1.0f;
////                m_SuperWidgetSlotViews[i].widgetSlotView.alpha = 0.0f;
////                [m_SuperWidgetSlotViews[i] setNeedsDisplay];
//                
//            } completion:^(BOOL finished) {
//                m_SuperWidgetSlotViews[i].isDoingWidgetCoverAnimation = YES;
//                m_SuperWidgetSlotViews[i].widgetCoverView.alpha = 1.0f;
//                m_SuperWidgetSlotViews[i].widgetSlotView.alpha = 0.f;
//                [m_SuperWidgetSlotViews[i] setNeedsDisplay];
                
//            } completion:^(BOOL finished) {
//                m_SuperWidgetSlotViews[i].isDoingWidgetCoverAnimation = YES;
//                m_SuperWidgetSlotViews[i].widgetCoverView.alpha = 1.0f;
//                m_SuperWidgetSlotViews[i].widgetSlotView.alpha = 0.f;
//                [m_SuperWidgetSlotViews[i] setNeedsDisplay];
//            }];
//            
////            [m_SuperWidgetSlotViews[i] setNeedsDisplay]; // 바로 갱신하게 변경함.
//        }
//    }
    
    for (int i=0; i< [MNWidgetMatrix getCurrentMatrixType] * 2; i++) {
        if ((pos != i)) {
            m_SuperWidgetSlotViews[i].isDoingWidgetCoverAnimation = YES;
            m_SuperWidgetSlotViews[i].widgetCoverView.alpha = 1.0f;
            m_SuperWidgetSlotViews[i].widgetSlotView.alpha = 0.f;
            [m_SuperWidgetSlotViews[i] setNeedsDisplay];
        }
    }
}

- (void)stopTwinkleAnimation
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
//    [self.layer removeAllAnimations];
    
//    for (int i=0; i< [MNWidgetMatrix getCurrentMatrixType] * 2; i++) {
//
////        m_SuperWidgetSlotViews[i].widgetCoverView.alpha = 1.0f;
////        m_SuperWidgetSlotViews[i].widgetSlotView.alpha = 0.0f;
////        [m_SuperWidgetSlotViews[i] setNeedsDisplay];
//        
////        [m_SuperWidgetSlotViews[i].layer removeAllAnimations];
//        
//        [UIView animateWithDuration:.01f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            
//            m_SuperWidgetSlotViews[i].widgetCoverView.alpha = 1.0f;
//            m_SuperWidgetSlotViews[i].widgetSlotView.alpha = 0;
////            [m_SuperWidgetSlotViews[i] setNeedsDisplay];
//            
//        } completion:nil];
//    }

    for (int i=0; i< [MNWidgetMatrix getCurrentMatrixType] * 2; i++) {
        m_SuperWidgetSlotViews[i].isDoingWidgetCoverAnimation = NO;
        m_SuperWidgetSlotViews[i].widgetCoverView.alpha = 1.0f;
        m_SuperWidgetSlotViews[i].widgetSlotView.alpha = 0.f;
        [m_SuperWidgetSlotViews[i] setNeedsDisplay];
    }
}

- (void)animateStep1:(MNWidgetSuperSlotView *)widgetSuperSlotView
{
    // 0.15초동안 위젯 커버를 안보이게 만들고 -> 0.1
    
    [UIView animateWithDuration:0.1f * ANIMATION_RATIO delay:0.0f * ANIMATION_RATIO options:UIViewAnimationOptionAllowUserInteraction animations:^{
        widgetSuperSlotView.widgetCoverView.alpha = 0.0f;
    } completion:nil];
    
    [self performSelector:@selector(animateStep2:) withObject:widgetSuperSlotView afterDelay:0.1f * ANIMATION_RATIO];
}

- (void)animateStep2:(MNWidgetSuperSlotView *)widgetSuperSlotView
{
    // 0.1초동안 빈 위젯 보이게 만들고
    // 0.5초동안 위젯을 보이게 만들고 -> 0.2
    
    [UIView animateWithDuration:0.2f * ANIMATION_RATIO delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        widgetSuperSlotView.widgetSlotView.alpha = 1.0f;
    } completion:nil];
    
    [self performSelector:@selector(animateStep3:) withObject:widgetSuperSlotView afterDelay:1.5f * ANIMATION_RATIO];
}

- (void)animateStep3:(MNWidgetSuperSlotView *)widgetSuperSlotView
{
    // 1.8초 동안 위젯을 보이게 유지. -> 1.5
    // 0.15초 동안 위젯을 안보이게 만들고 -> 0.1
    
    [UIView animateWithDuration:0.1f * ANIMATION_RATIO delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        widgetSuperSlotView.widgetSlotView.alpha = 0.0f;
    } completion:nil];
    
    [self performSelector:@selector(animateStep4:) withObject:widgetSuperSlotView afterDelay:0.1f * ANIMATION_RATIO];
}

- (void)animateStep4:(MNWidgetSuperSlotView *)widgetSuperSlotView
{
    // 0.1초 동안 빈화면 유지
    // 0.2초 동안 위젯 커버를 보이게 만듬 -> 0.1
    
    [UIView animateWithDuration:0.1f * ANIMATION_RATIO delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        widgetSuperSlotView.widgetCoverView.alpha = 1.0f;
    } completion:nil];
    
    if (widgetSuperSlotView.pos + 1 == [MNWidgetMatrix getCurrentMatrixType] * 2)
    {
        [self performSelector:@selector(startTwinkleAnimation) withObject:nil afterDelay:0.4f * ANIMATION_RATIO];
    }
}

- (void)runTwinkleAnimationWithWidgetSuperSlotView:(MNWidgetSuperSlotView *)widgetSuperSlotView {
    
    // 위젯 애니메이션이 돌아가는 동안 만약 다른 위젯을 눌러서 애니메이션이 취소가 되었다면, 바로 커버를 씌워 주기
    // 다시 단계 줄인 애니메이션 - 딱 4단계만 가동
    // 새 애니메이션
    // 0.15초동안 위젯 커버 아이콘을 안보이게 만들고 -> 0.1
    
    [self performSelector:@selector(animateStep1:) withObject:widgetSuperSlotView afterDelay:0.0f];
    
//    [UIView animateWithDuration:0.1f * ANIMATION_RATIO delay:0.15f * ANIMATION_RATIO options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^
//     {
//         widgetSuperSlotView.widgetCoverView.alpha = 0;
//     } completion:^(BOOL finished)
//     {
//         // 0.1초동안 빈 위젯 보이게 만들고
//         // 0.5초동안 위젯을 보이게 만들고 -> 0.2
//         [UIView animateWithDuration:0.2f * ANIMATION_RATIO delay:0.1f * ANIMATION_RATIO options:UIViewAnimationOptionAllowUserInteraction animations:^
//          {
//              widgetSuperSlotView.widgetSlotView.alpha = 1.0f;
//          } completion:^(BOOL finished)
//          {
//              // 1.8초 동안 위젯을 보이게 유지. -> 1.5
//              // 0.15초 동안 위젯을 안보이게 만들고 -> 0.1
//              [UIView animateWithDuration:0.1f * ANIMATION_RATIO delay:(1.5f) * ANIMATION_RATIO options:UIViewAnimationOptionAllowUserInteraction animations:^
//               {
//                   widgetSuperSlotView.widgetSlotView.alpha = 0;
//               } completion:^(BOOL finished)
//               {
//                   // 0.1초 동안 빈화면 유지
//                   // 0.2초 동안 위젯 커버를 보이게 만듬 -> 0.1
//                   [UIView animateWithDuration:0.1f * ANIMATION_RATIO delay:0.1f * ANIMATION_RATIO options:UIViewAnimationOptionAllowUserInteraction animations:^
//                    {
//                        if (widgetSuperSlotView.isDoingWidgetCoverAnimation == NO) {
////                            NSLog(@"auto cover animation cover view alpha 1");
//                            widgetSuperSlotView.widgetCoverView.alpha = 1.0f;
//                        }
//                    } completion:^(BOOL finished)
//                    {
//                        // 제일 마지막 애니메이션이면 다시 시작
//                        if (widgetSuperSlotView.pos + 1 == [MNWidgetMatrix getCurrentMatrixType] * 2)
//                        {
//                            [self performSelector:@selector(startTwinkleAnimation) withObject:nil afterDelay:0.05f * ANIMATION_RATIO];
//                        }
//                    }];
//               }];
//          }];
//     }];
}

#pragma mark - Tutorial
// 우측 하단 위젯이 일정관리 위젯임을 확인하고, 만약 오늘 내일 일정이 없을 경우 명언으로 변경
// 취소됨
- (void)checkScheduleOfReminderWidgetOnTutorial {
    if (m_SuperWidgetSlotViews[3].widgetType == REMINDER) {
        if ([m_SuperWidgetSlotViews[3].widgetSlotView.WidgetView class] == [MNWidgetReminderView class]) {
            MNWidgetReminderView *reminderView = (MNWidgetReminderView *) m_SuperWidgetSlotViews[3].widgetSlotView.WidgetView;
            if (reminderView.todayEvents.count + reminderView.tomorrowEvents.count == 0) {
//                NSLog(@"widget need to be changed to Quotes Widget");
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:[NSNumber numberWithInt:QUOTES] forKey:@"Type"];
                [dict setObject:[NSNumber numberWithInt:3] forKey:@"Pos"];
                [self.widgetMatrix replaceObjectAtIndex:3 withObject:dict];
                [MNWidgetMatrixLoadSaver saveWidgetMatrix:self.widgetMatrix];
                
                // 나중에 커버쪽도 고려를 해야함
                [self loadNewWidgetWithCoverAtIndex:3];
            }
        }
    }
}


@end
