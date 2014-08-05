//
//  MNThinSeparator.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 10. 6..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNThinSeparator.h"

@implementation MNThinSeparator

- (void)layoutSubviews
{
    CGRect newFrame = self.frame;
    if ([UIScreen mainScreen].scale == 2.0f) {
        newFrame.size.height = 0.5f;
    }else{
        newFrame.size.height = 1.0f;
    }
    self.frame = newFrame;
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
