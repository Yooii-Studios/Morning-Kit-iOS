//
//  MNAlarmScrollItemView.h
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 3..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNAlarm.h"

@protocol MNAlarmScrollItemViewDelegate <NSObject>

@optional
- (void)alarmItemHadSwipedToBeRemoved:(int)index;
- (void)alarmItemHadSwipedToBeRemovedWithAlarmID:(NSInteger)alarmID;

@required
- (void)alarmItemClickedToPresentAlarmPreferenceModalController:(int)index;

@end

@interface MNAlarmScrollItemView : UIScrollView <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) MNAlarm *alarm;
@property (nonatomic, strong) UIView *alarmView;
@property (nonatomic, strong) UIButton *alarmSwitchButton;
@property (nonatomic, strong) id<MNAlarmScrollItemViewDelegate> MNDelegate;
//@property (nonatomic) NSInteger currentPage;

@property (nonatomic) BOOL isScrolling;
@property (nonatomic) BOOL isSwipeSoundTriggered;

- (void)initScrollView;
- (void)initAlarmView;

@end
