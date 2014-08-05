//
//  MNAlarmRingtone.h
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 12..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNAlarmRingtone : NSObject <NSCoding>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *resource;
@property (strong, nonatomic) NSString *extensionType;

// constructor
+ (MNAlarmRingtone *)alarmRingtoneWithTitle:(NSString *)title withResource:(NSString *)resourceString withExtensionType:(NSString *) extensionType;

+ (MNAlarmRingtone *)alarmRingtoneWithTitle:(NSString *)title withExtensionType:(NSString *) extensionType;

// comparator
- (BOOL)isEqualAlarmRingtone:(MNAlarmRingtone *)alarmRingtone;


@end
