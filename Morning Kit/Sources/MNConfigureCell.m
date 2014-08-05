//
//  MNConfigureCell.m
//  Morning Kit
//
//  Created by 김우성 on 13. 6. 10..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNConfigureCell.h"
#import "MNTheme.h"

@implementation MNConfigureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
        self.frontView = (UIView *)[self viewWithTag:300];
        self.isCellUnlocked = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesBegan");
    if (self.isCellUnlocked) {
        self.frontView.backgroundColor = [MNTheme getTouchedBackgroundUIColor];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesEnded");
    if (self.isCellUnlocked) {
        self.frontView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesCancelled");
    if (self.isCellUnlocked) {
        self.frontView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    }
    [super touchesCancelled:touches withEvent:event];
}

@end
