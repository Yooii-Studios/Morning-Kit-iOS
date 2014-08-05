 //
//  MNConfigureSettingController.h
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 30..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MNConfigureSettingControllerDelegate <NSObject>

- (void)doneButtonClicked;

@end

@interface MNConfigureSettingController : UITableViewController

- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;

@property (strong, nonatomic) id<MNConfigureSettingControllerDelegate> delegate;

@end
