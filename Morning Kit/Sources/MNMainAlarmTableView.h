//
//  MNAlarmListTableVIew.h
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 30..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNAlarmPreferenceController.h"

@protocol MNMainAlarmTableViewDelegate <NSObject>

- (void)alarmItemSwitchClicked:(int)index;

@end

@interface MNMainAlarmTableView : UITableView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *alarmList;
@property (nonatomic, strong) id<MNMainAlarmTableViewDelegate> MNDelegate;

// Initializer
- (void)initWithAlarmList:(NSMutableArray *)alarmList withDelegate:(id)delegate;

@end
