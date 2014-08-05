//
//  MNWidgetLoadingView.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 4. 27..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetLoadingView.h"
#import "MNTheme.h"

#define WIDTH_LOADING 40
#define HEIGHT_LOADING 40
#define POS_X_LOADING 57
#define POS_Y_LOADING 32

//#define IMAGEVIEW_FRAME_LANDSCAPE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGRectMake(223, 130, 60, 60) : CGRectMake(57, 22, 40, 40))
//#define IMAGEVIEW_FRAME_PORTLAIT ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGRectMake(162, 70, 60, 60) : CGRectMake(57, 22, 40, 40))

#define OFFSET_IMAGEVIEW 20
#define OFFSET_IMAGEVIEW_LAND 20

@implementation MNWidgetLoadingView
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.loadingImageView setFrame:CGRectMake(POS_X_LOADING, POS_Y_LOADING, WIDTH_LOADING, HEIGHT_LOADING)];
    }
    
    return self;
}

- (void)startAnimating
{
    NSArray *imageArr = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"loading01_01.png"],
                                [UIImage imageNamed:@"loading01_02.png"],
                                [UIImage imageNamed:@"loading01_03.png"],
                                [UIImage imageNamed:@"loading01_04.png"],
                                [UIImage imageNamed:@"loading01_05.png"],
                                [UIImage imageNamed:@"loading01_06.png"],
                                [UIImage imageNamed:@"loading01_07.png"],
                                [UIImage imageNamed:@"loading01_08.png"],
                                [UIImage imageNamed:@"loading01_09.png"],
                                [UIImage imageNamed:@"loading01_10.png"],
                                [UIImage imageNamed:@"loading01_11.png"],
                                [UIImage imageNamed:@"loading01_12.png"],
                                nil];
    
    self.loadingImageView.animationImages = [imageArr copy];
    self.loadingImageView.animationDuration = 0.6;
    self.loadingImageView.animationRepeatCount = 0;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect newImageViewFrame = self.loadingImageView.frame;
        
        if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation ==UIInterfaceOrientationLandscapeRight))
        {
            newImageViewFrame.origin.x = self.frame.size.width/2 - 30;
            newImageViewFrame.origin.y = self.frame.size.height/2 - 30 - OFFSET_IMAGEVIEW_LAND;
        }
        else
        {
            newImageViewFrame.origin.x = self.frame.size.width/2 - 30;
            newImageViewFrame.origin.y = self.frame.size.height/2 - 30 - OFFSET_IMAGEVIEW;
        }
        
        self.loadingImageView.frame = newImageViewFrame;
    }
    
    self.label.textColor = [MNTheme getWidgetSubFontUIColor];
    
    [self.loadingImageView setAlpha:1.0f];
    [self.noNetworkLabel setAlpha:0.0f];
    [self.loadingImageView startAnimating];
    self.label.text = MNLocalizedString(@"loading", @"Loading");
    
    self.state = MNWidgetStateFormal;
}

- (void)stopAnimating
{
    [self.loadingImageView stopAnimating];
}

- (void)onLanguageChanged
{
    if (self.state == MNWidgetStateNoNetwork)
        [self showNoNetwork];
    else if (self.state == MNWidgetStateNoLocation)
        [self showNOLocation];
    else if (self.state == MNWidgetStateError)
        [self showWidgetError:self.latestErrorMsg];
}

- (void)showWidgetError:(NSString *)error
{
    self.latestErrorMsg = error;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect newImageViewFrame = self.loadingImageView.frame;
        
        if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation ==UIInterfaceOrientationLandscapeRight))
        {
            newImageViewFrame.origin.x = self.frame.size.width/2 - 30;
            newImageViewFrame.origin.y = self.frame.size.height/2 - 30 - OFFSET_IMAGEVIEW_LAND;
        }
        else
        {
            newImageViewFrame.origin.x = self.frame.size.width/2 - 30;
            newImageViewFrame.origin.y = self.frame.size.height/2 - 30 - OFFSET_IMAGEVIEW;
        }
        
        self.loadingImageView.frame = newImageViewFrame;
    }
    
    self.loadingImageView.alpha = 0.0f;
    self.noNetworkLabel.alpha = 1.0f;
    self.noNetworkLabel.text = [self.delegate getWidgetTypeString];
    self.label.text = error;
    self.label.textColor = [MNTheme getWidgetSubFontUIColor];
    self.noNetworkLabel.textColor = [MNTheme getMainFontUIColor];
    
    self.state = MNWidgetStateError;
}

- (void)showNoNetwork
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect newImageViewFrame = self.loadingImageView.frame;
        
        if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation ==UIInterfaceOrientationLandscapeRight))
        {
            newImageViewFrame.origin.x = self.frame.size.width/2 - 30;
            newImageViewFrame.origin.y = self.frame.size.height/2 - 30 -OFFSET_IMAGEVIEW_LAND;
        }
        else
        {
            newImageViewFrame.origin.x = self.frame.size.width/2 - 30;
            newImageViewFrame.origin.y = self.frame.size.height/2 - 30 - OFFSET_IMAGEVIEW;
        }
        
        self.loadingImageView.frame = newImageViewFrame;
    }
    
    [self.loadingImageView setAlpha:0.0f];
    [self.noNetworkLabel setAlpha:1.0f];
    [self.noNetworkLabel setText:[self.delegate getWidgetTypeString]];
    if([self.noNetworkLabel.text isEqualToString:MNLocalizedString(@"exchange_rate", @"환율")])
        self.noNetworkLabel.text = [self.noNetworkLabel.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    self.label.text = MNLocalizedString(@"no_network_connection", "No Network");
    self.noNetworkLabel.textColor = [MNTheme getMainFontUIColor];
    
    self.state = MNWidgetStateNoNetwork;
}

- (void)showNOLocation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect newImageViewFrame = self.loadingImageView.frame;
        
        if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation ==UIInterfaceOrientationLandscapeRight))
        {
            newImageViewFrame.origin.x = self.frame.size.width/2 - 30;
            newImageViewFrame.origin.y = self.frame.size.height/2 - 30 - OFFSET_IMAGEVIEW_LAND;
        }
        else
        {
            newImageViewFrame.origin.x = self.frame.size.width/2 - 30;
            newImageViewFrame.origin.y = self.frame.size.height/2 - 30 - OFFSET_IMAGEVIEW;
        }
        
        self.loadingImageView.frame = newImageViewFrame;
    }
    
    [self.loadingImageView setAlpha:0.0f];
    [self.noNetworkLabel setAlpha:1.0f];
    [self.noNetworkLabel setText:[self.delegate getWidgetTypeString]];
    self.noNetworkLabel.textColor = [MNTheme getMainFontUIColor];
    self.label.text = @"Location fail";
    
    self.state = MNWidgetStateNoLocation;
}

@end
