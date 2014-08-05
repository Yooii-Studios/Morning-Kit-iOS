//
//  MNAlarmPreferenceController.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 3..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNAlarmPreferenceController.h"
#import "MNAlarmProcessor.h"
#import "MNAlarmRepeatDayOfWeekStringMaker.h"
#import "MNAlarmSong.h"
#import "MNAlarmSoundProcessor.h"
#import "MNAlarmSongValidator.h"
#import "MNDefinitions.h"
#import "MNEffectSoundPlayer.h"
#import "MNTheme.h"

@interface MNAlarmPreferenceController ()

@end

@implementation MNAlarmPreferenceController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initWithNewAlarm
{
//    self.title = @"Add Alarm";
    self.title = MNLocalizedString(@"add_an_alarm", @"Add Alarm");
    
    // 새 알람 생성 - 생성할 때 검증까지 전부 마침
    self.alarmInPreference = [MNAlarmProcessor makeAlarm];
}

- (void)initWithEditingAlarm {
//    self.title = @"Edit Alarm";
    self.title = MNLocalizedString(@"edit_alarm", @"Add Alarm");
    
    // 받아온 알람을 가지고 초기화
    
    // 알람이 만약 노래라면 validation 하기
    if ([MNAlarmSoundProcessor checkValidateAlarmSound:self.alarmInPreference.alarmSound] == NO) {
        self.alarmInPreference.alarmSound = nil;
        self.alarmInPreference.alarmSound = [MNAlarmSoundProcessor loadDefaultAlarmSound];
        
//        NSLog(@"%@ / Sound is not valid, set to default sound", self.class);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // 첫 알람 공지 메시지 확인
    [MNAlarmProcessor checkAlarmGuideMessage];
    
    // Navigation Item
    self.navigationItem.leftBarButtonItem.title = MNLocalizedString(@"cancel", @"Cancel");
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleBordered;
    
    self.navigationItem.rightBarButtonItem.title = MNLocalizedString(@"done", @"Done");
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
    
    // AlarmPreferenceTable init
    self.alarmPreferenceTableView.dataSource = self;
    self.alarmPreferenceTableView.delegate = self;
        
    // 알람 생성, 수정에 따라 다른 초기화를 해줌
    if (self.isAlarmNew) {
        [self initWithNewAlarm];
    }else{
        [self initWithEditingAlarm];
    }
    
    // DatePicker
//    NSLog(@"%@", self.alarmInPreference.alarmDate.description);
    self.alarmTimePicker.locale = [NSLocale currentLocale];
    self.alarmTimePicker.timeZone = [NSTimeZone localTimeZone];
    self.alarmTimePicker.date = self.alarmInPreference.alarmDate;
    [self.alarmTimePicker addTarget:self action:@selector(alarmTimeChanged:) forControlEvents:UIControlEventValueChanged];
    
    // 테마
    self.alarmPreferenceTableView.backgroundColor = [MNTheme getAlarmPrefBackgroundUIColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    
    if (indexPath.row == 1) {
        CellIdentifier = @"alarm_pref_repeat_cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // 600 타이틀, 601 디테일, 603 밑줄
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:600];
        titleLabel.textColor = [MNTheme getAlarmPrefMainFontUIColor];
        UILabel *detailLabel = (UILabel *)[cell viewWithTag:601];
        detailLabel.textColor = [MNTheme getAlarmPrefSubFontUIColor];
        UIView *seperateLine = [cell viewWithTag:603];
        seperateLine.backgroundColor = [MNTheme getAlarmPrefSeperateLineUIColor];
        
        titleLabel.text = MNLocalizedString(@"alarm_pref_repeat", @"반복");
        detailLabel.text = [MNAlarmRepeatDayOfWeekStringMaker makeStringWithAlarmRepeatDayOfWeekArray:self.alarmInPreference.alarmRepeatDayOfWeek];
        self.repeatCell = cell;
        
    }else if(indexPath.row == 2) {
        CellIdentifier = @"alarm_pref_sound_cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // 커스터마이징
        // 600 타이틀, 601 디테일, 603 밑줄
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:600];
        titleLabel.textColor = [MNTheme getAlarmPrefMainFontUIColor];
        UILabel *detailLabel = (UILabel *)[cell viewWithTag:601];
        detailLabel.textColor = [MNTheme getAlarmPrefSubFontUIColor];
        UIView *seperateLine = [cell viewWithTag:603];
        seperateLine.backgroundColor = [MNTheme getAlarmPrefSeperateLineUIColor];
        
        titleLabel.text = MNLocalizedString(@"alarm_pref_sound_type", @"소리");
        
        // 새로 설정하는 알람이면 최근 선택 소리를 표시하기
        if (self.isAlarmNew) {
            self.latestSelectedAlarmSound = [MNAlarmSoundProcessor loadAlarmSoundFromHistory];
            detailLabel.text = self.latestSelectedAlarmSound.title;
        }else{
            switch (self.alarmInPreference.alarmSound.alarmSoundType) {
                case MNAlarmSoundTypeSong:
                    detailLabel.text = self.alarmInPreference.alarmSound.title;
                    break;
                    
                case MNAlarmSoundTypeRingtone:
                    detailLabel.text = self.alarmInPreference.alarmSound.title;
                    break;
                    
                case MNAlarmSoundTypeVibrate:
                    detailLabel.text = MNLocalizedString(@"alarm_sound_string_vibrate", nil);
                    break;
                    
                // 일어나면 안되는 상황
                case MNAlarmSoundTypeNone:
                    detailLabel.text = @"Error";
                    break;
            }
        }
        self.soundCell = cell;
        
    }else if(indexPath.row == 3) {
        CellIdentifier = @"alarm_pref_snooze_cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        self.snoozeCell = cell;
        
        // 커스터마이징
        // 600 타이틀, 601 디테일, 603 밑줄
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:600];
        titleLabel.textColor = [MNTheme getAlarmPrefMainFontUIColor];
        UIView *seperateLine = [cell viewWithTag:603];
        seperateLine.backgroundColor = [MNTheme getAlarmPrefSeperateLineUIColor];
        
//        UILabel *snoozeLabel = (UILabel *)[cell viewWithTag:102];
        titleLabel.text = MNLocalizedString(@"alarm_wake_snooze", @"스누즈");
        self.alarmSnoozeSwitch = (UISwitch *)[cell viewWithTag:101];
        [self.alarmSnoozeSwitch addTarget:self action:@selector(alarmSnoozeSwitchDidChanged:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.isAlarmNew) {
            [self.alarmSnoozeSwitch setOn:YES];
        }else{
            [self.alarmSnoozeSwitch setOn:self.alarmInPreference.isSnoozeOn];
        }
        
    }else {
        CellIdentifier = @"alarm_pref_label_cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // 커스터마이징
        // 600 타이틀, 601 디테일, 603 밑줄
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:600];
        titleLabel.textColor = [MNTheme getAlarmPrefMainFontUIColor];
        UILabel *detailLabel = (UILabel *)[cell viewWithTag:601];
        detailLabel.textColor = [MNTheme getAlarmPrefSubFontUIColor];
        UIView *seperateLine = [cell viewWithTag:603];
        seperateLine.backgroundColor = [MNTheme getAlarmPrefSeperateLineUIColor];
        
//        cell.textLabel.text = MNLocalizedString(@"alarm_pref_label", @"레이블");
        titleLabel.text = MNLocalizedString(@"alarm_pref_label", @"레이블");
//        titleLabel.backgroundColor = [UIColor blueColor];
        self.labelCell = cell;
//        self.labelCell.textLabel.text = self.alarmInPreference.alarmLabel;
        if ([self.alarmInPreference.alarmLabel isEqualToString:@"Alarm"]) {
//            self.labelCell.detailTextLabel.text = MNLocalizedString(@"alarm_default_label", @"Alarm");
            detailLabel.text = MNLocalizedString(@"alarm_default_label", @"Alarm");
        }else{
//            self.labelCell.detailTextLabel.text = self.alarmInPreference.alarmLabel;
            detailLabel.text = self.alarmInPreference.alarmLabel;
        }
//        detailLabel.backgroundColor = [UIColor redColor];
    }
    
//    cell.contentView.backgroundColor = [MNTheme getAlarmPrefBackgroundUIColor];
//    cell.accessoryView.backgroundColor = [MNTheme getAlarmPrefBackgroundUIColor];
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [MNTheme getAlarmPrefBackgroundUIColor];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.alarmPreferenceTableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - navigation methods

- (IBAction)cancelButtonTouched:(id)sender {
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK_CLOSE];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonTouched:(id)sender {
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK_CLOSE];
    [self.MNDelegate MNAlarmPreferenceControllerDidSaveAlarm:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - prepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"AlarmPreferenceRepeatSegue"])
    {
        MNAlarmPreferenceRepeatController *alarmPreferenceRepeatController = segue.destinationViewController;
        alarmPreferenceRepeatController.delegate = self;
        alarmPreferenceRepeatController.alarmRepeatDayOfWeek = self.alarmInPreference.alarmRepeatDayOfWeek;
        
    }else if([[segue identifier] isEqualToString:@"AlarmPreferenceSoundSegue"]){
        MNAlarmPreferenceSoundController *alarmPreferenceSoundController = segue.destinationViewController;
        alarmPreferenceSoundController.delegate = self;
        switch (self.alarmInPreference.alarmSound.alarmSoundType) {
            case MNAlarmSoundTypeSong:
                alarmPreferenceSoundController.previousAlarmSong = self.alarmInPreference.alarmSound.alarmSong;
                alarmPreferenceSoundController.alarmSoundType = MNAlarmSoundTypeSong;
                break;
                
            case MNAlarmSoundTypeRingtone:
                alarmPreferenceSoundController.previousAlarmRingtone = self.alarmInPreference.alarmSound.alarmRingtone;
                alarmPreferenceSoundController.alarmSoundType = MNAlarmSoundTypeRingtone;
                break;
                
            case MNAlarmSoundTypeVibrate:
                alarmPreferenceSoundController.alarmSoundType = MNAlarmSoundTypeVibrate;
                break;
                
            // 일어나면 안되는 상황
            case MNAlarmSoundTypeNone:
                break;
        }
        
    }else if([[segue identifier] isEqualToString:@"AlarmPreferenceLabelSegue"]){
        MNAlarmPreferenceLabelController *alarmPreferenceLabelController = segue.destinationViewController;
        alarmPreferenceLabelController.delegate = self;
        
        UILabel *detailLabel = (UILabel *)[self.labelCell viewWithTag:601];
        alarmPreferenceLabelController.alarmLabel = detailLabel.text;
    }
}

#pragma mark - MNAlarmPreferenceLabelController Delegate Methods

- (void)MNAlarmPreferenceLabelControllerDidAlarmLabelSetting:(MNAlarmPreferenceLabelController *)controller {
    
    UILabel *detailLabel = (UILabel *)[self.labelCell viewWithTag:601];
    
    if ([controller.alarmLabelTextField.text isEqualToString:MNLocalizedString(@"alarm_default_label", @"Alarm")]) {
        detailLabel.text = controller.alarmLabelTextField.text;
        self.alarmInPreference.alarmLabel = @"Alarm";
    }else{
        detailLabel.text = controller.alarmLabelTextField.text;
        self.alarmInPreference.alarmLabel = controller.alarmLabelTextField.text;
    }
}

#pragma mark - MNAlarmPreferenceRepeatController Delegate Methods

- (void)MNAlarmPreferenceRepeatControllerDidSelectingRepeat:(MNAlarmPreferenceRepeatController *)controller {
    // 1. alarmInPreference 의 repeat 에 controller의 repeat을 대입해 줌 (NSMutableArray 안의 NSNumber들의 모임)
    self.alarmInPreference.alarmRepeatDayOfWeek = controller.alarmRepeatDayOfWeek;
    self.alarmInPreference.isRepeatOn = NO;
    
    for (NSNumber *repeatDayOfWeek in self.alarmInPreference.alarmRepeatDayOfWeek) {
//        NSLog(@"repeat : %@", [repeatDayOfWeek boolValue]? @"YES" : @"NO");
        
        if (repeatDayOfWeek.boolValue == YES) {
            self.alarmInPreference.isRepeatOn = YES;
        }
    }
    
    
    // 2. 셀의 String을 변경해준다.
    UILabel *detailLabel = (UILabel *)[self.repeatCell viewWithTag:601];
    
    NSString *alarmRepeatString = [MNAlarmRepeatDayOfWeekStringMaker makeStringWithAlarmRepeatDayOfWeekArray:controller.alarmRepeatDayOfWeek];
    
    detailLabel.text = alarmRepeatString;
}

#pragma mark - MNAlarmPreferenceSoundController Delegate Methods

// 노래를 고를 경우의 처리
- (void)MNAlarmPreferenceSoundControllerDidPickSong:(MNAlarmPreferenceSoundController *)controller {
    MNAlarmSong *selectedAlarmSong = [controller.songsHistoryList objectAtIndex:controller.checkedIndexPath.row];
    
    if (MN_DEBUG) {
        NSLog(@"MNAlarmPreferenceSoundControllerDidPickSong: %@", selectedAlarmSong.title);
    }

    self.alarmInPreference.alarmSound.alarmSoundType = MNAlarmSoundTypeSong;

    self.alarmInPreference.alarmSound.title = selectedAlarmSong.title;
    
    self.alarmInPreference.alarmSound.alarmRingtone = nil;
    self.alarmInPreference.alarmSound.alarmSong = selectedAlarmSong;

    UILabel *detailLabel = (UILabel *)[self.soundCell viewWithTag:601];
    
    detailLabel.text = self.alarmInPreference.alarmSound.alarmSong.title;
}

// 벨소리를 고를 경우의 처리
- (void)MNAlarmPreferenceSoundControllerDidPickRingtone:(MNAlarmPreferenceSoundController *)controller {
    MNAlarmRingtone *selectedAlarmRingtone = [controller.ringtonesList objectAtIndex:controller.checkedIndexPath.row];
    
    if (MN_DEBUG) {
        NSLog(@"MNAlarmPreferenceSoundControllerDidPickRingtone: %@", selectedAlarmRingtone.title);
    }

    self.alarmInPreference.alarmSound.alarmSoundType = MNAlarmSoundTypeRingtone;
    
    self.alarmInPreference.alarmSound.title = selectedAlarmRingtone.title;
    
    self.alarmInPreference.alarmSound.alarmRingtone = selectedAlarmRingtone;
    self.alarmInPreference.alarmSound.alarmSong = nil;

    UILabel *detailLabel = (UILabel *)[self.soundCell viewWithTag:601];
    detailLabel.text = self.alarmInPreference.alarmSound.alarmRingtone.title;
}

// 음소거를 고를 경우의 처리
- (void)MNAlarmPreferenceSoundControllerDidPickMute:(MNAlarmPreferenceSoundController *)controller {
    self.alarmInPreference.alarmSound.alarmSoundType = MNAlarmSoundTypeVibrate;

    NSString *vibrateString = MNLocalizedString(@"alarm_sound_string_vibrate", nil);
    self.alarmInPreference.alarmSound.title = vibrateString;
    
    self.alarmInPreference.alarmSound.alarmRingtone = nil;
    self.alarmInPreference.alarmSound.alarmSong = nil;

    UILabel *detailLabel = (UILabel *)[self.soundCell viewWithTag:601];
    detailLabel.text = vibrateString;
}

#pragma mark - Alarm Snooze Switch On/Off Handler

- (void)alarmSnoozeSwitchDidChanged:(UISwitch *)sender {
    self.alarmInPreference.isSnoozeOn = sender.isOn;
}

#pragma mark - Alarm Time Value Changed Handler

- (void)alarmTimeChanged:(UIDatePicker *)sender {
    self.alarmInPreference.alarmDate = sender.date;
}

@end
