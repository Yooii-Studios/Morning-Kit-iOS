//
//  MNConfigureInfoController.h
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 30..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNConfigureCell.h"
//#import <ConnectorSDK/CNConnector.h>
#import <StoreKit/StoreKit.h>

@protocol MNConfigureInfoControllerDelegate <NSObject>

- (void)doneButtonClicked;

@end

@interface MNConfigureInfoController : UITableViewController <SKStoreProductViewControllerDelegate> // OpenYooiiAppMarketDelegate,

@property (strong, nonatomic) IBOutlet MNConfigureCell *storeCell;
@property (strong, nonatomic) IBOutlet MNConfigureCell *rateMorningKitCell;
//@property (strong, nonatomic) IBOutlet MNConfigureCell *restoreCell;
@property (strong, nonatomic) IBOutlet MNConfigureCell *helpCell;
@property (strong, nonatomic) IBOutlet MNConfigureCell *creditCell;
@property (strong, nonatomic) IBOutlet MNConfigureCell *likeUsOnFaceBookCell;
@property (strong, nonatomic) IBOutlet MNConfigureCell *moreAppsCell;

@property (strong, nonatomic) id<MNConfigureInfoControllerDelegate> delegate;

- (IBAction)doneButtonClicked:(id)sender;

@end
