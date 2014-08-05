//
//  MNPortraitNavigationController.m
//  Morning Kit
//
//  Created by 김우성 on 13. 6. 18..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNPortraitNavigationController.h"

@implementation MNPortraitNavigationController

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationPortrait;
    }else{
        if(self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            return UIInterfaceOrientationPortraitUpsideDown;
        }
        return UIInterfaceOrientationPortrait;
    }
}

// Tell the system what we support
-(NSUInteger)supportedInterfaceOrientations
{
//    return UIInterfaceOrientationMaskAll;
    
    // return UIInterfaceOrientationMaskLandscapeRight;
    //    return UIInterfaceOrientationMaskAll;
    //    if (self.interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) {
    //        [self adjustButtonViewOnOrientation:self.interfaceOrientation];
    //    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
    }
}

@end
