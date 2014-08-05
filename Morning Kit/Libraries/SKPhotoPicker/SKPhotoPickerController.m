//
//  SKPhotoPickerController.m
//  SKPhotoPicker
//
//  Created by 김우성 on 13. 4. 5..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import "SKPhotoPickerController.h"
#import "SKPhotoScaleCropViewController.h"

@interface SKPhotoPickerController ()

@end

@implementation SKPhotoPickerController

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
//    self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - button handler

- (IBAction)defaultImagePickerButtonClicked:(id)sender {
    self.photoSelectType = UIImagePicker;

    // initiate imagePicker
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        [self presentModalViewController:imagePickerController animated:YES];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else{
        // in iPad, UIImagePickerController must be presented via UIPopoverController
        /*
        self.imagePopoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        CGRect arrow = CGRectMake(1, 15, 1, 1);
        [self.imagePopoverController presentPopoverFromRect:self.view.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
         */
        
        CGRect arrow = CGRectMake(560, 920, 320, 480);
        self.imagePopoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        self.imagePopoverController.delegate = self;
        [self.imagePopoverController presentPopoverFromRect:arrow
                                 inView:self.view
               permittedArrowDirections:UIPopoverArrowDirectionDown
                               animated:YES];
    }
}

- (IBAction)customImagePickerButtonClicked:(id)sender {
    self.photoSelectType = SKPhotoPicker;
    
    // initialize imagePicker
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.delegate = self;
//    imagePickerController.allowsEditing = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        [self presentModalViewController:imagePickerController animated:YES];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else{
        // in iPad, UIImagePickerController must be presented via UIPopoverController
        CGRect arrow = CGRectMake(45, 920, 320, 480);
        self.imagePopoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        self.imagePopoverController.delegate = self;
        [self.imagePopoverController presentPopoverFromRect:arrow
                                                     inView:self.view
                                   permittedArrowDirections:UIPopoverArrowDirectionDown
                                                   animated:YES];
    }
}

- (IBAction)removePhotoButtonClicked:(id)sender {
    self.selectedImageView.image = nil;
}


#pragma - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
//    NSLog(@"Picker Selected");
    if (self.photoSelectType == UIImagePicker) {
        // Default iOS Image Picker
        //    [self.selectedImageView setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        [self.selectedImageView setImage:[info objectForKey:UIImagePickerControllerEditedImage]];
//        NSLog(@"width: %f, height: %f", self.selectedImageView.image.size.width, self.selectedImageView.image.size.height);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.imagePopoverController dismissPopoverAnimated:YES];
        }

    }else{
        // save origianl image
        self.selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.defaultImagePickerController = picker;
        
        // show action sheet to decide the crop direction
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Portrait", @"Landscape", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
//    NSLog(@"Picker Cancel");
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.imagePopoverController dismissPopoverAnimated:YES];
    }
}


#pragma mark - UIActionSheet Delegate Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
        {
            // Portrait
            [self pushPhotoScaleViewControllerWithCropOrientation:SKPhotoCropOrientationPortrait];
            break;
        }
        case 1:
        {
            // Landscape
            [self pushPhotoScaleViewControllerWithCropOrientation:SKPhotoCropOrientationLandscape];
            break;
        }
        case 2:
            // Cancel
            break;
    }
}

- (void)pushPhotoScaleViewControllerWithCropOrientation:(SKPhotoCropOrientation)photoCropOrientation {
    // Customized SK Image Picker
    // initialize photoScaleViewController
    UIStoryboard *storyboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"SKPhotoPicker_iPad" bundle:[NSBundle mainBundle]];
    }else{
        storyboard = [UIStoryboard storyboardWithName:@"SKPhotoPicker_iPhone" bundle:[NSBundle mainBundle]];
    }
    SKPhotoScaleCropViewController *photoScaleViewController = [storyboard instantiateViewControllerWithIdentifier:@"SKPhotoScaleViewController"];
    
    photoScaleViewController.originalImage = self.selectedImage;
    photoScaleViewController.SKDelegate = self;
    photoScaleViewController.photoCropOrientation = photoCropOrientation;
    
    // push controller without navigation bar(initialized in photoScaleViewContoller's viewWillAppear)
    [self.defaultImagePickerController pushViewController:photoScaleViewController animated:YES];
}


#pragma mark - SKPhotoScaleViewDelegate method

- (void)SKPhotoScaleCropViewControllerDidCropping:(SKPhotoScaleCropViewController *)photoScaleCropViewController {
//    NSLog(@"SKPhotoScaleCropViewControllerDidCropping");
    
    self.selectedImageView.image = photoScaleCropViewController.cropedImage;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.imagePopoverController dismissPopoverAnimated:YES];
    }
}


#pragma mark - rotation

// for iOS 5.1

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // on iPad support all orientations
        return YES;
    }
    else {
        // on iPhone/iPod support all orientations except Portrait Upside Down
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    return NO;
    
//    return YES;
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
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


@end
