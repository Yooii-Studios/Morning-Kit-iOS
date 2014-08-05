//
//  MNWidgetQuotesView.m
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNWidgetQuotesView.h"
#import "MNDefinitions.h"
#import "MNTheme.h"
#import "MNQuotesLoader.h"
#import "MNQuotesData.h"
#import "MNLanguage.h"

@implementation MNWidgetQuotesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - widget init method

- (void)initWidgetView {
    
    // 아래 것이 구현되면 삭제해야함
    // 현재 선택된 언어를 선택. 테스트로 영어 선택
//    self.currentSelectedLanguage = MNQuotesLanguageEnglish;
    // 각 언어에 해당하는 리스트 확보
//    self.quotesDataList = [MNQuotesLoader loadQuotesAndAuthorsWithLanguage:self.currentSelectedLanguage];
    
    //// 수정 ////
    // 언어들의 리스트 로드는 doWidgetLoading
    // 명언 리스트 로드
    self.quotesDatasList = [MNQuotesLoader loadAllQuotesData];
    ////////////
    
    [self initLabel];
}

- (void)initLabel {
    // 수직 맞춤
    self.quoteLabel.centerVertically = YES;
}

- (void)initThemeColor {
    // 배경색
//    self.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [self setColorOfQuoteLabel];
}

- (void)setColorOfQuoteLabel {
    // 레이블 색. 내용은 mainColor, 사람은 subColor
    self.quoteLabel.textColor = [MNTheme getMainFontUIColor];
//    self.quoteLabel.backgroundColor = [UIColor redColor];
    
    NSRange newLineCharacterRange = [self.quoteLabel.text rangeOfString:@"\n"];
    if (newLineCharacterRange.location == NSNotFound) {
//        NSLog(@"newLine doesn't exist");
    }else{
//        NSLog(@"newLine exists");
        NSMutableAttributedString *attrString = [self.quoteLabel.attributedText mutableCopy];
//        [attrString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
//            paragraphStyle.textAlignment = kCTTextAlignmentCenter;
//            paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
//            paragraphStyle.maximumLineHeight = WIDGET_HEIGHT;   // 이건 없어도 되는 듯
//        }];
        [attrString setTextColor:[MNTheme getMainFontUIColor]];
        [attrString setTextColor:[MNTheme getWidgetSubFontUIColor] range:NSMakeRange(newLineCharacterRange.location, attrString.length-newLineCharacterRange.location)];
//        NSLog(@"string length: %d / location: %d", attrString.length, newLineCharacterRange.location);
        self.quoteLabel.attributedText = attrString; 
    }
}


#pragma mark - process

- (void)loadQuotesLanguesList {
    self.quotesLanguagesList = [self.widgetDictionary objectForKey:@"quoteLanguagesList"];
    
    // 첫 위젯 로딩이라면 현재 언어를 파악해서 그것만 켜주기
    if (self.quotesLanguagesList == nil || self.quotesLanguagesList.count != 5) {
        NSInteger currentLanguageIndex = [MNLanguage getLanguageIndexFromCodeString:[MNLanguage getCurrentLanguage]];
        NSMutableArray *languagesList = [NSMutableArray array];
        
        // 러시아어는 없으므로 영어로 변환해주기
        if ([[MNLanguage getCurrentLanguage] isEqualToString:@"ru"]) {
            currentLanguageIndex = [MNLanguage getLanguageIndexFromCodeString:@"en"];
        }
        
        for (int i=0; i<5; i++) {
            if (i == currentLanguageIndex) {
                [languagesList addObject:@YES];
            }else{
                [languagesList addObject:@NO];
            }
        }
        self.quotesLanguagesList = [NSArray arrayWithArray:languagesList];
//        self.quotesLanguagesList = @[@YES, @YES, @YES, @YES, @YES];
    }
}

#pragma mark - widget process method

- (void)doWidgetLoadingInBackground {
    // 선택된 언어를 로딩
    [self loadQuotesLanguesList];
    
    // 선택된 언어중에서 랜덤 언어 인덱스와 랜덤 명언 인덱스를 생성해 명언에 대입
    self.randomLanguageIndex = 0;
    
    // 1. 랜덤 언어 인덱스 - while문을 고려했지만 무한 루프에 빠지는 것을 방지하고자 100번만 돌림 
    for (int i=0; i<100; i++) {
        self.randomLanguageIndex = arc4random() % 5; // 언어가 5개
        if (((NSNumber *)[self.quotesLanguagesList objectAtIndex:self.randomLanguageIndex]).boolValue == YES) {
            break;
        }
    }
    // 2. 랜덤 명언 인덱스
    if ([self.quotesDatasList objectAtIndex:self.randomLanguageIndex]) {
        self.randomQuotesIndex = arc4random() % ((NSArray *)[self.quotesDatasList objectAtIndex:self.randomLanguageIndex]).count;
    }
    
//    NSLog(@"language: %d / quote: %d", self.randomLanguageIndex, self.randomQuotesIndex);
    
    // 3. 명언을 구하기
    NSArray *quotesDataList = [self.quotesDatasList objectAtIndex:self.randomLanguageIndex];
    if (quotesDataList) {
        MNQuotesData *quotesData = [quotesDataList objectAtIndex:self.randomQuotesIndex];
        self.currentQuoteString = [NSString stringWithFormat:@"%@\n%@", quotesData.quotesString, quotesData.authorString];
    }
}

- (void)updateUI{
    self.quoteLabel.text = self.currentQuoteString;
    [self adjustFontForLabel];
    [self setColorOfQuoteLabel];
}

- (void)adjustFontForLabel {
    
    NSInteger maximumFontSize, minimumFontSize;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        maximumFontSize = 13;
        minimumFontSize = 8;
    }else{
        maximumFontSize = 27;
        minimumFontSize = 17;
    }
    
    // 새로운 방법 찾기
    NSString *text = [NSString stringWithFormat:@"%@\n\n", self.quoteLabel.text]; // 높이를 약간 더 길게 측정하니까 제대로 안에 들어옴. 편법. by 우성
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:maximumFontSize];
    
    // 제일 긴 명언을 표시할 때 8까지는 줄여야함
    for (int i=maximumFontSize; i>minimumFontSize; i=i-1) {
        font = [font fontWithSize:i];
        
        CGSize constraintSize = CGSizeMake(self.quoteLabel.frame.size.width, MAXFLOAT);
        CGSize labelSize = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];

        int numberOfLines = ceil((labelSize.height/(CGFloat)i));
//        NSLog(@"labelSize.height/i: %f", labelSize.height/i);
//        NSLog(@"numberOfLines: %d", numberOfLines);
        int calculatedLabelHeight = numberOfLines * i;
        
        if (calculatedLabelHeight <= self.quoteLabel.frame.size.height) {
//            NSLog(@"labelSize.height: %f", labelSize.height);
//            NSLog(@"self.quoteLabel.frame.size.height: %f", self.quoteLabel.frame.size.height);
//            NSLog(@"final fontSize: %d", i);
//            NSLog(@"lines: %d", (int)(labelSize.height/i));
//            NSLog(@"calculated height: %d", ((int)(labelSize.height/i) * i));
            break;
        }
    }
    self.quoteLabel.font = font;
    self.quoteLabel.text = text;
    
    // 이름 쪽은 한 픽셀씩 줄이기, 명언 내용은 왼쪽 정렬
    NSRange newLineCharacterRange = [self.quoteLabel.text rangeOfString:@"\n"];
    if (newLineCharacterRange.location == NSNotFound) {
        //        NSLog(@"newLine doesn't exist");
    }else{
        //        NSLog(@"newLine exists");
        NSMutableAttributedString *attrString = [self.quoteLabel.attributedText mutableCopy];
//        [attrString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
//            paragraphStyle.textAlignment = kCTTextAlignmentCenter;
//            paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
//            paragraphStyle.maximumLineHeight = WIDGET_HEIGHT;   // 이건 없어도 되는 듯
//        }];
        // pointSize 와 fontSize는 같은 값.
        [attrString setFont:[font fontWithSize:font.pointSize-2] range:NSMakeRange(newLineCharacterRange.location, attrString.length-newLineCharacterRange.location)];
//        [attrString setTextAlignment:kCTTextAlignmentLeft lineBreakMode:kCTLineBreakByWordWrapping];
//        [attrString setTextAlignment:kCTTextAlignmentLeft lineBreakMode:kCTLineBreakByWordWrapping range:NSMakeRange(0, newLineCharacterRange.length)];
        [attrString setTextAlignment:kCTTextAlignmentCenter lineBreakMode:kCTLineBreakByWordWrapping range:NSMakeRange(0, attrString.length)];
//        [attrString setTextAlignment:kCTTextAlignmentCenter lineBreakMode:kCTLineBreakByWordWrapping range:NSMakeRange(newLineCharacterRange.location, attrString.length-newLineCharacterRange.location)];
        self.quoteLabel.attributedText = attrString;
    }
}


#pragma mark - widget click handler

- (void)widgetClicked {
    // 위젯이 클릭되면, 현재 선택되어 있는 언어들과, 현재 출력중인 명언을 넣어주어야 한다.
    [self.widgetDictionary setObject:self.quotesLanguagesList forKey:@"quoteLanguagesList"];
    [self.widgetDictionary setObject:self.quoteLabel.text forKey:@"quoteString"];
}

// 회전할 때 다시 잡아주기
- (void)layoutSubviews {
    [self adjustFontForLabel];
    [self setColorOfQuoteLabel];
}

@end
