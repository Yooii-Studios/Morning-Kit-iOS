//
//  MNView.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 8. 25..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNView.h"
#import "MNTheme.h"

@implementation MNView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

#pragma mark - Touches 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
    self.backgroundColor = [MNTheme getTouchedBackgroundUIColor];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //    NSLog(@"touchesEnded");
    self.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    
    if (self.MNDelegate) {
        [self.MNDelegate MNViewDidClicked];
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //    NSLog(@"touchesCancelled");
    self.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [super touchesCancelled:touches withEvent:event];
}

@end
