//
//  MNCalendarModalViewController.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 4..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetModalController.h"

@interface MNCalendarModalViewController : MNWidgetModalController

@property (strong, nonatomic) IBOutlet UILabel *lunarLabel;
@property (strong, nonatomic) IBOutlet UISwitch *lunarSwitch;

@end
