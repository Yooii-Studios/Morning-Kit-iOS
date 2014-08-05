//
//  MNWidgetWindowView.h
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 30..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNWidgetViewFactory.h"
#import "MNWidgetWindowView.h"
#import "MNWidgetSlotView.h"
#import "MNWidgetSuperSlotView.h"

@protocol MNWidgetViewClickDelegatebyWidgetWindowView <NSObject>

-(void)widgetClicked:(int)index;
-(void)needToArchive;

@end

@interface MNWidgetWindowView : UIView <MNWidgetViewClickDelegate, MNWidgetSuperSlotViewDelegate>
{
//    MNWidgetSlotView *m_Widgets[4];
    MNWidgetSuperSlotView *m_SuperWidgetSlotViews[4];
}

- (void)initWithWidgetMatrix:(NSMutableArray *)matrix;
- (void)reloadWidgetIndex:(NSInteger)index;
- (void)refreshAll;
- (void)onRotation;
- (void)setFrameOnRotation:(UIInterfaceOrientation)orientation;
- (void)initThemeColor;
- (void)loadNewWidgetAtIndex:(int)index;
- (void)loadNewWidgetWithCoverAtIndex:(int)index;
- (void)checkWidgetMatrix;
- (void)onLanguageChanged;
- (void)logEventOnFlurry;

// 일정 위젯 일정 체크
- (void)checkScheduleOfReminderWidgetOnTutorial;

// 위젯 커버 애니메이션 by 우성
- (void)startTwinkleAnimation;
- (void)stopTwinkleAnimation;
- (void)removeAllWidgetCover;
- (void)refreshWidgetCoverImage;

@property (strong, nonatomic) NSMutableArray *widgetMatrix;
@property (strong, nonatomic) id<MNWidgetViewClickDelegatebyWidgetWindowView> delegate;
@property (nonatomic) BOOL isWidgetCoverOn;
@property (nonatomic) BOOL isWidgetWindowDoingCoverAnimation;

@end
