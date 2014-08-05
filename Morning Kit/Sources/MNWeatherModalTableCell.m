//
//  MNWeatherModalTableCell.m
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 4. 29..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWeatherModalTableCell.h"

@implementation MNWeatherModalTableCell

@synthesize image_countryFlag;
@synthesize label_locationName;
@synthesize label_locationSpecification;

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

+ (CGFloat)getCellHeight    {    return 55;     }


@end
