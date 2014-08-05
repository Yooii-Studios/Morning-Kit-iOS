//
//  MNWeatherTimeGetter.m
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 5. 13..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWeatherTimeGetter.h"

@interface MNTimeOffset : NSObject

@property (nonatomic) int hour;
@property (nonatomic) int min;

- (id) initHour : (int) _hour Min : (int) _min;

@end

@implementation MNWeatherTimeGetter

static NSMutableDictionary* timezoneOffsets;

+ (MNTimeOffset*) getTimezoneoffset : (NSString*) timezoneString
{
    MNTimeOffset* result = [[MNTimeOffset alloc] initHour:0 Min:0];
    
    if( timezoneOffsets == nil )
        return result;
    
    NSArray* seperates = [timezoneString componentsSeparatedByString:@" "];
    int count = seperates.count;
    
    // seperates count is 1 or 4
    // 0 : UTC
    // 1 : +/-
    // 2 : H/M
    // 3 : empty
    
    //
    if( count == 1 )
        return result;
    
    //
    int signMultiplier = 1;
    if( [seperates[1] caseInsensitiveCompare:@"+"] != NSOrderedSame )
        signMultiplier = -1;
    
    NSArray* hourAndMin = [seperates[count-2] componentsSeparatedByString:@":"];
    result.hour = [hourAndMin[0] intValue] * signMultiplier;
    
    if( hourAndMin.count >= 2 )
        result.min = [hourAndMin[1] intValue] * signMultiplier;
    
//    for(int i=0;i <count; ++i)
//    {
//        NSLog(@"[%d] : %@", i, seperates[i]);
//    }
//    NSLog(@"result : %d:%d", result.hour, result.min);
    
    return result;
}

+ (NSString*) getTimeStringOfTimeZone: (NSString*)_timezoneCode
{
    NSString* result = @"00:00:00";
    
    if( timezoneOffsets == nil )
    {
        timezoneOffsets = [[NSMutableDictionary alloc] init];
        NSStringEncoding encoding;
        NSString* content;
        NSString* path = [[NSBundle mainBundle] pathForResource:@"world_time_abbreviations" ofType:@"txt"];
        
        if(path)
        {
            content = [NSString stringWithContentsOfFile:path  usedEncoding:&encoding  error:NULL];
        }
        // NSLog(@"path is %@",path);
        if (content)
        {
            NSArray* eachRow = [content componentsSeparatedByString:@"\n"];
            
            NSArray* seperates;
            NSString* timezoneCode;
            MNTimeOffset* timezoneOffset;
            for(int i=1; i<eachRow.count; ++i)  // 첫줄은 주석이니 무시
            {
                @try
                {
                    seperates = [eachRow[i] componentsSeparatedByString:@"\t"];
                    timezoneCode = seperates[0];
                    
                    timezoneOffset = [MNWeatherTimeGetter getTimezoneoffset:seperates[seperates.count-1]];
                    
                    [timezoneOffsets setValue:timezoneOffset forKey:timezoneCode ];
                }
                @catch (NSException* e) {
                    continue;
                }
                
            }
        }
    }// init ns dictionary end

    // get timeoffset of current timezone coe
    MNTimeOffset *currentTimeOffset = timezoneOffsets[ _timezoneCode ];
    
    if( currentTimeOffset == nil )
        return result;
    
    // get time of gmt
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss a";//@"yyyy-MM-dd'T'HH:mm";
    
//    NSLog(@"currentTimeOffset Hour : %d", currentTimeOffset.hour);
//    NSLog(@"currentTimeOffset Min : %d", currentTimeOffset.min);
    
    // -7:-10 -->> GMT -07:10
   
    NSTimeZone *timezone = [NSTimeZone timeZoneForSecondsFromGMT:currentTimeOffset.hour*3600+currentTimeOffset.min*60];
    [dateFormatter setTimeZone:timezone];
    
    NSDate* currentDate = [NSDate date];
    
    NSString *timeStamp = [dateFormatter stringFromDate:currentDate];
    
    return timeStamp;
}

@end


@implementation MNTimeOffset

@synthesize hour;
@synthesize min;

- (id) initHour : (int) _hour Min : (int) _min
{
    self = [super init];
    if( self )
    {
        hour = _hour;
        min = _min;
    }
    return self;
}

@end