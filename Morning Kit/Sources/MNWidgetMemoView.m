//
//  MNWidgetMemoView.m
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNWidgetMemoView.h"
#import "MNTheme.h"
#import "MNDefinitions.h"
#import <QuartzCore/QuartzCore.h>

#define FONT_SIZE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 20 : 13)
#define MIN_FONT_SIZE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 12 : 8)

@implementation MNWidgetMemoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWidgetView {
    self.memoString = @"";
    //    self.memoLabel.autoresizingMask =
    //    (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |
    //    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
    //    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
}

- (void)doWidgetLoadingInBackground
{
}

- (void)updateUI
{
    self.memoString = [self.widgetDictionary objectForKey:MEMO_STRING];
    self.archivedString = [[NSUserDefaults standardUserDefaults] objectForKey:MEMO_ARCHIVED_STRING];
    //    NSLog(@"%@", memoString);
    
    // 위젯에 저장된 메모가 있고, 기본 메모가 아닐 경우
//    NSLog(@"%@", self.memoString);
    if (self.memoString && self.memoString.length > 0) {
        [self.loadingDelegate stopAnimation];
        self.memoLabel.alpha = 1;
        self.memoLabel.text = self.memoString;
        //            self.memoLabel.textAlignment = NSTextAlignmentLeft;
        
        self.summarylabel.alpha = 0;
        self.widgetNameLabel.alpha = 0;
    }
    // 위젯에 저장된 메모가 없을 경우
    else{
        // 최근 메모 저장 부분을 그냥 새로 짜자.
        // 기본적으로는 메모 입력 부분을 보여준다.
        // 만약 최근에 저장했던 메모가 있다면 그것을 보여 준다.
        if (self.archivedString)
        {
            [self.loadingDelegate stopAnimation];
            self.memoLabel.alpha = 1;
            self.memoLabel.text = self.archivedString;
            self.memoString = self.archivedString;
            
            self.summarylabel.alpha = 0;
            
            self.widgetNameLabel.alpha = 0;
            [self.widgetDictionary setObject:self.memoString forKey:MEMO_STRING];
        }
        else
        {
            self.memoLabel.alpha = 0;
            
            self.summarylabel.alpha = 0;
            //            self.summarylabel.text = MNLocalizedString(@"memo_write_here", @"여기에 입력하세요");
            
            //            self.widgetNameLabel.text = [NSString stringWithFormat:@"%@", MNLocalizedString(@"memo", @"메모")];
            self.widgetNameLabel.alpha = 0;
            [self.loadingDelegate showWidgetErrorMessage:MNLocalizedString(@"memo_write_here", @"")];
            
            //            self.memoString = [NSString stringWithFormat:@"%@", MNLocalizedString(@"memo", @"메모")];
            //            [self.widgetDictionary setObject:self.memoString forKey:MEMO_STRING];
        }
    }
    //    if (self.memoString) {
    //        [self.widgetDictionary setObject:self.memoString forKey:MEMO_STRING];
    //    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self onRotationWithOrientation:orientation];
}

- (void)adjustFontForLabel {
    
    if (self.memoString) {
        // 새로운 방법 찾기
        NSString *text = self.memoLabel.text;
        UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_SIZE];
        
        // 제일 긴 메모를 표시할 때 8까지는 줄여야함
        for (int i=FONT_SIZE; i>MIN_FONT_SIZE; i=i-1) {
            font = [font fontWithSize:i];
            
            CGSize constraintSize = CGSizeMake(self.memoLabel.frame.size.width, MAXFLOAT);
            CGSize labelSize = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
            
            if (labelSize.height <= self.memoLabel.frame.size.height) {
                break;
            }
        }
        self.memoLabel.font = font;
        self.memoLabel.text = text;
    }
}

- (void)onLanguageChanged
{
    [self doWidgetLoadingInBackground];
    [self updateUI];
}

- (void)initThemeColor {
    [super initThemeColor];
    
//    self.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    self.memoLabel.textColor = [MNTheme getMainFontUIColor];
    self.widgetNameLabel.textColor = [MNTheme getMainFontUIColor];
    self.summarylabel.textColor = [MNTheme getWidgetSubFontUIColor];
    
//    [self refreshWidgetView];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - on ratation

- (void)onRotationWithOrientation:(UIInterfaceOrientation)orientation
{
    CGRect widgetFrame = self.frame;
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight))
        {
            width = widgetFrame.size.width - 60.f;
            height = widgetFrame.size.height - 60.f;
        }
        else
        {
            width = widgetFrame.size.width - 50.f;
            height = widgetFrame.size.height - 50.f;
        }
    }
    else
    {
        if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight))
        {
            width = widgetFrame.size.width - 15.f;
            height = widgetFrame.size.height - 15.f;
        }
        else
        {
            width = widgetFrame.size.width - 10.f;
            height = widgetFrame.size.height - 10.f;
        }
    }
    
    x = widgetFrame.size.width/2.f - width/2.f;
    y = widgetFrame.size.height/2.f - height/2.f;
    
    self.memoLabel.frame = CGRectMake(x,
                                      y,
                                      width,
                                      height);
    
    [self adjustFontForLabel];
}

@end
