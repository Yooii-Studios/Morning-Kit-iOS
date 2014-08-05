//
//  MNTimeZone.m
//  SearchDisplayTestProject
//
//  Created by 김우성 on 13. 5. 18..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import "MNTimeZone.h"

@implementation MNTimeZone

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.cityName                           = [aDecoder decodeObjectForKey:@"cityName"];
        self.timeZoneName                       = [aDecoder decodeObjectForKey:@"timeZoneName"];
        self.searchPriority                     = [aDecoder decodeIntegerForKey:@"searchPriority"];
        self.localizedCityNames                 = [aDecoder decodeObjectForKey:@"localizedCityNames"];
        self.hourOffset                         = [aDecoder decodeIntegerForKey:@"hourOffset"];
        self.minuteOffset                       = [aDecoder decodeIntegerForKey:@"minuteOffset"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:       self.cityName               forKey:@"cityName"];
    [aCoder encodeObject:       self.timeZoneName           forKey:@"timeZoneName"];
    [aCoder encodeInteger:      self.searchPriority         forKey:@"searchPriority"];
    [aCoder encodeObject:       self.localizedCityNames     forKey:@"localizedCityNames"];
    [aCoder encodeInteger:      self.hourOffset             forKey:@"hourOffset"];
    [aCoder encodeInteger:      self.minuteOffset           forKey:@"minuteOffset"];
}

@end
