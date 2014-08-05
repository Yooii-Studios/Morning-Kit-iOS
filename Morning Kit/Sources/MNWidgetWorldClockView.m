//
//  MNWidgetWorldClockView.m
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNWidgetWorldClockView.h"
#import "MNDefinitions.h"
#import "MNRoundRectedViewMaker.h"
#import "MNTheme.h"
#import <QuartzCore/QuartzCore.h>
#import "MNTimeZoneProcessor.h"
#import "MNDaylightSavingTimeChecker.h"

@implementation MNWidgetWorldClockView

#define OFFSET_CLOCKVIEW_Y ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 50 : 15)

// iPhone 2*1 대비 오프셋
#define OFFSET_DAY_PHONE 25
#define OFFSET_CITYNAME_PHONE 38
#define SIZE_DAY_LABEL_PORTRAIT_PHONE (CGSizeMake(67, 21))
#define SIZE_CITY_LABEL_PORTRAIT_PHONE (CGSizeMake(67, 16))

#define SIZE_DAY_LABEL_LANDSCAPE_PHONE (CGSizeMake(129, 21))
#define SIZE_CITY_LABEL_LANDSCAPE_PHONE (CGSizeMake(129, 16))

// iPad 기본 오프셋
#define OFFSET_CLOCKVIEW_PORTRAIT 97
#define OFFSET_DAY_PORTRAIT -57
#define OFFSET_CITYNAME_PORTRAIT -80

#define OFFSET_DIGITAL_CLOCKVIEW 85

// iPad 기본 사이즈
#define SIZE_CLOCKVIEW_PORTRAIT (CGSizeMake(140, 140))
#define SIZE_DIGITAL_CLOCKVIEW_PORTRAIT (CGSizeMake(263, 117))
#define SIZE_LABEL_PORTRAIT (CGSizeMake(263, 32))

// iPad 기본 폰트사이즈
#define FONTSIZE_LABEL_PORTRAIT 20
#define FONTSIZE_DIGITAL_CLOCKVIEW_PORTRAIT 80
#define FONTSIZE_DIGITAL_AMPM_PORTRAIT 25

// iPad 가로 오프셋
#define OFFSET_CLOCKVIEW_LANDSCAPE 126
#define OFFSET_DAY_LANDSCAPE -74
#define OFFSET_CITYNAME_LANDSCAPE -103

#define OFFSET_DIGITAL_CLOCKVIEW_LANDSCAPE 115

// iPad 가로 사이즈
#define SIZE_CLOCKVIEW_LANDSCAPE (CGSizeMake(190, 190))
#define SIZE_LABEL_LANDSCAPE (CGSizeMake(322, 37))
#define SIZE_DIGITAL_CLOCKVIEW_LANDSCAPE (CGSizeMake(390, 160))

// iPad 가로 폰트사이즈
#define FONTSIZE_LABEL_LANDSCAPE 25
#define FONTSIZE_DIGITAL_CLOCKVIEW_LANDSCAPE 120
#define FONTSIZE_DIGITAL_AMPM_LANDSCAPE 37

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *label = [[UILabel alloc] init];
        label.text = @"worldclock";
        label.textAlignment = NSTextAlignmentCenter;
        [label setFrame:CGRectMake(0, 0, 100, 100)];
        [label setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]];
        
        [self addSubview:label];
    }

    return self;
}


#pragma mark - MNWidgetView methods

- (void)initWidgetView {
}

- (void)initClockView
{
    if (self.clockBaseImageView.alpha != 0)
        self.clockBaseImageView.alpha = 0;
    
    [self.clockView removeFromSuperview];
    self.clockView = nil;
    self.clockView = [[ClockView alloc] initWithFrame:self.clockBaseImageView.frame];
    self.clockView.clockType = self.clockType;
    
    // 24시간제 추가
    NSNumber *isUsing24HoursNumber = [self.widgetDictionary objectForKey:WORLD_CLOCK_USING_24HOURS];
    BOOL isUsing24Hours = NO;
    if (isUsing24HoursNumber) {
        isUsing24Hours = isUsing24HoursNumber.boolValue;
    }
    self.clockView.isUsing24Hours = isUsing24Hours;
    
//    [self.clockView setHourHandImage:[UIImage imageNamed:[MNTheme getWorldClockHourHandResourceName]].CGImage];
//	[self.clockView setMinHandImage:[UIImage imageNamed:[MNTheme getWorldClockMinuteHandResourceName]].CGImage];
//	[self.clockView setSecHandImage:[UIImage imageNamed:[MNTheme getWorldClockSecondHandResourceName]].CGImage];
    self.clockView.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:self.clockView];
    
    self.clockView.digitalFontSize = 37;
    self.clockView.digitalAMPMFontSize = 15;
    
    self.clockView.MNDelegate = self;
    [self.clockView layoutSubviews];
    [self.clockView startWithHourOffset:self.selectedTimeZone.hourOffset withMinuteOffset:self.selectedTimeZone.minuteOffset];
}

- (void)initDayDifferencePageControl {
    // 선택된 도시와 현지의 시간을 비교,
    // 12시 00초 맞추었을 때, 초 차이가 하루 이상 나면 전날/오늘/내일 비교해서 세팅해주기
    //    self.dayDifferencePageControl.currentPage = 1;
    self.dayDifferenceLabel.text = MNLocalizedString(@"world_clock_today", @"오늘");
}

- (void)initAMPMView {
    self.superViewOfAMPM.layer.cornerRadius = ROUNDED_CORNER_RADIUS_WORLD_CLOCK_AMPM;
    
    if (self.innerShadowLayer) {
        [self.innerShadowLayer removeFromSuperlayer];
        self.innerShadowLayer = nil;
    }
    self.innerShadowLayer = [[SKInnerShadowLayer alloc] init];
    // 위/아래 그라데이션
    self.innerShadowLayer.colors = (@[ (id)[UIColor clearColor].CGColor,
                                    (id)[UIColor clearColor].CGColor]);
	
	self.innerShadowLayer.frame = self.superViewOfAMPM.bounds;
	self.innerShadowLayer.cornerRadius = ROUNDED_CORNER_RADIUS_WORLD_CLOCK_AMPM;
    
	self.innerShadowLayer.innerShadowOpacity = 0.4f;
	self.innerShadowLayer.innerShadowColor = [UIColor blackColor].CGColor;
    
    //	self.innerShadowLayer.borderColor = [MNTheme getForwardBackgroundUIColor].CGColor;
    //    self.innerShadowLayer.borderColor = [UIColor blackColor].CGColor;
    self.innerShadowLayer.borderColor = [MNTheme getBackwardBackgroundUIColor].CGColor;
	self.innerShadowLayer.borderWidth = 0.5f;
    
    // 내가 초기화
    self.innerShadowLayer.innerShadowOffset = CGSizeMake(0, 0);
	
	[self.superViewOfAMPM.layer addSublayer:self.innerShadowLayer];
    [self.superViewOfAMPM bringSubviewToFront:self.ampmLabel];
    
//    if (self.clockType == WORLD_CLOCK_TYPE_ANALOG) {
//        self.superViewOfAMPM.alpha = 1;
//    }else{
//        self.superViewOfAMPM.alpha = 0;
//    }
    // am, pm 구분 - clockView Delegate 로 처리
    /*
     if(self.worldClockData.dateComponents.hour >= 0 && self.worldClockData.dateComponents.hour < 12) {
     self.ampmLabel.text = @"AM";
     }else{
     self.ampmLabel.text = @"PM";
     }
     */
}


#pragma mark - widget process

- (void)doWidgetLoadingInBackground {
    
    NSNumber *clockTimeNumber = [self.widgetDictionary objectForKey:WORLD_CLOCK_TYPE];
    if (clockTimeNumber) {
        self.clockType = clockTimeNumber.integerValue;
    }else{
        self.clockType = WORLD_CLOCK_TYPE_ANALOG;
    }
    
    NSData *selectedTimeZoneData = [self.widgetDictionary objectForKey:WORLD_CLOCK_SELECTED_TIMEZONE];
    if (selectedTimeZoneData) {
        self.selectedTimeZone = [NSKeyedUnarchiver unarchiveObjectWithData:selectedTimeZoneData];
    }else{
        // 입력값이 없으므로, 영어의 경우 Paris, 다른 곳의 경우 Los Angeles로 설정
        self.selectedTimeZone = [MNTimeZoneProcessor getDefaultTimeZone];
    }
    
    // worldClockDate 구하기
    // GMT 시간에서 offset을 적용
    NSDate *worldClockDate = [NSDate date];
    worldClockDate = [worldClockDate dateByAddingTimeInterval:(self.selectedTimeZone.hourOffset * 60 * 60 +
                                                               self.selectedTimeZone.minuteOffset * 60)];
    self.selectedTimeZone.worldClockDate = worldClockDate;
    
    // daylight saving time 구하기
    if ([MNDaylightSavingTimeChecker isTimeZoneInDaylightSavingTime:self.selectedTimeZone]) {
        self.selectedTimeZone.hourOffset += 1;
    }
}

- (void)updateUI
{
    NSNumber *isUsing24HoursNumber = [self.widgetDictionary objectForKey:WORLD_CLOCK_USING_24HOURS];
    BOOL isUsing24Hours = NO;
    if (isUsing24HoursNumber) {
        isUsing24Hours = isUsing24HoursNumber.boolValue;
    }
    self.clockView.isUsing24Hours = isUsing24Hours;
    
    if (self.clockType == WORLD_CLOCK_TYPE_ANALOG) {
        self.superViewOfAMPM.alpha = 1;
        if (!self.clockView || (self.clockView.clockType != self.clockType)) {
            [self initClockView];
        }
    }else{
        self.superViewOfAMPM.alpha = 0;
        
        if (!self.clockView || (self.clockView.clockType != self.clockType)) {
            [self initClockView];
        }
    }
    
    [self initAMPMView];
    [self initDayDifferencePageControl];
    
    if (self.selectedTimeZone.cityName) {
        self.cityNameLabel.text = self.selectedTimeZone.cityName;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        [self onRotationWithOrientation:orientation];
    }
}

#pragma mark - Language

- (void)onLanguageChanged
{
    [self doWidgetLoadingInBackground];
}

#pragma mark - Theme Color

- (void)initThemeColor {
//    NSLog(@"initThemeColor");
    
//    self.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    self.superViewOfAMPM.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    [self.clockView stop];
    [self.clockView startWithHourOffset:self.selectedTimeZone.hourOffset withMinuteOffset:self.selectedTimeZone.minuteOffset];
    [self initAMPMView];
    self.ampmLabel.textColor = [MNTheme getMainFontUIColor];
    
    self.cityNameLabel.textColor = [MNTheme getWidgetSubFontUIColor];
    self.dayDifferenceLabel.textColor = [MNTheme getWidgetSubFontUIColor];
    
    // 레이블 프레임 조절
    if (self.dayDifferneceLabelOffsetY == 0) {
        
        self.dayDifferneceLabelOffsetY = self.frame.size.height - self.dayDifferenceLabel.frame.origin.y;
        self.cityNameLabelOffsetY = self.frame.size.height - self.cityNameLabel.frame.origin.y;
    }
}


#pragma mark - Click Handler

- (void)widgetClicked {
}

#pragma mark - ClockView Delegate

- (void)shouldChangeBackgroundTo:(MNTimeState)ampmState {
    if (ampmState == MNTimeStateAM) {
        [self.clockView setClockBackgroundImage:[UIImage imageNamed:[MNTheme getWorldClockAMBaseResourceName]].CGImage];
        [self.clockView setHourHandImage:[UIImage imageNamed:[MNTheme getWorldClockHourHandResourceName:@"AM"]].CGImage];
        [self.clockView setMinHandImage:[UIImage imageNamed:[MNTheme getWorldClockMinuteHandResourceName:@"AM"]].CGImage];
        [self.clockView setSecHandImage:[UIImage imageNamed:[MNTheme getWorldClockSecondHandResourceName:@"AM"]].CGImage];
    }else{
        [self.clockView setClockBackgroundImage:[UIImage imageNamed:[MNTheme getWorldClockPMBaseResourceName]].CGImage];
        [self.clockView setHourHandImage:[UIImage imageNamed:[MNTheme getWorldClockHourHandResourceName:@"PM"]].CGImage];
        [self.clockView setMinHandImage:[UIImage imageNamed:[MNTheme getWorldClockMinuteHandResourceName:@"PM"]].CGImage];
        [self.clockView setSecHandImage:[UIImage imageNamed:[MNTheme getWorldClockSecondHandResourceName:@"PM"]].CGImage];
    }
}

- (void)shouldChangeLabelTo:(MNTimeState)ampmState {
    if (ampmState == MNTimeStateAM) {
        self.ampmLabel.text = MNLocalizedString(@"alarm_am", @"AM"); // @"AM";
    }else{
        self.ampmLabel.text = MNLocalizedString(@"alarm_pm", @"PM"); // @"PM";
    }
}

- (void)shouldChangeDayDifferenceTo:(MNDayDifference)dayDifference {
    //    self.dayDifferencePageControl.currentPage = dayDifference;
    
    switch (dayDifference) {
        case MNDayDifferenceYesterDay:
            self.dayDifferenceLabel.text = MNLocalizedString(@"world_clock_yesterday", @"어제");
            break;
            
        case MNDayDifferenceToday:
            self.dayDifferenceLabel.text = MNLocalizedString(@"world_clock_today", @"오늘");
            break;
            
        case MNDayDifferenceTomorrow:
            self.dayDifferenceLabel.text = MNLocalizedString(@"world_clock_tomorrow", @"내일");
            break;
    }
}


#pragma mark - on ratation

- (void)onRotationWithOrientation:(UIInterfaceOrientation)orientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // LANDSCAPE IPAD
        if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight))
        {
            CGRect newClockViewFrame = self.clockView.frame;
            
            if (self.clockType == WORLD_CLOCK_TYPE_DIGITAL)
            {
                newClockViewFrame.size = SIZE_DIGITAL_CLOCKVIEW_LANDSCAPE;
                newClockViewFrame.origin.x = self.frame.size.width/2 - newClockViewFrame.size.width/2;
                newClockViewFrame.origin.y = self.frame.size.height/2 - OFFSET_DIGITAL_CLOCKVIEW_LANDSCAPE;
                
                self.clockView.digitalAMPMFontSize = FONTSIZE_DIGITAL_AMPM_LANDSCAPE;
                self.clockView.digitalFontSize = FONTSIZE_DIGITAL_CLOCKVIEW_LANDSCAPE;
            }
            else
            {
                newClockViewFrame.size = SIZE_CLOCKVIEW_LANDSCAPE;
                newClockViewFrame.origin = CGPointMake(self.frame.size.width/2 - newClockViewFrame.size.width/2, self.frame.size.height/2 - OFFSET_CLOCKVIEW_LANDSCAPE);
            }
            self.clockView.digitalClockLabel.frame = CGRectMake(0, 0, newClockViewFrame.size.width, newClockViewFrame.size.height);
            self.clockView.frame = newClockViewFrame;
            
            CGRect newCityNameFrame = self.cityNameLabel.frame;
            newCityNameFrame.size = SIZE_LABEL_LANDSCAPE;
            newCityNameFrame.origin = CGPointMake(self.frame.size.width/2 - newCityNameFrame.size.width/2, self.frame.size.height/2 - OFFSET_CITYNAME_LANDSCAPE);
            self.cityNameLabel.frame = newCityNameFrame;
            
            CGRect newDayFrame = self.clockView.frame;
            newDayFrame.size = SIZE_LABEL_LANDSCAPE;
            newDayFrame.origin = CGPointMake(self.frame.size.width/2 - newDayFrame.size.width/2, self.frame.size.height/2 - OFFSET_DAY_LANDSCAPE);
            self.dayDifferenceLabel.frame = newDayFrame;
            
            self.cityNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LABEL_LANDSCAPE];
            self.dayDifferenceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LABEL_LANDSCAPE];
        }
        // PORTRAIT IPAD
        else
        {
            CGRect newClockViewFrame = self.clockView.frame;
            if (self.clockType == WORLD_CLOCK_TYPE_DIGITAL)
            {
                newClockViewFrame.size = SIZE_DIGITAL_CLOCKVIEW_PORTRAIT;
                newClockViewFrame.origin.x = self.frame.size.width/2 - newClockViewFrame.size.width/2;
                newClockViewFrame.origin.y = self.frame.size.height/2 - OFFSET_DIGITAL_CLOCKVIEW;
                
                self.clockView.digitalAMPMFontSize = FONTSIZE_DIGITAL_AMPM_PORTRAIT;
                self.clockView.digitalFontSize = FONTSIZE_DIGITAL_CLOCKVIEW_PORTRAIT;
            }
            else
            {
                newClockViewFrame.size = SIZE_CLOCKVIEW_PORTRAIT;
                newClockViewFrame.origin = CGPointMake(self.frame.size.width/2 - newClockViewFrame.size.width/2, self.frame.size.height/2 - OFFSET_CLOCKVIEW_PORTRAIT);
            }
            self.clockView.digitalClockLabel.frame = CGRectMake(0, 0, newClockViewFrame.size.width, newClockViewFrame.size.height);
            self.clockView.frame = newClockViewFrame;
            
            CGRect newCityNameFrame = self.cityNameLabel.frame;
            newCityNameFrame.size = SIZE_LABEL_PORTRAIT;
            newCityNameFrame.origin = CGPointMake(self.frame.size.width/2 - newCityNameFrame.size.width/2, self.frame.size.height/2 - OFFSET_CITYNAME_PORTRAIT);
            self.cityNameLabel.frame = newCityNameFrame;
            
            CGRect newDayFrame = self.clockView.frame;
            newDayFrame.size = SIZE_LABEL_PORTRAIT;
            newDayFrame.origin = CGPointMake(self.frame.size.width/2 - newDayFrame.size.width/2, self.frame.size.height/2 - OFFSET_DAY_PORTRAIT);
            self.dayDifferenceLabel.frame = newDayFrame;
            
            self.cityNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LABEL_PORTRAIT];
            self.dayDifferenceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONTSIZE_LABEL_PORTRAIT];
        }
    }
    else
    {        
        // 시계쪽 조절
        CGRect newCityNameFrame = self.cityNameLabel.frame;
        CGRect newDayDiffenceFrame = self.dayDifferenceLabel.frame;
        CGFloat labelOffset = 0;
        
        if (orientation == UIInterfaceOrientationPortrait)
        {
            self.clockView.frame = self.clockBaseImageView.frame;
            self.clockView.digitalFontSize = 35;
            newCityNameFrame.size = SIZE_CITY_LABEL_PORTRAIT_PHONE;
            newDayDiffenceFrame.size = SIZE_DAY_LABEL_PORTRAIT_PHONE;
        }
        else
        {
            CGRect newClockViewFrame = self.clockView.frame;
            newClockViewFrame.origin.x = self.frame.size.width/2 - self.clockView.frame.size.width/2;
            newClockViewFrame.origin.y = self.frame.size.height/2 - self.clockView.frame.size.height/2 - OFFSET_CLOCKVIEW_Y;
            self.clockView.frame = newClockViewFrame;
            self.clockView.digitalFontSize = 37;
            newCityNameFrame.size = SIZE_CITY_LABEL_LANDSCAPE_PHONE;
            newDayDiffenceFrame.size = SIZE_DAY_LABEL_LANDSCAPE_PHONE;
//            labelOffset = OFFSET_CLOCKVIEW_Y;
        }
        
        newCityNameFrame.origin = CGPointMake(self.frame.size.width/2 - newCityNameFrame.size.width/2, self.frame.size.height/2 - newCityNameFrame.size.height/2 + OFFSET_CITYNAME_PHONE + labelOffset);
//        newCityNameFrame.size.width = self.frame.size.width/2 - 10; // 10은 그냥 넘치지 않게 하기 위해
//        newCityNameFrame.origin.x = self.frame.size.width/2 - newCityNameFrame.size.width/2;
//        newCityNameFrame.origin.y = self.frame.size.height - self.cityNameLabelOffsetY;
        
        newDayDiffenceFrame.origin = CGPointMake(self.frame.size.width/2 - newDayDiffenceFrame.size.width/2, self.frame.size.height/2 - newDayDiffenceFrame.size.height/2 + OFFSET_DAY_PHONE + labelOffset);
//        newDayDiffenceFrame.size.width = self.frame.size.width/2 - 10;
//        newDayDiffenceFrame.origin.x = self.frame.size.width/2 - newDayDiffenceFrame.size.width/2;
//        newDayDiffenceFrame.origin.y = self.frame.size.height - self.dayDifferneceLabelOffsetY;
        self.dayDifferenceLabel.frame = newDayDiffenceFrame;
        
        // 아이폰에서는 세로일 경우를 제외하고 전부 맞추어 준다. 
        if (self.clockType == WORLD_CLOCK_TYPE_DIGITAL) {
            newDayDiffenceFrame.origin.y -= 10;
            newCityNameFrame.origin.y -= 10;
            self.clockView.digitalAMPMFontSize = 15;
//            self.clockView.digitalFontSize = 37;
        }else{
            if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
                newDayDiffenceFrame.origin.y += 5;
                newCityNameFrame.origin.y += 5;
            }
        }
        
        self.cityNameLabel.frame = newCityNameFrame;
        self.dayDifferenceLabel.frame = newDayDiffenceFrame;
        
//        NSLog(@"%@", NSStringFromCGRect(newCityNameFrame));
//        NSLog(@"%@", NSStringFromCGRect(newDayDiffenceFrame));
//        NSLog(@"city offset: %f", self.frame.size.height/2 - newCityNameFrame.size.height/2 - newCityNameFrame.origin.y);
//        NSLog(@"day offset: %f", self.frame.size.height/2 - newDayDiffenceFrame.size.height/2 - newDayDiffenceFrame.origin.y);
    }
    
//    NSLog(@"%d", self.clockView.digitalFontSize);
    [self.clockView stop];
    [self.clockView startWithHourOffset:self.selectedTimeZone.hourOffset withMinuteOffset:self.selectedTimeZone.minuteOffset];
    
//    NSLog(@"%f %f %f %f", self.clockView.frame.origin.x, self.clockView.frame.origin.y
//          , self.clockView.frame.size.width, self.clockView.frame.size.height);
}

@end
