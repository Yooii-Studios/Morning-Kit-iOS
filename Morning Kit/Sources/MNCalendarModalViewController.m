//
//  MNCalendarModalViewController.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 4..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNCalendarModalViewController.h"
#import "MNTheme.h"
#import "MNDefinitions.h"

@interface MNCalendarModalViewController ()

@end

@implementation MNCalendarModalViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    // Lunar Label
    self.lunarLabel.text = MNLocalizedString(@"calendar_lunar_calendar", @"음력 달력");
    self.lunarLabel.textColor = [MNTheme getMainFontUIColor];
    
    // Lunar Switch
    BOOL isLunarCalendarOn = ((NSNumber *)[self.widgetDictionary objectForKey:@"isLunarCalendarOn"]).boolValue;
    self.lunarSwitch.on = isLunarCalendarOn;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.lunarSwitch.tintColor = [MNTheme getSwitchTintColorInModalController];
    }
//    self.lunarSwitch.onTintColor = [MNTheme getSecondSubFontUIColor];
//    self.lunarSwitch.tintColor = [MNTheme getForwardBackgroundUIColor]; // only for iOS 6
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - widget modal controller

- (void)doneButtonClicked {
    [self.widgetDictionary setObject:@(self.lunarSwitch.on) forKey:@"isLunarCalendarOn"];
    [super doneButtonClicked];
}

- (void)cancelButtonClicked {
    [super cancelButtonClicked];
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

@end
