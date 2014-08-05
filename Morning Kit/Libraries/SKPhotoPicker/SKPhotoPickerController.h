//
//  SKPhotoPickerController.h
//  SKPhotoPicker
//
//  Created by 김우성 on 13. 4. 5..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKPhotoScaleCropViewController.h"

typedef NS_ENUM(NSInteger, SKPhotoSelectType) {
    SKPhotoPicker = 0,
    UIImagePicker,
};

// Controller - Main Controller
@interface SKPhotoPickerController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, SKPhotoScaleCropViewControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *selectedImageView;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImagePickerController *defaultImagePickerController;
@property (nonatomic)  SKPhotoSelectType photoSelectType;

// for iPad
@property (nonatomic, strong) UIPopoverController *imagePopoverController;

- (IBAction)removePhotoButtonClicked:(id)sender;
- (IBAction)customImagePickerButtonClicked:(id)sender;
- (IBAction)defaultImagePickerButtonClicked:(id)sender;

@end
