//
//  SKPhotoScaleFrameView.m
//  SKPhotoPicker
//
//  Created by 김우성 on 13. 4. 5..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import "SKPhotoScaleView.h"
#import <AVFoundation/AVFoundation.h>

@implementation SKPhotoScaleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)initializeScrollView {
    
//    NSLog(@"photoScaleView frame: %@", NSStringFromCGRect(self.frame));
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        self.frame = CGRectMake(0, 0, 320, 443);
//    }
    
    self.selectedImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    // initialize zooming
    self.alwaysBounceHorizontal = YES;
    self.alwaysBounceVertical = YES;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.maximumZoomScale = 3;
    self.minimumZoomScale = 1;
    self.delegate = self;
    self.clipsToBounds = YES;
    self.decelerationRate = UIScrollViewDecelerationRateFast;   // make similar with default image picker
    
    // imageView
    self.selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.selectedImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // adjust contentInset of scrollView
    self.contentSize = self.selectedImageView.bounds.size;
    if (self.photoCropOrientation == SKPhotoCropOrientationPortrait) {
        
        // get difference with between cropRect and UIImageView frame
        CGRect cropRect = [SKPhotoCropFrameView getCropRectFromOrientation:self.photoCropOrientation];
        CGRect aspectFitRect = AVMakeRectWithAspectRatioInsideRect(self.selectedImageView.image.size, self.selectedImageView.frame);
        CGFloat difference = fabsf(cropRect.size.width - aspectFitRect.size.width);
        self.contentInset = UIEdgeInsetsMake(0, difference/2, 0, difference/2);
    }else{
        
        // get difference with between cropRect and UIImageView frame
        CGRect cropRect = [SKPhotoCropFrameView getCropRectFromOrientation:self.photoCropOrientation];
        CGRect aspectFitRect = AVMakeRectWithAspectRatioInsideRect(self.selectedImageView.image.size, self.selectedImageView.frame);
        CGFloat difference = fabsf(cropRect.size.height - aspectFitRect.size.height);
        self.contentInset = UIEdgeInsetsMake(difference/2, 0, difference/2 + 20, 0);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UIScrollView delegate method

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // mark this view will be zoomed
    return self.selectedImageView;
//    return self.zoomingView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // subView is UIImageView
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    // adjust center of subView
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
    
    // adjust contentInset
    CGFloat increasingZoomScale = (scrollView.zoomScale == 1) ? 0 : (-1 * (1 - scrollView.zoomScale));
    
    CGRect cropRect = [SKPhotoCropFrameView getCropRectFromOrientation:self.photoCropOrientation];
    CGRect aspectFitRect = AVMakeRectWithAspectRatioInsideRect(self.selectedImageView.image.size, self.selectedImageView.frame);
    
    // implement at `Landscape` mode first
    if (self.photoCropOrientation == SKPhotoCropOrientationPortrait) {
        // get scaledFrameWidth because it's `Portrait` crop mode
        CGFloat increasingFrameWidth = scrollView.frame.size.width * increasingZoomScale;
        CGFloat diffrenceBetweenWidth = fabsf(cropRect.size.width - aspectFitRect.size.width);
        self.contentInset = UIEdgeInsetsMake(0, diffrenceBetweenWidth/2 - increasingFrameWidth/2, 0, diffrenceBetweenWidth/2 - increasingFrameWidth/2);
        
        // adjust contentOffset when zoomScale is 1. there is a some position problem at scale 1.
        if (scrollView.zoomScale == 1) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x - diffrenceBetweenWidth/2, scrollView.contentOffset.y);
        }
    }else{
        // get scaledFrameHeight because it's `Landscape` crop mode
        CGFloat increasingFrameHeight = scrollView.frame.size.height * increasingZoomScale;
        CGFloat diffrenceBetweenHeight = fabsf(cropRect.size.height - aspectFitRect.size.height);
        self.contentInset = UIEdgeInsetsMake(diffrenceBetweenHeight/2 - increasingFrameHeight/2, 0, diffrenceBetweenHeight/2 - increasingFrameHeight/2, 0);
        
        // adjust contentOffset when zoomScale is 1. there is a some position problem at scale 1.
        if (scrollView.zoomScale == 1) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y - diffrenceBetweenHeight/2);
        }
    }
}

#pragma mark - hit test

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
//    NSLog(@"%@ hitTest", [self class]);
    if ([self pointInside:point withEvent:event]) {
        return self;
    }else{
        return nil;
    }
}


#pragma mark - set center

// This code block is from WWDC - there are some errors.
/*
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.zoomingView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self.zoomingView.frame = frameToCenter;
}
 */

@end
