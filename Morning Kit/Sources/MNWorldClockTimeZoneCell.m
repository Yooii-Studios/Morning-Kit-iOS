//
//  MNWorldClockTimeZoneCell.m
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 20..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWorldClockTimeZoneCell.h"
#import "MNDefinitions.h"

@implementation MNWorldClockTimeZoneCell

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

+ (CGFloat)getCellHeight    {
    return WORLD_CLOCK_TIMEZONE_CELL_HEIGHT;
}

@end
