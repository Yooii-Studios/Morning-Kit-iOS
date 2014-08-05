//
//  MNWoeidParser.h
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 5. 4..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNLocationInfo.h"

@interface MNWoeidParser : NSObject

+ (NSInteger)parseWithLocation : (MNLocationInfo*) _locationInfo;

@end
