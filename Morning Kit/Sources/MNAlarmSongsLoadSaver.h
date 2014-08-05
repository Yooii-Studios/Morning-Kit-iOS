//
//  MNAlarmSongsLoadSaver.h
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 10..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNAlarmSongsLoadSaver : NSObject

+ (NSMutableArray *)loadSongsList;
+ (void)saveSongsListWithSongsList:(NSMutableArray *)songsList;

@end
