//
//  SKDynamicStatusBarLineView.h
//  SKDynamicStatusBarLine
//
//  Created by Wooseong Kim on 13. 10. 1..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKDynamicStatusBarLineView : UIView <UIScrollViewDelegate>

@property (nonatomic) BOOL isEnabled;

- (id)initWithScrollView:(UIScrollView *)scrollView;

@end
