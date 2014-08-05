//
//  MNUnlockManager.h
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 7. 10..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNUnlockManager : NSObject

+ (void)showUnlockControllerWithProductID:(NSString *)productID withController:(UIViewController *)controller;

@end
