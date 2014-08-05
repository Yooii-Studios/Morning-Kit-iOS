//
//  MNCountryNameFactory.m
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 5. 12..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNCountryNameFactory.h"

@implementation MNCountryNameFactory

static NSMutableDictionary* countryNames;

+ (NSString*) getCountryName : (NSString*) _countryCode
{
    if( countryNames == nil )
    {
        countryNames = [[NSMutableDictionary alloc] init];
        
        NSStringEncoding encoding;
        NSString* content;
        NSString* path = [[NSBundle mainBundle] pathForResource:@"countrycode" ofType:@"txt"];
        
        if(path)
        {
            content = [NSString stringWithContentsOfFile:path  usedEncoding:&encoding  error:NULL];
        }
        // NSLog(@"path is %@",path);
        if (content)
        {
            NSArray* eachRow = [content componentsSeparatedByString:@"\r\n"];
            
            NSArray* seperates;
            NSString* countryCode;
            NSString* countryName;
            for(int i=0; i<eachRow.count; ++i)
            {
                @try
                {
                    seperates = [eachRow[i] componentsSeparatedByString:@"/"];
                    countryCode = seperates[0];
                    countryName = seperates[1];
                    
                    countryCode = [countryCode lowercaseString];
                    
                    //countryName[countryCode] = countryName;
                    [countryNames setValue:countryName forKey:countryCode];
                }
                @catch (NSException* e) {
                    continue;
                }
                
            }
        }
    }
    
    if( countryNames[[_countryCode lowercaseString]] )
        return countryNames[[_countryCode lowercaseString]];
    else
        return @"";
}

@end









