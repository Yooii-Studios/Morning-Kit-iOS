//
//  MNDateCountdownModalViewController.m
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 11..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNDateCountdownModalViewController.h"
#import "MNTheme.h"
#import "MNDefinitions.h"
#import "MNDefaultDateMaker.h"
#import "MNKeyboardHideButtonMaker.h"

@interface MNDateCountdownModalViewController ()

@end

@implementation MNDateCountdownModalViewController

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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // title
        self.titleTextField.placeholder = MNLocalizedString(@"date_countdown_write_a_title", @"제목 입력");
        self.titleTextField.delegate = self;
        NSString *titleString = [self.widgetDictionary objectForKey:DATE_COUNTDOWN_TITLE];
        if (titleString) {
            self.titleTextField.text = [self.widgetDictionary objectForKey:DATE_COUNTDOWN_TITLE];
        }else{
            self.titleTextField.text = @"";
        }
        
        // date
        self.datePicker.locale = [NSLocale currentLocale];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            self.datePicker.backgroundColor = [UIColor whiteColor];
        }
        NSDate *dateCountdownDate = [self.widgetDictionary objectForKey:DATE_COUNTDOWN_DATE];
        if (dateCountdownDate) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.datePicker.date = dateCountdownDate;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.datePicker.date = [MNDefaultDateMaker getDefaultDate];
                self.titleTextField.text = MNLocalizedString(@"date_countdown_new_year", @"New Year");
            });
        }
    });
    
    // theme
    self.view.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    
    /*
    // title
    self.titleTextField.placeholder = MNLocalizedString(@"date_countdown_write_a_title", @"제목 입력");
    self.titleTextField.delegate = self;
    NSString *titleString = [self.widgetDictionary objectForKey:DATE_COUNTDOWN_TITLE];
    if (titleString) {
        self.titleTextField.text = [self.widgetDictionary objectForKey:DATE_COUNTDOWN_TITLE];
    }else{
        self.titleTextField.text = @"";
    }
    
    // date
    self.datePicker.locale = [NSLocale currentLocale];
    NSDate *dateCountdownDate = [self.widgetDictionary objectForKey:DATE_COUNTDOWN_DATE];
    if (dateCountdownDate) {
        self.datePicker.date = dateCountdownDate;
    }else{
        self.datePicker.date = [MNDefaultDateMaker getDefaultDate];
        self.titleTextField.text = MNLocalizedString(@"date_countdown_new_year", @"New Year");
    }
     */
    
    // 키보드 알림 등록
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    */
    
    // 키보드 숨김 버튼 - 폰만
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.hideKeyboardButton.alpha = 0;
        [self.hideKeyboardButton removeFromSuperview];
    }else{
        
        // 키보드 숨김 버튼을 UITextField에 연결시키기
        // 악세사리뷰(외부 프로젝트로 해결해서 가져온 코드)
        [MNKeyboardHideButtonMaker makeKeyboardHideButtonToTextField:self.titleTextField withHideButton:self.hideKeyboardButton];
        
        /*
         CGRect newButtonFrame = self.hideKeyboardButton.frame;
         newButtonFrame.origin.y = self.view.frame.size.height - (KEYBOARD_HEIGHT) - newButtonFrame.size.height;
         self.hideKeyboardButton.frame = newButtonFrame;
         [self.hideKeyboardButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
         self.hideKeyboardButton.alpha = 0;
         [self.view sendSubviewToBack:self.hideKeyboardButton];
         */
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button handler

- (void)doneButtonClicked {
    // 내용이 있을 경우만 저장하기
    
//    NSLog(@"%@", self.titleTextField.text);
//    NSLog(@"%@", MNLocalizedString(@"date_countdown_new_year",nil));
    if ([self.titleTextField.text isEqualToString:MNLocalizedString(@"date_countdown_new_year",nil)]) {
        [self.widgetDictionary setObject:@YES forKey:DATE_COUNTDOWN_IS_TITLE_NEW_YEAR];
    }else{
        [self.widgetDictionary removeObjectForKey:DATE_COUNTDOWN_IS_TITLE_NEW_YEAR];
    }
    [self.widgetDictionary setObject:self.titleTextField.text forKey:DATE_COUNTDOWN_TITLE];
    [self.widgetDictionary setObject:self.datePicker.date forKey:DATE_COUNTDOWN_DATE];
    
//    if (self.titleTextField.text.length != 0) {
//        [self.widgetDictionary setObject:self.titleTextField.text forKey:DATE_COUNTDOWN_TITLE];
//        [self.widgetDictionary setObject:self.datePicker.date forKey:DATE_COUNTDOWN_DATE];
//    }else{
//        [self.widgetDictionary removeObjectForKey:DATE_COUNTDOWN_TITLE];
//        [self.widgetDictionary removeObjectForKey:DATE_COUNTDOWN_DATE];
////        [self.widgetDictionary setObject:self.datePicker.date forKey:DATE_COUNTDOWN_DATE];
//    }
    [super doneButtonClicked];
}

#pragma mark - keyboard handling

/*
- (void)hideKeyboard {
    //    NSLog(@"hideKeyboard");
    [self.titleTextField resignFirstResponder];
    self.hideKeyboardButton.alpha = 0;
}
 */

- (void)keyboardWillShow:(NSNotification *)notif
{
    // The keyboard will be shown. If the user is editing the author, adjust the display so that the
    // author field will not be covered by the keyboard.
    //    if ( [self.memoTextView isFirstResponder] && self.view.frame.origin.y >= 0)
    //    {
    //        [self setViewMovedUp:YES];
    //    }
    //    else if ( [self.memoTextView isFirstResponder] && self.view.frame.origin.y < 0)
    //    {
    //        [self setViewMovedUp:NO];
    //    }
    
    // 키보드 숨김 버튼 관련 코드 제거
    /*
    self.hideKeyboardButton.alpha = 1;
    CGRect currentFrame = self.hideKeyboardButton.frame;
    self.hideKeyboardButton.frame = CGRectMake(currentFrame.origin.x,
                                               self.view.frame.size.height - currentFrame.size.height,
                                               currentFrame.size.width,
                                               currentFrame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:KEYBOARD_UP_DURATION];
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        [UIView setAnimationCurve:UIViewAnimationOptionCurveEaseOut];
//    }
    self.hideKeyboardButton.frame = currentFrame;
    [UIView commitAnimations];
    [self.view bringSubviewToFront:self.hideKeyboardButton];
     */
}

- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // If moving up, not only decrease the origin but increase the height so the view
        // covers the entire screen behind the keyboard.
        
        rect.origin.y -= KEYBOARD_HEIGHT;
        rect.size.height += KEYBOARD_HEIGHT;
        
    }
    else
    {
        // If moving down, not only increase the origin but decrease the height.
        rect.origin.y += KEYBOARD_HEIGHT;
        rect.size.height -= KEYBOARD_HEIGHT;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}


#pragma mark - UITextField Delegate method

- (void)textFieldDidEndEditing:(UITextField *)myTextField;
{
    if( self.view.frame.origin.y < 0 )
    {
//        [self setViewMovedUp:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if( self.view.frame.origin.y < 0 )
    {
//        [self setViewMovedUp:NO];
    }
    [self.titleTextField resignFirstResponder];
//    self.hideKeyboardButton.alpha = 0;
    return YES;
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
