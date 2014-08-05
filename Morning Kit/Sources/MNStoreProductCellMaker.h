//
//  MNStoreProductCellMaker.h
//  MNStoreControllerProj
//
//  Created by Wooseong Kim on 13. 7. 9..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MNStoreController;

@interface MNStoreProductCellMaker : NSObject

+ (void)initProductCell:(UICollectionViewCell *)productCell withTabIndex:(NSInteger)tabIndex withRow:(NSInteger)row withStoreController:(MNStoreController *)controller;

@end
