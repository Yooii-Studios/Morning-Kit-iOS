//
//  MNWorldClockTimeZoneCell.h
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 20..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNWorldClockTimeZoneCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *cityNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeZoneLabel;

+ (CGFloat)getCellHeight;

@end
