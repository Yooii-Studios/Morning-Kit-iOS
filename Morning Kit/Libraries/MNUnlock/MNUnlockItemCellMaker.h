//
//  MNUnlockItemCellMaker.h
//  MNStoreControllerProj
//
//  Created by Wooseong Kim on 13. 7. 9..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MNUnlockController;

@interface MNUnlockItemCellMaker : NSObject

+ (void)initUnlockItemCell:(UITableViewCell *)unlockItemCell withRow:(NSInteger)row withUnlockController:(MNUnlockController *)controller;

@end
