//
//  MNWeatherModalTableCell.h
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 4. 29..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNWeatherModalTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel       *label_locationName;
@property (strong, nonatomic) IBOutlet UILabel       *label_locationSpecification;
@property (strong, nonatomic) IBOutlet UIImageView   *image_countryFlag;

+ (CGFloat)getCellHeight;

@end
