//
//  MNFlickrModalViewController.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 3..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetModalController.h"

@interface MNFlickrModalViewController : MNWidgetModalController <UITextFieldDelegate, UIActionSheetDelegate> {
    float orignalViewTop;
    float keyboardHeight;
}

@property (nonatomic, strong) IBOutlet UIButton *flickrImageButton;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) IBOutlet UITextField *keywordTextField;
@property (nonatomic, strong) IBOutlet UILabel *grayscaleLabel;
@property (nonatomic, strong) IBOutlet UISwitch *grayscaleSwitch;

@property (nonatomic, strong) IBOutlet UIButton *hideKeyboardButton;

@end
