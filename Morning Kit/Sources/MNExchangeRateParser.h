//
//  MNExchangeRateParser.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 10..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MNExchangeRateParseErr -1

@interface MNExchangeRateParser : NSObject 

+ (double)getExchangeRateWithBase:(NSString *)baseStr Target:(NSString *)targetStr;

@end
