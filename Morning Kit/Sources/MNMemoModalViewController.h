//
//  MNMemoModalViewController.h
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 10..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetModalController.h"

@interface MNMemoModalViewController : MNWidgetModalController <UITextViewDelegate>

@property (strong, nonatomic) NSString *memoString;
@property (strong, nonatomic) NSString *archivedString;
@property (strong, nonatomic) IBOutlet UITextView *memoTextView;
@property (strong, nonatomic) IBOutlet UIView *outerView;

@property (strong, nonatomic) IBOutlet UIButton *hideKeyboardButton;

@end
