//
//  MNWidgetSelector.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 4. 30..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNWidgetSelectScrollView.h"
#import "MNDefinitions.h"

#define WIDGET_SELECTOR_NIB_NAME ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"MNWidgetSelector_iPad" : @"MNWidgetSelector")

@interface MNWidgetSelector : UIView <UIScrollViewDelegate>

- (void)setThemeColor;
- (void)makeRoundRect;
- (void)orderSelectorItems;
- (void)gotoPage:(BOOL)animated;
- (void)gotoPageWithInt:(int)page Animated:(BOOL)YesOrNO;
- (void)localize;
- (void)indicateCurrentWidget:(enum widgetID)type;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *selectorItems;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *lockers;

@property (strong, nonatomic) IBOutlet MNWidgetSelectScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UILabel *storeLabel;

@end
