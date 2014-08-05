//
//  MNFlickrModalViewController.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 3..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNFlickrModalViewController.h"
#import "MNTheme.h"
#import "MNDefinitions.h"
#import "MNFlickrImageProcessor.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JLToast.h"
#import "MNFlickrFetcher.h"
#import "MNKeyboardHideButtonMaker.h"

#define KEYBOARD_OFFSET 35

#define NO_IMAGE_OFFSET ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 10 : 20)

@interface MNFlickrModalViewController ()

@end

@implementation MNFlickrModalViewController

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
    
    // 테마
    self.view.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    self.flickrImageButton.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    [self.flickrImageButton.imageView setContentMode:UIViewContentModeScaleAspectFit];

    // 그레이스케일 레이블
    self.grayscaleLabel.text = MNLocalizedString(@"flickr_use_gray_scale", @"그레이스케일");
    self.grayscaleLabel.textColor = [MNTheme getMainFontUIColor];
    
    // 그레이스케일 스위치
//    self.grayscaleSwitch.onTintColor = [MNTheme getSecondSubFontUIColor];
    self.grayscaleSwitch.on = ((NSNumber *)[self.widgetDictionary objectForKey:FLICKR_GRAY_SCALE_ON]).boolValue;
    [self.grayscaleSwitch addTarget:self action:@selector(grayscaleSwitchToggled:) forControlEvents:UIControlEventValueChanged];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.grayscaleSwitch.tintColor = [MNTheme getSwitchTintColorInModalController];
    }
    
    // 입력 이미지가 없으면 배경만 바꾸어줌. 있다면 대입하고 버튼 셀럭터 구성
    NSData *imageData = [self.widgetDictionary objectForKey:FLICKR_IMAGE_DATA];
    if (imageData) {
//        self.flickrImageButton.backgroundColor = [UIColor clearColor];
        UIImage *flickrImage = [UIImage imageWithData:imageData];
        self.originalImage = flickrImage;
        if (self.grayscaleSwitch.on) {
            flickrImage = [MNFlickrImageProcessor getGrayscaledImageFromOriginalImage:flickrImage];
        }
        [self.flickrImageButton setImage:flickrImage forState:UIControlStateNormal];

        // 셀럭터 달기 - 사진 저장
        [self.flickrImageButton addTarget:self action:@selector(flickrImageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 텍스트 필드
//    self.keywordTextField.textColor = [MNTheme getMainFontUIColor];
    self.keywordTextField.delegate = self;
    self.keywordTextField.placeholder = MNLocalizedString(@"flickr_search_images", @"이미지 찾기");
    if (imageData == nil) {
        self.keywordTextField.frame = CGRectOffset(self.keywordTextField.frame, 0, -self.flickrImageButton.frame.size.height - NO_IMAGE_OFFSET);
        self.grayscaleLabel.frame = CGRectOffset(self.grayscaleLabel.frame, 0, -self.flickrImageButton.frame.size.height - NO_IMAGE_OFFSET);
        self.grayscaleSwitch.frame = CGRectOffset(self.grayscaleSwitch.frame, 0, -self.flickrImageButton.frame.size.height - NO_IMAGE_OFFSET);
    }
//    self.keywordTextField.backgroundColor = [MNTheme getSecondSubFontUIColor];
    
    NSString *keywordString = [self.widgetDictionary objectForKey:FLICKR_KEYWORD];
    if (keywordString) {
        self.keywordTextField.text = keywordString;
    }else{
        NSString *archivedKeywordString = [[NSUserDefaults standardUserDefaults] objectForKey:FLICKR_KEYWORD];
        if (archivedKeywordString) {
            self.keywordTextField.text = archivedKeywordString;
        }else{
            self.keywordTextField.text = @"Morning";
        }
    }
    
    // 키보드 숨김 버튼 등록 - 폰만
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.hideKeyboardButton.alpha = 0;
        [self.hideKeyboardButton removeFromSuperview];
    }else{
        // 키보드 알림 등록
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWillShow:)
//                                                     name:UIKeyboardWillShowNotification
//                                                   object:self.view.window];
        
        // 새로 만든 코드로 대체
        [MNKeyboardHideButtonMaker makeKeyboardHideButtonToTextField:self.keywordTextField withHideButton:self.hideKeyboardButton];
        
        /*
        CGRect newButtonFrame = self.hideKeyboardButton.frame;
//        newButtonFrame.origin.y = self.view.frame.size.height - (KEYBOARD_HEIGHT) - newButtonFrame.size.height;
        newButtonFrame.origin.y = self.view.frame.size.height - newButtonFrame.size.height;
        self.hideKeyboardButton.frame = newButtonFrame;
        [self.hideKeyboardButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
        self.hideKeyboardButton.alpha = 0;
        [self.hideKeyboardButton bringSubviewToFront:self.hideKeyboardButton];
         */
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - keyboard handling

- (void)hideKeyboard {
//    NSLog(@"hideKeyboard");
//    [self setViewMovedUp:NO];
    
//    self.hideKeyboardButton.alpha = 1;
    
    // 뷰 초기화
    CGRect rect = self.view.frame;
    rect.origin.y += (KEYBOARD_HEIGHT - KEYBOARD_OFFSET);
    //    rect.size.height += KEYBOARD_HEIGHT - KEYBOARD_OFFSET;
    
    // 키보드 초기화
    /*
    CGRect currentFrame = self.hideKeyboardButton.frame;
    currentFrame.origin.y = rect.size.height - currentFrame.size.height;
    self.hideKeyboardButton.frame = currentFrame;
     */
    
    // 애니메이션 시작
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
//    self.hideKeyboardButton.alpha = 0;
//    currentFrame.origin.y = self.view.frame.size.height - 30 - currentFrame.size.height;
//    self.hideKeyboardButton.frame = currentFrame;
    
    //    self.hideKeyboardButton.frame = currentFrame;
    //    [self setViewMovedUp:YES];
    
    // 로직 변경
    // 키보드
    /*
    self.hideKeyboardButton.frame = CGRectMake(currentFrame.origin.x,
                                               rect.size.height - currentFrame.size.height,
                                               currentFrame.size.width,
                                               currentFrame.size.height);
     */
    
    // 뷰
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
    [self.keywordTextField resignFirstResponder];
//    self.hideKeyboardButton.alpha = 0;
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    // The keyboard will be shown. If the user is editing the author, adjust the display so that the
    // author field will not be covered by the keyboard.
//    if ( [self.keywordTextField isFirstResponder] && self.view.frame.origin.y >= 0)
//    {
//        [self setViewMovedUp:YES];
//    }
//    else if ( [self.keywordTextField isFirstResponder] && self.view.frame.origin.y < 0)
//    {
//        [self setViewMovedUp:NO];
//    }
//    self.hideKeyboardButton.alpha = 1;
    
//    [self setViewMovedUp:YES];
    
//    self.hideKeyboardButton.alpha = 1;

    // 뷰 초기화
    CGRect rect = self.view.frame;
    rect.origin.y -= (KEYBOARD_HEIGHT - KEYBOARD_OFFSET);
//    rect.size.height += KEYBOARD_HEIGHT - KEYBOARD_OFFSET;
    
    // 키보드 초기화
    /*
    CGRect currentFrame = self.hideKeyboardButton.frame;
    currentFrame.origin.y = rect.size.height - currentFrame.size.height;
    self.hideKeyboardButton.frame = currentFrame;
     */
    
    // 애니메이션 시작
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];

    // 키보드
    /*
    self.hideKeyboardButton.frame = CGRectMake(currentFrame.origin.x,
                                               rect.size.height - (KEYBOARD_HEIGHT) - currentFrame.size.height - rect.origin.y,
                                               currentFrame.size.width,
                                               currentFrame.size.height);
     */
    
    // 뷰
    self.view.frame = rect;

//    self.hideKeyboardButton.frame = currentFrame;
    [UIView commitAnimations];
//    [self.view bringSubviewToFront:self.hideKeyboardButton];
}

/*
- (void)setViewMovedUp:(BOOL)movedUp
{   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = self.view.frame;
    
    if (movedUp)
    {
        // If moving up, not only decrease the origin but increase the height so the view
        // covers the entire screen behind the keyboard.
        
        rect.origin.y -= KEYBOARD_HEIGHT - KEYBOARD_OFFSET;
//        rect.size.height += KEYBOARD_HEIGHT - 30;
        
    }
    else
    {
        // If moving down, not only increase the origin but decrease the height.
        rect.origin.y += KEYBOARD_HEIGHT - KEYBOARD_OFFSET;
//        rect.size.height -= KEYBOARD_HEIGHT - 30;
    }
    
    self.view.frame = rect;
    [UIView commitAnimations];
}
*/

- (void)textFieldDidEndEditing:(UITextField *)myTextField;
{
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        if( self.view.frame.origin.y < 0 )
//        {
//            [self setViewMovedUp:NO];
//        }
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        if( self.view.frame.origin.y < 0 )
//        {
//            [self setViewMovedUp:NO];
//        }
        [self.keywordTextField resignFirstResponder];
////        self.hideKeyboardButton.alpha = 0;
//    }
    return YES;
} 


#pragma mark - click handling

- (void)doneButtonClicked {

    // 키워드가 입력되어 있어야 저장하기. 없으면 취소와 같은 효과
    if (self.keywordTextField.text.length > 0) {
        // 입력한 키워드를 저장했다 다음에 새 플리커 위젯에 사용
        [[NSUserDefaults standardUserDefaults] setObject:self.keywordTextField.text forKey:FLICKR_KEYWORD];
        [self.widgetDictionary setObject:self.keywordTextField.text forKey:FLICKR_KEYWORD];
    }
    [self.widgetDictionary setObject:@(self.grayscaleSwitch.on) forKey:FLICKR_GRAY_SCALE_ON];
    [super doneButtonClicked];
}

- (void)flickrImageButtonClicked {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:MNLocalizedString(@"flickr_save_to_library_guide", @"파일이 저장됩니다")
                                  delegate:self
                                  cancelButtonTitle:MNLocalizedString(@"cancel", @"취소")
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:[NSString stringWithFormat:@"%@ - %@", MNLocalizedString(@"ok", @"확인"), MNLocalizedString(@"flickr_normal_quality", "확인 (고화질)")], [NSString stringWithFormat:@"%@ - %@", MNLocalizedString(@"ok", @"확인"), MNLocalizedString(@"flickr_high_quality", "확인 (고화질)")], nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:self.view];
}

#pragma mark - action sheet delegate method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"actionSheetButtonClicked: %d", buttonIndex);
    if (buttonIndex == 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 사진 저장
            [self savePhotoToLibrary:self.flickrImageButton.imageView.image];
            /*
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            
            [library writeImageToSavedPhotosAlbum:[self.flickrImageButton.imageView.image CGImage] orientation:(ALAssetOrientation)[self.flickrImageButton.imageView.image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
                if (error) {
                    // TODO: error handling
                    NSLog(@"error happen!");
                } else {
                    // TODO: success handling
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[JLToast makeText:MNLocalizedString(@"flickr_photo_saved", nil)] show];
                    });
                }
            }];
             */
        });
    }else if(buttonIndex == 1) {
        
//        [self performSelectorOnMainThread:@selector(showLoadingMsg) withObject:nil waitUntilDone:NO];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:0.6f];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[JLToast makeText:MNLocalizedString(@"loading", @"로딩 중...")] show];
            });
             
        });
        
        // dispatch를 통해 사진을 저장하는 로직을 넣는다
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *urlString = [self.widgetDictionary objectForKey:@"flickrPhotoUrlString"];
//            NSLog(@"%@", urlString);
            
            // 크기를 z -> b로 고치자(긴 쪽 1024). 원본은 접근이 불가능해 보인다.
            urlString = [urlString stringByReplacingOccurrencesOfString:@"_z" withString:@"_b"];
//            NSLog(@"%@", urlString);
            
            // 이미지 fetching
            NSData *highQualityFlickrImageData;
            highQualityFlickrImageData = [MNFlickrFetcher flickrImageDataFromUrlString:urlString];
            
            // 이미지를 가져왔다면 흑백 처리하고 저장
            if (highQualityFlickrImageData) {
                UIImage *highQualityFlickrImage = [UIImage imageWithData:highQualityFlickrImageData];
                if (self.grayscaleSwitch.on) {
                    highQualityFlickrImage = [MNFlickrImageProcessor getGrayscaledImageFromOriginalImage:highQualityFlickrImage];
                }
                [self savePhotoToLibrary:highQualityFlickrImage];
            }else{
                
            }
        });
    }
}

- (void)savePhotoToLibrary:(UIImage *)image {
    // 사진 저장
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            // TODO: error handling
            NSLog(@"error happen!");
        } else {
            // TODO: success handling
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSThread sleepForTimeInterval:0.6f];
//                [[JLToast makeText:MNLocalizedString(@"flickr_photo_saved", nil) delay:0.6f duration:JLToastShortDelay] show];
                [[JLToast makeText:MNLocalizedString(@"flickr_photo_saved", nil)] show];
            });
        }
    }];
}

#pragma mark - rotate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    return NO;
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
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - grayscaleSwitchToggled

- (void)grayscaleSwitchToggled:(UISwitch *)grayscaleSwitch {
//    NSLog(@"grayscaleSwitchToggled");
//    NSLog(@"%d", grayscaleSwitch.on);
    
    if (self.originalImage) {
        if (grayscaleSwitch.on) {
            [self.flickrImageButton setImage:[MNFlickrImageProcessor getGrayscaledImageFromOriginalImage:self.originalImage] forState:UIControlStateNormal];
        }else{
            [self.flickrImageButton setImage:self.originalImage forState:UIControlStateNormal];
        }        
    }
}

#pragma mark - keyboard animation

- (void)viewDidAppear:(BOOL)animated
{
    // 가장 초기의 뷰 위치를 저장
    orignalViewTop = self.view.frame.origin.y;
    
    // 3가지 노티피케이션에 대한 옵저버 등록
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(keyboardWillAnimate:)
                                                   name:UITextFieldTextDidBeginEditingNotification
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(keyboardWillAnimate:)
                                                   name:UIKeyboardWillShowNotification
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(keyboardWillAnimate:)
                                                   name:UIKeyboardWillHideNotification
                                                 object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // 옵저버 제거
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidBeginEditingNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

// exp: process on keyboard show(or hide)
- (void)keyboardWillAnimate:(NSNotification *)notification
{
//    NSLog(@"keyboardWillAnimate");
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    if ([duration intValue] == 0)
        duration = [NSNumber numberWithFloat:0.25f];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    if ([notification name] == UITextFieldTextDidBeginEditingNotification)
    {
//        NSLog(@"UITextFieldTextDidBeginEditingNotification");
        
        // 원래 로직
        float viewHeight = self.view.frame.size.height;
        float visibleHeight = viewHeight - keyboardHeight;
        UITextField *field = self.keywordTextField;
        float fieldTop = field.frame.origin.y + field.frame.size.height/2;
        
        float offset = -fieldTop + visibleHeight/2;
        
        if (offset < -keyboardHeight)
            offset = -keyboardHeight;
        
        if (offset > 0)
            offset = 0;
        
        [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                       orignalViewTop + offset,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height)];
    }
    else if ([notification name] == UIKeyboardWillShowNotification)
    {
        // iOS 7.0에서 이쪽에서 문제가 생겨버림.
//        NSLog(@"UIKeyboardWillShowNotification");
        CGRect keyboardBounds;
        [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
        
        keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
        
        if (keyboardHeight != 0 && keyboardHeight > keyboardBounds.size.height)
            [UIView setAnimationDuration:0];
        
        keyboardHeight = keyboardBounds.size.height;
        
//        NSLog(@"%f", KEYBOARD_HEIGHT - keyboardHeight);
        
        float viewHeight = self.view.frame.size.height;
        float visibleHeight = viewHeight - keyboardHeight;
        UITextField *field = self.keywordTextField;
        float fieldTop = field.frame.origin.y + field.frame.size.height/2;
        
        float offset = -fieldTop + visibleHeight/2;
        
        if (offset < -keyboardHeight)
            offset = -keyboardHeight;
        
        if (offset > 0)
            offset = 0;
        
        // 큰 키보드 올라올 때 offset 79, 작은 일본어 키보드 올라올 때 offset 61
//        NSLog(@"%f + %f", orignalViewTop, offset);
        
        [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                       orignalViewTop + offset, // self.view.frame.origin.y, // 0, // orignalViewTop + offset,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height)];
        
        /*
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && (keyboardHeight - KEYBOARD_HEIGHT) == 36) {
            // 36만큼 키보드를 더 올려 준다.
            [UIView setAnimationDuration:0];
            
            CGRect currentFrame = self.hideKeyboardButton.frame;
//            NSLog(@"%@", NSStringFromCGRect(currentFrame));
            
            self.hideKeyboardButton.frame = CGRectMake(currentFrame.origin.x,
                                                       currentFrame.origin.y - keyboardHeight + 36 + (79-61),
                                                       currentFrame.size.width,
                                                       currentFrame.size.height);
            [UIView commitAnimations];
        }else{
            // 뷰 초기화
            CGRect rect = self.view.frame;
            //        rect.origin.y -= (KEYBOARD_HEIGHT - KEYBOARD_OFFSET);
            //    rect.size.height += KEYBOARD_HEIGHT - KEYBOARD_OFFSET;
            
            // 키보드 초기화
            CGRect currentFrame = self.hideKeyboardButton.frame;
            currentFrame.origin.y = rect.size.height - currentFrame.size.height;
            self.hideKeyboardButton.frame = currentFrame;
            
            // 애니메이션 시작(키보드가 새로 나올 때만)
            if (self.hideKeyboardButton.alpha == 0) {
                self.hideKeyboardButton.alpha = 1;
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.25];
            }
            
            // 키보드
            self.hideKeyboardButton.frame = CGRectMake(currentFrame.origin.x,
                                                       rect.size.height - (KEYBOARD_HEIGHT) - currentFrame.size.height - rect.origin.y,
                                                       currentFrame.size.width,
                                                       currentFrame.size.height);
        }
         */
    }
    else if ([notification name] == UIKeyboardWillHideNotification)
    {
//        NSLog(@"UIKeyboardWillHideNotification");
        keyboardHeight = 0;
        
        [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                       orignalViewTop,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height)];
    }
    
    [UIView commitAnimations];
}

@end
