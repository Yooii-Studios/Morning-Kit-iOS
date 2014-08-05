//
//  MNReminderModalController.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 9. 27..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNReminderModalController.h"
#import "MNTheme.h"
#import "MNRoundRectedViewMaker.h"
#import "MNLanguage.h"

#define FONT_SIZE 20
#define MIN_FONT_SIZE 10

#define DATE_FONT_SIZE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 20 : 14)
#define TITLE_FONT_SIZE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 16 : 12)
#define LINE_HEIGHT_SCALE_FACTOR ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2.0f : 1.6f)

@interface MNReminderModalController ()

@end

@implementation MNReminderModalController

#pragma mark - View Lifecycle

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
    
    self.view.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
//    self.textView.font = [UIFont fontWithName:@"Helvetica-bold" size:40];
    
    self.eventLoader = [[MNCalendarEventLoader alloc] init];
    self.eventLoader.delegate = self;
    [self.eventLoader loadEvents];
    
    [MNRoundRectedViewMaker makeRoundRectedView:self.textView.superview];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.superview.backgroundColor = [MNTheme getForwardBackgroundUIColor];
//    self.textView.clipsToBounds = YES;
    
    self.scheduleLabel.text = MNLocalizedString(@"reminder_event", @"Events");
    self.scheduleLabel.textColor = [MNTheme getMainFontUIColor];
    self.birthdayLabel.text = MNLocalizedString(@"reminder_birthday", @"reminder_birthday");
    self.birthdayLabel.textColor = [MNTheme getMainFontUIColor];
    
    [self.birthDaySwitch setOn:self.showBirthday animated:NO];
    [self.scheduleSwitch setOn:self.showSchedule animated:NO];
    
    if (self.birthDaySwitch.on && !self.scheduleSwitch.on) {
        self.birthDaySwitch.enabled = NO;
    }else if(!self.birthDaySwitch.on && self.scheduleSwitch.on) {
        self.scheduleSwitch.enabled = NO;
    }else{
        self.birthDaySwitch.enabled = YES;
        self.scheduleSwitch.enabled = YES;
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.birthDaySwitch.tintColor = [MNTheme getSwitchTintColorInModalController];
        self.scheduleSwitch.tintColor = [MNTheme getSwitchTintColorInModalController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Widget Modal View Controller Methods

- (void)initWithDictionary:(NSMutableDictionary *)dict
{
    [super initWithDictionary:dict];
    
    if (dict[WIDGETKEY_SHOW_SCHEDULE] && dict[WIDGETKEY_SHOW_BIRTHDAY])
    {
        self.showBirthday = [dict[WIDGETKEY_SHOW_BIRTHDAY] boolValue];
        self.showSchedule = [dict[WIDGETKEY_SHOW_SCHEDULE] boolValue];
    }
    else
    {
        // 없다면 마지막 설정 값이 있는지 체크
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *latestSettings = [defaults objectForKey:@"reminder_lastsettings"];
        
        if (latestSettings)
        {
            self.showSchedule = [latestSettings[SHARED_WIDGETKEY_SHOW_SCHEDULE] boolValue];
            self.showBirthday = [latestSettings[SHARED_WIDGETKEY_SHOW_BIRTHDAY] boolValue];
            
            [self.widgetDictionary setObject:[NSNumber numberWithBool:self.showSchedule] forKey:WIDGETKEY_SHOW_SCHEDULE];
            [self.widgetDictionary setObject:[NSNumber numberWithBool:self.showBirthday] forKey:WIDGETKEY_SHOW_BIRTHDAY];
        }
        else
        {
            self.showBirthday = YES;
            self.showSchedule = YES;
            
            [self.widgetDictionary setObject:[NSNumber numberWithBool:self.showSchedule] forKey:WIDGETKEY_SHOW_SCHEDULE];
            [self.widgetDictionary setObject:[NSNumber numberWithBool:self.showBirthday] forKey:WIDGETKEY_SHOW_BIRTHDAY];
        }
    }
}

- (void)doneButtonClicked
{
    [self.widgetDictionary setObject:[NSNumber numberWithBool:self.showSchedule] forKey:WIDGETKEY_SHOW_SCHEDULE];
    [self.widgetDictionary setObject:[NSNumber numberWithBool:self.showBirthday] forKey:WIDGETKEY_SHOW_BIRTHDAY];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *latestSettings = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithBool:self.showSchedule], SHARED_WIDGETKEY_SHOW_SCHEDULE,
                                           [NSNumber numberWithBool:self.showBirthday], SHARED_WIDGETKEY_SHOW_BIRTHDAY, nil];
    [userDefaults setObject:latestSettings forKey:@"reminder_lastsettings"];
    
    [super doneButtonClicked];
}

- (void)cancelButtonClicked
{
    [super cancelButtonClicked];
}

#pragma mark - Reminder Widget Modal Methods

- (void)showEvents
{
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        self.textView.numberOfLines = 11;
//        self.textView.minimumScaleFactor = 0.5f;
//    }
//    else
//    {
//        self.eventLabel.numberOfLines = 8;
//        self.eventLabel.minimumScaleFactor = 0.5f;
//    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    if (self.allDayEvents.count > 0 && self.showSchedule)
        [attributedString appendAttributedString:[self getAlldayEventsString:self.allDayEvents]];
    if (self.birthDayEvents.count > 0 && self.showBirthday)
        [attributedString appendAttributedString:[self getBirthDayEventsString:self.birthDayEvents]];
    if (self.scheduleEvents.count > 0 && self.showSchedule)
        [attributedString appendAttributedString:[self getScheduleEventsString:self.scheduleEvents]];
    
    if (self.tomorrowEvents.count > 0 && ((self.showBirthday && self.tomorrowBirthDayEvents.count > 0)
        || (self.showSchedule && (self.tomorrowAllDayEvents.count > 0 || self.tomorrowScheduleEvents.count > 0))))
    {
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:DATE_FONT_SIZE];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.lineHeightMultiple = LINE_HEIGHT_SCALE_FACTOR;
//        NSLog(@"%f", paragraphStyle.lineHeightMultiple);
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, [MNTheme getWidgetPointFontUIColor], NSForegroundColorAttributeName ,nil];
        NSMutableAttributedString *tomorrowString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",MNLocalizedString(@"world_clock_tomorrow", nil)] attributes:attributes];
        [attributedString appendAttributedString:tomorrowString];
    }
    
    
    if (self.tomorrowAllDayEvents.count > 0 && self.showSchedule)
        [attributedString appendAttributedString:[self getAlldayEventsString:self.tomorrowAllDayEvents]];
    if (self.tomorrowBirthDayEvents.count > 0 && self.showBirthday)
        [attributedString appendAttributedString:[self getBirthDayEventsString:self.tomorrowBirthDayEvents]];
    if (self.tomorrowScheduleEvents.count > 0 && self.showSchedule)
        [attributedString appendAttributedString:[self getScheduleEventsString:self.tomorrowScheduleEvents]];
    
    if (attributedString.length == 0)
    {
        //        attributedString = [[NSMutableAttributedString alloc] initWithString:@"No Schedule Today"];
        //        NSRange range = NSMakeRange(0, attributedString.length);
        //        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        //        paragraph.alignment = NSTextAlignmentCenter;
        //        [attributedString addAttribute:NSForegroundColorAttributeName value:[MNTheme getWidgetCalendarEvnetFontUIColor] range:range];
        //        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:range];
//        [self.loadingDelegate showWidgetErrorMessage:@"No Schedule Today"];
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:DATE_FONT_SIZE];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [MNTheme getWidgetPointFontUIColor], NSForegroundColorAttributeName, nil];
        attributedString = [[NSMutableAttributedString alloc] initWithString:MNLocalizedString(@"reminder_no_schedule", @"NO Schedule") attributes:attributes];
    }
    
    //    self.eventLabel.adjustsLetterSpacingToFitWidth = YES;
    //    CGFloat fontSize = [self fontSizeWithFont:self.eventLabel.font constrainedToSize:self.frame.size string:attributedString.string];
    
    //    self.eventLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:fontSize];
    self.textView.attributedText = attributedString;
    
//    [self adjustFontForLabel];
}

- (void)groupEvents
{
    self.allDayEvents = [NSMutableArray array];
    self.birthDayEvents = [NSMutableArray array];
    self.scheduleEvents = [NSMutableArray array];
    
    // 각 이벤트 별 어트리뷰티드 스트링 메이킹
    for (MNCalendarEvent *event in self.todayEvents)
    {
        if (event.isAllday)
        {
            if (event.isBirthDayEvent)
            {
                [self.birthDayEvents addObject:event];
            }
            else
            {
                [self.allDayEvents addObject:event];
            }
        }
        else
        {
            [self.scheduleEvents addObject:event];
        }
    }
    
    self.tomorrowAllDayEvents = [NSMutableArray array];
    self.tomorrowBirthDayEvents = [NSMutableArray array];
    self.tomorrowScheduleEvents = [NSMutableArray array];
    
    for (MNCalendarEvent *event in self.tomorrowEvents)
    {
        if (event.isAllday)
        {
            if (event.isBirthDayEvent)
            {
                [self.tomorrowBirthDayEvents addObject:event];
            }
            else
            {
                [self.tomorrowAllDayEvents addObject:event];
            }
        }
        else
        {
            [self.tomorrowScheduleEvents addObject:event];
        }
    }
}

- (NSMutableAttributedString *)getAlldayEventsString:(NSMutableArray *)alldayEvents
{
    NSMutableAttributedString *attributedString;
    
    NSString *fullStr;
    NSString *dateString = MNLocalizedString(@"reminder_all_day", @"ALLDAY");
    NSString *titles = @"";
    
    for (MNCalendarEvent *event in alldayEvents)
    {
        titles = [titles stringByAppendingFormat:@"%@\n", event.title];
    }
    
    fullStr = [NSString stringWithFormat:@"%@\n%@", dateString, titles];
    
    NSRange dateRange = [fullStr rangeOfString:dateString];
    NSRange titlesRange = [fullStr rangeOfString:titles];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.headIndent = 0;
    paragraphStyle.firstLineHeadIndent = 5;
    //    paragraphStyle.lineHeightMultiple = 2.0;
    //    paragraphStyle.tailIndent = 0.25;
    
    attributedString = [[NSMutableAttributedString alloc] initWithString:fullStr];
    
    UIFont *dateFont = [UIFont fontWithName:@"Helvetica-Bold" size:DATE_FONT_SIZE];
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:TITLE_FONT_SIZE];
    [attributedString addAttribute:NSFontAttributeName value:dateFont range:dateRange];
    [attributedString addAttribute:NSFontAttributeName value:titleFont range:titlesRange];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:titlesRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[MNTheme getWidgetCalendarEvnetFontUIColor] range:titlesRange];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[MNTheme getWidgetPointFontUIColor] range:dateRange];
    
    return attributedString;
}

- (NSMutableAttributedString *)getBirthDayEventsString:(NSMutableArray *)birthDayEvents
{
    NSMutableAttributedString *attributedString;
    
    NSString *fullStr;
    NSString *dateString = MNLocalizedString(@"reminder_birthday", @"reminder_birthday");
    NSString *titles = @"";
    
    for (MNCalendarEvent *event in birthDayEvents)
    {
        titles = [titles stringByAppendingFormat:@"%@\n", event.title];
    }
    
    fullStr = [NSString stringWithFormat:@"%@\n%@", dateString, titles];
    NSRange dateRange = [fullStr rangeOfString:dateString];
    NSRange titlesRange = [fullStr rangeOfString:titles];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.headIndent = 0;
    paragraphStyle.firstLineHeadIndent = 5;
    
    attributedString = [[NSMutableAttributedString alloc] initWithString:fullStr];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:titlesRange];
    
    UIFont *dateFont = [UIFont fontWithName:@"Helvetica-Bold" size:DATE_FONT_SIZE];
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:TITLE_FONT_SIZE];
    [attributedString addAttribute:NSFontAttributeName value:dateFont range:dateRange];
    [attributedString addAttribute:NSFontAttributeName value:titleFont range:titlesRange];
    
    paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = LINE_HEIGHT_SCALE_FACTOR;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:dateRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[MNTheme getWidgetPointFontUIColor] range:dateRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[MNTheme getWidgetCalendarEvnetFontUIColor] range:titlesRange];
    
    return attributedString;
}

- (NSMutableAttributedString *)getScheduleEventsString:(NSMutableArray *)scheduleEvents
{
    NSMutableAttributedString *fullAttributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSDateFormatter *formatterFor24hour = [[NSDateFormatter alloc] init];
    [formatterFor24hour setLocale:[NSLocale currentLocale]];
    [formatterFor24hour setDateStyle:NSDateFormatterNoStyle];
    [formatterFor24hour setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatterFor24hour stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatterFor24hour AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatterFor24hour PMSymbol]];
    BOOL isUsing24hour = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    
    if (isUsing24hour)
        formmater.dateFormat = @"HH:mm";
    else
        formmater.dateFormat = @"hh:mm";
    
    for (MNCalendarEvent *event in scheduleEvents)
    {
        NSString *fullStr;
        NSString *dateString = [formmater stringFromDate:event.startDate];
        NSString *titleString = event.title;
        
        [formatterFor24hour setDateFormat:@"HH"];
        NSInteger hour = [[formatterFor24hour stringFromDate:event.startDate] integerValue];
        NSString *ampmString;
        
        if (!isUsing24hour)
        {
            if ([[MNLanguage getCurrentLanguage] isEqualToString:@"en"])
            {
                ampmString = @" ";
                if (hour >= 12)
                    ampmString = [ampmString stringByAppendingString:MNLocalizedString(@"alarm_pm", @"PM")];
                else
                    ampmString = [ampmString stringByAppendingString:MNLocalizedString(@"alarm_am", @"AM")];
                
                dateString = [formmater stringFromDate:event.startDate];
                dateString = [dateString stringByAppendingString:ampmString];
            }
            else
            {
                if (hour >= 12)
                    ampmString = MNLocalizedString(@"alarm_pm", @"PM");
                else
                    ampmString = MNLocalizedString(@"alarm_am", @"AM");
                
                ampmString = [ampmString stringByAppendingString:@" "];
                
                dateString = [formmater stringFromDate:event.startDate];
                dateString = [ampmString stringByAppendingString:dateString];
            }
        }
        else
        {
            ampmString = @"";
            dateString = [formmater stringFromDate:event.startDate];
        }
        
        fullStr = [NSString stringWithFormat:@"%@\n%@\n", dateString, titleString];
        
        NSRange dateRange = [fullStr rangeOfString:dateString];
        NSRange titleRange = [fullStr rangeOfString:titleString];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.headIndent = 0;
        paragraphStyle.firstLineHeadIndent = 5;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullStr];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:titleRange];
        
        UIFont *dateFont = [UIFont fontWithName:@"Helvetica-Bold" size:DATE_FONT_SIZE];
        UIFont *titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:TITLE_FONT_SIZE];
        [attributedString addAttribute:NSFontAttributeName value:dateFont range:dateRange];
        [attributedString addAttribute:NSFontAttributeName value:titleFont range:titleRange];
        
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineHeightMultiple = LINE_HEIGHT_SCALE_FACTOR;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:dateRange];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[MNTheme getWidgetCalendarEvnetFontUIColor] range:titleRange];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[MNTheme getWidgetPointFontUIColor] range:dateRange];
    
        [fullAttributedString appendAttributedString:attributedString];
    }
    //        [titles stringByAppendingFormat:@"%@\n%@", event.title,];
    //    }
    //    NSRange titlesRange = NSRangeFromString(titles);
    //
    //    fullStr = [NSString stringWithFormat:@"%@\n%@", dateString, titles];
    //    attributedString = [[NSMutableAttributedString alloc] initWithString:fullStr];
    //    [attributedString addAttribute:NSForegroundColorAttributeName value:[MNTheme getWidgetPointFontUIColor] range:dateRange];
    //    [attributedString addAttribute:NSForegroundColorAttributeName value:[MNTheme getWidgetCalendarEvnetFontUIColor] range:titlesRange];
    
    return fullAttributedString;
}

//- (void)adjustFontForLabel {
//    
//    // 새로운 방법 찾기
//    NSString *text = self.textView.text;
//    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_SIZE];
//    
//    // 제일 긴 메모를 표시할 때 8까지는 줄여야함
//    for (int i=FONT_SIZE; i>MIN_FONT_SIZE; i=i-1) {
//        font = [font fontWithSize:i];
//        
//        CGSize constraintSize = CGSizeMake(self.textView.frame.size.width, MAXFLOAT);
//        CGSize labelSize = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
//        
//        if (labelSize.height <= self.textView.frame.size.height) {
//            break;
//        }
//        self.textView.font = font;
//    }
//}

- (void)requestGranted:(NSMutableArray *)events
{
    self.todayEvents = events;
    [self groupEvents];
    [self showEvents];
}

- (void)requestGrantedWithTodayEvents:(NSMutableArray *)todayEvents withTomorrowEvents:(NSMutableArray *)tomorrowEvents {
    self.todayEvents = todayEvents;
    self.tomorrowEvents = tomorrowEvents;
    [self groupEvents];
    [self showEvents];
}

#pragma mark - Switch Events

- (IBAction)scheduleSwitchValueChanged:(id)sender
{
    self.showSchedule = self.scheduleSwitch.on;
    [self showEvents];
    if (!self.scheduleSwitch.on) {
        self.birthDaySwitch.enabled = NO;
    }else{
        self.birthDaySwitch.enabled = YES;
    }
}

- (IBAction)birthDaySwitchValueChanged:(id)sender
{
    self.showBirthday = self.birthDaySwitch.on;
    [self showEvents];
    if (!self.birthDaySwitch.on) {
        self.scheduleSwitch.enabled = NO;
    }else{
        self.scheduleSwitch.enabled = YES;
    }
}

@end
