//
//  MNWidgetCalendarView.m
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNWidgetCalendarView.h"
#import "MNTheme.h"
#import "MNLanguage.h"
#import "Flurry.h"

#define OFFSET_TO_LEFT_WHEN_LUNAR_ON_PORTRAIT ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 60 : 25)
#define OFFSET_TO_LEFT_WHEN_LUNAR_ON_LANDSCAPE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 90 : 35) // Last Q/A 변경전 40

#define OFFSET_MONTH_UNIVERSIAL ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 25 : 5)
#define OFFSET_WEEKDAY_UNIVERSIAL ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 62 : 43)
#define OFFSET_MONTH_LUNAR_UNIVERSIAL ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 14 : 5)
#define OFFSET_WEEKDAY_LUNAR_UNIVERSIAL ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 48 : 35)

// iPad Basic Alignment - Offset

#define OFFSET_BASIC_X 59
#define OFFSET_LUNAR_X -31

#define OFFSET_MONTH_Y 67
#define OFFSET_DAY_Y 29
#define OFFSET_WEEKDAY_Y -40

#define OFFSET_LUNAR_MONTH_Y 47
#define OFFSET_LUNAR_DAY_Y 19
#define OFFSET_LUNAR_WEEKDAY_Y -19

// 기본 달력 사이즈
#define SIZE_MONTH (CGSizeMake(226, 32))
#define SIZE_DAY (CGSizeMake(140, 62))
#define SIZE_WEEKDAY (CGSizeMake(226, 28))

#define SIZE_LUNAR_MONTH (CGSizeMake(120, 28))
#define SIZE_LUNAR_DAY (CGSizeMake(120, 40))
#define SIZE_LUNAR_WEEKDAY (CGSizeMake(120, 28))

// 기본 달력 폰트사이즈
#define FONTSIZE_MONTH ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 31 : 13)
#define FONTSIZE_DAY ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 83 : 41)
#define FONTSIZE_WEEKDAY ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 26 : 11)

#define FONSIZE_LUNAR_MONTH ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 19 : 9)
#define FONTSIZE_LUNAR_DAY ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 50 : 29)
#define FONTSIZE_LUNAR_WEEKDAY ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 16 : 8)

#define FONSIZE_LUNAR_MONTH_ENG ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 18 : 8)
#define FONTSIZE_LUNAR_DAY_ENG ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 49 : 28)
#define FONTSIZE_LUNAR_WEEKDAY_ENG ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 15 : 7)

// iPad Landscape Alignment - Offset

#define OFFSET_BASIC_X_LANDSCAPE 88
#define OFFSET_LUNAR_X_LANDSCAPE -35

#define OFFSET_MONTH_Y_LANDSCAPE 100
#define OFFSET_DAY_Y_LANDSCAPE 42
#define OFFSET_WEEKDAY_Y_LANDSCAPE -61

#define OFFSET_LUNAR_MONTH_Y_LANDSCAPE 65
#define OFFSET_LUNAR_DAY_Y_LANDSCAPE 27
#define OFFSET_LUNAR_WEEKDAY_Y_LANDSCAPE -39

// Size
#define SIZE_MONTH_LANDSCAPE (CGSizeMake(320, 58))
#define SIZE_DAY_LANDSCAPE (CGSizeMake(320, 97))
#define SIZE_WEEKDAY_LANDSCAPE (CGSizeMake(320, 38))

#define SIZE_LUNAR_MONTH_LANDSCAPE (CGSizeMake(200, 29))
#define SIZE_LUNAR_DAY_LANDSCAPE (CGSizeMake(200, 60))
#define SIZE_LUNAR_WEEKDAY_LANDSCAPE (CGSizeMake(200, 24))

// FontSize - Last QA +1씩
#define FONTSIZE_MONTH_LANDSCAPE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 47 : 14)
#define FONTSIZE_DAY_LANDSCAPE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 122 : 42)
#define FONTSIZE_WEEKDAY_LANDSCAPE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 40 : 12)

#define FONSIZE_LUNAR_MONTH_LANDSCAPE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 29 : 10)
#define FONTSIZE_LUNAR_DAY_LANDSCAPE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 74 : 29)
#define FONTSIZE_LUNAR_WEEKDAY_LANDSCAPE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 25 : 9)

#define FONSIZE_LUNAR_MONTH_LANDSCAPE_ENG ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 27 : 10)
#define FONTSIZE_LUNAR_DAY_LANDSCAPE_ENG ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 72 : 29)
#define FONTSIZE_LUNAR_WEEKDAY_LANDSCAPE_ENG ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 23 : 9)

@implementation MNWidgetCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWidgetView {
    // 매초 날짜를 체크해주는 타이머를 생성
    self.widgetCalendarTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(calculateCalendar:) userInfo:nil repeats:YES];
}

- (void)doWidgetLoadingInBackground {
    
    [self calculateCalendar:nil];
}

- (void)updateUI{
    if (self.isLunarCalendarOn) {
        self.label_Lunar_Day.alpha = 1;
        self.label_Lunar_DayOfWeek.alpha = 1;
        self.label_Lunar_Month.alpha = 1;
    }else{
        self.label_Lunar_Day.alpha = 0;
        self.label_Lunar_DayOfWeek.alpha = 0;
        self.label_Lunar_Month.alpha = 0;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self onRotationWithOrientation:orientation];
}

- (void)initThemeColor {
    [self calculateCalendar:nil];
//    self.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    
    self.label_Month.textColor = [MNTheme getMainFontUIColor];
    self.label_Day.textColor = [MNTheme getMainFontUIColor];
    self.label_DayOfWeek.textColor = [MNTheme getWidgetSubFontUIColor];
    
    if (self.isLunarCalendarOn) {
        self.label_Lunar_Month.textColor = [MNTheme getMainFontUIColor];
        self.label_Lunar_Day.textColor = [MNTheme getMainFontUIColor];
        self.label_Lunar_DayOfWeek.textColor = [MNTheme getWidgetSubFontUIColor];
    }
}

- (void)widgetClicked {
    // 아래 표기는 새로운 NSNumber 리터럴 표기법
//    NSLog(@"%@", @(self.isLunarCalendarOn));
    [self.widgetDictionary setObject:@(self.isLunarCalendarOn) forKey:@"isLunarCalendarOn"];
}

#pragma mark - on ratation
- (void)onRotationWithOrientation:(UIInterfaceOrientation)orientation {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // LANDSCAPE IPAD
        if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight))
        {
            CGRect newMonth = self.label_Month.frame;
            newMonth.size = SIZE_MONTH_LANDSCAPE;
            newMonth.origin.x = self.frame.size.width/2 -  newMonth.size.width/2;
            newMonth.origin.y = self.frame.size.height/2 - OFFSET_MONTH_Y_LANDSCAPE;
            CGRect newDay = self.label_Day.frame;
            newDay.size = SIZE_DAY_LANDSCAPE;
            newDay.origin.x = self.frame.size.width/2 -  newDay.size.width/2;
            newDay.origin.y = self.frame.size.height/2 - OFFSET_DAY_Y_LANDSCAPE;
            CGRect newDayOfWeek = self.label_DayOfWeek.frame;
            newDayOfWeek.size = SIZE_WEEKDAY_LANDSCAPE;
            newDayOfWeek.origin.x = self.frame.size.width/2 -  newDayOfWeek.size.width/2;
            newDayOfWeek.origin.y = self.frame.size.height/2 - OFFSET_WEEKDAY_Y_LANDSCAPE;
            
            CGRect newLunarMonth = self.label_Lunar_Month.frame;
            newLunarMonth.size = SIZE_LUNAR_MONTH_LANDSCAPE;
            newLunarMonth.origin.x = self.frame.size.width/2;
            newLunarMonth.origin.y = self.frame.size.height/2 - OFFSET_LUNAR_MONTH_Y_LANDSCAPE;
            CGRect newLunarDay = self.label_Lunar_Day.frame;
            newLunarDay.size = SIZE_LUNAR_DAY_LANDSCAPE;
            newLunarDay.origin.x = self.frame.size.width/2;
            newLunarDay.origin.y = self.frame.size.height/2 - OFFSET_LUNAR_DAY_Y_LANDSCAPE;
            CGRect newLunarDayOfWeek = self.label_Lunar_DayOfWeek.frame;
            newLunarDayOfWeek.size = SIZE_LUNAR_WEEKDAY_LANDSCAPE;
            newLunarDayOfWeek.origin.x = self.frame.size.width/2;
            newLunarDayOfWeek.origin.y = self.frame.size.height/2 - OFFSET_LUNAR_WEEKDAY_Y_LANDSCAPE;
            
            if (self.isLunarCalendarOn)
            {
                newMonth.origin.x -= OFFSET_BASIC_X_LANDSCAPE;
                newDay.origin.x -= OFFSET_BASIC_X_LANDSCAPE;
                newDayOfWeek.origin.x -= OFFSET_BASIC_X_LANDSCAPE;
                
                newLunarMonth.origin.x  -= OFFSET_LUNAR_X_LANDSCAPE;
                newLunarDayOfWeek.origin.x -= OFFSET_LUNAR_X_LANDSCAPE;
                newLunarDay.origin.x -= OFFSET_LUNAR_X_LANDSCAPE;
            }
            
            self.label_Month.frame = newMonth;
            self.label_Day.frame = newDay;
            self.label_DayOfWeek.frame = newDayOfWeek;
            
            self.label_Lunar_Month.frame = newLunarMonth;
            self.label_Lunar_Day.frame = newLunarDay;
            self.label_Lunar_DayOfWeek.frame = newLunarDayOfWeek;
            
            self.label_Month.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_MONTH_LANDSCAPE];
            self.label_Day.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_DAY_LANDSCAPE];
            self.label_DayOfWeek.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_WEEKDAY_LANDSCAPE];
            
            if ([[MNLanguage getCurrentLanguage] isEqualToString:@"en"]) {
                self.label_Lunar_Month.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONSIZE_LUNAR_MONTH_LANDSCAPE_ENG];
                self.label_Lunar_Day.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LUNAR_DAY_LANDSCAPE_ENG];
                self.label_Lunar_DayOfWeek.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LUNAR_WEEKDAY_LANDSCAPE_ENG];
            }else{
                self.label_Lunar_Month.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONSIZE_LUNAR_MONTH_LANDSCAPE];
                self.label_Lunar_Day.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LUNAR_DAY_LANDSCAPE];
                self.label_Lunar_DayOfWeek.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LUNAR_WEEKDAY_LANDSCAPE];
            }
        }
        // PORTRAIT IPAD
        else
        {
            CGRect newMonth = self.label_Month.frame;
            newMonth.size = SIZE_MONTH;
            newMonth.origin.x = self.frame.size.width/2 -  newMonth.size.width/2;
            newMonth.origin.y = self.frame.size.height/2 - OFFSET_MONTH_Y;
            CGRect newDay = self.label_Day.frame;
            newDay.size = SIZE_DAY;
            newDay.origin.x = self.frame.size.width/2 -  newDay.size.width/2;
            newDay.origin.y = self.frame.size.height/2 - OFFSET_DAY_Y;
            CGRect newDayOfWeek = self.label_DayOfWeek.frame;
            newDayOfWeek.size = SIZE_WEEKDAY;
            newDayOfWeek.origin.x = self.frame.size.width/2 -  newDayOfWeek.size.width/2;
            newDayOfWeek.origin.y = self.frame.size.height/2 - OFFSET_WEEKDAY_Y;
            
            CGRect newLunarMonth = self.label_Lunar_Month.frame;
            newLunarMonth.size = SIZE_LUNAR_MONTH;
            newLunarMonth.origin.x = self.frame.size.width/2;
            newLunarMonth.origin.y = self.frame.size.height/2 - OFFSET_LUNAR_MONTH_Y;
            CGRect newLunarDay = self.label_Lunar_Day.frame;
            newLunarDay.size = SIZE_LUNAR_DAY;
            newLunarDay.origin.x = self.frame.size.width/2;
            newLunarDay.origin.y = self.frame.size.height/2 - OFFSET_LUNAR_DAY_Y;
            CGRect newLunarDayOfWeek = self.label_Lunar_DayOfWeek.frame;
            newLunarDayOfWeek.size = SIZE_LUNAR_WEEKDAY;
            newLunarDayOfWeek.origin.x = self.frame.size.width/2;
            newLunarDayOfWeek.origin.y = self.frame.size.height/2 - OFFSET_LUNAR_WEEKDAY_Y;
            
            if (self.isLunarCalendarOn)
            {
                newMonth.origin.x -= OFFSET_BASIC_X;
                newDay.origin.x -= OFFSET_BASIC_X;
                newDayOfWeek.origin.x -= OFFSET_BASIC_X;
                
                newLunarMonth.origin.x  -= OFFSET_LUNAR_X;
                newLunarDayOfWeek.origin.x -= OFFSET_LUNAR_X;
                newLunarDay.origin.x -= OFFSET_LUNAR_X;
            }
            
            self.label_Month.frame = newMonth;
            self.label_Day.frame = newDay;
            self.label_DayOfWeek.frame = newDayOfWeek;
            
            self.label_Lunar_Month.frame = newLunarMonth;
            self.label_Lunar_Day.frame = newLunarDay;
            self.label_Lunar_DayOfWeek.frame = newLunarDayOfWeek;
            
            self.label_Month.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_MONTH];
            self.label_Day.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_DAY];
            self.label_DayOfWeek.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_WEEKDAY];
            
            if ([[MNLanguage getCurrentLanguage] isEqualToString:@"en"]) {
                self.label_Lunar_Month.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONSIZE_LUNAR_MONTH_ENG];
                self.label_Lunar_Day.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LUNAR_DAY_ENG];
                self.label_Lunar_DayOfWeek.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LUNAR_WEEKDAY_ENG];
            }else{
                self.label_Lunar_Month.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONSIZE_LUNAR_MONTH];
                self.label_Lunar_Day.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LUNAR_DAY];
                self.label_Lunar_DayOfWeek.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LUNAR_WEEKDAY];
            }
        }
    }
    else
    {
        if (self.isLunarCalendarOn)
        {
            // 가로만 수정해주면 될듯
            if (orientation == UIInterfaceOrientationPortrait)
            {
                [self setLunarCalendarFrameWithOffset:OFFSET_TO_LEFT_WHEN_LUNAR_ON_PORTRAIT];
                [self setCalendarFrameWithOffset:OFFSET_TO_LEFT_WHEN_LUNAR_ON_PORTRAIT];
                
                self.label_Month.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_MONTH];
                self.label_Day.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_DAY];
                self.label_DayOfWeek.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_WEEKDAY];
                
                if ([[MNLanguage getCurrentLanguage] isEqualToString:@"en"]) {
                    self.label_Lunar_Month.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONSIZE_LUNAR_MONTH_ENG];
                    self.label_Lunar_Day.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LUNAR_DAY_ENG];
                    self.label_Lunar_DayOfWeek.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LUNAR_WEEKDAY_ENG];
                }else{
                    self.label_Lunar_Month.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONSIZE_LUNAR_MONTH];
                    self.label_Lunar_Day.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LUNAR_DAY];
                    self.label_Lunar_DayOfWeek.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LUNAR_WEEKDAY];
                }
            }
            else
            {
                [self setLunarCalendarFrameWithOffset:OFFSET_TO_LEFT_WHEN_LUNAR_ON_LANDSCAPE];
                [self setCalendarFrameWithOffset:OFFSET_TO_LEFT_WHEN_LUNAR_ON_LANDSCAPE];
                
                self.label_Month.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_MONTH_LANDSCAPE];
                self.label_Day.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_DAY_LANDSCAPE];
                self.label_DayOfWeek.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_WEEKDAY_LANDSCAPE];
                
                self.label_Lunar_Month.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONSIZE_LUNAR_MONTH_LANDSCAPE];
                self.label_Lunar_Day.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LUNAR_DAY_LANDSCAPE];
                self.label_Lunar_DayOfWeek.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LUNAR_WEEKDAY_LANDSCAPE];
            }
        }
        else
        {
            // 음력이 없다면 중앙으로만 맞추면 됨
            [self setCalendarFrameWithOffset:0];
        }
    }
}

- (void)setCalendarFrameWithOffset:(NSInteger)offset {
    CGRect newDayFrame = self.label_Day.frame;
    newDayFrame.origin.x = self.frame.size.width/2 - newDayFrame.size.width/2 - offset;
    self.label_Day.frame = newDayFrame;
    
    CGRect newMonthFrame = self.label_Month.frame;
    newMonthFrame.origin.x = self.frame.size.width/2 - newMonthFrame.size.width/2 - offset;
    newMonthFrame.origin.y = newDayFrame.origin.y - OFFSET_MONTH_UNIVERSIAL;
    self.label_Month.frame = newMonthFrame;
    
    CGRect newDayOfWeekFrame = self.label_DayOfWeek.frame;
    newDayOfWeekFrame.origin.x = self.frame.size.width/2 - newDayOfWeekFrame.size.width/2 - offset;
    newDayOfWeekFrame.origin.y = newDayFrame.origin.y + OFFSET_WEEKDAY_UNIVERSIAL;
    self.label_DayOfWeek.frame = newDayOfWeekFrame;
}

- (void)setLunarCalendarFrameWithOffset:(NSInteger)offset {
    CGRect newLunarDayFrame = self.label_Lunar_Day.frame;
    newLunarDayFrame.origin.x = self.frame.size.width/2 - newLunarDayFrame.size.width/3 + offset;
    self.label_Lunar_Day.frame = newLunarDayFrame;
    
    CGRect newLunarMonthFrame = self.label_Lunar_Month.frame;
    newLunarMonthFrame.origin.x = self.frame.size.width/2 - newLunarMonthFrame.size.width/3 + offset;
    newLunarMonthFrame.origin.y = newLunarDayFrame.origin.y - OFFSET_MONTH_LUNAR_UNIVERSIAL;
    self.label_Lunar_Month.frame = newLunarMonthFrame;
    
    CGRect newLunarDayOfWeekFrame = self.label_Lunar_DayOfWeek.frame;
    newLunarDayOfWeekFrame.origin.x = self.frame.size.width/2 - newLunarDayOfWeekFrame.size.width/3 + offset;
    newLunarDayOfWeekFrame.origin.y = newLunarDayFrame.origin.y + OFFSET_WEEKDAY_LUNAR_UNIVERSIAL;
    self.label_Lunar_DayOfWeek.frame = newLunarDayOfWeekFrame;
}



#pragma mark - timer method

- (void)calculateCalendar:(NSTimer *)theTimer{
    self.isLunarCalendarOn = ((NSNumber *)[self.widgetDictionary valueForKey:@"isLunarCalendarOn"]).boolValue;
    
    // 메인 달력 계산
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
//    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];    // 모든 표시를 영어 대문자로
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:[MNLanguage getCurrentLanguage]];    // 현재 언어로 설정
    
    [formatter setDateFormat:@"MMMM"];
    NSString *month = [formatter stringFromDate:todayDate];
    [formatter setDateFormat:@"EEEE"];
    NSString *weekday = [formatter stringFromDate:todayDate];
    [formatter setDateFormat:@"dd"];
    NSString *day = [formatter stringFromDate:todayDate];
    
    // 테스트
//    [formatter setDateFormat:@"ss"];
//    NSString *second = [formatter stringFromDate:todayDate];
    
    
//    [formatter setDateFormat:@"hh:mm:ss"];
//    NSLog(@"%@", [formatter stringFromDate:todayDate]);
    
    self.label_Month.text = [month uppercaseString];
    self.label_Day.text = day;
    self.label_DayOfWeek.text = [weekday uppercaseString];
    
    // 음력 달력 계산
    if (self.isLunarCalendarOn) {
        
        // 테스트: 임의의 오늘을 만들어 보자
        // 테스트 완료 후에는 오늘 날짜 [NSDate date] 대입
        NSCalendar *testSolarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *testTodayComponents = [testSolarCalendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
        
        testTodayComponents.year = 2013;
        testTodayComponents.month = 1;
        testTodayComponents.day = 15;
//        NSDate *testTodayDate = [testSolarCalendar dateFromComponents:testTodayComponents];
        NSDate *testTodayDate = [NSDate date];
        
        NSCalendar *lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
        NSDateComponents *lunarComponents = [lunarCalendar components:(NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:testTodayDate];

        // 7월 8일로 테스트 1. - 6월 2일이 나옴
//        lunarComponents.month = 12;
//        lunarComponents.day = 23;
        
        NSDate *lunarDate = [[NSCalendar currentCalendar] dateFromComponents:lunarComponents];

        // 7월 8일 테스트 2. 둘다 있어야 함
//        lunarComponents = [lunarCalendar components:(NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:lunarDate];
//        lunarDate = [[NSCalendar currentCalendar] dateFromComponents:lunarComponents];
        
        NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:[MNLanguage getCurrentLanguage]];    // 현재 언어로 설정
        [formatter setDateFormat:@"MMMM"];
        NSString *lunarMonth = [formatter stringFromDate:lunarDate];

        // 사용 안하게 변경
//        [formatter setDateFormat:@"EEEE"];
//        NSString *lunarWeekday = [formatter stringFromDate:lunarDate];
        
        [formatter setDateFormat:@"dd"];
        NSString *lunarDay = [formatter stringFromDate:lunarDate];
//        lunarDay = [NSString stringWithFormat:@"%d", [lunarDay integerValue] - 1];
        // -1 을 하면 해결이 되지는 않음. 1일일 경우 0일이 나오는 것?
        lunarDay = [NSString stringWithFormat:@"%d", [lunarDay integerValue]];
        
        self.label_Lunar_Month.text = [lunarMonth uppercaseString];
        self.label_Lunar_Day.text = lunarDay;
        
        // 요일 계산 수정: 요일은 음력의 날짜를 양력에 대입한 날의 요일을 찾자 - 이사님 수정
        // 문제: 중국 달력의 년도가 이상하다. 2013년 = 음력 30년. 왜 그런지 모름.
        // 그래서 어쩔 수 없이 월일만 가지고 따져야 한다.
        // 일반적 케이스: 음력 월 < 양력 월이다. 음력 월이 작거나 같으면 무조건 같은 년도.
        // 음력 월이 양력 월보다 더 크다면 작년이다. ex) 양력 2013년 1월 23일 = 음력 2012년 12월 23일
        NSCalendar *solarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *solarComponents = [solarCalendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:testTodayDate];

        if (lunarComponents.month > solarComponents.month) {
            solarComponents.year -= 1;
        }
        solarComponents.month = lunarComponents.month;
        solarComponents.day = lunarComponents.day;
        NSDate *convertedLunarDate = [solarCalendar dateFromComponents:solarComponents];
//        NSLog(@"%@", convertedLunarDate);
        
        [formatter setDateFormat:@"EEEE"];
        NSString *lunarWeekday = [formatter stringFromDate:convertedLunarDate];
        
        self.label_Lunar_DayOfWeek.text = [lunarWeekday uppercaseString];
//        self.label_Lunar_DayOfWeek.text = self.label_DayOfWeek.text;
    
//        NSLog(@"%d/%d/%d", lunarComponents.year, lunarComponents.month, lunarComponents.day);
//        NSLog(@"%d/%d/%d", components.year, components.month, components.day);
    }
}

- (void)logEventOnFlurry
{
    [super logEventOnFlurry];
    
    NSDictionary *param;
    
    if (self.isLunarCalendarOn)
        param = [NSDictionary dictionaryWithObject:@"Yes" forKey:@"Is Using Lunar Calendar?"];
    else
        param = [NSDictionary dictionaryWithObject:@"No" forKey:@"Is Using Lunar Calendar?"];
    
    [Flurry logEvent:@"Calendar" withParameters:param];
}

- (void)stopTimer {
    [self.widgetCalendarTimer invalidate];
    self.widgetCalendarTimer = nil;
}


- (void)removeFromSuperview
{
//    NSLog(@"calendar: stop timer in removeFromSuperView");
	[self stopTimer];
	[super removeFromSuperview];
}

- (void)dealloc
{
//    NSLog(@"calendar: stop timer in dealloc");
	[self stopTimer];
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
