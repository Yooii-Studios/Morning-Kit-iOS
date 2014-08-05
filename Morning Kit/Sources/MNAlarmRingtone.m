//
//  MNAlarmRingtone.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 12..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNAlarmRingtone.h"

@implementation MNAlarmRingtone

+ (MNAlarmRingtone *)alarmRingtoneWithTitle:(NSString *)title withResource:(NSString *)resourceString withExtensionType:(NSString *) extensionType {
    
    MNAlarmRingtone *alarmRingtone = [[MNAlarmRingtone alloc] init];
    alarmRingtone.title = MNLocalizedString(title, nil); // title;
    alarmRingtone.resource = resourceString;
    alarmRingtone.extensionType = extensionType;
    
    return alarmRingtone;
}

+ (MNAlarmRingtone *)alarmRingtoneWithTitle:(NSString *)title withExtensionType:(NSString *) extensionType { 
    return [MNAlarmRingtone alarmRingtoneWithTitle:title withResource:title withExtensionType:extensionType];
}

// comparator
- (BOOL)isEqualAlarmRingtone:(MNAlarmRingtone *)alarmRingtone {
    return ([self.title isEqualToString:alarmRingtone.title] &&
            [self.resource isEqualToString:alarmRingtone.resource] &&
            [self.extensionType isEqualToString:alarmRingtone.extensionType] ) ? YES : NO;
}

#pragma mark - NSCoding Delegate Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.title                          = [aDecoder decodeObjectForKey:@"title"];
        self.resource                       = [aDecoder decodeObjectForKey:@"resource"];
        self.extensionType                  = [aDecoder decodeObjectForKey:@"extensionType"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title                  forKey:@"title"];
    [aCoder encodeObject:self.resource               forKey:@"resource"];
    [aCoder encodeObject:self.extensionType          forKey:@"extensionType"];
}


@end
