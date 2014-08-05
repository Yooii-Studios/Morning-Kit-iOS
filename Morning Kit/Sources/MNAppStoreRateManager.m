//
//  MNAppStoreRateManager.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 8. 12..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNAppStoreRateManager.h"
#import <StoreKit/StoreKit.h>

@implementation MNAppStoreRateManager

+ (void)presentAppStoreControllerWithMorningKitWithController:(UIViewController *)controller {
    // 새 로직: 바로 앱스토어를 modal로 띄우기
    SKStoreProductViewController *storeController = [[SKStoreProductViewController alloc] init];
    storeController.delegate = (id<SKStoreProductViewControllerDelegate>)controller; // productViewControllerDidFinish
    // <SKStoreProductViewControllerDelegate>
    
    // 이것 적용이 되지 않는다.
    storeController.navigationItem.leftBarButtonItem.title = MNLocalizedString(@"done", @"Done");
    storeController.navigationItem.rightBarButtonItem.title = MNLocalizedString(@"done", @"Done");
    
    // Example app_store_id (e.g. for Words With Friends)
    // [NSNumber numberWithInt:322852954];
    
    // iTuensConnect 에 앱 링크의 숫자 부분이 매개 변수
    
    // 경북대 도서관: 테스트용
    //            NSDictionary *productParameters = @{ SKStoreProductParameterITunesItemIdentifier : @"602918897" };
    // Morning Kit : 667312140
    NSDictionary *productParameters = @{ SKStoreProductParameterITunesItemIdentifier : @"667312140" };
    
    [storeController loadProductWithParameters:productParameters completionBlock:^(BOOL result, NSError *error) {
        if (result) {
            //                    [self presentViewController:storeController animated:YES completion:nil];
        } else {
            [[[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", nil) message:@"Can't find Morning Kit" delegate:nil cancelButtonTitle:MNLocalizedString(@"OK", nil) otherButtonTitles: nil] show];
        }
    }];
    
    /*
     // 경북대 도서관 들어가지는 URL
     //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://itunes.apple.com/app/gyeongbugdae-doseogwan-for/id602918897?mt=8"]];
     
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://itunes.apple.com/us/app/morning-kit/id667312140?l=ko&ls=1&mt=8"]];
     // itms: 는 디바이스에서만 테스트가능
     // https://itunes.apple.com/kr/app/funny-cartoon-face/id333209093?mt=8
     // itms://itunes.com/app/FunnyCartoonFace
     // http://itunes.com/app/gyeongbugdae-doseogwan-for
     // https://itunes.apple.com/us/app/morning-kit/id667312140?l=ko&ls=1&mt=8
     // https://itunes.apple.com/kr/app/gyeongbugdae-doseogwan-for/id602918897?mt=8
     break;
     */
    
    [controller presentViewController:storeController animated:YES completion:nil];
}

@end
