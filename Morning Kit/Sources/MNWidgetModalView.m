//
//  MNWidgetModalView.m
//  Morning Kit
//
//  Created by Yong Bin Bae on 13. 3. 31..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetModalView.h"

@implementation MNWidgetModalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - must have to be implemented

- (void)initWithDictionary:(NSMutableDictionary *)dict
{
    self.widgetDictionary = dict;
}

- (void)doneSetting
{
    
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
