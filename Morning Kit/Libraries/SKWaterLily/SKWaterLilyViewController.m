//
//  SKViewController.m
//  SKWaterLilyTest
//
//  Created by Wooseong Kim on 13. 10. 5..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import "SKWaterLilyViewController.h"

@interface SKWaterLilyViewController ()

@end

@implementation SKWaterLilyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 각 디바이스와 버전을 체크하기
    // 폰 / 패드 비교 후 3.5인치, 4인치 비교
    // 아트는 차라리 레티나 아트를 넣어버리자
    
    // 일단 5인치일때만 따로 처리해보고, 나머지는 그대로 해보자.
    self.view.backgroundColor = [UIColor redColor];
    
    self.waterLilyTheme = [[SKWaterLilyTheme alloc] init];
}

#pragma mark -
#pragma mark Rotate Image
/*
- (UIImage *)scaleAndRotateImage:(UIImage *)image  {
 
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat boundHeight;
    
    boundHeight = bounds.size.height;
    bounds.size.height = bounds.size.width;
    bounds.size.width = boundHeight;
    transform = CGAffineTransformMakeScale(-1.0, 1.0);
//    transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0); //use angle/360 *MPI
    transform = CGAffineTransformRotate(transform, 90.0 * M_PI/180); //use angle/360 *MPI
//    transform = CGAffineTransformMakeTranslation(0.0, 0.0);
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    imageCopy = [self scaleAndRotateImage2:imageCopy];
//    imageCopy = [self scaleAndRotateImage2:imageCopy];
    return imageCopy;
    
}

*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
//    NSLog(@"viewWillLayoutSubviews");
    
    // 각 사진을 회전하기
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self.waterLilyImageView setImage:self.waterLilyTheme.portraitWaterLilyImage];
    }else{
        [self.waterLilyImageView setImage:self.waterLilyTheme.landscapeWaterLilyImage];
    }
}

- (IBAction)selectImageButtonClicked:(id)sender {
    
}

- (IBAction)cancelButtonClicked:(id)sender {
    
}

@end
