//
//  MNAlarmSong.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 11..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNAlarmSong.h"

@implementation MNAlarmSong

+ (MNAlarmSong *)alarmSongWithTitle:(NSString *)title withMediaItemCollection:(MPMediaItemCollection *)mediaItemCollection {
    MNAlarmSong *alarmSong = [[MNAlarmSong alloc] init];
    alarmSong.title = title;
    alarmSong.mediaItemCollection = mediaItemCollection;
    
    return alarmSong;
}

- (BOOL)isEqualAlarmSong:(MNAlarmSong *)alarmSong {
    return [self.title isEqualToString:alarmSong.title] ? YES : NO;
}

#pragma mark - NSCoding Delegate Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.title                          = [aDecoder decodeObjectForKey:@"title"];
        
//        NSData *dataOfMediaItemCollection   = [aDecoder decodeObjectForKey:@"mediaItemCollection"];
//        self.mediaItemCollection            = [NSKeyedUnarchiver unarchiveObjectWithData:dataOfMediaItemCollection];
        self.mediaItemCollection            = [aDecoder decodeObjectForKey:@"mediaItemCollection"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:   self.title                      forKey:@"title"];
    [aCoder encodeObject:    self.mediaItemCollection       forKey:@"mediaItemCollection"];
//    NSData *dataOfMediaItemCollection = [NSKeyedArchiver archivedDataWithRootObject:self.mediaItemCollection];
//    [aCoder encodeObject:   dataOfMediaItemCollection       forKey:@"mediaItemCollection"];
}

@end
