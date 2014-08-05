//
//  MNStoreProductCellMaker.m
//  MNStoreControllerProj
//
//  Created by Wooseong Kim on 13. 7. 9..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import "MNStoreProductCellMaker.h"
#import "MNStoreController.h"
#import "MNStoreProductBuyButton.h"
#import "MNStoreManager.h"
#import <QuartzCore/QuartzCore.h>
#import "MNStoreButtonMaker.h"
#import "MNStoreProductCell.h"

@implementation MNStoreProductCellMaker

+ (void)initProductCell:(MNStoreProductCell *)productCell withTabIndex:(NSInteger)tabIndex withRow:(NSInteger)row withStoreController:(MNStoreController *)controller {
    
    // 셀 자체 처리: 그림자 및 라운딩
    productCell.backgroundColor = UIColorFromHexCode(0x464646);
    
    productCell.layer.cornerRadius = 6;
    
    productCell.layer.shadowColor = [UIColor blackColor].CGColor;
    productCell.layer.shadowOpacity = 0.5f;
    productCell.layer.shadowOffset = CGSizeMake(0, 0);
    productCell.layer.shadowRadius = 3.0f;
    productCell.layer.masksToBounds = NO;
    
    // 태그 101 이미지, 102 제품 이름, 103 구매 버튼
    // 제대로 초기화를 하고 쓰자
    UIImageView *productImageView = (UIImageView *)[productCell viewWithTag:101];
    productImageView.image = nil;
    
    UILabel *productName = (UILabel *)[productCell viewWithTag:102];
    
    MNStoreProductBuyButton *productBuyButton = (MNStoreProductBuyButton *)[productCell viewWithTag:103];
    [productBuyButton setTitle:@"$0.99" forState:UIControlStateNormal];
    [MNStoreButtonMaker makeStoreOnButton:productBuyButton];
    [productBuyButton addTarget:controller action:@selector(productBuyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    switch (tabIndex) {
        case MNStoreTabTypeFunction:
            // 1번 기능 탭: 알람, 광고X, 매트릭스
            switch (row) {     

                case 0:
                    productName.text = MNLocalizedString(@"store_item_more_alarm_slots", nil); // @"More Alarm Decks";
                    productBuyButton.productID = STORE_PRODUCT_ID_MORE_ALARM_DECKS;
                    productImageView.image = [UIImage imageNamed:@"shop_more_alarms_icon"];
                    break;
                    
                case 1:
                    productName.text = MNLocalizedString(@"store_item_no_ads", nil); // @"No Ad";
                    productBuyButton.productID = STORE_PRODUCT_ID_NO_AD;
                    productImageView.image = [UIImage imageNamed:@"shop_no_ad_icon"];
                    break;
                    
                case 2:
                    productName.text = MNLocalizedString(@"store_item_matrix", nil); // @"More Matrix";
                    productBuyButton.productID = STORE_PRODUCT_ID_MORE_MATRIX;
                    productImageView.image = [UIImage imageNamed:@"shop_more_matrix_icon"];
                    break;
            }
            break;
            
        case MNStoreTabTypeWidget:
            // 2번 위젯 탭: 날짜 계산, 메모
            switch (row) {
                case 0:
                    productName.text = MNLocalizedString(@"store_item_widget_date_countdown", nil); // @"Date Countdown";
                    productBuyButton.productID = STORE_PRODUCT_ID_WIDGET_DATE_COUNTDOWN;
                    productImageView.image = [UIImage imageNamed:@"shop_widget_date_countdown_icon"];
                    break;
                    
                case 1:
                    productName.text = MNLocalizedString(@"store_item_widget_memo", nil); // @"Memo";
                    productBuyButton.productID = STORE_PRODUCT_ID_WIDGET_MEMO;
                    productImageView.image = [UIImage imageNamed:@"shop_widget_memo_icon"];
                    break;
            }
            break;
            
        case MNStoreTabTypeTheme:
            // 3번 테마 탭: 사진(세로), 사진(가로), 스카이 블루
            switch (row) {
//                case 2:
//                    productName.text = MNLocalizedString(@"setting_theme_photo", nil); // @"사진\n세로모드";
//                    productBuyButton.productID = STORE_PRODUCT_ID_THEME_PHOTO_PORTRAIT;
//                    productImageView.image = [UIImage imageNamed:@"store_photo"];
//                    break;
                    
//                case 1:
//                    productName.text = MNLocalizedString(@"store_item_photo_landscape", nil); // @"사진\n가로모드";
//                    productBuyButton.productID = STORE_PRODUCT_ID_THEME_PHOTO_LANDSCAPE;
//                    productImageView.image = [UIImage imageNamed:@"shop_photo_land_icon"];
//                    break;
                    
                case 0:
                    productName.text = MNLocalizedString(@"store_item_classic_white", nil); // @"사진\n가로모드";
                    productBuyButton.productID = STORE_PRODUCT_ID_THEME_CLASSIC_WHITE;
                    productImageView.image = [UIImage imageNamed:@"shop_theme_white_icon"];
                    break;
                    
                case 1:
                    productName.text = MNLocalizedString(@"store_item_skyblue", nil); // @"Theme\n스카이블루";
                    productBuyButton.productID = STORE_PRODUCT_ID_THEME_SKY_BLUE;
                    productImageView.image = [UIImage imageNamed:@"shop_theme_skyblue_icon"];
                    break;
            }
            break;
    }
    
    if (controller.isBuying) {
        productBuyButton.userInteractionEnabled = NO;
    }else{
        productBuyButton.userInteractionEnabled = YES;
    }

    if ([[NSUserDefaults standardUserDefaults] boolForKey:productBuyButton.productID] == YES) {
//        [productBuyButton setTitle:@"Purchased" forState:UIControlStateNormal];
        [productBuyButton setTitle:MNLocalizedString(@"store_purchased", nil) forState:UIControlStateNormal];
        productBuyButton.titleLabel.numberOfLines = 1;
        productBuyButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        productBuyButton.titleLabel.lineBreakMode = NSLineBreakByClipping; // <-- MAGIC LINE
        productBuyButton.userInteractionEnabled = NO;
        productCell.userInteractionEnabled = NO;
    }else{
        [productBuyButton setTitle:@"$0.99" forState:UIControlStateNormal];
        productBuyButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        productBuyButton.titleLabel.lineBreakMode = NSLineBreakByClipping; // <-- MAGIC LINE
        productBuyButton.userInteractionEnabled = YES;
        productCell.userInteractionEnabled = YES;
    }
    
}

@end
