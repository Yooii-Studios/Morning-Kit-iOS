//
//  MNUnlockManager.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 7. 10..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNUnlockManager.h"
#import "MNPortraitNavigationController.h"
#import "MNUnlockController.h"
#import "MNDefinitions.h"
#import "MNEffectSoundPlayer.h"

@implementation MNUnlockManager

+ (void)showUnlockControllerWithProductID:(NSString *)productID withController:(UIViewController *)controller {
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"IAPStoryboard" bundle:[NSBundle mainBundle]];
    }else{
        storyboard = [UIStoryboard storyboardWithName:@"IAPStoryboard_iPad" bundle:[NSBundle mainBundle]];
    }
    
    MNPortraitNavigationController *portraitNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"Nav_MNUnlockController"];
    
    MNUnlockController *unlockController = (MNUnlockController *)portraitNavigationController.topViewController;
    unlockController.productID = productID;
    
//    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK];
    [controller presentViewController:portraitNavigationController animated:YES completion:nil];
}

@end
