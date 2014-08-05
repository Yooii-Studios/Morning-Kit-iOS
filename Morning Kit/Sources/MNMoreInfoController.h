//
//  MNMoreInfoController.h
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 8. 12..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNStoreManager.h"
#import "MBProgressHUD.h"

@interface MNMoreInfoController : UITableViewController <MNStoreManagerDelegate>

@property (strong, nonatomic) MBProgressHUD *hud;
@property (nonatomic) BOOL isBuying;

@end
