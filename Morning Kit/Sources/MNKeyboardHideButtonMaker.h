//
//  MNKeyboardHideButtonMaker.h
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 10. 4..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNKeyboardHideButtonMaker : NSObject

+ (void)makeKeyboardHideButtonToTextField:(UITextField *)textField withHideButton:(UIButton *)hideKeyboardButton;
+ (void)makeKeyboardHideButtonToTextView:(UITextView *)textView withHideButton:(UIButton *)hideKeyboardButton;

@end
