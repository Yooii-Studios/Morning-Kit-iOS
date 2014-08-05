//
//  MNWidgetView.h
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 21..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//
#pragma once

#import <UIKit/UIKit.h>
#import "MNWidgetModel.h"
#import "MNWidgetLoadingView.h"

@protocol MNWidgetViewClickDelegate <NSObject>

- (void) widgetClicked:(int)index;
- (void) needToArchive;

@end

@protocol MNWidgetLoadingDelegate <NSObject>

- (void)startAnimation;
- (void)stopAnimation;
- (void)showNetworkFail;
- (void)showLocationFail;
- (void)showWidgetErrorMessage:(NSString *)msg;
- (void)setThemeColor:(UIColor *)color;
- (void)setLoadingViewAlpha:(CGFloat)alpha;

@end

@class Reachability;

@interface MNWidgetView : UIView

- (void)initWithDictionary:(NSMutableDictionary *)dictionary;
- (void)initWidgetView;
- (void)refreshWidgetView;
- (void)onRotationWithOrientation:(UIInterfaceOrientation)orientation;
- (void)onLanguageChanged;
- (void)doWidgetLoadingInBackground;
- (void)updateUI;
- (void)widgetClicked;
- (void)initThemeColor;
- (void)processOnNoNetwork;
- (void)logEventOnFlurry;

@property (strong, nonatomic) MNWidgetModel *model;
@property (strong, nonatomic) NSMutableDictionary *widgetDictionary;
@property (nonatomic) int pos;
@property (nonatomic) int type;
@property (strong, nonatomic) id<MNWidgetViewClickDelegate> delegate;
@property (strong, nonatomic) Reachability *reach;
@property (nonatomic) BOOL isUsingNetwork;
@property (strong, nonatomic) id<MNWidgetLoadingDelegate> loadingDelegate;

@end
