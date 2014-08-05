//
//  MNWidgetSuperSlotView.h
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 9. 10..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNWidgetCoverView.h"
#import "MNWidgetSlotView.h"

@protocol MNWidgetSuperSlotViewDelegate <NSObject>

- (void)widgetSlotvViewRemoveWidgetCover:(int)pos;
- (void)widgetSlotvViewTouchEnded:(int)pos;
- (BOOL)isWidgetWindowDoingAnimation;
- (void)cancelWidgetWindowAnimation;
- (void)widgetSuperSlotViewDidWidgetCoverAnimation;

@end

// 기존 슬롯뷰의 기능을 확장해 커버뷰 // 슬롯뷰 // 백그라운드뷰로 나눈다.
@interface MNWidgetSuperSlotView : UIView

@property (strong, nonatomic) UIView *widgetBackgroundView;
@property (strong, nonatomic) MNWidgetSlotView *widgetSlotView;
@property (strong, nonatomic) MNWidgetCoverView *widgetCoverView;

@property (nonatomic) NSInteger pos;
@property (nonatomic) NSInteger widgetType;
@property (nonatomic) BOOL isDoingWidgetCoverAnimation;

@property (strong, nonatomic) id<MNWidgetSuperSlotViewDelegate> MNWidgetSuperSlotViewDelegate;

- (void)initBackgroundView:(int)pos;
- (void)initCoverView:(int)pos;
- (void)initThemeColor;
- (void)refreshCoverView;

@end
