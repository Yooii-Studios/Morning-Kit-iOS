//
//  MNCityInfoQuery.h
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 5. 11..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNLocationInfo.h"

enum SearchMethod { eSM_Prefix, eSM_Contains_But_Not_Prefix };

@interface MNCityInfoQuery : NSObject

- (id) init;
- (id) initWithNonEtc;

- (NSMutableArray*)getCityLocations: (NSString*)_query inMethod : (enum SearchMethod) _method ;

// WWO에서 사용할 메서드
- (MNLocationInfo *)findSameCityLocationInfoWithCityName:(NSString*)cityNameToFind;

@property (strong, nonatomic) NSMutableArray*   fibers;

@end
