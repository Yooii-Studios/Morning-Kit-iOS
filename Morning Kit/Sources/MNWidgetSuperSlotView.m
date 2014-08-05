//
//  MNWidgetSuperSlotView.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 9. 10..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetSuperSlotView.h"
#import "MNTheme.h"
#import "MNDefinitions.h"
#import <QuartzCore/QuartzCore.h>
#import "MNWidgetCoverImageLoader.h"
#import "MNEffectSoundPlayer.h"
#import "MNStoreManager.h"
#import "MNRefreshDateChecker.h"

#define NIB_NAME_COVER_VIEW ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNWidgetCoverView_iPad" : @"MNWidgetCoverView_iPhone")

@implementation MNWidgetSuperSlotView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - Widget Background

- (void)initBackgroundView:(int)pos
{
    self.widgetBackgroundView = [[UIView alloc] init];
    [self addSubview:self.widgetBackgroundView];
    [self sendSubviewToBack:self.widgetBackgroundView];
    self.widgetBackgroundView.layer.cornerRadius = ROUNDED_CORNER_RADIUS;
    self.widgetBackgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
}

- (void)initThemeColor
{
    self.widgetBackgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
}

#pragma mark - Widget Cover

- (void)initCoverView:(int)pos {
    // CoverView 초기화
    if (self.widgetCoverView == nil) {
        self.widgetCoverView = [[[NSBundle mainBundle] loadNibNamed:NIB_NAME_COVER_VIEW owner:self options:nil] objectAtIndex:0];
        [self addSubview:self.widgetCoverView];
        [self bringSubviewToFront:self.widgetCoverView];
    }
    
    self.widgetCoverView.backgroundColor = [UIColor clearColor];
    self.widgetCoverView.layer.cornerRadius = ROUNDED_CORNER_RADIUS;
    
    self.widgetCoverView.widgetCoverImage.image = [MNWidgetCoverImageLoader getCoverImage:self.widgetType];
    
    // 기존 뷰들의 알파값들을 전부 안보이게 처리하자.
    self.pos = pos;
    
    self.isDoingWidgetCoverAnimation = NO;
}

- (void)refreshCoverView
{
    self.widgetCoverView.widgetCoverImage.image = [MNWidgetCoverImageLoader getCoverImage:self.widgetType];
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.widgetBackgroundView.backgroundColor = [MNTheme getTouchedBackgroundUIColor];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.widgetBackgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%@", self.MNWidgetSuperSlotViewDelegate);
    
    [self.widgetSlotView.WidgetView widgetClicked];
    self.widgetBackgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    
    // 노 위젯 커버 아이템을 샀고 동시에 특정 날짜 지난 경우는 기존과 같게
    if ([[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_NO_WIDGET_COVER] && [MNRefreshDateChecker isDateOverThanLimitDate])
    {
        [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK];
        [self.widgetSlotView.WidgetView.delegate widgetClicked:self.pos];
    }
    // 노 위젯 커버 아이템 없을 경우는 커버 동작
    else
    {
        if (self.MNWidgetSuperSlotViewDelegate) {
            if ([self.MNWidgetSuperSlotViewDelegate isWidgetWindowDoingAnimation])
            {
                if (self.isDoingWidgetCoverAnimation == NO) {
                    [self doWidgetCoverRemoveAnimation];
                }
            }
            else
            {
                // 위젯 커버 애니메이션이 취소된 경우에는 위젯 커버 알파값을 체크하자
                if (self.widgetCoverView.alpha == 1.0f)
                {
                    if (self.isDoingWidgetCoverAnimation == NO) {
                        [self doWidgetCoverRemoveAnimation];
                    }
                }
                else
                {
                    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK];
                    [self.widgetSlotView.WidgetView.delegate widgetClicked:self.pos];
                }
            }
        }
        else
        {
            // 예외상황이 있을 경우 무조건 위젯 설정을 실행하자
            [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK];
            [self.widgetSlotView.WidgetView.delegate widgetClicked:self.pos];
        }
    }
}

- (void)doWidgetCoverRemoveAnimation {
    [self.MNWidgetSuperSlotViewDelegate cancelWidgetWindowAnimation];
    [self.MNWidgetSuperSlotViewDelegate widgetSlotvViewRemoveWidgetCover:self.pos];
    
    // 다른 위젯들 전부 크로스페이드 시키기
    // 유저 인터랙션을 켜니까 동시 애니메이션이 좀 이상하게 됨.
    // UIViewAnimationOptionAllowUserInteraction
    // UIViewAnimationOptionTransitionNone
    
    // 새 애니메이션
    // 총 1.3초
    // 0.3초동안 위젯 커버 보이고,
    // 0.3초동안 위젯 커버 아이콘을 안보이게 만들고,
    // 0.2초동안 빈 위젯 보이게 만들고
    // 0.5초동안 위젯을 보이게 만듬
    
    NSInteger ANIMATION_RATIO = 1.333;
    
    // 새 애니메이션
    
    // 0.15초동안 위젯 커버 보이고,
    // 0.1초동안 위젯 커버 아이콘을 안보이게 만들고,
    
    self.isDoingWidgetCoverAnimation = YES;
    [UIView animateWithDuration:0.1f * ANIMATION_RATIO delay:0.15f * ANIMATION_RATIO options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
//        self.widgetCoverView.widgetCoverImage.alpha = 0;
        self.widgetCoverView.alpha = 0.f;
//        self.widgetSlotView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
        self.widgetCoverView.alpha = 0;
        [self.widgetCoverView setNeedsDisplay];
        
        // 0.2초동안 빈 위젯 보이게 만들고
        // 0.2초동안 위젯을 보이게 만듬
        [UIView animateWithDuration:0.2f * ANIMATION_RATIO delay:0.2f * ANIMATION_RATIO options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
//            self.widgetCoverView.alpha = 0.0f;
            self.widgetSlotView.alpha = 1.0f;
            //            self.LoadingView.alpha = 1.0f;
            //            self.WidgetView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            self.isDoingWidgetCoverAnimation = NO;
            if (self.MNWidgetSuperSlotViewDelegate) {
                [self.MNWidgetSuperSlotViewDelegate widgetSuperSlotViewDidWidgetCoverAnimation];
            }
        }];
    }];
}

@end
