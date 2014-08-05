//
//  MNWidgetMatrixLoadSaver.h
//  Morning Kit
//
//  Created by Yong Bin Bae on 13. 3. 14..
//  Copyright (c) 2013년 Yooii. All rights reserved.
//
#pragma once

#import <Foundation/Foundation.h>
#import "MNDefinitions.h"

@interface MNWidgetMatrixLoadSaver : NSObject
{
    NSUserDefaults *defaults;
}

+ (NSMutableArray *) loadWidgetMatrix;
+ (void) saveWidgetMatrix:(NSMutableArray *)matrix;

@end
