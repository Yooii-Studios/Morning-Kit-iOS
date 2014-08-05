//
//  MNAlarmPreferenceSoundController.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 10..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNAlarmPreferenceSoundController.h"
#import "MNAlarmSongsLoadSaver.h"
#import "MNAlarmRingtonesLoadSaver.h"
#import "MNAlarm.h"
#import "MNAlarmSoundProcessor.h"
#import "MNDefinitions.h"

@interface MNAlarmPreferenceSoundController ()

@end

@implementation MNAlarmPreferenceSoundController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = MNLocalizedString(@"alarm_pref_sound_type", @"사운드");
    
    [self initMPMusicPlayer];
    
    // 아이폰 기본 알람 앱 처럼 음악 히스토리 리스트와 벨소리 리스트를 모델에서 가져온다
    self.songsHistoryList = [MNAlarmSongsLoadSaver loadSongsList];
    self.ringtonesList = [MNAlarmRingtonesLoadSaver loadRingtonesList];
    
    // 알람 타입에 따라 선택된 소리 체크 
    switch (self.alarmSoundType) {
        case MNAlarmSoundTypeSong:
            if (self.previousAlarmSong) {
                int i = 0;
                for (MNAlarmSong *alarmSong in self.songsHistoryList) {
                    if ([self.previousAlarmSong isEqualAlarmSong:alarmSong]) {
                        self.checkedIndexPath = [NSIndexPath indexPathForRow:i inSection:MNAlarmSoundTypeSong];
                    }
                    i++;
                }
            }
            break;
            
        case MNAlarmSoundTypeRingtone:
            if (self.previousAlarmRingtone) {
                int i = 0;
                for (MNAlarmRingtone *alarmRingtone in self.ringtonesList) {
                    if ([self.previousAlarmRingtone isEqualAlarmRingtone:alarmRingtone]) {
                        self.checkedIndexPath = [NSIndexPath indexPathForRow:i inSection:MNAlarmSoundTypeRingtone];
                    }
                    i++;
                }
            }
            break;
            
        case MNAlarmSoundTypeVibrate:
            self.checkedIndexPath = [NSIndexPath indexPathForRow:0 inSection:MNAlarmSoundTypeVibrate];
            break;
            
        // 일어나면 안되는 상황
        case MNAlarmSoundTypeNone:
            break;
    }
    
    // 뒤로 돌아갈 경우 음악을 꺼 준다. 다만 음악을 고르는 컨트롤러를 보여줄 경우는 끄지 않을 때를 위한 변수
    self.soundPlayerShouldStop = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 네비게이션 백 버튼을 클릭할 경우 발생
- (void)viewWillDisappear:(BOOL)animated {
    
//    NSLog(@"viewWillDisappear");
    // 사운드 타입 체크헤서 delegate 메서드 전달
    if (MN_DEBUG) {
//        NSLog(@"%d", self.alarmSoundType);
    }
    
    // 제대로 재생이 안 멈추는 경우가 있어, 확실히 멈추려고 이 코드를 더 추가.
    if (self.soundPlayerShouldStop) {
        if (self.musicPlayer && self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
            [self.musicPlayer stop];
        }
        if (self.ringtonePlayer && self.ringtonePlayer.isPlaying) {
            [self.ringtonePlayer stop];
        }
    }
    
    switch (self.alarmSoundType) {
        case MNAlarmSoundTypeSong:
            [self.delegate MNAlarmPreferenceSoundControllerDidPickSong:self];
            break;
            
        case MNAlarmSoundTypeRingtone:
            [self.delegate MNAlarmPreferenceSoundControllerDidPickRingtone:self];
            break;
            
        case MNAlarmSoundTypeVibrate:
            [self.delegate MNAlarmPreferenceSoundControllerDidPickMute:self];
            break;
            
        // 일어나면 안되는 상황
        case MNAlarmSoundTypeNone:
            break;
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
//    NSLog(@"viewDidDisappear");
    // PreferenceController 에 delegate 를 줌.
    
//     [self.delegate MNAlarmPreferenceSoundControllerDidDisappear:self];
    
    if (self.soundPlayerShouldStop) {
        if (self.musicPlayer && self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
            [self.musicPlayer stop];
        }
        if (self.ringtonePlayer && self.ringtonePlayer.isPlaying) {
            [self.ringtonePlayer stop];
        }
    }
    
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    
    // 뷰가 다시 나타날 때에는 뒤로 갈 가능성이 생기므로 viewDidDisapper에서 음악이 멈출 수 있게 하기
    self.soundPlayerShouldStop = YES;
    
    [super viewWillAppear:animated];
}

#pragma mark - init

- (void)initMPMusicPlayer {

#if TARGET_IPHONE_SIMULATOR
//    NSLog(@"ios simulator");
#else
//    NSLog(@"ios device");
    if (self.musicPlayer == nil) {
        self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        self.musicPlayer.repeatMode = MPMusicRepeatModeAll;
    }
#endif
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections. - 나중에 벨소리 완료하고, 3 섹션 None 추가하기.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 3;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Song
    if (section == MNAlarmSoundTypeSong) {
        return self.songsHistoryList.count + 1;     // 1(Pick a song cell)
    }
    // Ringtone
    else if(section == MNAlarmSoundTypeRingtone){
        return self.ringtonesList.count;
    }
    // Mute
    else{
        return 1;
    }
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"MP3";
    }else if(section == 1) {
        return @"Bell Sound";
    }
    return nil;
}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    
    // Songs
    if (indexPath.section == MNAlarmSoundTypeSong) {
        // Last Cell
        if (indexPath.row == self.songsHistoryList.count) {
            CellIdentifier = @"alarm_pref_sound_pick_a_song_cell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.textLabel.text = MNLocalizedString(@"alarm_pref_pick_your_favorite_sond", @"음악 선택");
        }
        // Song Cell
        else{
            CellIdentifier = @"alarm_pref_sound_item_cell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            MNAlarmSong *alarmSong = [self.songsHistoryList objectAtIndex:indexPath.row];
            cell.textLabel.text = alarmSong.title;
        }
    }
    // Ringtones
    else if(indexPath.section == MNAlarmSoundTypeRingtone){
        CellIdentifier = @"alarm_pref_sound_item_cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        MNAlarmRingtone *alarmRingtone = [self.ringtonesList objectAtIndex:indexPath.row];
        cell.textLabel.text = alarmRingtone.title;
    }
    // Mute
    else{
        CellIdentifier = @"alarm_pref_sound_item_cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text = MNLocalizedString(@"alarm_sound_string_vibrate", nil);
    }
    
    // 선택된 셀이 있을 경우 체크해주기 
    if (self.checkedIndexPath != nil && indexPath.section == self.checkedIndexPath.section && indexPath.row == self.checkedIndexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    
    return cell;
}

/*
 스와이프 삭제 기능 구현 후 막아놓은 상태 - 이사님과 삭제 후 동작에 관해 이야기 나누어 봐야할 것으로 생각.
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == MNAlarmSoundTypeSong && indexPath.row != self.songsHistoryList.count) {
        return YES;
    }
    return NO;
//    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == MNAlarmSoundTypeSong && indexPath.row != self.songsHistoryList.count) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
//    return UITableViewCellEditingStyleDelete;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.songsHistoryList removeObjectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [MNAlarmSongsLoadSaver saveSongsListWithSongsList:self.songsHistoryList];
        });
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

#pragma mark - check a newly selected cell and play / play or stop sound

// 이전 셀 선택 해제 하고 새 셀 선택하고 기존 노래 멈추고 새 노래 재생, 히스토리 저장
- (void)indicateCheckmarkToNewlySelectedCellWithIndexPath:(NSIndexPath *)indexPath {
    
    if (self.checkedIndexPath) {
        [self.tableView cellForRowAtIndexPath:self.checkedIndexPath].accessoryType = UITableViewCellAccessoryNone;
    }
    
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    self.checkedIndexPath = indexPath;

    switch (indexPath.section) {
        case MNAlarmSoundTypeSong:
            [self checkNewlySelectedCellAndPlayaSongWithIndexPath:indexPath];
            break;
            
        case MNAlarmSoundTypeRingtone:
            [self checkNewlySelectedCellAndPlayRingtoneWithIndexPath:indexPath];
            break;
            
        case MNAlarmSoundTypeVibrate:
            [self checkNewlySelectedMuteCellWithIndexPath:indexPath];
            break;
    }
}

- (void)checkNewlySelectedCellAndPlayaSongWithIndexPath:(NSIndexPath *)indexPath
{
    // 기존 노래 중지, 새 노래 재생
    if ([self.musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [self.musicPlayer stop];
    }
    MNAlarmSong *alarmSong = [self.songsHistoryList objectAtIndex:indexPath.row];
    [self.musicPlayer setQueueWithItemCollection:alarmSong.mediaItemCollection];
    [self.musicPlayer play];
    
    // soundType
    self.alarmSoundType = MNAlarmSoundTypeSong;
    
    // 히스토리에 저장
    MNAlarmSound *alarmSound = [MNAlarmSound alarmSoundWithAlarmType:self.alarmSoundType withAlarmSong:alarmSong withAlarmRingtone:nil];
    [MNAlarmSoundProcessor saveAlarmSoundToHistoryWithAlarmSound:alarmSound];
}

- (void)checkNewlySelectedCellAndPlayRingtoneWithIndexPath:(NSIndexPath *)indexPath
{    
    MNAlarmRingtone *alarmRingtone = [self.ringtonesList objectAtIndex:indexPath.row];
    
    //////////////////////////////
    // 진동에도 소리가 울리게 하는 코드 //
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    //                AudioSessionInitialize (NULL, NULL, NULL, NULL);
    //                AudioSessionSetActive(true);
    //
    //                // Allow playback even if Ring/Silent switch is on mute
    //                UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    //                AudioSessionSetProperty (kAudioSessionProperty_AudioCategory,
    //                                         sizeof(sessionCategory),&sessionCategory);
    //////////////////////////////
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:alarmRingtone.resource ofType:alarmRingtone.extensionType]];
    self.ringtonePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.ringtonePlayer prepareToPlay];
    [self.ringtonePlayer play];
    
    // soundType
    self.alarmSoundType = MNAlarmSoundTypeRingtone;
    
    // 히스토리에 저장
    MNAlarmSound *alarmSound = [MNAlarmSound alarmSoundWithAlarmType:self.alarmSoundType withAlarmSong:nil withAlarmRingtone:alarmRingtone];
    [MNAlarmSoundProcessor saveAlarmSoundToHistoryWithAlarmSound:alarmSound];
}

- (void)checkNewlySelectedMuteCellWithIndexPath:(NSIndexPath *)indexPath
{
    // 기존 노래 & 벨소리 재생 중지
    if (self.musicPlayer && [self.musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [self.musicPlayer stop];
    }
    if (self.ringtonePlayer && self.ringtonePlayer.isPlaying) {
        [self.ringtonePlayer stop];
    }
    
    // 진동 울림
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    // soundType
    self.alarmSoundType = MNAlarmSoundTypeVibrate;
    
    // 히스토리에 저장
    MNAlarmSound *alarmSound = [MNAlarmSound alarmSoundWithAlarmType:self.alarmSoundType withAlarmSong:nil withAlarmRingtone:nil];
    [MNAlarmSoundProcessor saveAlarmSoundToHistoryWithAlarmSound:alarmSound];
}

// 노래 재생 중이면 정지, 정지 중이면 재생
- (void)PlayOrStopSound:(NSIndexPath *)indexPath
{
//    NSLog(@"%d", indexPath.section);
    if (indexPath.section == MNAlarmSoundTypeSong) {
        if (self.musicPlayer) {
            
            if ([self.musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
                [self.musicPlayer stop];
            }else{
                MNAlarmSong *alarmSong = [self.songsHistoryList objectAtIndex:indexPath.row];
                [self.musicPlayer setQueueWithItemCollection:alarmSong.mediaItemCollection];
                [self.musicPlayer play];
            }
        }
    }else if(indexPath.section == MNAlarmSoundTypeRingtone) {
        if (self.ringtonePlayer) {
            if (self.ringtonePlayer.isPlaying) {
                [self.ringtonePlayer stop];
            }else{
                //////////////////////////////
                // 진동에도 소리가 울리게 하는 코드 //
                NSError *error = nil;
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
                [[AVAudioSession sharedInstance] setActive:YES error:&error];
                
//                AudioSessionInitialize (NULL, NULL, NULL, NULL);
//                AudioSessionSetActive(true);
//                
//                // Allow playback even if Ring/Silent switch is on mute
//                UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
//                AudioSessionSetProperty (kAudioSessionProperty_AudioCategory,
//                                         sizeof(sessionCategory),&sessionCategory);
                //////////////////////////////
                
                MNAlarmRingtone *alarmRingtone = [self.ringtonesList objectAtIndex:indexPath.row];
                NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:alarmRingtone.resource ofType:alarmRingtone.extensionType]];
                self.ringtonePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                [self.ringtonePlayer prepareToPlay];
                [self.ringtonePlayer play];
            }
        }else{
            // 미리 골라져 있는 벨소리를 들을 때
            [self checkNewlySelectedCellAndPlayRingtoneWithIndexPath:indexPath];
        }
    }else if(indexPath.section == MNAlarmSoundTypeVibrate) {
        // 기존 소리 정지
        if (self.ringtonePlayer && self.ringtonePlayer.isPlaying) {
            [self.ringtonePlayer stop];
        }
        if (self.musicPlayer && [self.musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
            [self.musicPlayer stop];
        }
        // 진동 재생 중이라면 정지, 정지라면 재생
//        NSLog(@"MNAlarmSoundTypeVibrate");
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
    }else{
        if (self.ringtonePlayer && self.ringtonePlayer.isPlaying) {
            [self.ringtonePlayer stop];
        }
        if (self.musicPlayer && [self.musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
            [self.musicPlayer stop];
        }
    }
}

#pragma mark - Table view delegate
// 사운드를 선택하는 알고리즘을 구현하는 아주 중요한 함수 - 로컬에서 최근의 선택 사항을 저장할 수 있게 구현해야 한다. 사운드 정보를 지닌 클래스를
// 영구 저장해서 초기화 과정에서 사운드 검증을 하고, 그 이후에 이 사운드 정보와 일치하는 NSIndexPath를 찾아내야 할 듯.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 1. 노래를 고르는 셀이면 노래 선택 컨트롤러를 푸시 (0 섹션의 제일 마지막 셀)
    if (indexPath.section == MNAlarmSoundTypeSong && indexPath.row == self.songsHistoryList.count) {
        // 컨트롤러 푸시
        MPMediaPickerController *mediaPickerController = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
        mediaPickerController.allowsPickingMultipleItems = NO;
        mediaPickerController.delegate = self;
        
        // 재생 중인 노래 정지하지 않기
        self.soundPlayerShouldStop = NO;
        
//        [self presentModalViewController:mediaPickerController animated:YES];
        [self presentViewController:mediaPickerController animated:YES completion:nil];
    }
    // 2. 노래 히스토리 선택 or 벨소리 선택
    else {
        // 같은 셀을 다시 클릭한다면, 체크는 유지하되 음악 재생을 정지하거나 다시 재생
        // 아니라면, 새로 선택한 셀로 체크하고 재생 및 처리.
        
        if (self.checkedIndexPath &&
            self.checkedIndexPath.section == indexPath.section && self.checkedIndexPath.row == indexPath.row) {
//            NSLog(@"same section, same row = same sound");
            [self PlayOrStopSound:indexPath];
        }else{
//            NSLog(@"not same section OR not same row in same section");
            [self indicateCheckmarkToNewlySelectedCellWithIndexPath:indexPath];
        }
    }
}

#pragma mark - MPMediaPickerController Delegate Methods

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    // 변수에 mediaItemCollection 추가
    self.selectedMediaItemCollection = mediaItemCollection;

    // 선택 음악 재생
    [self.musicPlayer setQueueWithItemCollection:self.selectedMediaItemCollection];
    [self.musicPlayer play];
    
    // 선택 음악 리스트에 추가 및 IndexPath 조정 (마지막에 추가, 5개 이상이면 첫번째 것 삭제)
    NSString *songTitle = [mediaItemCollection.representativeItem valueForProperty:MPMediaItemPropertyTitle];
    
    MNAlarmSong *selectedAlarmSong = [MNAlarmSong alarmSongWithTitle:songTitle withMediaItemCollection:mediaItemCollection];
    
    // 같은 이름의 노래가 있는지 체크 -
    int i = 0;
    BOOL isThereSameTitleOfSong = NO;
    for (MNAlarmSong *alarmSong in self.songsHistoryList) {
        if ([alarmSong.title isEqualToString:songTitle]) {
            isThereSameTitleOfSong = YES;
            break;
        }
        i++;
    }
    
    // 있다면 추가하지 않고 그대로 두고 선택된 셀을 원래 노래가 있던 위치로 수정
    if (isThereSameTitleOfSong) {
        self.checkedIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
    }
    // 없다면 추가
    else{
        // 5개 이상이면 제일 밑을 빼기
        if (self.songsHistoryList.count >= 5) {
            [self.songsHistoryList removeObjectAtIndex:0];
        }
        [self.songsHistoryList addObject:selectedAlarmSong];
        self.checkedIndexPath = [NSIndexPath indexPathForRow:self.songsHistoryList.count-1 inSection:0];
    }
    
    // 히스토리 리스트에 저장
    [MNAlarmSongsLoadSaver saveSongsListWithSongsList:self.songsHistoryList];
    
    // 최근 선택한 노래 히스토리에 저장
    MNAlarmSound *alarmSound = [MNAlarmSound alarmSoundWithAlarmType:self.alarmSoundType withAlarmSong:selectedAlarmSong withAlarmRingtone:nil];
    [MNAlarmSoundProcessor saveAlarmSoundToHistoryWithAlarmSound:alarmSound];
    
    // 노래 선택 적용
    [self indicateCheckmarkToNewlySelectedCellWithIndexPath:self.checkedIndexPath];
    
    // Reload
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
};

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
};

@end
