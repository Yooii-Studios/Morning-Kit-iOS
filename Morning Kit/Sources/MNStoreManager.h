//
//  MNStoreManager.h
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 7. 6..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STORE_PRODUCT_ID_FULL_VERSION @"com.yooiistudios.morningkit.fullversion"
#define STORE_PRODUCT_ID_MORE_ALARM_DECKS @"com.yooiistudios.morningkit.morealarmdecks"
//#define MORE_WIDGETS @"moreWidgets"
#define STORE_PRODUCT_ID_NO_AD @"com.yooiistudios.morningkit.noad"

// 추가해야할 것
//#define MORE_THEME @"moreTheme"
#define STORE_PRODUCT_ID_MORE_MATRIX @"com.yooiistudios.morningkit.morematrix"
#define STORE_PRODUCT_ID_NO_WIDGET_COVER @"com.yooiistudios.morningkit.nowidgetcover"
#define STORE_PRODUCT_ID_UNLOCK_PHOTOS_OF_DEVELOPERS @"com.yooiistudios.morningkit.photosofdevelopers"

// 최종적으로 추가됨
#define STORE_PRODUCT_ID_THEME_PHOTO @"com.yooiistudios.morningkit.themephoto"
#define STORE_PRODUCT_ID_THEME_PHOTO_PORTRAIT @"com.yooiistudios.morningkit.themephotoportrait"
#define STORE_PRODUCT_ID_THEME_PHOTO_LANDSCAPE @"com.yooiistudios.morningkit.themephotolandscape"
#define STORE_PRODUCT_ID_THEME_SKY_BLUE @"com.yooiistudios.morningkit.themeskyblue"
#define STORE_PRODUCT_ID_THEME_CLASSIC_WHITE @"com.yooiistudios.morningkit.themeclassicwhite"

#define STORE_PRODUCT_ID_WIDGET_DATE_COUNTDOWN @"com.yooiistudios.morningkit.widgetdatecountdown"
#define STORE_PRODUCT_ID_WIDGET_MEMO @"com.yooiistudios.morningkit.widgetmemo"

#define STORE_PURCHASED_ITEM_IDs @"purchasedItemIds"

// IAP 관련
#import <StoreKit/SKProduct.h>
#import <StoreKit/SKPayment.h>
#import <StoreKit/SKProductsRequest.h>
#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKPaymentTransaction.h>

@protocol MNStoreManagerDelegate <NSObject>

@required
- (void)MNStoreManagerFinishTransactions; // 애니메이션 취소용

@optional
- (void)MNStoreManagerBoughtItem:(NSString *)productID;
- (void)MNStoreManagerRestoreItems;

@end

// 구매에 관한 모든 로직을 여기에서 처리한다
// test id: iap2@yooii.com, 비번은 회사비번
@interface MNStoreManager : NSObject <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, strong) id<MNStoreManagerDelegate> MNDelegate;

+ (MNStoreManager *)sharedStoreManager;
+ (void)restorePurchasesWithDelegate:(id<MNStoreManagerDelegate>)delegate;
+ (void)buyItemWithItemID:(NSString *)itemID withDelegate:(id<MNStoreManagerDelegate>)delegate;

@end
