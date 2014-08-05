//
//  YBCell.h
//  YBTableViewWidget
//
//  Created by Yongbin Bae on 13. 10. 5..
//  Copyright (c) 2013년 Morning Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNThinSeparator.h"

@interface MNReminderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet MNThinSeparator *separator;
@property (strong, nonatomic) IBOutlet UILabel *tomorrowSeparator;

@end
