//
//  MNAlarmListTableVIew.m
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 30..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNMainAlarmTableView.h"
#import "MNDefinitions.h"
//#import "MNAlarmDateFormat.h"
#import "MNTheme.h"
//#import "MNAlarmScrollItemView.h"
//#import "MNAlarmAddItemView.h"
#import "MNRoundRectedViewMaker.h"
#import "MNEffectSoundPlayer.h"
//#import <QuartzCore/QuartzCore.h>
//#import <OHAttributedLabel/OHAttributedLabel.h>
#import "MNAlarmCellProcessor.h"

@implementation MNMainAlarmTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Made by Wooseong

- (void)initWithAlarmList:(NSMutableArray *)alarmList withDelegate:(id)delegate {
    self.alarmList = alarmList;
    self.delegate = self;
    self.dataSource = self;
    self.MNDelegate = delegate;
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.scrollEnabled = NO;
    
    // shadow 가 뷰 밖으로 퍼지게 하고 싶음
    self.layer.masksToBounds = NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - alarmList Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
//    NSLog(@"alarmTable numberOfSectionInTableView");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    NSLog(@"%@ / numberOfRowsInSection", [self class]);
    return 1 + self.alarmList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    
    // Configure the cell...
    if (indexPath.row == self.alarmList.count) {
        CellIdentifier  = @"AlarmAddCell_Main";
        cell = [MNAlarmCellProcessor makeAddAlarmCell:CellIdentifier tableView:tableView withDelegate:self.MNDelegate];
//        cell = [self makeAddAlarmCell:CellIdentifier tableView:tableView];
        
        /*
        CGRect newCellFrame = cell.frame;
        newCellFrame.size.width = [UIScreen mainScreen].applicationFrame.size.width;
        cell.frame = newCellFrame;
        NSLog(@"tableView: %@", NSStringFromCGRect(self.frame));
        NSLog(@"cell: %@", NSStringFromCGRect(cell.frame));
        NSLog(@"cell contentView: %@", NSStringFromCGRect(cell.contentView.frame));
        NSLog(@"cell backgroundView: %@", NSStringFromCGRect(backgroundView.frame));
         */
    }else{
        CellIdentifier  = @"AlarmScrollItemCell_Main";
        cell = [MNAlarmCellProcessor makeAlarmItemCell:CellIdentifier tableView:tableView withRow:indexPath.row withAlarmList:self.alarmList withDelegate:self.MNDelegate];
//        cell = [self makeAlarmItemCell:CellIdentifier tableView:tableView indexPath:indexPath];
    }
    
    // = @"MainAlarmAddCell";
    // iOS6에서는 forIndexPath를 붙이는데, iOS5에서는 사용하지 않는다.
    
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    cell.tag = indexPath.row;
    
    // 셀 간 여백 추가 - 일단 제거
    /*
    UIView *cellSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, ALARM_ITEM_HEIGHT-ALARM_SEPERATOR_HEIGHT, 320, ALARM_SEPERATOR_HEIGHT)];
    [cellSeparator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
     UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleWidth];
    [cellSeparator setContentMode:UIViewContentModeTopLeft];
    cellSeparator.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    [cell addSubview:cellSeparator];
    */
    
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    cell.backgroundColor = [UIColor colorWithRed:67.0/255 green:67.0/255 blue:67.0/255 alpha:1];
    // Configure the cell...
    if (indexPath.row == self.alarmList.count) {
        
    }else{
        
    }
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.alarmList.count) {
        // 위쪽 1.5, 아래쪽 3
        return ALARM_ITEM_HEIGHT + PADDING_INNER + PADDING_BOUNDARY;
    }else{
        return ALARM_ITEM_HEIGHT + PADDING_INNER * 2;
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - alarmList Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSLog(@"%d", indexPath.row);
}


#pragma mark - Alarm Target Action

- (void)alarmSwitchButtonDidChanged:(id)sender {
    
//    NSLog(@"%@ / alarmSwitchButtonDidChanged", [self class]);
    
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_ALARM_ON_OFF];
    
    UIButton* alarmSwitchButton = (UIButton *)sender;
    
    // sender에서 row를 알아내는 방법은 여러 가지가 있다. 버전별 안정성을 위해 2번을 사용.
    // 1. cell의 tag
    //    UITableViewCell* cell = (UITableViewCell*)[[[alarmSwitchButton superview] superview] superview];
    //    int index = [self indexPathForCell:cell].row;
    
    // 2. button의 tag. 최상단의 알람 추가 부분은 뺀다.
    int index = alarmSwitchButton.tag - ALARM_SWITCH_TAG_OFFSET;
    
    // index가 count보다 작아야 over head 가 생기지 않는다
    if (index < self.alarmList.count) {
        // 알람 스위치 이미지 변경
        MNAlarm *alarm = [self.alarmList objectAtIndex:index];
        
        UIView *alarmView = [alarmSwitchButton superview];
        if (alarm.isAlarmOn) {
            // 선택된 상태면 off 시키기
            [alarmSwitchButton setImage:[UIImage imageNamed:[MNTheme getAlarmSwitchOffResourceName]] forState:UIControlStateNormal];
            [MNAlarmCellProcessor changeTimeAndRepeatLabelWithSwitchOn:NO withAlarmView:alarmView withAlarm:alarm];
            //        [self changeTimeAndRepeatLabelWithSwitchOn:NO withAlarmView:alarmView withAlarm:alarm];
        }else{
            // 선택되지 않은 상태면 on 시키기
            [alarmSwitchButton setImage:[UIImage imageNamed:[MNTheme getAlarmSwitchOnResourceName]] forState:UIControlStateNormal];
            [MNAlarmCellProcessor changeTimeAndRepeatLabelWithSwitchOn:YES withAlarmView:alarmView withAlarm:alarm];
            //        [self changeTimeAndRepeatLabelWithSwitchOn:YES withAlarmView:alarmView withAlarm:alarm];
        }
        
        // 여기서는 UI변경만 하고 컨트롤러에게 프로세스 넘기기
        [self.MNDelegate alarmItemSwitchClicked:index];
        
        // 멀티터치가 되었을 경우를 대비하여 스위치가 변한다면 알람뷰를 원 색으로 돌려주기
        alarmView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    }
}


@end
