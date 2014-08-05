//
//  MNExchangeRateCell.m
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 19..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNExchangeRateCell.h"
#import "MNTheme.h"

@implementation MNExchangeRateCell

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
    [MNTheme sharedTheme].isThemeForConfigure = YES;
    self.currencyUnitCodeLabel.textColor = [MNTheme getSubFontUIColor];
    self.countryNameLabel.textColor = [MNTheme getMainFontUIColor];
    self.backgroundColor = [UIColor clearColor];
    [MNTheme sharedTheme].isThemeForConfigure = NO;
    
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
