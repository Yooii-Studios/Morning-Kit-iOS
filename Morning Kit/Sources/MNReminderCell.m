//
//  YBCell.m
//  YBTableViewWidget
//
//  Created by Yongbin Bae on 13. 10. 5..
//  Copyright (c) 2013년 Morning Team. All rights reserved.
//

#import "MNReminderCell.h"
#import "MNTheme.h"

@implementation MNReminderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    self.backgroundColor = [UIColor clearColor];
//    self.dateLabel.textColor = [MNTheme getMainFontUIColor];
//    self.titleLabel.textColor = [MNTheme getMainFontUIColor];
    
//    self.separator.backgroundColor = [UIColor clearColor];
    self.separator.backgroundColor = [MNTheme getSubFontUIColor];
//    self.separator.backgroundColor = [MNTheme getMainFontUIColor];
//    NSLog(@"%@", NSStringFromCGRect(self.separator.frame));
    
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);//[MNTheme getSubFontUIColor].CGColor);
//    
//    // Draw them with a 2.0 stroke width so they are a bit more visible.
//    
//    CGContextBeginPath(context);
//    
//    CGContextSetLineWidth(context, 1.0f);
//    
//    CGContextMoveToPoint(context, 5, rect.size.height - 1); //start at this point
//    
//    CGContextAddLineToPoint(context, rect.size.width-5, rect.size.height-1); //draw to this point
//    
//    // and now draw the Path!
//    CGContextStrokePath(context);
//}

@end
