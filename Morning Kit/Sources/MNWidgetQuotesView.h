//
//  MNWidgetQuotesView.h
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//
#pragma once

#import "MNWidgetView.h"
#import <OHAttributedLabel/OHAttributedLabel.h>

typedef NS_ENUM(NSInteger, MNQuotesLanguage) {
    MNQuotesLanguageEnglish = 0,
    MNQuotesLanguageKorean,
    MNQuotesLanguageJapan,
    MNQuotesLanguageSimplifiedChinese,
    MNQuotesLanguageTraditionalChinese,
};

@interface MNWidgetQuotesView : MNWidgetView

//@property (nonatomic) MNQuotesLanguage currentSelectedLanguage;
//@property (nonatomic, strong) NSArray *quotesDataList;

// 확장: 선택된 언어들의 컨테이너와, 명언 데이터 리스트의 컨테이너
@property (nonatomic, strong) NSArray *quotesLanguagesList;
@property (nonatomic, strong) NSArray *quotesDatasList;
@property (nonatomic) NSInteger randomLanguageIndex;
@property (nonatomic) NSInteger randomQuotesIndex;
@property (nonatomic, strong) NSString *currentQuoteString;

@property (nonatomic, strong) IBOutlet OHAttributedLabel *quoteLabel;

@end
