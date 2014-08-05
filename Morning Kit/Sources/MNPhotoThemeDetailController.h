//
//  MNPhotoThemeDetailController.h
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 16..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKPhotoCropFrameView.h"
#import "SKPhotoScaleCropViewController.h"
#import "MNConfigureCell.h"
#import "MNImagePickerController.h"

@class MNPhotoThemeDetailController;

@protocol MNPhotoThemeDetailControllerDelegate <NSObject>

- (void)photoThemeDetailControllerDidSave:(MNPhotoThemeDetailController *)photoThemeDetailController;

@end


@interface MNPhotoThemeDetailController : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, SKPhotoScaleCropViewControllerDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) id<MNPhotoThemeDetailControllerDelegate> MNDelegate;
@property (nonatomic) SKPhotoCropOrientation *selectedPhotoCropOrientation;

@property (nonatomic, strong) IBOutlet MNConfigureCell *portraitCell;
@property (nonatomic, strong) IBOutlet MNConfigureCell *landscapeCell;

@property (nonatomic, strong) IBOutlet UIImageView *portraitImageView;
@property (nonatomic, strong) IBOutlet UIImageView *landscapeImageView;

// iPad
@property (nonatomic, strong) UIPopoverController *imagePopoverController;

- (IBAction)doneButtonClicked:(id)sender;

@end
