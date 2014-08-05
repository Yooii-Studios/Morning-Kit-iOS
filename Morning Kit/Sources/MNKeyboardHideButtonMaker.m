//
//  MNKeyboardHideButtonMaker.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 10. 4..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNKeyboardHideButtonMaker.h"
#import "MNTheme.h"

@implementation MNKeyboardHideButtonMaker

+ (void)makeKeyboardHideButtonToTextField:(UITextField *)textField withHideButton:(UIButton *)hideKeyboardButton {
    // 키보드 숨김 버튼을 UITextField에 연결시키기
    // 악세사리뷰(외부 프로젝트로 해결해서 가져온 코드)
    UIView *inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, hideKeyboardButton.frame.size.height)];
    textField.inputAccessoryView = inputAccessoryView;
    
    UIButton *hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hideButton setImage:[UIImage imageNamed:[MNTheme getKeyboardHideButtonResourceName]] forState:UIControlStateNormal];
    CGRect hideButtonFrame = hideKeyboardButton.frame;
    hideButtonFrame.origin.y = 0;
    hideButton.frame = hideButtonFrame;
    [inputAccessoryView addSubview:hideButton];
    
    [hideButton addTarget:textField action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    
    [hideKeyboardButton removeFromSuperview];
}

+ (void)makeKeyboardHideButtonToTextView:(UITextView *)textView withHideButton:(UIButton *)hideKeyboardButton {
    // 키보드 숨김 버튼을 UITextField에 연결시키기
    // 악세사리뷰(외부 프로젝트로 해결해서 가져온 코드)
    UIView *inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, hideKeyboardButton.frame.size.height)];
    textView.inputAccessoryView = inputAccessoryView;
    
    UIButton *hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hideButton setImage:[UIImage imageNamed:[MNTheme getKeyboardHideButtonResourceName]] forState:UIControlStateNormal];
    CGRect hideButtonFrame = hideKeyboardButton.frame;
    hideButtonFrame.origin.y = 0;
    hideButton.frame = hideButtonFrame;
    [inputAccessoryView addSubview:hideButton];
    
    [hideButton addTarget:textView action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    
    [hideKeyboardButton removeFromSuperview];
}

@end
