//
//  MNTimeZoneProcessor.h
//  SearchDisplayTestProject
//
//  Created by 김우성 on 13. 5. 18..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNTimeZone.h"

@interface MNTimeZoneProcessor : NSObject

+ (NSArray *)loadTimeZonesFromRawFile:(NSString *)rawFileName;
+ (NSArray *)getFilteredArrayWithSearchString:(NSString *)searchString fromTimeZoneArray:(NSArray *)allTimeZones;
+ (MNTimeZone *)getDefaultTimeZone;

@end
