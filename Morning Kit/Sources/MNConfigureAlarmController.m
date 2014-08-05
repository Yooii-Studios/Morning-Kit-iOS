//
//  MNConfigureAlarmController.m
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 30..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNConfigureAlarmController.h"
#import "MNDefinitions.h"
//#import "MNAlarmListProcessor.h"
//#import "MNAlarmDateFormat.h"
//#import "MNAppDelegate.h"
#import "MNAlarmListProcessor.h"
#import "MNAlarmProcessor.h"
#import "MNAlarmCellProcessor.h"
#import "MNEffectSoundPlayer.h"
#import "MNMainAlarmTableView.h"
#import "MNTheme.h"
#import "MNUnlockManager.h"
#import "MNStoreController.h"

@interface MNConfigureAlarmController ()

@end

@implementation MNConfigureAlarmController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    self.alarmTableView.alarmList = [MNAlarmListProcessor loadAlarmList];
    [self.tableView reloadData];
    
    self.title = MNLocalizedString(@"tab_alarm", @"알람");
    self.navigationItem.rightBarButtonItem.title = MNLocalizedString(@"done", "완료");
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
    
    // 노티피케이션 센터에 리로드 관련 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAlarmTableView) name:CONFIGURE_ALARM_OBSERVER_NAME object:nil];
}

- (void)reloadAlarmTableView{
    self.alarmTableView.alarmList = [MNAlarmListProcessor loadAlarmList];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // iOS 7 이상이면 네비게이션 탭 변경
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.translucent = NO;
//        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
        // 타이틀
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeFont : [UIFont fontWithName:@"helvetica-bold" size:iOS7_NAV_TITLE_FONT_SIZE]};
    }
    
    self.alarmTableView.alarmList = [MNAlarmListProcessor loadAlarmList];
    
    MNAppDelegate *appDelegate = (MNAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.alarmDelegate = self;
    
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.rightBarButtonItem = self.navigationItem.rightBarButtonItem;

    // table inset top 맞추기
    self.tableView.contentInset = UIEdgeInsetsMake(CONTENT_INSET_TOP, 0, 0, 0);
    MNMainAlarmTableView * alarmTableView = (MNMainAlarmTableView *)self.tableView;
    alarmTableView.MNDelegate = self;
    alarmTableView.alarmList = self.alarmTableView.alarmList;
    alarmTableView.delaysContentTouches = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    // 노티피케이션 센터에 리로드 관련 해지
    [[NSNotificationCenter defaultCenter] removeObserver:self.tableView name:CONFIGURE_ALARM_OBSERVER_NAME object:nil];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - new alarmTable

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    
    // Configure the cell...
    if (indexPath.row == 0) {
        CellIdentifier  = @"AlarmAddCell_Configure";
        cell = [MNAlarmCellProcessor makeConfigureAddAlarmCell:CellIdentifier tableView:tableView withDelegate:self];
    }else{
        CellIdentifier  = @"AlarmScrollItemCell_Configure";
        cell = [MNAlarmCellProcessor makeAlarmItemCell:CellIdentifier tableView:tableView withRow:indexPath.row-1 withAlarmList:self.alarmTableView.alarmList withDelegate:self];
    }
    
    return cell;
}

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
    return 1 + self.alarmTableView.alarmList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ALARM_ITEM_HEIGHT + PADDING_INNER * 2;
}

#pragma mark - new table view delegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Navigation logic may go here. Create and push another view controller.
}

/*
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ALARM_ITEM_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + self.alarmTableView.alarmList.count;
//    NSLog(@"%d", 1 + self.alarmTableView.alarmList.count);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor colorWithRed:67.0/255 green:67.0/255 blue:67.0/255 alpha:1];
    
    // 셀 간 여백 추가
    UIView *cellSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, ALARM_ITEM_HEIGHT, 320 ,2)];
    [cellSeparator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
     UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleWidth];
    [cellSeparator setContentMode:UIViewContentModeTopLeft];
    [cellSeparator setBackgroundColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1]];
    [cell addSubview:cellSeparator];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        CellIdentifier  = @"AlarmAddCell_Configure";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }else{
        CellIdentifier  = @"AlarmItemCell_Configure";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 알람 아이템 초기화
        MNAlarm *alarm = [self.alarmTableView.alarmList objectAtIndex:indexPath.row - 1];
        
        // locale 에 맞는 알람 시간 설정을 위한 클래스
        MNAlarmDateFormat *alarmDateFormat = [MNAlarmDateFormat alarmDateFormatWithDate:alarm.alarmDate];
        
        // 101 시간 / 102 AM / 103 레이블 / 104 버튼
        // Alarm Time
        UILabel *alarmTimeLabel = (UILabel *)[cell viewWithTag:101];
        alarmTimeLabel.text = alarmDateFormat.alarmTimeString;
        
        // AM PM
        UILabel *ampmLabel = (UILabel *)[cell viewWithTag:102];
        if (alarmDateFormat.isUsing24hours == NO) {
            ampmLabel.text = alarmDateFormat.ampmString;
            
            // 시가 한 자리 수면 위치를 좀 더 왼쪽으로 당기기
            if (alarmDateFormat.hourForString < 10) {
                [ampmLabel setFrame:CGRectMake(alarmTimeLabel.frame.origin.x + alarmTimeLabel.frame.size.width - 15,
                                               ampmLabel.frame.origin.y,
                                               ampmLabel.frame.size.width,
                                               ampmLabel.frame.size.height)];
            }
            ampmLabel.alpha = 1;
        }else{
            ampmLabel.alpha = 0;
        }
        
        // Name
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:103];
        nameLabel.text = alarm.alarmLabel;
        
        // Button
        UIButton *button = (UIButton *)[cell viewWithTag:104];
        button.alpha = 1;
    }
    
    // 셀 간 여백 추가
    UIView *cellSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, ALARM_ITEM_HEIGHT, 320, ALARM_SEPERATOR_HEIGHT)];
    [cellSeparator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
     UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleWidth];
    [cellSeparator setContentMode:UIViewContentModeTopLeft];
    [cellSeparator setBackgroundColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1]];
    [cell addSubview:cellSeparator];

    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [MNAlarmListProcessor removeAlarmAtIndex:indexPath.row - 1 fromAlarmList:self.alarmTableView.alarmList];
//        [self.alarmTableView.alarmList removeObjectAtIndex:indexPath.row - 1];
        [MNAlarmListProcessor saveAlarmList:self.alarmTableView.alarmList];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

/*
#pragma mark - Table view delegate

// 원하지 않을 경우 segue를 넘기지 않기 위한 꼼수
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 추가 셀이고 수정 상태가 아니거나, 알람 셀이면서 수정 상태일 경우만 preferenceController를 실행 
    if ((indexPath.row == 0 && self.tableView.editing == NO) || (indexPath.row != 0 && self.tableView.editing)) {
        return indexPath;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Navigation logic may go here. Create and push another view controller.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    // 수정 시에는 오른쪽 버튼을 가리기
    if (self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    }
    
    // Edit 모드에 따라 추가 셀과 알람 셀의 상태 변경하기
    NSArray* cells =  [self.tableView visibleCells];
    NSInteger count = 0;
    for (UITableViewCell *cell in cells) {
        UIButton *alarmSwitchButton = (UIButton *)[cell viewWithTag:104];
        
        if (editing == YES) {
            if (count == 0) {
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }else{
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                [UIView animateWithDuration:0.3 animations:^{
                    alarmSwitchButton.alpha = 0;
                    [alarmSwitchButton setFrame:CGRectMake(alarmSwitchButton.frame.origin.x - 50,
                                                           alarmSwitchButton.frame.origin.y,
                                                           alarmSwitchButton.frame.size.width,
                                                           alarmSwitchButton.frame.size.height)];
                }];
            }
        }else{
            if (count == 0) {
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            }else{
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [UIView animateWithDuration:0.3 animations:^{
                    alarmSwitchButton.alpha = 1;
                    [alarmSwitchButton setFrame:CGRectMake(225,
                                                           alarmSwitchButton.frame.origin.y,
                                                           alarmSwitchButton.frame.size.width,
                                                           alarmSwitchButton.frame.size.height)];

                }];
            }
        }
        count += 1;
    }
    
    // 테이블의 수정 상태 변경 
    [self.tableView setEditing:editing animated:YES];
}


// 스와이프시 딜리트 버튼이 뜨지 않는 메서드. 나중에 필요하면 주석처리할 것이지만 이게 없으면 너무 안예쁘게 지워진다.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
    if (self.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}
 */

#pragma mark - Prepare For Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ConfigureAlarmPreferenceSegue_Add"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        MNAlarmPreferenceController *alarmPreferenceController = (MNAlarmPreferenceController *)navigationController.topViewController;
        alarmPreferenceController.MNDelegate = self;
        alarmPreferenceController.isAlarmNew = YES;
        
    }else if([[segue identifier] isEqualToString:@"ConfigureAlarmPreferenceSegue_Edit"]){
        UINavigationController *navigationController = segue.destinationViewController;
        MNAlarmPreferenceController *alarmPreferenceController = (MNAlarmPreferenceController *)navigationController.topViewController;
        alarmPreferenceController.MNDelegate = self;
        alarmPreferenceController.isAlarmNew = NO;
        self.selectedRow = [self.tableView indexPathForSelectedRow].row - 1;
        alarmPreferenceController.alarmInPreference = [self.alarmTableView.alarmList objectAtIndex:self.selectedRow];
    }
}

#pragma mark - Navigation Button Methods

- (IBAction)doneButtonClicked:(id)sender {
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_SETTING];
    [self.delegate doneButtonClicked];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MNAlarmPreferenceController Delegate Methods

- (void)MNAlarmPreferenceControllerDidSaveAlarm:(MNAlarmPreferenceController *)controller {
    if (controller.isAlarmNew) {
//        [self.alarmTableView.alarmList addObject:controller.alarmInPreference];
        [MNAlarmListProcessor addAlarm:controller.alarmInPreference intoAlarmList:self.alarmTableView.alarmList];
    }else{
//        [self.alarmTableView.alarmList replaceObjectAtIndex:self.selectedRow withObject:controller.alarmInPreference];
        [MNAlarmListProcessor replaceAlarm:controller.alarmInPreference atIndex:self.selectedRow inAlarmList:self.alarmTableView.alarmList];
    }
    [MNAlarmListProcessor saveAlarmList:self.alarmTableView.alarmList];
    
    [self.tableView reloadData];
}

#pragma mark - MNAlarmListControllerDelegate Delegate Method

// 앱을 나갔다가 24시간제를 변경하고 들어올 때 바로 구현하고 싶었으나 24시간제 확인하는 로직이 문제인지 다른 화면으로 갔다가 와야만 변경이 됨.
- (void)MNAlarmListShouldBeReloaded {
    [self.tableView reloadData];
}


#pragma mark - MNMainAlarmTableView delegate method

// 알람테이블뷰에서 클릭이 넘어오면 메인 알람 리스트에서 알람 on/off 해 주고, archive 하고, 테이블 리로드
- (void)alarmItemSwitchClicked:(int)index {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [MNAlarmProcessor processAlarmSwitchButtonTouchAction:self.alarmTableView.alarmList atIndex:index];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [self.alarmTableView reloadData];
        //        });
    });
    
//    [MNAlarmProcessor processAlarmSwitchButtonTouchAction:self.alarmTableView.alarmList atIndex:index];
//    [self.tableView reloadData];
}


#pragma mark - MNAlarmScrollItemView delegate method

- (void)alarmItemClickedToPresentAlarmPreferenceModalController:(int)index {
    //    NSLog(@"alarmItemClickedToPresentAlarmPreferenceModalController");
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK];
    
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        NSLog(@"Loading an iPhone storyboard");
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle:[NSBundle mainBundle]];
    }else{
//        NSLog(@"Loading an iPad storyboard");
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPad" bundle:[NSBundle mainBundle]];
    }
    
    // Navigation instantiation from storyboard
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"AlarmPreferenceNavigationController"];
    
    // AlarmPreferenceController initialization
    MNAlarmPreferenceController *alarmPreferenceController = (MNAlarmPreferenceController *)navigationController.topViewController;
    alarmPreferenceController.MNDelegate = self;
    alarmPreferenceController.isAlarmNew = NO;
    self.selectedRow = index;
    alarmPreferenceController.alarmInPreference = [self.alarmTableView.alarmList objectAtIndex:self.selectedRow];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

// Swipe 되면 그 인덱스 알람 취소하고 삭제해주기 - 인덱스에서 ID로 변경
- (void)alarmItemHadSwipedToBeRemovedWithAlarmID:(NSInteger)alarmID {
    /*
    [MNAlarmListProcessor removeAlarmWithAlarmID:alarmID fromAlarmList:self.alarmTableView.alarmList];
    //        [MNAlarmListProcessor removeAlarmAtIndex:index fromAlarmList:self.alarmTableView.alarmList];
    
    // 변경한 알람 저장
    [MNAlarmListProcessor saveAlarmList:self.alarmTableView.alarmList];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    */

    // 디스패치를 써서 구현
    dispatch_queue_t dQueue = dispatch_get_global_queue(DISPATCH_QUEUE_SERIAL, 0);
    dispatch_async(dQueue, ^{
        [MNAlarmListProcessor removeAlarmWithAlarmID:alarmID fromAlarmList:self.alarmTableView.alarmList];
        //        [MNAlarmListProcessor removeAlarmAtIndex:index fromAlarmList:self.alarmTableView.alarmList];
        
        // 변경한 알람 저장
        [MNAlarmListProcessor saveAlarmList:self.alarmTableView.alarmList];
        
        // UI 처리
        dispatch_async(dispatch_get_main_queue(), ^{
            // 알람 테이블뷰 재로딩
            [self.tableView reloadData];
        });
    });
    //    dispatch_release(dQueue);
}

/*
- (void)alarmItemHadSwipedToBeRemoved:(int)index {
    
    // 디스패치를 써서 구현
    dispatch_queue_t dQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dQueue, ^{
        [MNAlarmListProcessor removeAlarmAtIndex:index fromAlarmList:self.alarmTableView.alarmList];
        
        // 변경한 알람 저장
        [MNAlarmListProcessor saveAlarmList:self.alarmTableView.alarmList];
        
        // UI 처리
        dispatch_async(dispatch_get_main_queue(), ^{
            // 알람 테이블뷰 재로딩
            [self.tableView reloadData];
        });
    });
//    dispatch_release(dQueue);
}
*/

#pragma mark - MNAlarmAddItem delegate method

- (void)alarmAddItemClickedToPresentAlarmPreferenceModalController {
    
    [MNAlarmProcessor checkAlarmGuideMessage];
    
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK];
    
    if (self.alarmTableView.alarmList.count >= ALARM_NUMBER_UNLOCK_LIMIT && [[NSUserDefaults standardUserDefaults] boolForKey:STORE_PRODUCT_ID_MORE_ALARM_DECKS] == NO) {
        [MNUnlockManager showUnlockControllerWithProductID:STORE_PRODUCT_ID_MORE_ALARM_DECKS withController:self];
        return;
    }
    
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //        NSLog(@"Loading an iPhone storyboard");
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle:[NSBundle mainBundle]];
    }else{
        //        NSLog(@"Loading an iPad storyboard");
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPad" bundle:[NSBundle mainBundle]];
    }
    
    // Navigation instantiation from storyboard
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"AlarmPreferenceNavigationController"];
    
    // AlarmPreferenceController initialization
    MNAlarmPreferenceController *alarmPreferenceController = (MNAlarmPreferenceController *)navigationController.topViewController;
    alarmPreferenceController.MNDelegate = self;
    alarmPreferenceController.isAlarmNew = YES;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
