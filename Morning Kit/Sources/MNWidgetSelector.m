
//
//  MNWidgetSelector.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 4. 30..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetSelector.h"
#import "MNTheme.h"
#import "MNRoundRectedViewMaker.h"
#import "MNDefinitions.h"
#import "MNLanguage.h"
#import "MNStoreController.h"

static NSString *WidgetLocalizeKey[10] =
{
    @"",
    @"weather",
    @"calendar",
    @"reminder",
    @"world_clock",
    @"saying",
    @"flickr",
    @"exchange_rate",
    @"memo",
    @"date_calculator"
};

@implementation MNWidgetSelector

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)localize
{
    self.labels = [self.labels sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return(
               ([obj1 tag] < [obj2 tag]) ? NSOrderedAscending  :
               ([obj1 tag] > [obj2 tag]) ? NSOrderedDescending :
               NSOrderedSame);
    }];
    
    for (UILabel *label in self.labels) {
        label.text = MNLocalizedString(WidgetLocalizeKey[label.tag], @"");
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        ;
    }
    else
    {
        if ([[MNLanguage getCurrentLanguage] isEqualToString:@"en"])
        {
            [((UILabel *)self.labels[WORLDCLOCK-1]) setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f]];
            [((UILabel *)self.labels[DATE_COUNTDOWN-1]) setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f]];
            [((UILabel *)self.labels[EXCHANGE_RATE-1]) setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f]];
        }
        else
        {
            [((UILabel *)self.labels[WORLDCLOCK-1]) setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
            [((UILabel *)self.labels[DATE_COUNTDOWN-1]) setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
            [((UILabel *)self.labels[EXCHANGE_RATE-1]) setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
        }
    }
    
    self.storeLabel.text = MNLocalizedString(@"info_store", nil);
}

- (void)makeRoundRect
{
    for (UIView *view in self.selectorItems) {
        [MNRoundRectedViewMaker makeRoundRectedView:view];
    }
}

- (void)setThemeColor
{
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    self.storeLabel.textColor = [MNTheme getStoreFontColor];
    [self setPageControlThemeColor];
    [self checkLockedWidgets];
}

- (void)setPageControlThemeColor
{
    if ([MNTheme getCurrentlySelectedTheme] == MNThemeTypeClassicWhite ||
        [MNTheme getCurrentlySelectedTheme] == MNThemeTypeMirror ||
        [MNTheme getCurrentlySelectedTheme] == MNThemeTypePhoto ||
        [MNTheme getCurrentlySelectedTheme] == MNThemeTypeScenery ||
        [MNTheme getCurrentlySelectedTheme] == MNThemeTypeWaterLily) {
        self.pageControl.currentPageIndicatorTintColor = UIColorFromHexCode(0x989898);
        self.pageControl.pageIndicatorTintColor = UIColorFromHexCode(0xc3c3c3);
    }
    else
    {
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3f];
    }
}

- (void)checkLockedWidgets
{
    int i = 0;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    for (UIView *view in self.selectorItems) {
        
        UIImageView *lockImageView;
        if (i<NUM_OF_WIDGET)
            lockImageView = (UIImageView *)self.lockers[i];
        
        // 구매 여부 체크(날짜 계산, 메모)
        if (i == DATE_COUNTDOWN-1 || i == MEMO-1) {
            lockImageView.image = [UIImage imageNamed:[MNTheme getWidgetLockerImageResourceName]];
            
            if (i == DATE_COUNTDOWN-1) {
                // 날짜 계산
                if ([userDefaults boolForKey:STORE_PRODUCT_ID_WIDGET_DATE_COUNTDOWN]) {
                    view.backgroundColor = [MNTheme getForwardBackgroundUIColor];
                    lockImageView.alpha = 0;
                }else{
                    view.backgroundColor = [MNTheme getLockedBackgroundUIColor];
                    lockImageView.alpha = 1;
                }
            }else if(i == MEMO-1) {
                // 메모
                if ([userDefaults boolForKey:STORE_PRODUCT_ID_WIDGET_MEMO]) {
                    view.backgroundColor = [MNTheme getForwardBackgroundUIColor];
                    lockImageView.alpha = 0;
                }else{
                    view.backgroundColor = [MNTheme getLockedBackgroundUIColor];
                    lockImageView.alpha = 1;
                }
            }
        }else{
            // 그외에는 무조건 사용 가능
            view.backgroundColor = [MNTheme getForwardBackgroundUIColor];
            lockImageView.alpha = 0;
        }
        view.superview.backgroundColor = [UIColor clearColor];
        
        i += 1;
    }
    
    i = 0;
    for (UILabel *label in self.labels) {
        // 구매 여부 체크(날짜 계산, 메모)
        if (i == DATE_COUNTDOWN-1) {
            // 날짜 계산
            if ([userDefaults boolForKey:STORE_PRODUCT_ID_WIDGET_DATE_COUNTDOWN]) {
                [label setTextColor:[MNTheme getMainFontUIColor]];
            }else{
                [label setTextColor:[MNTheme getWidgetLockedFontUIColor]];
            }
        }else if(i == MEMO-1) {
            // 메모
            if ([userDefaults boolForKey:STORE_PRODUCT_ID_WIDGET_MEMO]) {
                [label setTextColor:[MNTheme getMainFontUIColor]];
            }else{
                [label setTextColor:[MNTheme getWidgetLockedFontUIColor]];
            }
        }else{
            // 그외에는 무조건 사용 가능
            [label setTextColor:[MNTheme getMainFontUIColor]];
        }
        i += 1;
    }
}

- (void)indicateCurrentWidget:(enum widgetID)type
{
    ((UIView *)self.selectorItems[type-1]).backgroundColor = [MNTheme getSelectedWidgetBackgroundUIColor];
}

- (void)orderSelectorItems
{
    self.selectorItems = [self.selectorItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return(
               ([obj1 tag] < [obj2 tag]) ? NSOrderedAscending  :
               ([obj1 tag] > [obj2 tag]) ? NSOrderedDescending :
               NSOrderedSame);
    }];
    
    self.lockers = [self.lockers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return (
                ([obj1 tag] < [obj2 tag]) ? NSOrderedAscending  :
                ([obj1 tag] > [obj2 tag]) ? NSOrderedDescending :
                NSOrderedSame);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (IBAction)valueChanged:(id)sender {
    [self gotoPage:YES];
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    
	// update the scroll view to the appropriate page
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:animated];
}

- (void)gotoPageWithInt:(int)page Animated:(BOOL)YesOrNO
{
    self.pageControl.currentPage = page;
    
    [self gotoPage:YesOrNO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview touchesEnded:touches withEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
