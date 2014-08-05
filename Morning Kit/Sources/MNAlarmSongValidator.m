//
//  MNAlarmSongValidator.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 14..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNAlarmSongValidator.h"
#import <MediaPlayer/MPMediaQuery.h>

#define TEST 0
//#define TEST 1

@implementation MNAlarmSongValidator

+ (BOOL)isAlarmSongValidate:(MNAlarmSong *)alarmSong {
    BOOL isExisting = NO;
    
    MPMediaItem *mediaItem = alarmSong.mediaItemCollection.representativeItem;
    
    if (mediaItem) {
        
        NSNumber *persistentID;
        
        // test - 노래가 없을 경우 validationQuery.item.count 가 0 인지 테스트해보기 - 성공
        if (TEST) {
            persistentID = [NSNumber numberWithFloat:1812738217318371283.000000];
        }else{
            persistentID =  [mediaItem valueForProperty:MPMediaItemPropertyPersistentID];
        }
        
        MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:persistentID forProperty:MPMediaItemPropertyPersistentID];
        MPMediaQuery *validationQuery = [[MPMediaQuery alloc] init];
        [validationQuery addFilterPredicate:predicate];
        
        if (validationQuery.items.count > 0) {
            isExisting = YES;
        }
    }
    
    return isExisting;
}

@end
