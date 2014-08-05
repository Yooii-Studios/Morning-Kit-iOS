//
//  MNUnlockItemCell.m
//  MNStoreControllerProj
//
//  Created by Wooseong Kim on 13. 7. 10..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import "MNUnlockItemCell.h"

@implementation MNUnlockItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    UIView *backgroundView = (UIView *)[self viewWithTag:200];
    backgroundView.backgroundColor = UIColorFromHexCode(0x747474);
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //    NSLog(@"touchesEnded");
    UIView *backgroundView = (UIView *)[self viewWithTag:200];
    backgroundView.backgroundColor = UIColorFromHexCode(0x5b5b5b);
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //    NSLog(@"touchesCancelled");
    UIView *backgroundView = (UIView *)[self viewWithTag:200];
    backgroundView.backgroundColor = UIColorFromHexCode(0x5b5b5b);
    [super touchesCancelled:touches withEvent:event];
}

@end
