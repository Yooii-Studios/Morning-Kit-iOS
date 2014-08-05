//
//  MNExchangeRateCell.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 19..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNExchangeRateCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *flagImageView;
@property (strong, nonatomic) IBOutlet UILabel *currencyUnitCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *countryNameLabel;

@end
