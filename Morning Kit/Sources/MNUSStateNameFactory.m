//
//  MNUSStateNameFactory.m
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 5. 12..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNUSStateNameFactory.h"

@implementation MNUSStateNameFactory

static NSMutableDictionary* USStateNames;

+ (NSString*) getStateName : (NSString*) _stateCode
{
    if( USStateNames == nil )
    {
        USStateNames = [[NSMutableDictionary alloc] init];
        NSStringEncoding encoding;
        NSString* content;
        NSString* path = [[NSBundle mainBundle] pathForResource:@"statecode_us" ofType:@"txt"];
        
        if(path)
        {
            content = [NSString stringWithContentsOfFile:path  usedEncoding:&encoding  error:NULL];
        }
        // NSLog(@"path is %@",path);
        if (content)
        {
            NSArray* eachRow = [content componentsSeparatedByString:@"\n"];
            
            NSArray* seperates;
            NSString* stateCode;
            NSString* stateName;
            for(int i=0; i<eachRow.count; ++i)
            {
                @try
                {
                    seperates = [eachRow[i] componentsSeparatedByString:@"/"];
                    stateCode = seperates[0];
                    stateName = seperates[1];
                    
                    stateCode = [stateCode lowercaseString];
                    
                    //countryName[countryCode] = countryName;
                    [USStateNames setValue:stateName forKey:stateCode];
                }
                @catch (NSException* e) {
                    continue;
                }
                
            }
        }
    }
    
    if( USStateNames[[_stateCode lowercaseString]] )
        return USStateNames[[_stateCode lowercaseString]];
    else
        return @"";
}


@end












