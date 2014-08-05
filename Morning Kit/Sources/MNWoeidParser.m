//
//  MNWoeidParser.m
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 5. 4..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWoeidParser.h"

// private class for MNWoeidParser
@interface MNWoeidParseDelegate : NSObject <NSXMLParserDelegate>
@property BOOL isWoeid;
@property NSInteger woeid;
//-(NSInteger)getWoeid;
@end

// static methods of MNWoeidParser
@implementation MNWoeidParser

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    
    return self;
}

+ (NSInteger)parseWithLocation : (MNLocationInfo*) _locationInfo
{
    // 로직 수정. 소수점 한 자리까지 쓰고 나머지는 버림. 그래도 검색이 될 것이라는 이사님의 예측. by 우성
//    NSLog(@"%@, %@", [NSString stringWithFormat:@"%.1f", [_locationInfo latitude]], [NSString stringWithFormat:@"%.1f", [_locationInfo longitude]]);
//    CGFloat fixedLatitude = [[NSString stringWithFormat:@"%.1f", _locationInfo.latitude] floatValue];
//    CGFloat fixedLongitude = [[NSString stringWithFormat:@"%.1f", _locationInfo.longitude] floatValue];
//    NSLog(@"%f, %f", [_locationInfo latitude], [_locationInfo longitude]);
//    NSLog(@"%f, %f", fixedLatitude, fixedLongitude);
    
//    NSString*  woeidParsingUrlString = [NSString stringWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=SELECT * FROM geo.placefinder WHERE text=\'%f,%f\' AND gflags=\'R\'&format=xml", fixedLatitude, fixedLongitude];
    
    // woeid가 0이 아닐 경우는 도시를 선택할 때. 즉 woeid 가 있다.
    if (_locationInfo.woeid != 0) {
        return _locationInfo.woeid;
    }
    
    // 이사님 테스트를 위해서 유료 API로 수정
    NSString *woeidParsingUrlString = [NSString stringWithFormat:@"http://where.yahooapis.com/v1/places.q('%f,%f')?appid=0CXXc9XV34EmyOybEBci_kHLbyxd.OSLkJPqPyPS6yh_Jxl0L.XozFY8Kjp5Gw--", _locationInfo.latitude, _locationInfo.longitude];
    
    //37.541, 126.986];
    //[_locationInfo latitude], [_locationInfo longitude]];
    woeidParsingUrlString = [woeidParsingUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    NSLog(@"WoeidParsingURL : %@", woeidParsingUrlString);
    
    NSURL *woeidParsingUrl = [NSURL URLWithString:woeidParsingUrlString];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:woeidParsingUrl];
    
    MNWoeidParseDelegate* parseDelegate = [[MNWoeidParseDelegate alloc] init];
    [xmlParser setDelegate:parseDelegate];
    
    [xmlParser parse];
    
    return parseDelegate.woeid;
}
@end


@implementation MNWoeidParseDelegate
@synthesize woeid;
-(id)init
{
    self = [super init];
    if( self )
    {
        self.woeid = 0;
        self.isWoeid = false;
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // NSLog(@"WoeidParse Element : %@", elementName);
    if( [elementName caseInsensitiveCompare:@"woeid"] == NSOrderedSame )
    {
        self.isWoeid = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ( self.isWoeid )
    {
//        NSLog(@"WoeidParse Woeid : %@", string );
        self.woeid  = [string integerValue];
        self.isWoeid = NO;
    }
}

+ (NSInteger)parseWithLocation : (MNLocationInfo*) _locationInfo {
    return 0;
}


@end

