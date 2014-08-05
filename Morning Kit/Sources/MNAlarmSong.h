//
//  MNAlarmSong.h
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 11..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMediaItemCollection.h>

@interface MNAlarmSong : NSObject <NSCoding>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) MPMediaItemCollection *mediaItemCollection;

// constructor
+ (MNAlarmSong *)alarmSongWithTitle:(NSString *)title withMediaItemCollection:(MPMediaItemCollection *)mediaItemCollection;

// comparator
- (BOOL)isEqualAlarmSong:(MNAlarmSong *)alarmSong;

@end
