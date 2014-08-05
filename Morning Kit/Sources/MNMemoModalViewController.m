//
//  MNMemoModalViewController.m
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 10..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNMemoModalViewController.h"
#import "MNRoundRectedViewMaker.h"
#import "MNTheme.h"
#import <QuartzCore/QuartzCore.h>
#import "MNDefinitions.h"
#import "JLToast.h"
#import "MBProgressHUD.h"
#import "MNKeyboardHideButtonMaker.h"

#define LIMIT_NUMBER_OF_LINES ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 11 : 9)
#define LIMIT ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 11 : 7)

#define SIZE_MAINMEMO ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGSizeMake(310, 200) : CGSizeMake(144, 94))
#define MIN_FONT_SIZE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 14 : 9)
#define FONT_SIZE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 20 : 13)

@interface MNMemoModalViewController ()

@end

@implementation MNMemoModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initRoundAndShadow
{
    //    [MNRoundRectedViewMaker makeRoundRectedView:self.outerView];
    
    self.outerView.layer.cornerRadius = ROUNDED_CORNER_RADIUS;
    self.outerView.layer.shadowColor = [[UIColor blackColor] CGColor];
    // 아래 수치는 계속 조정중
    self.outerView.layer.shadowOpacity = 0.7f;
    self.outerView.layer.shadowRadius = 1.3f;
    self.outerView.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    self.memoTextView.backgroundColor = [UIColor clearColor];
    self.memoTextView.delegate = self;
    
    self.outerView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    
    // 라운딩 & 그림자 처리
    [self initRoundAndShadow];
    
    // 메모 받아오기
    self.memoString = [self.widgetDictionary objectForKey:MEMO_STRING];
    self.archivedString = [[NSUserDefaults standardUserDefaults] objectForKey:MEMO_ARCHIVED_STRING];
    
    if (self.memoString && [self.memoString isEqualToString:MNLocalizedString(@"memo", nil)] == NO) {
        self.memoTextView.text = self.memoString;
        self.memoTextView.textColor = [MNTheme getMainFontUIColor];
    }else{
        // 새로 로직 작성: 최근 메모 기억
        if (self.archivedString && [self.memoString isEqualToString:MNLocalizedString(@"memo", nil)] == NO) {
            self.memoTextView.text = self.archivedString;
            self.memoTextView.textColor = [MNTheme getMainFontUIColor];
        }else{
            self.memoTextView.text = MNLocalizedString(@"memo_write_here_modal", @"여기에 입력");
            self.memoTextView.textColor = [MNTheme getWidgetSubFontUIColor];
        }
        
        /*
        self.memoTextView.text = [[NSUserDefaults standardUserDefaults] objectForKey:MEMO_ARCHIVED_STRING];
        if (self.memoTextView.text) {
            self.memoString = self.memoTextView.text;
            self.memoTextView.textColor = [MNTheme getMainFontUIColor];
        }else{
            self.memoTextView.text = MNLocalizedString(@"memo_write_here_modal", @"여기에 입력");
            self.memoTextView.textColor = [MNTheme getWidgetSubFontUIColor];
        }
         */
    }
    
    // 키보드 알림 등록
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    // 키보드 숨김 버튼 - 폰만
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.hideKeyboardButton.alpha = 0;
        [self.hideKeyboardButton removeFromSuperview];
    }else{
        
        [MNKeyboardHideButtonMaker makeKeyboardHideButtonToTextView:self.memoTextView withHideButton:self.hideKeyboardButton];
        
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

#pragma mark - keyboard handling

- (void)hideKeyboard {
    //    NSLog(@"hideKeyboard");
    [self.memoTextView resignFirstResponder];
    self.hideKeyboardButton.alpha = 0;
}

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
    
    /*
    self.hideKeyboardButton.alpha = 1;
    CGRect currentFrame = self.hideKeyboardButton.frame;
    self.hideKeyboardButton.frame = CGRectMake(currentFrame.origin.x,
                                               self.view.frame.size.height - currentFrame.size.height,
                                               currentFrame.size.width,
                                               currentFrame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
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

- (void)textFieldDidEndEditing:(UITextField *)myTextField;
{
    if( self.view.frame.origin.y < 0 )
    {
        [self setViewMovedUp:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if( self.view.frame.origin.y < 0 )
    {
        [self setViewMovedUp:NO];
    }
    [self.memoTextView resignFirstResponder];
    return YES;
}

#pragma mark - button handler

- (void)doneButtonClicked {
//    NSLog(@"%@", self.memoTextView.text);
    // 메모가 기본 것이 아니면서 && length 가 0이 아니어야 저장함
    if (self.memoTextView.text.length != 0 && [self.memoTextView.text isEqualToString:MNLocalizedString(@"memo_write_here_modal", @"여기에 입력")] == NO) {
        [self.widgetDictionary setObject:self.memoTextView.text forKey:MEMO_STRING];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.memoTextView.text forKey:MEMO_ARCHIVED_STRING];
    }else{
        [self.widgetDictionary setObject:@"" forKey:MEMO_STRING];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:MEMO_ARCHIVED_STRING];
    }
    [super doneButtonClicked];
}

#pragma mark - TextView delgate method


- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.memoTextView.text.length == 0) {
        self.memoTextView.textColor = [MNTheme getWidgetSubFontUIColor];
        self.memoTextView.text = MNLocalizedString(@"memo_write_here_modal", @"여기에 입력");
        self.memoString = nil;
    }else{
        self.memoString = self.memoTextView.text;
    }
}
 
/*
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.memoTextView.textColor = [MNTheme getSubFontUIColor];
        self.memoTextView.text = MNLocalizedString(@"memo_write_here_modal", @"여기에 입력");
        self.memoString = nil;
    }
}
 */

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if ([self.memoTextView.text isEqualToString:MNLocalizedString(@"memo_write_here_modal", @"여기에 입력")]) {
        self.memoTextView.text = nil;
        self.memoTextView.textColor = [MNTheme getMainFontUIColor];
    }
//    if (self.memoString == nil) {
//        self.memoTextView.text = nil;
//        self.memoTextView.textColor = [MNTheme getMainFontUIColor];
//    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    // limit the number of lines in textview
    NSString* newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    CGSize mainMemoSize = SIZE_MAINMEMO;
    
    // pretend there's more vertical space to get that extra line to check on
    CGSize tallerSize = CGSizeMake(mainMemoSize.width-15, mainMemoSize.height*LIMIT_NUMBER_OF_LINES);
    
    UIFont *newFont = [UIFont fontWithName:@"Helvetica-Bold" size:MIN_FONT_SIZE];
    CGSize newSize = [newText sizeWithFont:newFont constrainedToSize:tallerSize lineBreakMode:NSLineBreakByWordWrapping];
    
//    CGSize newSize = [newText sizeWithFont:newFont minFontSize:MIN_FONT_SIZE actualFontSize:FONT_SIZE forWidth:mainMemoSize.width lineBreakMode:NSLineBreakByWordWrapping];
    
//    int numLines = textView.contentSize.height/textView.font.lineHeight;
//    NSLog(@"%f %f", textView.contentSize.height, textView.frame.size.height);
    if (textView.contentSize.height + 5 > textView.frame.size.height) {
        if ([text isEqualToString:@"\n"])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = MNLocalizedString(@"memo_end_of_page_halt", @"페이지 끝");
            hud.margin = 10.f;
            hud.yOffset = -20.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:1];
            
            return NO;
        }
    }
    
    if (newSize.height >= mainMemoSize.height)
    {
//        NSLog(@"9 lines are full");
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = MNLocalizedString(@"memo_end_of_page_halt", @"페이지 끝");
        hud.margin = 10.f;
        hud.yOffset = -20.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:1];
        
        return NO;
    }
    
    
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
