//
//  MNFlickrJSONParser.h
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 14..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNFlickrPhotoInfo.h"

@interface MNFlickrJSONParser : NSObject

//+ (NSInteger)getRandomPageNumberFromURLString:(NSString *)urlString;
//+ (NSString *)getFlickrPhotoURLFromQueryString:(NSString *)queryString;

// 새로 생각한 로직
+ (MNFlickrPhotoInfo *)getFirstFlickrPhotoInfoWithKeyword:(NSString *)keyword;
+ (NSString *)getFlickrPhotoUrlStringWithKeyword:(NSString *)keyword withTotalNumberOfPhotos:(NSInteger)totalNumberOfPhotos;

@end
