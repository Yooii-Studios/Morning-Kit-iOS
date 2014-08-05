//
//  MNAlarmPreferenceLabelController.h
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 7..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNAlarmPreferenceLabelController;

@protocol MNAlarmPreferenceLabelControllerDelegate <NSObject>

- (void)MNAlarmPreferenceLabelControllerDidAlarmLabelSetting:(MNAlarmPreferenceLabelController *)controller;

@end

@interface MNAlarmPreferenceLabelController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *alarmLabel;
@property (strong, nonatomic) IBOutlet UITextField *alarmLabelTextField;
@property (strong, nonatomic) id<MNAlarmPreferenceLabelControllerDelegate> delegate;

@end
