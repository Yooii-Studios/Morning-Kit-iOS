//
//  SKPhotoScaleViewController.m
//  SKPhotoPicker
//
//  Created by 김우성 on 13. 4. 5..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import "SKPhotoScaleCropViewController.h"
#import "SKImageCroppingProecessor.h"

@interface SKPhotoScaleCropViewController ()

@end

@implementation SKPhotoScaleCropViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        NSLog(@"init");
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
//        NSLog(@"%@ initWithCoder", [self class]);
    }
    return self;
}

/*
- (void)initGestureRecognizer{
//    [self.view setMultipleTouchEnabled:YES];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.panGestureRecognizer.cancelsTouchesInView = NO;
    self.panGestureRecognizer.delegate = self;
    [self.photoScaleFrameView addGestureRecognizer:self.panGestureRecognizer];
    
    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    self.pinchGestureRecognizer.cancelsTouchesInView = NO;
    self.pinchGestureRecognizer.delegate = self;
    [self.photoScaleFrameView addGestureRecognizer:self.pinchGestureRecognizer];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.tapGestureRecognizer.cancelsTouchesInView = NO;
    self.tapGestureRecognizer.delegate = self;
    self.tapGestureRecognizer.numberOfTapsRequired = 2;
    [self.photoScaleFrameView addGestureRecognizer:self.tapGestureRecognizer];
}
 */

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSLog(@"viewWillAppear");
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        
        self.cancelBarButton.title = MNLocalizedString(@"cancel", nil);
        self.chooseBarButton.title = MNLocalizedString(@"photo_theme_choose", nil);
        self.labelBarButtonItem.title = MNLocalizedString(@"photo_theme_move_and_scale", nil);
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            self.navigationController.navigationBar.translucent = NO;
            self.cancelBarButton.tintColor = self.chooseBarButton.tintColor;
            self.chooseBarButton.tintColor = nil;
            self.labelBarButtonItem.tintColor = [UIColor blackColor];
            self.toolBar.barTintColor = [UIColor whiteColor];
            self.toolBar.tintColor = nil;
        }
    }else{
        self.title = MNLocalizedString(@"photo_theme_move_and_scale", nil);
//        self.navigationController.title = @"Choose Photo";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:MNLocalizedString(@"cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(newCancelButtonClicked:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:MNLocalizedString(@"photo_theme_choose", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(useButtonClicked:)];
        self.toolBar.alpha = 0;
//        self.navigationController.navigationItem.leftBarButtonItem = nil;
//        self.navigationController.navigationItem.rightBarButtonItem = nil;
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            self.navigationController.navigationBar.translucent = NO;
            
            // 타이틀
            self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor blackColor]};
        }
    }
    
//    NSLog(@"frame: %@", NSStringFromCGRect(self.view.frame));
}

// initialize after choosing a picture
- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"viewDidLoad");
    
	// Do any additional setup after loading the view.
    self.selectedImageView.image = self.originalImage;
    
    // statusBar - BlackTranslucent
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    }
    self.wantsFullScreenLayout = YES;
    
    // PhotoCropFrameView
    self.photoCropFrameView.opaque = NO;
    self.photoCropFrameView.backgroundColor = [UIColor clearColor];
    self.photoCropFrameView.photoCropOrientation = self.photoCropOrientation;
    [self.photoCropFrameView setNeedsDisplay];
    
    // PhotoScaleFrameView
    self.view.backgroundColor = [UIColor blackColor];
    [self.photoScaleFrameView.selectedImageView setImage:self.selectedImageView.image];
    self.photoScaleFrameView.photoCropOrientation = self.photoCropOrientation;
    [self.photoScaleFrameView initializeScrollView];
    
    // adjust scrollView inset fit to cropRect
//    CGRect cropRect = [self.photoCropFrameView getCropRectFromOrientation:self.photoCropOrientation];
//    self.photoScaleFrameView.zoomingView.frame = cropRect;
    
    if (self.photoCropOrientation == SKPhotoCropOrientationPortrait) {
        // left, right inset
//        self.photoScaleFrameView.contentInset = UIEdgeInsetsMake(0, 30, 0, 30);
//        self.photoScaleFrameView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    }else{
        // top, bottom inset
//        self.photoScaleFrameView.contentSize = CGSizeMake(self.photoScaleFrameView.contentSize.width + 40, self.photoScaleFrameView.contentSize.height);
//        self.photoScaleFrameView.contentInset = UIEdgeInsetsMake(30, 0, 30, 0);
    }
    
//    NSLog(@"photoView frame: %@", NSStringFromCGRect(self.view.frame));
//    NSLog(@"photoScaleFrameView frame: %@", NSStringFromCGRect(self.photoScaleFrameView.frame));
//    NSLog(@"photoCropFrameView frame: %@", NSStringFromCGRect(self.photoCropFrameView.frame));
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    // 흰색 스테이터스 바
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button handlers - for iPhone

- (IBAction)cancelButtonClicked:(id)sender {
//    NSLog(@"cancelButtonClicked");
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseButtonClicked:(id)sender {
//    NSLog(@"chooseButtonClicked");
    
    // get cropped image from views
    self.cropedImage = [SKImageCroppingProecessor getCroppedImageFromPhotoCropFrameView:self.photoCropFrameView withPhotoScaleView:self.photoScaleFrameView];
    
    // save photo
    [self.SKDelegate SKPhotoScaleCropViewControllerDidCropping:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Gesture Recognizer action method

- (void)handlePan:(UIPanGestureRecognizer*)recognizer {
//    NSLog(@"pan gesture detected");
}

- (void)handlePinch:(UIPinchGestureRecognizer*)recognizer {
//    NSLog(@"pinch gesture detected");
    
//    NSLog(@"scale = %f", [recognizer scale]);
//	NSLog(@"velocity = %f", [recognizer velocity]);
}

- (void)handleTap:(UITapGestureRecognizer*)recognizer {
//    NSLog(@"tap gesture detected");
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    NSLog(@"shouldRecognizeSimultaneouslyWithGestureRecognizer");
    return YES;
}
*/

#pragma mark - button handlers - for iPad

- (void)useButtonClicked:(id)sender {
    self.cropedImage = [SKImageCroppingProecessor getCroppedImageFromPhotoCropFrameView:self.photoCropFrameView withPhotoScaleView:self.photoScaleFrameView];
    
    // save photo
    [self.SKDelegate SKPhotoScaleCropViewControllerDidCropping:self];
//    [self.navigationController dismissModalViewControllerAnimated:YES];
//    [[self.navigationController popViewControllerAnimated:YES].navigationController popViewControllerAnimated:YES];
}

- (void)newCancelButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
