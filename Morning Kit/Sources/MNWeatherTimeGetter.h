//
//  MNWeatherTimeGetter.h
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 5. 13..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNWeatherTimeGetter : NSObject

+ (NSString*) getTimeStringOfTimeZone: (NSString*)_timezoneCode;

@end
