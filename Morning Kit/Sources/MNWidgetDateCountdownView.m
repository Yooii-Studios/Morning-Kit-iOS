//
//  MNWidgetDateCountdownView.m
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNWidgetDateCountdownView.h"
#import "MNTheme.h"
#import "MNDefinitions.h"

#define KEY_DATE @"DATE"
#define KEY_TAG @"TAG"

// 아이패드 기본 오프셋
#define OFFSET_CONTENT 68
#define OFFSET_COUNT 10
#define OFFSET_DATE -80
// 아이패드 가로모드 오프셋
#define OFFSET_CONTENT_LAND 100
#define OFFSET_COUNT_LAND 20
#define OFFSET_DATE_LAND -100
// 아이패드 기본 폰트 사이즈
#define FONTSIZE_CONTENT 43
#define FONTSIZE_COUNT 43
#define FONTSIZE_DATE 20
// 아이패드 가로모드 폰트 사이즈
#define FONTSIZE_CONTENT_LAND 60
#define FONTSIZE_COUNT_LAND 60
#define FONTSIZE_DATE_LAND 25
// 아이패드 기본 크기
#define WIDTH 316
#define HEIGHT_CONTENT 40
#define HEIGHT_COUNT 40
#define HEIGHT_DATE 20
// 아이패드 가로모드 크기
#define WIDTH_LAND 420
#define HEIGHT_CONTENT_LAND 50
#define HEIGHT_COUNT_LAND 50
#define HEIGHT_DATE_LAND 25


@implementation MNWidgetDateCountdownView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWidgetView {
    
}

- (void)initThemeColor {
    NSDate *targetDate = [self.widgetDictionary objectForKey:DATE_COUNTDOWN_DATE];
    if (targetDate) {
        self.countLabel.textColor = [MNTheme getWidgetPointFontUIColor];
    }else{
        self.countLabel.textColor = [MNTheme getMainFontUIColor];
    }
    
//    self.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    self.contentLabel.textColor = [MNTheme getMainFontUIColor];
//    self.countLabel.textColor = [MNTheme getWidgetPointFontUIColor];
    self.dateLabel.textColor = [MNTheme getWidgetSubFontUIColor];
//    NSLog(@"%@", NSStringFromCGRect(self.dateLabel.frame));
//    NSLog(@"%@", NSStringFromCGRect(self.frame));
}

- (void)doWidgetLoadingInBackground {
    // 기념일 계산
    NSString *title = [self.widgetDictionary objectForKey:DATE_COUNTDOWN_TITLE];
    NSDate *targetDate = [self.widgetDictionary objectForKey:DATE_COUNTDOWN_DATE];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy.MM.dd"];
    [format setTimeStyle:NSDateFormatterNoStyle];
    [format setDateStyle:NSDateFormatterMediumStyle];

    if (targetDate)
    {
            
//            NSString *countString = [self calculateCountString:targetDate];
//            self.contentString = [NSString stringWithFormat:@"%@\n%@", title, countString];
        self.contentLabel.text = title;
        
        // 새해 타이틀은 언어에 따라 교체해주기
        if ([self.widgetDictionary objectForKey:DATE_COUNTDOWN_IS_TITLE_NEW_YEAR]) {
            self.contentLabel.text = MNLocalizedString(@"date_countdown_new_year", nil);
        }
        
        self.countLabel.text = [self calculateCountString:targetDate];
        self.dateLabel.text = [format stringFromDate:targetDate];
    }
    else
    {
        self.contentLabel.text = MNLocalizedString(@"date_countdown_date", @"날짜");
        self.countLabel.text = MNLocalizedString(@"date_countdown_countdown", @"계산");
        
        // 기존 오늘 날짜를 바꾸는 것에서 변경
//        self.dateLabel.text = [format stringFromDate:[NSDate date]];
        self.dateLabel.text = MNLocalizedString(@"date_countdown_create_countdown", @"날짜 계산 입력");
    }

}

- (void)updateUI {
//    self.contentLabel.text = self.contentString;
}

- (void)onRotationWithOrientation:(UIInterfaceOrientation)orientation
{
    // iPad일때만 처리
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight))
        {
            CGRect widgetFrame = self.frame;
            CGRect newContentLabel = self.contentLabel.frame;
            CGRect newCountLabel = self.countLabel.frame;
            CGRect newDateLabel = self.dateLabel.frame;
            
            newContentLabel.size = CGSizeMake(WIDTH_LAND, HEIGHT_CONTENT_LAND);
            newCountLabel.size = CGSizeMake(WIDTH_LAND, HEIGHT_COUNT_LAND);
            newDateLabel.size = CGSizeMake(WIDTH_LAND, HEIGHT_DATE_LAND);
            
            newContentLabel.origin.x = widgetFrame.size.width/2 - newContentLabel.size.width/2;
            newContentLabel.origin.y = widgetFrame.size.height/2 - OFFSET_CONTENT_LAND;
            newCountLabel.origin.x = widgetFrame.size.width/2 - newCountLabel.size.width/2;
            newCountLabel.origin.y = widgetFrame.size.height/2 - OFFSET_COUNT_LAND;
            newDateLabel.origin.x = widgetFrame.size.width/2 - newDateLabel.size.width/2;
            newDateLabel.origin.y = widgetFrame.size.height/2 - OFFSET_DATE_LAND;
            
            self.contentLabel.frame = newContentLabel;
            self.countLabel.frame = newCountLabel;
            self.dateLabel.frame = newDateLabel;
            
            self.contentLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_CONTENT_LAND];
            self.countLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_COUNT_LAND];
            self.dateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_DATE_LAND];
        }
        else
        {
            CGRect widgetFrame = self.frame;
            CGRect newContentLabel = self.contentLabel.frame;
            CGRect newCountLabel = self.countLabel.frame;
            CGRect newDateLabel = self.dateLabel.frame;
            
            newContentLabel.size = CGSizeMake(WIDTH, HEIGHT_CONTENT);
            newCountLabel.size = CGSizeMake(WIDTH, HEIGHT_COUNT);
            newDateLabel.size = CGSizeMake(WIDTH, HEIGHT_DATE);
            
            newContentLabel.origin.x = widgetFrame.size.width/2 - newContentLabel.size.width/2;
            newContentLabel.origin.y = widgetFrame.size.height/2 - OFFSET_CONTENT;
            newCountLabel.origin.x = widgetFrame.size.width/2 - newCountLabel.size.width/2;
            newCountLabel.origin.y = widgetFrame.size.height/2 - OFFSET_COUNT;
            newDateLabel.origin.x = widgetFrame.size.width/2 - newDateLabel.size.width/2;
            newDateLabel.origin.y = widgetFrame.size.height/2 - OFFSET_DATE;
            
            self.contentLabel.frame = newContentLabel;
            self.countLabel.frame = newCountLabel;
            self.dateLabel.frame = newDateLabel;
            
            self.contentLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_CONTENT];
            self.countLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_COUNT];
            self.dateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_DATE];
        }
    }
}

- (void)widgetClicked
{
}

- (void)onLanguageChanged
{
    [self doWidgetLoadingInBackground];
}

#pragma mark - process

- (NSString *)calculateCountString:(NSDate *)targetDate {
    // 오늘이면 Today, 아니면 D+/-321 같은 식으로 표현
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *todayDate = [NSDate date];
    
    NSDateComponents *todayDateComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:todayDate];
    todayDateComponents.hour = 0;
    todayDateComponents.minute = 0;
    todayDateComponents.second = 0;
    todayDate = [calendar dateFromComponents:todayDateComponents];
    
    NSDateComponents *targetDateComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:targetDate];
    targetDateComponents.hour = 0;
    targetDateComponents.minute = 0;
    targetDateComponents.second = 0;
    targetDate = [calendar dateFromComponents:targetDateComponents];
    
    NSInteger dayCount = [targetDate timeIntervalSinceDate:todayDate] / 60 / 60 / 24;
//    NSLog(@"dayCount: %d", dayCount);
    
    NSString *countString;
    if (dayCount == 0)
    {
        countString = MNLocalizedString(@"world_clock_today", @"오늘");
    }else if(dayCount > 0) {
        countString = [NSString stringWithFormat:@"D-%d", +dayCount];
    }else{
        countString = [NSString stringWithFormat:@"D+%d", -(dayCount-1)];
    }
    
    return countString;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
