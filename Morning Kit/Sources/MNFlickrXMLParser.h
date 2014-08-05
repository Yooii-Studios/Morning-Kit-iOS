//
//  MNFlickrParser.h
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 27..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNFlickrXMLParser : NSObject <NSXMLParserDelegate>

@property (nonatomic) BOOL isParserFindingTotalNumber;
@property (strong, nonatomic) NSString *flickrPhotoURLString;
@property (strong, nonatomic) NSString *numberOfTotalPage;
@property (strong, nonatomic) NSString *farmID;
@property (strong, nonatomic) NSString *serverID;
@property (strong, nonatomic) NSString *photoID;
@property (strong, nonatomic) NSString *secret;

- (NSString *)parsingFromFlickrURL:(NSString *)urlString;

@end
