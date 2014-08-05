//
//  SKDynamicStatusBarLineView.m
//  SKDynamicStatusBarLine
//
//  Created by Wooseong Kim on 13. 10. 1..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import "SKDynamicStatusBarLineView.h"
#import "MNTheme.h"
#import "MNTranslucentFont.h"

#define LINE_HEIGHT 0.5f
#define LINE_HEIGHT_NON_RETINA 1.0f
#define LIMIT_PERCENTAGE 0.04f

@implementation SKDynamicStatusBarLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
        
        CGFloat lineHeight;
        if ([UIScreen mainScreen].scale == 2.0f) {
            lineHeight = LINE_HEIGHT;
        }else{
            lineHeight = LINE_HEIGHT_NON_RETINA;
        }
        self.frame = CGRectMake(0, statusBarFrame.size.height, [UIScreen mainScreen].bounds.size.width, lineHeight);
        self.isEnabled = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        // You can customize the color or position, etc.
//        if([MNTranslucentFont getCurrentFontType] == MNTranslucentFontTypeBlack) {
//            self.backgroundColor = [UIColor blackColor];
//        }else{
//            self.backgroundColor = [UIColor whiteColor];
//        }
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
        scrollView.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameChanged:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

#pragma mark - UIScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    // You can customize this values
    if (self.isEnabled) {
        if (scrollView.contentOffset.y > scrollView.frame.size.height * LIMIT_PERCENTAGE) {
            // over 15% length of total height, alpha is 0.4f
            self.alpha = 0.4f;
        }else{
            // under 15%m, fade in/out with alpha
            CGFloat limit = scrollView.frame.size.height * LIMIT_PERCENTAGE;
            CGFloat alphaRatio = scrollView.contentOffset.y / limit * 0.4f;
            self.alpha = alphaRatio;
        }
    } else {
        self.alpha = 0;
    }
}

#pragma mark - In-call status 
- (void)statusBarFrameChanged:(NSNotification *)notification {
    NSValue *rectValue = [[notification userInfo] valueForKey:UIApplicationStatusBarFrameUserInfoKey];
    
    CGRect oldFrame;
    [rectValue getValue:&oldFrame];
    
//    NSLog(@"statusBarFrameChanged: oldSize %f, %f", oldFrame.size.width, oldFrame.size.height);
    if(oldFrame.size.height == 20) {
//        NSLog(@"bar is on");
        self.isEnabled = NO;
    } else {
//        NSLog(@"bar is off");
        self.isEnabled = YES;
    }
}

@end
