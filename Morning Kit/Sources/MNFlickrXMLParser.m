//
//  MNFlickrParser.m
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 27..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNFlickrXMLParser.h"

@implementation MNFlickrXMLParser

- (NSString *)parsingFromFlickrURL:(NSString *)urlString {
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    [parser setDelegate:self];
    [parser parse];
    if (self.isParserFindingTotalNumber) {
        return self.numberOfTotalPage;
    }else{
        return self.flickrPhotoURLString;
    }
}

#pragma mark XMLParse delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    //    NSLog(@"parsing part start");
    if (self.isParserFindingTotalNumber == YES) {
        if ([elementName isEqualToString:@"photos"]) {
            self.numberOfTotalPage = [attributeDict objectForKey:@"total"];
        }
    }else{
        if ( [elementName isEqualToString:@"photo"] ) {
            self.photoID = [attributeDict objectForKey:@"id"];
            self.farmID = [attributeDict objectForKey:@"farm"];
            self.serverID = [attributeDict objectForKey:@"server"];
            self.secret = [attributeDict objectForKey:@"secret"];
            // 사이즈 m, n, -, z, c, b, o 순서대로인데, o는 못씀
            self.flickrPhotoURLString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_z.jpg", self.farmID, self.serverID, self.photoID, self.secret];
            //        NSLog(@"parsing success");
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //    NSLog(@"parsing part end");
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //    NSLog(@"parsing part foundCharacters");
}


@end
