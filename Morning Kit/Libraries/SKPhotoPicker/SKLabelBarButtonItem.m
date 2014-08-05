//
//  SKLabelBarButtonItem.m
//  SKPhotoPicker
//
//  Created by 김우성 on 13. 4. 10..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import "SKLabelBarButtonItem.h"

@implementation SKLabelBarButtonItem

- (void) awakeFromNib {
    UIView *theView = [self valueForKey:@"view"];
    
    if ([theView respondsToSelector:@selector(setUserInteractionEnabled:)]) {
        theView.userInteractionEnabled = NO;
    }
}

@end
