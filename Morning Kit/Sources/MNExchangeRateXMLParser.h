//
//  MNExchangeRateXMLParser.h
//  Morning Kit
//
//  Created by Wooseong Kim on 2013. 11. 5..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

// 없어진 구글 API를 대체하기 위해 만든 파서
@interface MNExchangeRateXMLParser : NSObject <NSXMLParserDelegate>

@property (nonatomic) double exchangeRate;

@end
