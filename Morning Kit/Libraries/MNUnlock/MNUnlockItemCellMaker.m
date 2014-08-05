//
//  MNUnlockItemCellMaker.m
//  MNStoreControllerProj
//
//  Created by Wooseong Kim on 13. 7. 9..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import "MNUnlockItemCellMaker.h"
#import <QuartzCore/QuartzCore.h>
#import "MNStoreButtonMaker.h"
#import "MNUnlockController.h"
#import "MNStoreManager.h"
#import "MNUnlockButton.h"

#define DETAIL_LABEL_TEXT_SIZE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 22 : 13)
#define UNLOCK_ITEM_CORNER_RADIUS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 15 : 6)
#define UNLOCK_ITEM_SHADOW_RADIUS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 6.0f : 3.0f)

@implementation MNUnlockItemCellMaker

+ (void)initUnlockItemCell:(UITableViewCell *)unlockItemCell withRow:(NSInteger)row withUnlockController:(MNUnlockController *)controller {
    
    unlockItemCell.backgroundColor = [UIColor clearColor];
    
    // 200 백그라운드
    UIView *backgroundView = (UIView *)[unlockItemCell viewWithTag:200];
    
    backgroundView.layer.cornerRadius = UNLOCK_ITEM_CORNER_RADIUS;
//    /*
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        backgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
        backgroundView.layer.shadowOpacity = 0.5f;
        backgroundView.layer.shadowOffset = CGSizeMake(0, 0);
        backgroundView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:backgroundView.bounds cornerRadius:UNLOCK_ITEM_CORNER_RADIUS].CGPath;
        backgroundView.layer.shadowRadius = UNLOCK_ITEM_SHADOW_RADIUS;
    }else{
        backgroundView.layer.borderColor = UIColorFromHexCode(0x333333).CGColor;
        backgroundView.layer.borderWidth = 1.0f;
    }
    backgroundView.layer.shouldRasterize = YES;
    backgroundView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    */
    
    // 101 이미지, 102 컨텐츠, 103 버튼
    UIImageView *imageView = (UIImageView *)[unlockItemCell viewWithTag:101];
    imageView.image = nil;
    imageView.backgroundColor = [UIColor clearColor];
    
    UILabel *contentLabel = (UILabel *)[unlockItemCell viewWithTag:102];
    contentLabel.textColor = [UIColor whiteColor];
    
    MNUnlockButton *unlockButton = (MNUnlockButton *)[unlockItemCell viewWithTag:103];
    [unlockButton addTarget:controller action:@selector(unlockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    unlockButton.unlockType = row;
    
    // 셀 초기화 - 클릭한 것인지 아닌지를 판단
    // 사용 여부에 따라 적절한 아트를 대입하고 각 행에 따라 적절한 내용을 대입하기
    BOOL isCellUsed = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 만약 풀버전 셀이 아니고, 구매를 했다면 모두 꺼주기(불필요한 구매 방지)
    if (row != MNUnlockTypeBuyFullVersion && [userDefaults boolForKey:controller.productID]) {
        isCellUsed = YES;
    }
    
    switch (row) {
        case MNUnlockTypeBuyFullVersion: {
            isCellUsed = [userDefaults boolForKey:STORE_PRODUCT_ID_FULL_VERSION];
            // 사용 여부 확인
            if (isCellUsed) {
                imageView.image = [UIImage imageNamed:@"fullversion_icon_off"];
            }else{
                imageView.image = [UIImage imageNamed:@"fullversion_icon_on"];
            }
            
            // 레이블 세팅
            contentLabel.text = MNLocalizedString(@"unlock_everything", nil); // @"Morning Kit의 모든 기능을 구입할 수 있습니다.";
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:DETAIL_LABEL_TEXT_SIZE] range:NSMakeRange(0, attributedString.length)];
            if (isCellUsed) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0xa8a8a8) range:NSMakeRange(0, attributedString.length)];
            }else{
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
                
                NSRange unlockRange = [attributedString.string rangeOfString:MNLocalizedString(@"unlock_everything_highlight", nil)]; //@"모든 기능"];
                [attributedString enumerateAttributesInRange:unlockRange options:NSWidthInsensitiveSearch | NSAnchoredSearch | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0x00ccff) range:unlockRange];
                }];
            }
            contentLabel.attributedText = attributedString;
            
            // 버튼 내용 입력
            [unlockButton setTitle:@"$1.99" forState:UIControlStateNormal];
            break;
        }
        case MNUnlockTypeBuyThisItemOnly: {
            isCellUsed = [userDefaults boolForKey:controller.productID];
            if (isCellUsed) {
                imageView.image = [UIImage imageNamed:@"buyit_icon_off"];
            }else{
                imageView.image = [UIImage imageNamed:@"buyit_icon_on"];
            }
            
            // 레이블 세팅
            contentLabel.text = MNLocalizedString(@"unlock_only_this", nil); // @"해당 기능을 구입할 수 있습니다.";
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:DETAIL_LABEL_TEXT_SIZE] range:NSMakeRange(0, attributedString.length)];
            if (isCellUsed) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0xa8a8a8) range:NSMakeRange(0, attributedString.length)];
            }else{
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
                
                NSRange unlockRange = [attributedString.string rangeOfString:MNLocalizedString(@"unlock_only_this_highlight", nil)]; //@"Connector"];
                [attributedString enumerateAttributesInRange:unlockRange options:NSWidthInsensitiveSearch | NSAnchoredSearch | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0x00ccff) range:unlockRange];
                }];
            }
            contentLabel.attributedText = attributedString;
            
            // 버튼 내용 입력
            [unlockButton setTitle:@"$0.99" forState:UIControlStateNormal];
            break;
        }
        case MNUnlockTypeReview: {
            BOOL isThisFunctionBought = [userDefaults boolForKey:controller.productID];
            if (isThisFunctionBought) {
                isCellUsed = YES;
            }else{
                isCellUsed = [userDefaults boolForKey:UNLOCK_REVIEW];            
            }
            if (isCellUsed) {
                imageView.image = [UIImage imageNamed:@"rating_icon_off"];
            }else{
                imageView.image = [UIImage imageNamed:@"rating_icon_on"];
            }
            
            // 레이블 세팅
            contentLabel.text = MNLocalizedString(@"unlock_review", nil); // @"별 5개 리뷰를 주시면 더 열심히 업데이트 할 수 있을 것 같습니다!\n리뷰 후 Free Unlock 됩니다.";
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:DETAIL_LABEL_TEXT_SIZE] range:NSMakeRange(0, attributedString.length)];
            if (isCellUsed) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0xa8a8a8) range:NSMakeRange(0, attributedString.length)];
            }else{
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
                
                NSRange unlockRange = [attributedString.string rangeOfString:MNLocalizedString(@"unlock_review_highlight", nil)]; // @"별 5개 리뷰"];
                [attributedString enumerateAttributesInRange:unlockRange options:NSWidthInsensitiveSearch | NSAnchoredSearch | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0x00ccff) range:unlockRange];
                }];
                
                /*
                NSRange unlock2Range = [attributedString.string rangeOfString:MNLocalizedString(@"unlock_review_highlight2", nil)]; // @"Free Unlock"];
                [attributedString enumerateAttributesInRange:unlockRange options:NSWidthInsensitiveSearch | NSAnchoredSearch | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0x00ccff) range:unlock2Range];
                }];
                 */
            }
            contentLabel.attributedText = attributedString;
            
            // 버튼 내용 입력
            [unlockButton setTitle:@"Rating" forState:UIControlStateNormal];
            break;
        }
        case MNUnlockTypeConnector: {
            BOOL isThisFunctionBought = [userDefaults boolForKey:controller.productID];
            if (isThisFunctionBought) {
                isCellUsed = YES;
            }else{
                isCellUsed = [userDefaults boolForKey:UNLOCK_CONNECTOR];
            }
            if (isCellUsed) {
                imageView.image = [UIImage imageNamed:@"connector_icon_off"];
            }else{
                imageView.image = [UIImage imageNamed:@"connector_icon_on"];
            }
            
            // 레이블 세팅
            contentLabel.text = MNLocalizedString(@"unlock_connector", nil); // @"Connector에 가입해 주시면\nFree Unlock 됩니다.";
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:DETAIL_LABEL_TEXT_SIZE] range:NSMakeRange(0, attributedString.length)];
            if (isCellUsed) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0xa8a8a8) range:NSMakeRange(0, attributedString.length)];
            }else{
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
                
                NSRange unlockRange = [attributedString.string rangeOfString:MNLocalizedString(@"unlock_connector_highlight", nil)]; //@"Connector"];
                [attributedString enumerateAttributesInRange:unlockRange options:NSWidthInsensitiveSearch | NSAnchoredSearch | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0x00ccff) range:unlockRange];
                }];
            }
            contentLabel.attributedText = attributedString;
            
            // 버튼 내용 입력
            [unlockButton setTitle:@"Join" forState:UIControlStateNormal];
            break;
        }
        case MNUnlockTypeUseMorningKit10Times: {
            
            BOOL isThisFunctionBought = [userDefaults boolForKey:controller.productID];
            if (isThisFunctionBought) {
                isCellUsed = YES;
            }else{
                isCellUsed = [userDefaults boolForKey:UNLOCK_USE_MORNING_10];
            }
            
            NSInteger morningLaunchCount = [userDefaults integerForKey:MORNING_LAUNCH_COUNT];
            
            if (morningLaunchCount >= MORNING_LAUNCH_COUNT_UNLOCK_LIMIT) {
                morningLaunchCount = MORNING_LAUNCH_COUNT_UNLOCK_LIMIT;
                [MNStoreButtonMaker makeStoreOnButton:unlockButton];
                unlockButton.userInteractionEnabled = YES;
                unlockItemCell.userInteractionEnabled = YES;
            }else{
                [MNStoreButtonMaker makeStoreOffButton:unlockButton];
                unlockButton.userInteractionEnabled = NO;
                unlockItemCell.userInteractionEnabled = NO;
                isCellUsed = YES;
            }
            
            imageView.alpha = 0;
            /*
            if (isCellUsed) {
                imageView.image = [UIImage imageNamed:@"morningkit_100_icon_off"];
                [MNStoreButtonMaker makeStoreOffButton:unlockButton];
                unlockButton.userInteractionEnabled = NO;
                unlockItemCell.userInteractionEnabled = NO;
            }else{
                imageView.image = [UIImage imageNamed:@"morningkit_100_icon_on"];
            }*/
                
            // 레이블 세팅
            contentLabel.text = MNLocalizedString(@"unlock_use_morning", nil); // @"Morning Kit을 10회 사용하시면 Free Unlock 됩니다.";
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:DETAIL_LABEL_TEXT_SIZE] range:NSMakeRange(0, attributedString.length)];
            if (isCellUsed) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0xa8a8a8) range:NSMakeRange(0, attributedString.length)];
            }else{
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
                
                NSRange unlockRange = [attributedString.string rangeOfString:MNLocalizedString(@"unlock_use_morning_highlight", nil)]; // @"Morning Kit"];
                [attributedString enumerateAttributesInRange:unlockRange options:NSWidthInsensitiveSearch | NSAnchoredSearch | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0x00ccff) range:unlockRange];
                }];
            }
            contentLabel.attributedText = attributedString;
            
            // 사용횟수 레이블 세팅            
            // 버튼 내용 입력
            NSString *countString = [NSString stringWithFormat:@"[%d/%d]", morningLaunchCount, MORNING_LAUNCH_COUNT_UNLOCK_LIMIT];
            [unlockButton setTitle:countString forState:UIControlStateNormal];
            
            attributedString = [[NSMutableAttributedString alloc] initWithString:countString];
            if (isCellUsed) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0xa8a8a8) range:NSMakeRange(0, attributedString.length)];
            }else{
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0x00ccff) range:NSMakeRange(attributedString.length - 3, 2)];
                /*
                NSRange unlockRange = [attributedString.string rangeOfString:[NSString stringWithFormat:@"%d", morningLaunchCount]];
                [attributedString enumerateAttributesInRange:unlockRange options:NSWidthInsensitiveSearch | NSAnchoredSearch | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0x00ccff) range:unlockRange];
                }];
                 */
            }
            
            UILabel *usingCountLabel = (UILabel *)[unlockItemCell viewWithTag:201];
            usingCountLabel.attributedText = attributedString;
            
            break;
        }
        case MNUnlockTypeFaceBookLike: {
            BOOL isThisFunctionBought = [userDefaults boolForKey:controller.productID];
            if (isThisFunctionBought) {
                isCellUsed = YES;
            }else{
                isCellUsed = [userDefaults boolForKey:UNLOCK_FACEBOOK_LIKE];
            }
            if (isCellUsed) {
                imageView.image = [UIImage imageNamed:@"like_icon_off"];
            }else{
                imageView.image = [UIImage imageNamed:@"like_icon_on"];
            }
            
            // 레이블 세팅
            contentLabel.text = MNLocalizedString(@"unlock_facebook", nil); // @"facebook Like 버튼을 눌러서\nFree Unlock 하세요.";
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:DETAIL_LABEL_TEXT_SIZE] range:NSMakeRange(0, attributedString.length)];
            if (isCellUsed) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0xa8a8a8) range:NSMakeRange(0, attributedString.length)];
            }else{
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
                
                NSRange unlockRange = [attributedString.string rangeOfString:MNLocalizedString(@"unlock_facebook_highlight", nil)]; // @"facebook Like"];
                [attributedString enumerateAttributesInRange:unlockRange options:NSWidthInsensitiveSearch | NSAnchoredSearch | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0x00ccff) range:unlockRange];
                }];
            }
            contentLabel.attributedText = attributedString;
            
            // 버튼 내용 입력
            [unlockButton setTitle:@"Like" forState:UIControlStateNormal];
            break;
        }
        case MNUnlockTypeTwitterFollow: {
            BOOL isThisFunctionBought = [userDefaults boolForKey:controller.productID];
            if (isThisFunctionBought) {
                isCellUsed = YES;
            }else{
                isCellUsed = [userDefaults boolForKey:UNLOCK_TWITTER_FOLLOW];
            }
            if (isCellUsed) {
                imageView.image = [UIImage imageNamed:@"follow_icon_off"];
            }else{
                imageView.image = [UIImage imageNamed:@"follow_icon_on"];
            }
            
            // 레이블 세팅
            contentLabel.text = MNLocalizedString(@"unlock_twitter", nil); // @"Follow 버튼을 눌러 주시면 Free Unlock 됩니다.";
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:DETAIL_LABEL_TEXT_SIZE] range:NSMakeRange(0, attributedString.length)];
            if (isCellUsed) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0xa8a8a8) range:NSMakeRange(0, attributedString.length)];
            }else{
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
                
                NSRange unlockRange = [attributedString.string rangeOfString:MNLocalizedString(@"unlock_twitter_highlight", nil)]; // @"Follow"];
                [attributedString enumerateAttributesInRange:unlockRange options:NSWidthInsensitiveSearch | NSAnchoredSearch | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexCode(0x00ccff) range:unlockRange];
                }];
            }
            contentLabel.attributedText = attributedString;
            
            // 버튼 내용 입력
            [unlockButton setTitle:@"Follow" forState:UIControlStateNormal];
            break;
        }
    }
    
    if (isCellUsed) {
        backgroundView.backgroundColor = UIColorFromHexCode(0x454545);
        contentLabel.textColor = UIColorFromHexCode(0xa8a8a8);
        unlockItemCell.userInteractionEnabled = NO;
        [MNStoreButtonMaker makeStoreOffButton:unlockButton];
        unlockButton.userInteractionEnabled = NO;
    }else{
        // 모닝 100회 실행은 버튼 사용 가능 여부 자체적으로 판단
        backgroundView.backgroundColor = UIColorFromHexCode(0x5b5b5b);
        //        contentLabel.textColor = UIColorFromHexCode(0xa8a8a8);
        [MNStoreButtonMaker makeStoreOnButton:unlockButton];
        unlockButton.userInteractionEnabled = YES;
        unlockItemCell.userInteractionEnabled = YES;
    }
}

@end
