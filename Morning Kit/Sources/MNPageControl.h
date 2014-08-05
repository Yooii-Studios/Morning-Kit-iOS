//
//  PageControl.h
//
//  Replacement for UIPageControl because that one only supports white dots.
//
//  Created by Morten Heiberg <morten@heiberg.net> on November 1, 2010.
//

#import <UIKit/UIKit.h>

@protocol MNPageControlDelegate;

@interface MNPageControl : UIView

// Set these to control the PageControl.
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;

// Customize these as well as the backgroundColor property.
@property (nonatomic, strong) UIColor *dotColorCurrentPage;
@property (nonatomic, strong) UIColor *dotColorOtherPage;

// Optional delegate for callbacks when user taps a page dot.
@property (nonatomic, weak) NSObject<MNPageControlDelegate> *delegate;

@end

@protocol MNPageControlDelegate<NSObject>
@optional
- (void)pageControlPageDidChange:(MNPageControl *)pageControl;
@end