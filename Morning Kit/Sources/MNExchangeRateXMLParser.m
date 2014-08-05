//
//  MNExchangeRateXMLParser.m
//  Morning Kit
//
//  Created by Wooseong Kim on 2013. 11. 5..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNExchangeRateXMLParser.h"
#import "MNExchangeRateParser.h"

@implementation MNExchangeRateXMLParser

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code
        // 기본으로 파싱이 안된 상황으로 놓기
        self.exchangeRate = MNExchangeRateParseErr;
    }
    return self;
}


#pragma mark XMLParse delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
//    NSLog(@"parsing part start");
//    NSLog(@"elementName: %@", elementName);
//    NSLog(@"attributeDict: %@", attributeDict);
    
    /*
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
     */
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//    NSLog(@"parsing part end");
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    NSLog(@"parsing part foundCharacters");
    if (string) {
        self.exchangeRate = [string doubleValue];
    }
}

@end
