//
//  SKPhotoScaleViewController.h
//  SKPhotoPicker
//
//  Created by 김우성 on 13. 4. 5..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKPhotoScaleView.h"
#import "SKPhotoCropFrameView.h"
#import "SKLabelBarButtonItem.h"

@class SKPhotoScaleCropViewController;

@protocol SKPhotoScaleCropViewControllerDelegate <NSObject>

- (void)SKPhotoScaleCropViewControllerDidCropping:(SKPhotoScaleCropViewController *)photoScaleCropViewController;

@end

// Controller - Customizing 'Move and Scale' Controller of UIImagePickerController
@interface SKPhotoScaleCropViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

// Toolbar
@property (nonatomic, strong) IBOutlet UIToolbar *toolBar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *cancelBarButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *chooseBarButton;
@property (nonatomic, weak) IBOutlet SKLabelBarButtonItem *labelBarButtonItem;
//@property (nonatomic, strong) IBOutlet UIBarButtonItem *labelBarButtonItem;

// Move and Scale Views
@property (nonatomic, strong) IBOutlet UIImageView *selectedImageView;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic) SKPhotoCropOrientation photoCropOrientation;
@property (nonatomic, strong) IBOutlet SKPhotoScaleView *photoScaleFrameView;
@property (nonatomic, strong) IBOutlet SKPhotoCropFrameView *photoCropFrameView;

@property (nonatomic, strong) id<SKPhotoScaleCropViewControllerDelegate> SKDelegate;

@property (nonatomic, strong) UIImage *cropedImage;

/*
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
 */

- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)chooseButtonClicked:(id)sender;

@end
