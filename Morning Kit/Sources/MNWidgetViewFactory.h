//
//  MNWidgetViewFactory.h
//  Morning Kit
//
//  Created by Yong Bin Bae on 13. 1. 5..
//  Copyright (c) 2013년 Yooii. All rights reserved.
//
#pragma once

#import <Foundation/Foundation.h>
#import "MNWidgetSlotView.h"
#import "MNWidgetSuperSlotView.h"

// 0 0 156 94
// 159 0 155 94
// 0 97 156 94
// 159 97 156 94

@interface MNWidgetViewFactory : NSObject

//+ (MNWidgetSlotView *) getWidgetView:(NSMutableDictionary *)dict withPos:(NSInteger)_pos;
+ (MNWidgetSuperSlotView *) getWidgetSuperSlotView:(NSMutableDictionary *)dict withPos:(NSInteger)_pos;

//+ (MNWidgetSlotView*) getWidgetViewWithWidgetCover:(NSMutableDictionary *)dict withPos:(NSInteger)_pos;

@end