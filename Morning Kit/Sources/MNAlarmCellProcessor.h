//
//  MNAlarmCellMaker.h
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 28..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OHAttributedLabel/OHAttributedLabel.h>
#import "MNAlarm.h"

@interface MNAlarmCellProcessor : NSObject

+ (UITableViewCell *)makeAddAlarmCell:(NSString *)CellIdentifier tableView:(UITableView *)tableView withDelegate:(id)delegate;
+ (UITableViewCell *)makeConfigureAddAlarmCell:(NSString *)CellIdentifier tableView:(UITableView *)tableView withDelegate:(id)delegate;
+ (UITableViewCell *)makeAlarmItemCell:(NSString *)CellIdentifier tableView:(UITableView *)tableView withRow:(NSInteger)row withAlarmList:(NSMutableArray *)alarmList withDelegate:(id)delegate;

+ (void)makeAttributedRepeatLabelWithLabel:(OHAttributedLabel *)repeatLabel withAlarm:(MNAlarm *)alarm;
+ (void)changeTimeAndRepeatLabelWithSwitchOn:(BOOL)isSwitchOn withAlarmView:(UIView *)alarmView withAlarm:(MNAlarm *)alarm;
@end
