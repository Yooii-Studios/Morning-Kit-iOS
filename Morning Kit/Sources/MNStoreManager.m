//
//  MNStoreManager.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 7. 6..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNStoreManager.h"

@implementation MNStoreManager

#pragma mark - Singleton

+ (MNStoreManager *)sharedStoreManager {
    static MNStoreManager *instance;
    
    if (instance == nil) {
        @synchronized(self) {
            if (instance == nil) {
                instance = [[self alloc] init];
            }
        }
    }
    
    // 기존 최초 한번만 구매가능 여부를 체크하는 것에서, 호출마다 체크를 하게 변경.
    // 스토어 설정 및 Observer 등록
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:instance];
    if ([SKPaymentQueue canMakePayments]) {
//        NSLog(@"Start IAP!");
        [[SKPaymentQueue defaultQueue] addTransactionObserver:instance];
    }else{
//        NSLog(@"Failed IAP");
    }
    
    return instance;
}


#pragma mark - Class Method

+ (void)buyItemWithItemID:(NSString *)productID withDelegate:(id<MNStoreManagerDelegate>)delegate {
    [MNStoreManager sharedStoreManager].MNDelegate = delegate;
    
    SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productID]];
    productRequest.delegate = [MNStoreManager sharedStoreManager];
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"TARGET_IPHONE_SIMULATOR: not access to App Store sandbox");
    if (delegate) {
        [delegate MNStoreManagerBoughtItem:productID];
    }
#else
    [productRequest start];
#endif
}

+ (void)restorePurchasesWithDelegate:(id<MNStoreManagerDelegate>)delegate {
    [MNStoreManager sharedStoreManager].MNDelegate = delegate;
    [[MNStoreManager sharedStoreManager] restoreAllPurchases];
}


#pragma mark - SKPayamentTransactionsObserver Protocol

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
        }
    }
}


#pragma mark - IAP Transaction methods

// 구매 관련 기능이 제대로 풀린 다음에 transaction을 처리해 줄 것
- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
//    NSLog(@"SKPaymentTransactionStateRestored");
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    if (self.MNDelegate) {
        [self.MNDelegate MNStoreManagerFinishTransactions];
    }
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
//    NSLog(@"SKPaymentTransactionStateFailed: %@", transaction.payment.productIdentifier);
//    NSLog(@"%@: %d", transaction.error.description, transaction.error.code);
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    if (self.MNDelegate) {
        [self.MNDelegate MNStoreManagerFinishTransactions];
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
//	NSLog(@"SKPaymentTransactionStatePurchased: %@", transaction.payment.productIdentifier);
    
    //	NSLog(@"Trasaction Identifier : %@", transaction.transactionIdentifier);
    //	NSLog(@"Trasaction Date : %@", transaction.transactionDate);
    
    /*
     if ([transaction.payment.productIdentifier isEqualToString:@"fullVersion"]) {
     self.fullVersionLabel.text = @"Purchased";
     }else if([transaction.payment.productIdentifier isEqualToString:@"moreAlarmDecks"]) {
     self.moreAlarmDecksLabel.text = @"Purchased";
     }
     */
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    if (self.MNDelegate) {
        [self.MNDelegate MNStoreManagerBoughtItem:transaction.payment.productIdentifier];
    }
}


#pragma mark - SKProductRequestDelegate Protocol

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
//    NSLog(@"SKProductRequest get response");
    if( response.products.count > 0 ) {
        SKProduct *product = [response.products objectAtIndex:0];
//        NSLog(@"Title: %@", product.localizedTitle);
        //        NSLog(@"Description: %@", product.localizedDescription);
        //        NSLog(@"Price: %@", product.price);
        
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
    if( response.invalidProductIdentifiers.count > 0 ) {
//        NSString *invalidString = [response.invalidProductIdentifiers objectAtIndex:0];
//        NSLog(@"Invalid Identifiers: %@", invalidString);
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
//    NSLog(@"SKProductRequest didFailWithError: %@", error.description);
    if (error.localizedDescription) {
        
        // 이상한 에러를 보여주는 것보다, 네트워크가 안될 가능성이 있다고 얘기하는 것이 나을듯.
//        [[[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:MNLocalizedString(@"cancel", nil) otherButtonTitles:nil] show];
        
        [[[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", nil) message:MNLocalizedString(@"no_network_connection", ) delegate:nil cancelButtonTitle:MNLocalizedString(@"cancel", nil) otherButtonTitles:nil] show];
    }else{
        // 네트워크가 안될 가능성이 있음
        [[[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", nil) message:MNLocalizedString(@"no_network_connection", ) delegate:nil cancelButtonTitle:MNLocalizedString(@"cancel", nil) otherButtonTitles:nil] show];
    }
    if (self.MNDelegate) {
        [self.MNDelegate MNStoreManagerFinishTransactions];
    }
}

#pragma mark - Restore IAP

- (void)restoreAllPurchases {
#if TARGET_IPHONE_SIMULATOR
//    NSLog(@"TARGET_IPHONE_SIMULATOR: not restore");
    if (self.MNDelegate) {
        [self.MNDelegate MNStoreManagerRestoreItems];
    }
#else
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
#endif
}

// restore 성공하면 호출되는 콜백 메서드
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    
//    NSLog(@"received restored transactions: %i", queue.transactions.count);
    
    // 구매 기록이 없으면 알려주고 빠져나가기
    if (queue.transactions.count == 0) {
        [[[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", nil) message:MNLocalizedString(@"store_no_purchase_records", @"No Purchase Records") delegate:nil cancelButtonTitle:MNLocalizedString(@"ok", nil) otherButtonTitles:nil] show];
        
        if (self.MNDelegate) {
            [self.MNDelegate MNStoreManagerFinishTransactions];
        }
    }else{
        for (SKPaymentTransaction *transaction in queue.transactions)
        {
            NSString *productID = transaction.payment.productIdentifier;
            [purchasedItemIDs addObject:productID];
            
            // 해당 productID를 저장하기
            //            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productID];
        }
        [[NSUserDefaults standardUserDefaults] setObject:purchasedItemIDs forKey:STORE_PURCHASED_ITEM_IDs];
        if (self.MNDelegate) {
            [self.MNDelegate MNStoreManagerRestoreItems];
        }
        [[[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", nil) message:MNLocalizedString(@"store_restore_success_message", nil) delegate:self cancelButtonTitle:MNLocalizedString(@"ok", nil) otherButtonTitles:nil] show];
    }
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
//    NSLog(@"restoreCompletedTransactionsFailedWithError: %@", error.description);
    [[[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:MNLocalizedString(@"cancel", nil) otherButtonTitles:nil] show];
    
    if (self.MNDelegate) {
        [self.MNDelegate MNStoreManagerFinishTransactions];
    }
}


@end
