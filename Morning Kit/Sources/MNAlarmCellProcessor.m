//
//  MNAlarmCellMaker.m
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 28..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNAlarmCellProcessor.h"
#import <QuartzCore/QuartzCore.h>
#import "MNAlarmAddItemView.h"
#import "MNTheme.h"
#import "MNRoundRectedViewMaker.h"
#import "MNAlarmDateFormat.h"
#import <OHAttributedLabel/OHAttributedLabel.h>
#import "MNAlarm.h"
#import "MNDefinitions.h"
#import "MNAlarmScrollItemView.h"
#import "MNAlarmRepeatDayOfWeekStringMaker.h"

// AM/PM 42->25로 변경
#define OFFSET_AM_PM ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0 : 8)// 8)
#define OFFSET_AM_PM_SHOURT ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 22 : 14)
#define OFFSET_REPEAT_LABEL ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? -2 : -5)

@implementation MNAlarmCellProcessor

+ (UITableViewCell *)makeAddAlarmCell:(NSString *)CellIdentifier tableView:(UITableView *)tableView withDelegate:(id)delegate {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.layer.masksToBounds = NO;
    //        cell.contentView.backgroundColor = [UIColor whiteColor];    // 테스트
    cell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    cell.backgroundColor = [UIColor clearColor];
    
    MNAlarmAddItemView *backgroundView = (MNAlarmAddItemView *)[cell viewWithTag:101];
    backgroundView.MNDelegate = (id<MNAlarmAddItemViewDelegate>)delegate;
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:cell isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:YES];
    
    // Plus Image
    UIButton *plusButton = (UIButton *)[backgroundView viewWithTag:104];
    [plusButton setImage:[UIImage imageNamed:[MNTheme getAlarmPlusResourceName]] forState:UIControlStateNormal];
    plusButton.userInteractionEnabled = NO;
    
    // Dividing Bar
    UIImageView *dividingBarImageView = (UIImageView *)[backgroundView viewWithTag:105];
    dividingBarImageView.image = [UIImage imageNamed:[MNTheme getAlarmDividingBarResourceName]];
    
    // 알람 추가 다국어
    UILabel *addAlarmLabel = (UILabel *)[backgroundView viewWithTag:102];
    addAlarmLabel.text = MNLocalizedString(@"add_an_alarm", @"알람 추가");
    if ([MNTheme getCurrentlySelectedTheme] == MNThemeTypeSkyBlue) {
        addAlarmLabel.textColor = UIColorFromHexCode(0x043f4b);
    }else{
        addAlarmLabel.textColor = [MNTheme getMainFontUIColor];
    }

//    NSLog(@"cell: %@", NSStringFromCGRect(cell.frame));
//    NSLog(@"backgroundView: %@", NSStringFromCGRect(backgroundView.frame));
    return cell;
}

+ (UITableViewCell *)makeConfigureAddAlarmCell:(NSString *)CellIdentifier tableView:(UITableView *)tableView withDelegate:(id)delegate {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.layer.masksToBounds = NO;
    //        cell.contentView.backgroundColor = [UIColor whiteColor];    // 테스트
    cell.contentView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    cell.backgroundColor = [UIColor clearColor];
    
    MNAlarmAddItemView *backgroundView = (MNAlarmAddItemView *)[cell viewWithTag:101];
    backgroundView.MNDelegate = (id<MNAlarmAddItemViewDelegate>)delegate;
    backgroundView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    // 래핑한 클래스에서 round-rected View 만들어주기
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:backgroundView inSuperView:cell isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    // Plus Image
    UIButton *plusButton = (UIButton *)[backgroundView viewWithTag:104];
    [plusButton setImage:[UIImage imageNamed:[MNTheme getAlarmPlusResourceName]] forState:UIControlStateNormal];
    plusButton.userInteractionEnabled = NO;
    
    // Dividing Bar
    UIImageView *dividingBarImageView = (UIImageView *)[backgroundView viewWithTag:105];
    dividingBarImageView.image = [UIImage imageNamed:[MNTheme getAlarmDividingBarResourceName]];
    
    // 알람 추가 다국어
    UILabel *addAlarmLabel = (UILabel *)[backgroundView viewWithTag:102];
    addAlarmLabel.text = MNLocalizedString(@"add_an_alarm", @"알람 추가");
    addAlarmLabel.textColor = [MNTheme getMainFontUIColor];
    return cell;
}

+ (UITableViewCell *)makeAlarmItemCell:(NSString *)CellIdentifier tableView:(UITableView *)tableView withRow:(NSInteger)row withAlarmList:(NSMutableArray *)alarmList withDelegate:(id)delegate {
//    NSLog(@"makeAlarmItemCell");
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.layer.masksToBounds = NO;
    cell.contentView.layer.masksToBounds = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor clearColor];
    cell.tag = row;
    //        NSLog(@"%d", cell.tag);
    
    // 알람 아이템 초기화 - 나중에 각 테마에 맞게 아트 에셋을 변경할 수 있어야 함
    // 동시에 지우다가 죽는 현상을 방지하기 위해 읽을 때 알람을 새로 읽고, 카운트보다 작아야 한다.
    MNAlarm *alarm;
    if (row < alarmList.count) {
        alarm = [alarmList objectAtIndex:row];
    }
    
    // locale 에 맞는 알람 시간 설정을 위한 클래스
    MNAlarmDateFormat *alarmDateFormat = [MNAlarmDateFormat alarmDateFormatWithDate:alarm.alarmDate];
    
    // 101 시간 / 102 AM / 103 레이블 / 104 버튼
    // Alarm Time
    UILabel *alarmTimeLabel = (UILabel *)[cell viewWithTag:101];
    alarmTimeLabel.text = alarmDateFormat.alarmTimeString;
    
    // AM PM
    UILabel *ampmLabel = (UILabel *)[cell viewWithTag:102];
    
    ampmLabel.text = alarmDateFormat.ampmString;
    
    // 시가 한 자리 수면 위치를 좀 더 왼쪽으로 당기기
    NSInteger offsetForAMPM = OFFSET_AM_PM;
    if (alarmDateFormat.isUsing24hours) {
        if (alarmDateFormat.hour < 10) {
            offsetForAMPM += OFFSET_AM_PM_SHOURT;
        }
    }else{
        // AM/PM을 사용할 때에는 한 자리 숫자를 다르게 사용
        if (alarmDateFormat.hourForString < 10) {
            offsetForAMPM += OFFSET_AM_PM_SHOURT; // = 22, 두 자리 한 자리 간격이 14라고 보면 됨.
        }
    }
    [ampmLabel setFrame:CGRectMake(alarmTimeLabel.frame.origin.x + alarmTimeLabel.frame.size.width - offsetForAMPM,
                                   ampmLabel.frame.origin.y,
                                   ampmLabel.frame.size.width,
                                   ampmLabel.frame.size.height)];

    if (alarmDateFormat.isUsing24hours == NO) {
        ampmLabel.alpha = 1;
    }else{
        ampmLabel.alpha = 0;
    }
    
    // RepeatLabel
    OHAttributedLabel *repeatLabel = (OHAttributedLabel *)[cell viewWithTag:200]; // 200
    if (alarm.isRepeatOn) {
        [self makeAttributedRepeatLabelWithLabel:repeatLabel withAlarm:alarm];  // 텍스트 만들기
    }else{
        repeatLabel.alpha = 0;
    }
    
    // 시간 숫자가 한 자리 수면 위치를 좀 더 왼쪽으로 당기기
    // 24시간제면 AM 만큼 더 땡겨주기
    NSInteger offsetForRepeatLabel = OFFSET_REPEAT_LABEL;
    if (alarmDateFormat.isUsing24hours) {
        [repeatLabel setFrame:CGRectMake(ampmLabel.frame.origin.x,
                                         ampmLabel.frame.origin.y + 1,
                                         repeatLabel.frame.size.width,
                                         repeatLabel.frame.size.height)];
    }else{
        [repeatLabel setFrame:CGRectMake(ampmLabel.frame.origin.x + ampmLabel.frame.size.width - offsetForRepeatLabel,
                                         ampmLabel.frame.origin.y + 1,
                                         repeatLabel.frame.size.width,
                                         repeatLabel.frame.size.height)];
    }
    
    // NameLabel
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:103];
    if ([alarm.alarmLabel isEqualToString:@"Alarm"]) {
        nameLabel.text = MNLocalizedString(@"alarm_default_label", @"Alarm");
    }else{
        nameLabel.text = alarm.alarmLabel;
    }
    nameLabel.textColor = [MNTheme getSubFontUIColor];
    
    // Dividing Bar
    UIImageView *dividingBarImageView = (UIImageView *)[cell viewWithTag:105];
//    dividingBarImageView.image = [UIImage imageNamed:[MNTheme getAlarmDividingBarResourceName]];
    
    // AlarmSwitch
    UIButton *alarmSwitchButton = (UIButton *)[cell viewWithTag:104];
    if (alarmSwitchButton == nil) {
        alarmSwitchButton = (UIButton *)[cell viewWithTag:row + ALARM_SWITCH_TAG_OFFSET];
    }
    
    // 테마별 이미지 적용 - UIControlStateNormal 만으로 스위치 기능하기 - 터치시 이미지 유지를 위해
    if (alarm.isAlarmOn) {
        [alarmSwitchButton setImage:[UIImage imageNamed:[MNTheme getAlarmSwitchOnResourceName]] forState:UIControlStateNormal];
        dividingBarImageView.image = [UIImage imageNamed:[MNTheme getAlarmDividingBarOnResourceName]];
    }else{
        [alarmSwitchButton setImage:[UIImage imageNamed:[MNTheme getAlarmSwitchOffResourceName]] forState:UIControlStateNormal];
        dividingBarImageView.image = [UIImage imageNamed:[MNTheme getAlarmDividingBarOffResourceName]];
    }
    
    // 터치시 식별을 위해 row+1000를 태그로 설정
    alarmSwitchButton.tag = row + ALARM_SWITCH_TAG_OFFSET;
    alarmSwitchButton.alpha = 1;
    [alarmSwitchButton addTarget:tableView action:@selector(alarmSwitchButtonDidChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    // 스크롤 뷰를 추가
    MNAlarmScrollItemView *scrollView = (MNAlarmScrollItemView *)[cell viewWithTag:106];
    scrollView.alpha = 1;
    scrollView.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    scrollView.MNDelegate = (id<MNAlarmScrollItemViewDelegate>)delegate;
    scrollView.alarmSwitchButton = alarmSwitchButton;
    scrollView.alarm = alarm;
    [scrollView initScrollView];
    [scrollView initAlarmView];
    
    // 알람 스위치 상태에 따라 비활성화, 반복 설정 해 주기
    [self changeTimeAndRepeatLabelWithSwitchOn:alarm.isAlarmOn withAlarmView:cell withAlarm:alarm];
    
//    repeatLabel.alpha = 1;
//    repeatLabel.text = @"temp";
//    repeatLabel.textColor = [UIColor blackColor];
//    repeatLabel.backgroundColor = [UIColor redColor];
//    OHAttributedLabel *label = (OHAttributedLabel *)[cell viewWithTag:600];
//    [label setText:@"Temp"];
//    [label setTextColor:[UIColor redColor]];
//    NSMutableAttributedString *string = [label.attributedText mutableCopy];
//    [string setTextColor:[UIColor blackColor]];
//    label.attributedText = string;
    
//    cell.exclusiveTouch = YES;
    return cell;
}

+ (void)makeAttributedRepeatLabelWithLabel:(OHAttributedLabel *)repeatLabel withAlarm:(MNAlarm *)alarm {
    // 월화수목금토일 을 전부 만들고, 각 알람의 반복 여부에 따라서 attribute 설정을 해 준다.
    /*
     "monday_short" = "M";
     "tuesday_short" = "T";
     "wednesday_short" = "W";
     "thursday_short" = "T";
     "friday_short" = "F";
     "saturday_short" = "S";
     "sunday_short" = "S";
     */
    
    // 추가 - 주중, 주말 매일 스트링 제작
//    NSLog(@"%@", [MNAlarmRepeatDayOfWeekStringMaker makeStringWithAlarmRepeatDayOfWeekArray:alarm.alarmRepeatDayOfWeek]);
    NSString *repeatString = [MNAlarmRepeatDayOfWeekStringMaker makeStringWithAlarmRepeatDayOfWeekArray:alarm.alarmRepeatDayOfWeek];
    
    if ([repeatString isEqualToString:MNLocalizedString(@"alarm_pref_repeat_everyday", @"매일")] || [repeatString isEqualToString:MNLocalizedString(@"alarm_pref_repeat_weekdays", @"주중")] || [repeatString isEqualToString:MNLocalizedString(@"alarm_pref_repeat_weekends", @"주말")]) {
        // 이 스트링으로 교체하고 전체 주 폰트 색으로 변경
        repeatLabel.text = [NSString stringWithFormat:@"/ %@", repeatString];
        repeatLabel.textColor = [MNTheme getMainFontUIColor];
        
    }else{
        repeatLabel.text = @"/ M T W T F S S";
        NSMutableAttributedString *attributedString = [repeatLabel.attributedText mutableCopy];
        [attributedString setTextAlignment:kCTTextAlignmentLeft lineBreakMode:kCTLineBreakByWordWrapping range:NSMakeRange(0, attributedString.length)];
        
        // 다국어 처리
        [attributedString replaceCharactersInRange:NSMakeRange(2, 1) withString:MNLocalizedString(@"monday_short", @"월")];
        [attributedString replaceCharactersInRange:NSMakeRange(4, 1) withString:MNLocalizedString(@"tuesday_short", @"화")];
        [attributedString replaceCharactersInRange:NSMakeRange(6, 1) withString:MNLocalizedString(@"wednesday_short", @"수")];
        [attributedString replaceCharactersInRange:NSMakeRange(8, 1) withString:MNLocalizedString(@"thursday_short", @"목")];
        [attributedString replaceCharactersInRange:NSMakeRange(10, 1) withString:MNLocalizedString(@"friday_short", @"금")];
        [attributedString replaceCharactersInRange:NSMakeRange(12, 1) withString:MNLocalizedString(@"saturday_short", @"토")];
        [attributedString replaceCharactersInRange:NSMakeRange(14, 1) withString:MNLocalizedString(@"sunday_short", @"일")];
        
        // 반복 여부에 따라 색 만들기
        [attributedString setTextColor:[MNTheme getMainFontUIColor]];
        
        for (int i=0; i < alarm.alarmRepeatDayOfWeek.count; i++) {
            BOOL isRepeat = ((NSNumber *)[alarm.alarmRepeatDayOfWeek objectAtIndex:i]).boolValue;
            //        NSLog(@"isRepeat: %d", isRepeat);
            
            if (!isRepeat) {
                [attributedString setTextColor:[MNTheme getSubFontUIColor] range:NSMakeRange((i+1) * 2, 1)];
            }
        }
        repeatLabel.attributedText = attributedString;
    }
}

#pragma mark - chagne alarm label state from alarm on/off state

+ (void)changeTimeAndRepeatLabelWithSwitchOn:(BOOL)isSwitchOn withAlarmView:(UIView *)alarmView withAlarm:(MNAlarm *)alarm{
    
    // 추가: 알람 뷰를 얻어내서, 비활성화와 반복 부분 표시 설정해주기
    //    NSLog(@"%@", alarmView.description);
    
    // 필요한 뷰들을 미리 읽기
    UILabel *alarmTimeLabel = (UILabel *)[alarmView viewWithTag:101];
    UILabel *ampmLabel = (UILabel *)[alarmView viewWithTag:102];
    OHAttributedLabel *repeatLabel = (OHAttributedLabel *)[alarmView viewWithTag:200];
    UIImageView *dividingBarImageView = (UIImageView *)[alarmView viewWithTag:105];
    
    if (isSwitchOn) {
        alarmTimeLabel.textColor = [MNTheme getMainFontUIColor];
        ampmLabel.textColor = [MNTheme getMainFontUIColor];
        if (alarm.isRepeatOn) {
            repeatLabel.alpha = 1;
        }else{
            repeatLabel.alpha = 0;
        }
        dividingBarImageView.image = [UIImage imageNamed:[MNTheme getAlarmDividingBarOnResourceName]];
    }else{
        alarmTimeLabel.textColor = [MNTheme getSubFontUIColor];
        ampmLabel.textColor = [MNTheme getSubFontUIColor];
        repeatLabel.alpha = 0;
        dividingBarImageView.image = [UIImage imageNamed:[MNTheme getAlarmDividingBarOffResourceName]];
    }
}


@end
