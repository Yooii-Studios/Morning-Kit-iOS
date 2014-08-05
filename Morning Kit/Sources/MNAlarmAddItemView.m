//
//  MNAlarmAddItemView.m
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 24..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNAlarmAddItemView.h"
#import "MNTheme.h"

@implementation MNAlarmAddItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.multipleTouchEnabled = NO;
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
//    NSLog(@"touchesBegan");
    self.backgroundColor = [MNTheme getTouchedBackgroundUIColor];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesEnded");
    self.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [super touchesEnded:touches withEvent:event];
    
    if (self.MNDelegate) {
        [self.MNDelegate alarmAddItemClickedToPresentAlarmPreferenceModalController];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesCancelled");
    self.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [super touchesCancelled:touches withEvent:event];
}

@end
