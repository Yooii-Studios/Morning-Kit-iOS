//
//  SKTutorialView.h
//  TestPopup
//
//  Created by Wooseong Kim on 13. 7. 4..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNTheme.h"
#import "MNPageControl.h"

typedef NS_ENUM(NSInteger, SKTutorialThemeType) {
    SKTutorialThemeTypeWaterLily = 0,
    SKTutorialThemeTypeClassicGray,
    SKTutorialThemeTypeScenery,
};

@protocol SKTutorialViewDelegate <NSObject>

- (void)SKTutorialViewDelegateDidConfirm:(MNThemeType)themeType;

@end


@interface SKTutorialView : UIView<UIScrollViewDelegate>

@property (strong, nonatomic) id<SKTutorialViewDelegate> SKDelegate;
@property (strong, nonatomic) IBOutlet UIView *popupTutorialView;

@property (strong, nonatomic) IBOutlet UILabel *themeSelectLabel;
@property (strong, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *themeScrollView;
@property (strong, nonatomic) IBOutlet UIView *themeScrollBackgroundView;
//@property (strong, nonatomic) IBOutlet UIPageControl *themePageControl;
@property (strong, nonatomic) IBOutlet MNPageControl *themePageControl;

@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)confirmButtonClicked:(id)sender;

@end
