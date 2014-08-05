//
//  MNQuotesLoader.m
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 4..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNQuotesLoader.h"
#import "MNWidgetQuotesView.h"
#import "MNQuotesData.h"

@implementation MNQuotesLoader

+ (NSArray *)loadQuotesAndAuthorsWithLanguage:(MNQuotesLanguage)currentLanguage {
    NSMutableArray *quotesDataList = [NSMutableArray array];
    
    NSString *fileName;
    
    switch (currentLanguage) {
        case MNQuotesLanguageEnglish:
            fileName = @"quotes_english";
            break;
            
        case MNQuotesLanguageKorean:
            fileName = @"quotes_korean";
            break;
            
        case MNQuotesLanguageJapan:
            fileName = @"quotes_japanese";
            break;
            
        case MNQuotesLanguageSimplifiedChinese:
            fileName = @"quotes_chinese_simplified";
            break;
            
        case MNQuotesLanguageTraditionalChinese:
            fileName = @"quotes_chinese_traditional";            
            break;
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
//    NSLog(@"%@", filePath);
    
    NSError *error = nil;
//    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF16LittleEndianStringEncoding error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    NSArray *allLinedStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
//    NSLog(@"%d", allLinedStrings.count);
    
    for (NSString *quotesSourceString in allLinedStrings) {
        // 탭으로 나누기
        NSArray *quotesArray = [quotesSourceString componentsSeparatedByString:@"\t"];
        MNQuotesData *quotesData = [[MNQuotesData alloc] init];
        if (quotesArray.count == 2) {
            quotesData.quotesString = [quotesArray objectAtIndex:0];
            quotesData.authorString = [quotesArray objectAtIndex:1];
            
            [quotesDataList addObject:quotesData];
        }
    }
    
    return [NSArray arrayWithArray:quotesDataList];
}

+ (NSArray *)loadAllQuotesData {
    NSMutableArray *quotesDatasList = [NSMutableArray array];
    
    for (int i=0; i<5; i++) {
        NSArray *quotesData = [MNQuotesLoader loadQuotesAndAuthorsWithLanguage:i];
        [quotesDatasList addObject:quotesData];
    }
    
    return (NSArray *)quotesDatasList;
}

@end
