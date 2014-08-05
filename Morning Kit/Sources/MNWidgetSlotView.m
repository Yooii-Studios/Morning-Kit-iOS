//
//  MNWidgetSlotView.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 4. 23..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetSlotView.h"
#import "MNTheme.h"
#import "MNDefinitions.h"
#import <QuartzCore/QuartzCore.h>
#import "MNRoundRectedViewMaker.h"
#import "MNEffectSoundPlayer.h"
#import "MNWidgetCoverImageLoader.h"
#import "MNWidgetNameMaker.h"
#import "MNStoreManager.h"

#define NIBNAME_LOADINGVIEW ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNWidgetLoadingView_iPad" : @"MNWidgetLoadingView")
#define NIB_NAME_COVER_VIEW ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNWidgetCoverView_iPad" : @"MNWidgetCoverView_iPhone")

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

@implementation MNWidgetSlotView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initLoadingView:(int)pos
{
    self.backgroundColor = [UIColor clearColor];
    self.LoadingView = [[[NSBundle mainBundle] loadNibNamed:NIBNAME_LOADINGVIEW owner:self options:nil] objectAtIndex:0];
    self.LoadingView.delegate = self;
    [self addSubview:self.LoadingView];
    self.LoadingView.layer.cornerRadius = ROUNDED_CORNER_RADIUS;
}

- (void)startAnimation
{
    self.WidgetView.alpha = 0.0f;
    self.LoadingView.alpha = 1.0f;
    [self.LoadingView startAnimating];
}

- (void)stopAnimation
{
    self.WidgetView.alpha = 1.0f;
    self.LoadingView.alpha = 0.0f;
    [self.LoadingView stopAnimating];
}

- (void)showLocationFail
{    
    [self.LoadingView showNOLocation];
    self.WidgetView.alpha = 0.0f;
    self.LoadingView.alpha = 1.0f;
}

- (void)showNetworkFail
{
    [self.LoadingView showNoNetwork];
    self.WidgetView.alpha = 0.0f;
    self.LoadingView.alpha = 1.0f;
}

- (void)showWidgetErrorMessage:(NSString *)msg
{
    [self.LoadingView showWidgetError:msg];
    self.WidgetView.alpha = 0.0f;
    self.LoadingView.alpha = 1.f;
}

- (void)setThemeColor:(UIColor *)color
{
    self.backgroundColor = [UIColor clearColor];
    self.WidgetView.backgroundColor = [UIColor clearColor];
    self.LoadingView.backgroundColor = [UIColor clearColor];
    self.LoadingView.label.textColor = [MNTheme getWidgetSubFontUIColor];
}

- (void)setLoadingViewAlpha:(CGFloat)alpha
{
    self.LoadingView.alpha = alpha;
}

- (NSString *)getWidgetTypeString
{
    return MNLocalizedString(WidgetLocalizeKey[[self.WidgetView.widgetDictionary[@"Type"] integerValue]], @"Type");
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
