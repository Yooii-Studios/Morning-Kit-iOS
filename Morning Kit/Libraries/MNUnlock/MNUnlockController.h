//
//  MNUnlockController.h
//  MNStoreControllerProj
//
//  Created by Wooseong Kim on 13. 7. 9..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MNStoreManager.h"
#import "SKInnerShadowLayer.h"
#import <StoreKit/StoreKit.h>
#import "Reachability.h"

typedef NS_ENUM(NSInteger, MNUnlockType) {
    MNUnlockTypeBuyFullVersion = 0,
    MNUnlockTypeBuyThisItemOnly,
    MNUnlockTypeReview,
    MNUnlockTypeFaceBookLike,  // 취소
    MNUnlockTypeTwitterFollow, // 취소
    MNUnlockTypeUseMorningKit10Times, // 취소
    MNUnlockTypeConnector, // 커넥터 취소되서 일단 사용하지 않음
};

#define UNLOCK_REVIEW @"unlock_review"
#define UNLOCK_CONNECTOR @"unlock_connector"
#define UNLOCK_USE_MORNING_10 @"unlock_use_morning_10"
#define UNLOCK_FACEBOOK_LIKE @"unlock_facebook_like"
#define UNLOCK_TWITTER_FOLLOW @"unlock_twitter_follow"

#define MORNING_LAUNCH_COUNT @"morning_launch_count"
#define MORNING_RATE_IT_MESSAGE_USED @"morning_rate_it_message_used"
#define MORNING_LAUNCH_COUNT_UNLOCK_LIMIT 10

@interface MNUnlockController : UIViewController <UITableViewDataSource, UITableViewDelegate, MNStoreManagerDelegate, SKStoreProductViewControllerDelegate>

@property (nonatomic, strong) NSString *productID;

@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UITableView *unlockItemTableView;
@property (nonatomic, strong) IBOutlet UIView *unlockTableBackgroundView;

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic) BOOL isBuying;
@property (nonatomic) BOOL needShowUnlockLabel;

@property (nonatomic, strong) IBOutlet UIButton *resetButton;

// 가현 요청
@property (nonatomic, strong) SKInnerShadowLayer *innerShadowLayer;

// 인터넷 테스트
@property (strong, nonatomic) Reachability *reach;

- (IBAction)doneButtonClicked:(id)sender;

- (IBAction)resetButtonClicked:(id)sender;

@end
