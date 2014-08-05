//
//  MNWidgetSlotView.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 4. 23..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNWidgetView.h"
#import "MNWidgetLoadingView.h"
#import "MNWidgetCoverView.h"

@protocol MNWidgetSlotViewDelegate <NSObject>

- (void)widgetSlotvViewRemoveWidgetCover:(int)pos;
- (void)widgetSlotvViewTouchEnded:(int)pos;
- (BOOL)isWidgetWindowDoingAnimation;
- (void)cancelWidgetWindowAnimation;

@end

@interface MNWidgetSlotView : UIView <MNWidgetLoadingDelegate, MNWidgetLoadingViewDelegate>

- (void)initLoadingView:(int)pos;

@property BOOL isLoading;

@property (strong, nonatomic) MNWidgetView *WidgetView;
@property (strong, nonatomic) MNWidgetLoadingView *LoadingView;

// 우성 추가: 위젯 커버 뷰
@property (nonatomic) NSInteger pos;
@property (strong, nonatomic) id<MNWidgetSlotViewDelegate> MNWidgetSlotViewDelegate;

@end
