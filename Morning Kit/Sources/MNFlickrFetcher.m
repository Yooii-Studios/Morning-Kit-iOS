//
//  MNFlickrFetcher.m
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 27..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNFlickrFetcher.h"
#import "MNDefinitions.h"
//#import "MNFlickrXMLParser.h"
#import "MNFlickrJSONParser.h"

@implementation MNFlickrFetcher

+ (NSData *)flickrImageDataFromUrlString:(NSString *)urlString {
    NSData *flickrImageData;
    
    if (urlString) {
        flickrImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        if (flickrImageData) {
//            NSLog(@"flickrImageData is loaded");
        }else{
//            NSLog(@"flickrImageData is not loaded");
        }
    }else{
//        NSLog(@"urlString is nil");
    }

    return flickrImageData;
}

@end
