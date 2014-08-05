//
//  MNDateCountdownModalViewController.h
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 11..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetModalController.h"

@interface MNDateCountdownModalViewController : MNWidgetModalController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField  *titleTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) IBOutlet UIButton *hideKeyboardButton;

@end
