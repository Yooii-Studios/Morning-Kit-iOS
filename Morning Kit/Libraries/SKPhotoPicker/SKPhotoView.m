//
//  SKPhotoView.m
//  SKPhotoPicker
//
//  Created by 김우성 on 13. 4. 9..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import "SKPhotoView.h"

@implementation SKPhotoView

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


#pragma mark - hit test

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
//    NSLog(@"%@ hitTest", [self class]); 
    NSEnumerator *reverseE = [self.subviews reverseObjectEnumerator];
    UIView *iSubView;
    
    while ((iSubView = [reverseE nextObject])) {
        
//        NSLog(@"iSubView: %@", iSubView.class);
        UIView *viewWasHit = [iSubView hitTest:[self convertPoint:point toView:iSubView] withEvent:event];
        if(viewWasHit) {
            return viewWasHit;
        }
        
    }
    return [super hitTest:point withEvent:event];
}

@end
