//
//  MNQuotesLanguageListLoader.m
//  Morning Kit
//
//  Created by 김우성 on 13. 6. 10..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNQuotesLanguageListLoader.h"

@implementation MNQuotesLanguageListLoader

+ (NSArray *)loadQuotesLanguageFromDictionary:(NSDictionary *)dictionary {
    NSArray *quotesLanguages = [dictionary objectForKey:@"quoteLanguagesList"];
    
    // 첫 위젯 로딩이거나 카운트가 지원 언어 갯수가 아니라면(예상 외 상황) 현재 언어 
    if (!quotesLanguages || quotesLanguages.count != 5) {
        
    }
    
    return quotesLanguages;
}

@end
