//
//  MNAlarmAddItemView.h
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 24..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNAlarmAddItemView;

@protocol MNAlarmAddItemViewDelegate <NSObject>

- (void)alarmAddItemClickedToPresentAlarmPreferenceModalController;

@end

@interface MNAlarmAddItemView : UIView

@property (strong, nonatomic) id<MNAlarmAddItemViewDelegate>MNDelegate;

@end
