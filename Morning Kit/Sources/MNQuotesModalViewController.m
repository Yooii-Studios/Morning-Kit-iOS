//
//  MNQuotesModalViewController.m
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 8..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNQuotesModalViewController.h"
#import "MNTheme.h"
#import "MNDefinitions.h"
#import "MNRoundRectedViewMaker.h"
#import "MNLanguage.h"
#import "MNQuotesLoader.h"
#import "MNQuotesData.h"

#define OFFSET_VIEW_BETWEEN_LABEL_AND_SWITCH (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 12 : 15)
#define OFFSET_LABEL_HEIGHT 40

//#define QUOTES_DEBUG 1
#define QUOTES_DEBUG 0
#define QUOTES_DEBUG_LANGUAGE_INDEX 2
#define QUOTES_DEBUG_CONTENT_INDEX 9

#define SWITCH_HEIGHT_iOS6 27
#define SWITCH_HEIGHT_iOS7 31

@interface MNQuotesModalViewController ()

@end

@implementation MNQuotesModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 테마
//    self.quoteLabel.backgroundColor = [MNTheme getTouchedBackgroundUIColor];
    self.quoteLabel.backgroundColor = [UIColor clearColor];
    self.roundRectedView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    self.view.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    // RoundRectView addTarget
    self.roundRectedView.MNDelegate = self;
    
    // 폰트 길이 조정
    NSString *text = [self.widgetDictionary objectForKey:@"quoteString"];
    if (!text || QUOTES_DEBUG) {
        text = [self loadFirstQuotes];
    }
    [self adjustFontForLabel:text];
    [self setColorOfQuoteLabel];
    
    // 레이블, 스위치 위치 조절
    [self initLabels];
    [self initSwitchs];
    
    // 스위치 선택 여부 체크
    [self checkSwitchStates];
    
    // 스크롤뷰 조절
    self.scrollView.delaysContentTouches = NO;
    CGRect newFrame = self.scrollView.frame;
//    CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
//    NSLog(@"applicationFrame: %@", NSStringFromCGRect(applicationFrame));
//    NSLog(@"viewFrame: %@", NSStringFromCGRect(self.view.frame));
    
    newFrame.size.height = self.view.frame.size.height - NAVIGATION_BAR_iPhone; // - WIDGET_SELECTOR_TOTAL_HEIGHT_iPhone;
    self.scrollView.frame = newFrame;
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width,
                                              self.traditionalChineseLabel.frame.origin.y + self.traditionalChineseLabel.frame.size.height + 10 + WIDGET_SELECTOR_TOTAL_HEIGHT)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 프레임이 여기서 늘어남. (autosize mask)
    [MNRoundRectedViewMaker makeRoundRectedView:self.roundRectedView];
}

- (void)adjustFontForLabel:(NSString *)quotesString {
    
    // 위젯뷰와 같은 방식
    NSInteger maximumFontSize, minimumFontSize;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        maximumFontSize = 18;
        minimumFontSize = 10;
    }else{
        maximumFontSize = 27;
        minimumFontSize = 17;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        // UILabel로 변경하고 난 후
        NSString *text = quotesString;
        
        
        // 새로운 방법 찾기
        //        NSString *text = [NSString stringWithFormat:@"%@\n\n", quotesString]; // 높이를 약간 더 길게 측정하니까 제대로 안에 들어옴. 편법. by 우성
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:maximumFontSize];
        
        // 새로운 사이즈 메서드
        /*
        // http://stackoverflow.com/questions/18784183/calculating-number-of-lines-of-dynamic-uilabel-ios7
        CGSize maxSize = CGSizeMake(self.quoteLabel.frame.size.width, MAXFLOAT);
        
        CGRect labelRect = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        
        NSLog(@"size %@", NSStringFromCGSize(labelRect.size));
//        [self adjustQuoteLabelFrameWithHeight:labelRect.size.height];
         */
        
        // 기존의 측정 방법
        // 제일 긴 명언을 표시할 때 8까지는 줄여야함
        for (int i=maximumFontSize; i>minimumFontSize; i=i-1) {
            font = [font fontWithSize:i];
            
//            NSLog(@"%d", i);
            
            CGSize constraintSize = CGSizeMake(self.quoteLabel.frame.size.width, MAXFLOAT);
            CGSize labelSize = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
            
//            NSLog(@"%f", labelSize.height);
            
            if (labelSize.height <= self.quoteLabel.frame.size.height) {
//                NSLog(@"font: %d", i);
                // 폰트에 맞는 height 가 나오면 프레임을 조절해준다.
                [self adjustQuoteLabelFrameWithHeight:labelSize.height + 1];
                break;
            }
            // 패드에서 가져온 소스
            if (i == minimumFontSize) {
//                NSLog(@"can't calculated, minimumFontSize");
//                CGSize newLineStringSize = [@"\n" sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
                [self adjustQuoteLabelFrameWithHeight:labelSize.height + 1];
            }
        }
        self.quoteLabel.font = font;
        self.quoteLabel.text = text;
    }else{
        // UILabel로 변경하고 난 후
        NSString *text = quotesString;
        
        // 새로운 방법 찾기
//        NSString *text = [NSString stringWithFormat:@"%@\n\n", quotesString]; // 높이를 약간 더 길게 측정하니까 제대로 안에 들어옴. 편법. by 우성
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:maximumFontSize];
        
        // 제일 긴 명언을 표시할 때 25까지는 줄여야함
//        NSLog(@"quoteLabel.size: %@", NSStringFromCGSize(self.quoteLabel.frame.size));
        for (int i=maximumFontSize; i>=minimumFontSize; i=i-1) {
            font = [font fontWithSize:i];
            
//            NSLog(@"font: %d", i);
            
            CGSize constraintSize = CGSizeMake(self.quoteLabel.frame.size.width, MAXFLOAT);
            CGSize labelSize = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
            
            //        NSLog(@"%f", labelSize.height);
//            NSLog(@"labelSize.height: %f", labelSize.height);
            
//            [self adjustQuoteLabelFrameWithHeight:labelSize.height];
//            break;
            
            if (labelSize.height <= self.quoteLabel.frame.size.height) {
//                NSLog(@"calculated font size: %d", i);
                
                // 폰트에 맞는 height 가 나오면 프레임을 조절해준다.
                // 기존 OHAttributedString 을 쓸때는 한줄을 더 조절해주었음.
                /*
//                [self adjustQuoteLabelFrameWithHeight:labelSize.height];
                CGSize newLineStringSize = [@"\n" sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
//                NSLog(@"%@", NSStringFromCGSize(newLineStringSize));
//                NSLog(@"%f", (newLineStringSize.height * 0.2));
                
                [self adjustQuoteLabelFrameWithHeight:labelSize.height - (newLineStringSize.height * 0.2)];// - newLineStringSize.height + 25]; // 5는 한글만 안되서 여유분으로 준 것
                 */
                
                // UILabel은 조절을 따로 해주지않음
                [self adjustQuoteLabelFrameWithHeight:labelSize.height + 1];
                break;
            }
            if (i == minimumFontSize) {
                // 기존 OHAttributedString 을 쓸때는 한줄을 더 조절해주었음.
                /*
//                NSLog(@"can't calculated, minimumFontSize");
                CGSize newLineStringSize = [@"\n" sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
                [self adjustQuoteLabelFrameWithHeight:labelSize.height - newLineStringSize.height + 8]; // 5는 한글만 안되서 여유분으로 준 것
                 */
                
                // UILabel은 조절을 따로 해주지않음
                [self adjustQuoteLabelFrameWithHeight:labelSize.height + 1];
            }
        }
        self.quoteLabel.font = font;
        self.quoteLabel.text = quotesString;
    }
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
        
        // 새로 바꿀 UILabel 메서드
//        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize] range:NSMakeRange(0, attributedString.length)];
        
        // 정렬 변경 - UILabel에서 해줌.
//        [attrString addAttribute:NSParagraphStyleAttributeName value:nil range:NSMakeRange(0, attrString.length)];
        
        // 색 변경
        [attrString addAttribute:NSForegroundColorAttributeName value:[MNTheme getMainFontUIColor] range:NSMakeRange(0, attrString.length)];
        NSRange authorRange = NSMakeRange(newLineCharacterRange.location, attrString.length-newLineCharacterRange.location);
        [attrString enumerateAttributesInRange:authorRange options:NSWidthInsensitiveSearch | NSAnchoredSearch | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            [attrString addAttribute:NSForegroundColorAttributeName value:[MNTheme getWidgetSubFontUIColor] range:authorRange];
        }];
        
        // 기존 OHAttributedString
//        [attrString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
//            paragraphStyle.textAlignment = kCTTextAlignmentCenter;
//            paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
//        }];
//        [attrString setTextColor:[MNTheme getMainFontUIColor]];
//        [attrString setTextColor:[MNTheme getWidgetSubFontUIColor] range:NSMakeRange(newLineCharacterRange.location, attrString.length-newLineCharacterRange.location)];
        //        NSLog(@"string length: %d / location: %d", attrString.length, newLineCharacterRange.location);
        self.quoteLabel.attributedText = attrString;
        self.quoteLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initLabels {
    // 레이블 로컬라이제이션
    self.englishLabel.text = MNLocalizedString(@"setting_language_english", "영어");
    self.englishLabel.textColor = [MNTheme getMainFontUIColor];
//    self.englishLabel.backgroundColor = [UIColor redColor];
    
    self.koreanLabel.text = MNLocalizedString(@"setting_language_korean", "한국어");
    self.koreanLabel.textColor = [MNTheme getMainFontUIColor];
//    self.koreanLabel.backgroundColor = [UIColor redColor];
    
    self.japaneseLabel.text = MNLocalizedString(@"setting_language_japanese", "일본어");
    self.japaneseLabel.textColor = [MNTheme getMainFontUIColor];
//    self.japaneseLabel.backgroundColor = [UIColor redColor];
    
    self.simplifiedChineseLabel.text = MNLocalizedString(@"setting_language_simplified_chinese", "중국어(간체)");
    self.simplifiedChineseLabel.textColor = [MNTheme getMainFontUIColor];
//    self.simplifiedChineseLabel.backgroundColor = [UIColor redColor];
    
    self.traditionalChineseLabel.text = MNLocalizedString(@"setting_language_traditional_chinese", "중국어(번체)");
    self.traditionalChineseLabel.textColor = [MNTheme getMainFontUIColor];
//    self.traditionalChineseLabel.backgroundColor = [UIColor redColor];
    
    // 레이블 프레임 조절
    CGRect newFrame = self.englishLabel.frame;
    newFrame.origin.y = self.roundRectedView.frame.origin.y + self.roundRectedView.frame.size.height + OFFSET_VIEW_BETWEEN_LABEL_AND_SWITCH;
    self.englishLabel.frame = newFrame;
    newFrame.origin.y += OFFSET_LABEL_HEIGHT;
    self.koreanLabel.frame = newFrame;
    newFrame.origin.y += OFFSET_LABEL_HEIGHT;
    self.japaneseLabel.frame = newFrame;
    newFrame.origin.y += OFFSET_LABEL_HEIGHT;
    self.simplifiedChineseLabel.frame = newFrame;
    newFrame.origin.y += OFFSET_LABEL_HEIGHT;
    self.traditionalChineseLabel.frame = newFrame;
}

- (void)initSwitchs {

    // dictionary에서 가져와서 bool 값을 지정해줌
    NSArray *quotesLanguagesList = [self.widgetDictionary objectForKey:@"quoteLanguagesList"];
    
    // 첫 위젯 로딩이라면 현재 언어를 파악해서 그것만 켜주기
    if (quotesLanguagesList == nil || quotesLanguagesList.count != 5) {
        NSInteger currentLanguageIndex = [MNLanguage getLanguageIndexFromCodeString:[MNLanguage getCurrentLanguage]];
        NSMutableArray *languagesList = [NSMutableArray array];
        for (int i=0; i<5; i++) {
            if (i == currentLanguageIndex) {
                [languagesList addObject:@YES];
            }else{
                [languagesList addObject:@NO];
            }
        }
        quotesLanguagesList = [NSArray arrayWithArray:languagesList];
    }
    
    //        NSLog(@"%@", quotesLangugesList);
    self.englishSwitch.on = ((NSNumber *)[quotesLanguagesList objectAtIndex:0]).boolValue;
    self.koreanSwitch.on = ((NSNumber *)[quotesLanguagesList objectAtIndex:1]).boolValue;
    self.japaneseSwitch.on = ((NSNumber *)[quotesLanguagesList objectAtIndex:2]).boolValue;
    self.simplifiedChineseSwitch.on = ((NSNumber *)[quotesLanguagesList objectAtIndex:3]).boolValue;
    self.traditionalChineseSwitch.on = ((NSNumber *)[quotesLanguagesList objectAtIndex:4]).boolValue;
    
    // 색 변경
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.englishSwitch.tintColor = [MNTheme getSwitchTintColorInModalController];
        self.koreanSwitch.tintColor = [MNTheme getSwitchTintColorInModalController];
        self.japaneseSwitch.tintColor = [MNTheme getSwitchTintColorInModalController];
        self.simplifiedChineseSwitch.tintColor = [MNTheme getSwitchTintColorInModalController];
        self.traditionalChineseSwitch.tintColor = [MNTheme getSwitchTintColorInModalController];
    }
    
//    self.englishSwitch.onTintColor = [MNTheme getSecondSubFontUIColor];
//    self.koreanSwitch.onTintColor = [MNTheme getSecondSubFontUIColor];
//    self.japaneseSwitch.onTintColor = [MNTheme getSecondSubFontUIColor];
//    self.simplifiedChineseSwitch.onTintColor = [MNTheme getSecondSubFontUIColor];
//    self.traditionalChineseSwitch.onTintColor = [MNTheme getSecondSubFontUIColor];
    
//    self.englishSwitch.backgroundColor = [UIColor blueColor];
//    self.koreanSwitch.backgroundColor = [UIColor blueColor];
//    self.japaneseSwitch.backgroundColor = [UIColor blueColor];
//    self.simplifiedChineseSwitch.backgroundColor = [UIColor blueColor];
//    self.traditionalChineseSwitch.backgroundColor = [UIColor blueColor];
    
    // 스위치 프레임 조절
    CGFloat iOSVersionOffset = 0;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        iOSVersionOffset = (SWITCH_HEIGHT_iOS7 - SWITCH_HEIGHT_iOS6) / 2;
    }
    
    CGRect newFrame = self.englishSwitch.frame;
    newFrame.origin.y = self.roundRectedView.frame.origin.y + self.roundRectedView.frame.size.height + OFFSET_VIEW_BETWEEN_LABEL_AND_SWITCH;
    self.englishSwitch.frame = newFrame;
    newFrame.origin.y += (OFFSET_LABEL_HEIGHT + iOSVersionOffset);
    self.koreanSwitch.frame = newFrame;
    newFrame.origin.y += (OFFSET_LABEL_HEIGHT + iOSVersionOffset);
    self.japaneseSwitch.frame = newFrame;
    newFrame.origin.y += (OFFSET_LABEL_HEIGHT + iOSVersionOffset);
    self.simplifiedChineseSwitch.frame = newFrame;
    newFrame.origin.y += (OFFSET_LABEL_HEIGHT + iOSVersionOffset);
    self.traditionalChineseSwitch.frame = newFrame;
    
    // addTargwet
    [self.englishSwitch addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.koreanSwitch addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.japaneseSwitch addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.simplifiedChineseSwitch addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.traditionalChineseSwitch addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)adjustQuoteLabelFrameWithHeight:(NSInteger)height {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect newQuoteLabelFrame = self.quoteLabel.frame;
        newQuoteLabelFrame.size.height = height;
        self.quoteLabel.frame = newQuoteLabelFrame;
        
        CGRect newRoundRectViewFrame = self.roundRectedView.frame;
        newRoundRectViewFrame.size.height = height + OFFSET_VIEW_BETWEEN_LABEL_AND_SWITCH*2;
        self.roundRectedView.frame = newRoundRectViewFrame;
    }else{
        CGRect newQuoteLabelFrame = self.quoteLabel.frame;
        newQuoteLabelFrame.size.height = height;
        self.quoteLabel.frame = newQuoteLabelFrame;
//        NSLog(@"quoteLabel frame: %@", NSStringFromCGRect(self.quoteLabel.frame));
//        if (QUOTES_DEBUG) {
//            self.roundRectedView.backgroundColor = [UIColor redColor];
//            self.quoteLabel.backgroundColor = [UIColor blueColor];
//        }
        CGRect newRoundRectViewFrame = self.roundRectedView.frame;
        newRoundRectViewFrame.size.height = height + OFFSET_VIEW_BETWEEN_LABEL_AND_SWITCH*2;
        self.roundRectedView.frame = newRoundRectViewFrame;
//        NSLog(@"roundRectedView frame: %@", NSStringFromCGRect(self.roundRectedView.frame));
    }
}

#pragma mark - quotes text 

- (NSString *)loadFirstQuotes {
    // dictionary에서 가져와서 bool 값을 지정해줌
    NSArray *quotesLanguagesList = [self.widgetDictionary objectForKey:@"quoteLanguagesList"];
    
    // 첫 위젯 로딩이라면 현재 언어를 파악해서 그것만 켜주기
    if (quotesLanguagesList == nil || quotesLanguagesList.count != 5) {
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
        quotesLanguagesList = [NSArray arrayWithArray:languagesList];
    }
    [self.widgetDictionary setObject:quotesLanguagesList forKey:@"quoteLanguagesList"];

    // 설정된 언어들중에서 명언을 골라주기

    // 선택된 언어중에서 랜덤 언어 인덱스와 랜덤 명언 인덱스를 생성해 명언에 대입
    NSInteger randomLanguageIndex = 0;

    // 1. 랜덤 언어 인덱스 - while문을 고려했지만 무한 루프에 빠지는 것을 방지하고자 100번만 돌림
    for (int i=0; i<100; i++) {
        randomLanguageIndex = arc4random() % 5; // 언어가 5개
        if (((NSNumber *)[quotesLanguagesList objectAtIndex:randomLanguageIndex]).boolValue == YES) {
            break;
        }
    }
    // 2. 랜덤 명언 인덱스
    NSArray *quotesDatasList = [MNQuotesLoader loadAllQuotesData];
    NSInteger randomQuotesIndex = 0;
    if ([quotesDatasList objectAtIndex:randomLanguageIndex]) {
        randomQuotesIndex = arc4random() % ((NSArray *)[quotesDatasList objectAtIndex:randomLanguageIndex]).count;
    }

    //    NSLog(@"language: %d / quote: %d", self.randomLanguageIndex, self.randomQuotesIndex);

    // 3. 명언을 구하기
    if (QUOTES_DEBUG) {
        randomLanguageIndex = QUOTES_DEBUG_LANGUAGE_INDEX;
        randomQuotesIndex = QUOTES_DEBUG_CONTENT_INDEX;
    }
    NSArray *quotesDataList = [quotesDatasList objectAtIndex:randomLanguageIndex];
    if (quotesDataList) {
        MNQuotesData *quotesData = [quotesDataList objectAtIndex:randomQuotesIndex];
        return [NSString stringWithFormat:@"%@\n%@", quotesData.quotesString, quotesData.authorString];
    }
    return nil;
}


#pragma mark - widget modal controller

- (void)doneButtonClicked {
    // 다섯개 switch 값을 모아서 전달
    NSArray *quotesLanguagesList = @[ @(self.englishSwitch.on),
                                      @(self.koreanSwitch.on),
                                      @(self.japaneseSwitch.on),
                                      @(self.simplifiedChineseSwitch.on),
                                      @(self.traditionalChineseSwitch.on)];
    
    [self.widgetDictionary setObject:quotesLanguagesList forKey:@"quoteLanguagesList"];
    
    [super doneButtonClicked];
}

- (void)cancelButtonClicked {
    [super cancelButtonClicked];
}


#pragma mark - switch handler method

- (void)checkSwitchStates {
    NSInteger counter = 0;
    UISwitch *lastSwitchWhichIsTurnedOn;
    
    if (self.englishSwitch.on) {
        counter += 1;
        lastSwitchWhichIsTurnedOn = self.englishSwitch;
    }
    if (self.koreanSwitch.on) {
        counter += 1;
        lastSwitchWhichIsTurnedOn = self.koreanSwitch;
    }
    if (self.japaneseSwitch.on) {
        counter += 1;
        lastSwitchWhichIsTurnedOn = self.japaneseSwitch;
    }
    if (self.simplifiedChineseSwitch.on) {
        counter += 1;
        lastSwitchWhichIsTurnedOn = self.simplifiedChineseSwitch;
    }
    if (self.traditionalChineseSwitch.on) {
        counter += 1;
        lastSwitchWhichIsTurnedOn = self.traditionalChineseSwitch;
    }
    
    if (counter == 1) {
        // 스위치가 눌렸을 때 자신을 제외한 모든 스위치가 off 라면, disable 시키기
        lastSwitchWhichIsTurnedOn.enabled = NO;
    }else{
        // 만약 on 되어 있는 스위치가 자신 포함 2개라면, 자신이 disable 되어 있다면 enable 시키기
        self.englishSwitch.enabled = YES;
        self.koreanSwitch.enabled = YES;
        self.japaneseSwitch.enabled = YES;
        self.simplifiedChineseSwitch.enabled = YES;
        self.traditionalChineseSwitch.enabled = YES;
    }
}

- (void)switchClicked:(UISwitch *)sender {
    [self checkSwitchStates];
}

#pragma mark - rotate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    return NO;
}


// for over iOS 6.0
- (BOOL)shouldAutorotate {
    return YES;
}


// Tell the system which initial orientation we want to have
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
    
}


// Tell the system what we support
-(NSUInteger)supportedInterfaceOrientations
{
    // return UIInterfaceOrientationMaskLandscapeRight;
    // return UIInterfaceOrientationMaskAll;
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - MNViewDelegate method

// 명언 복사 묻기
- (void)MNViewDidClicked {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:MNLocalizedString(@"cancel", @"취소")
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:MNLocalizedString(@"quotes_copy", @"복사"), nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:self.view];
}


#pragma mark - action sheet delegate method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //    NSLog(@"actionSheetButtonClicked: %d", buttonIndex);
    if (buttonIndex == 0) {
//        NSLog(@"복사");
        [[UIPasteboard generalPasteboard] setString:self.quoteLabel.text];
    }
}

@end
