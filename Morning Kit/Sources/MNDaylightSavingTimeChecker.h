//
//  MNDaylightSavingTimeChecker.h
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 22..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNTimeZone.h"

@interface MNDaylightSavingTimeChecker : NSObject

+ (BOOL)isTimeZoneInDaylightSavingTime:(MNTimeZone *)targetTimeZone;

@end
