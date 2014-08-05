//
//  MNWidgetModalController.h
//  Morning Kit
//
//  Created by Yong Bin Bae on 13. 3. 24..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import "MNWidgetModalView.h"
#import "MNWidgetSelector.h"

@protocol MNWidgetModalViewDelegate <NSObject>

- (void)reloadWidgetIndex:(int)index;
- (void)widgetChangedOnModalView:(int)index;

@end

@interface MNWidgetModalController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *widgetDictionary;
@property (strong, nonatomic) NSMutableDictionary *prevWidgetDictionary;
@property (strong, nonatomic) MNWidgetSelector *selector;
@property (strong, nonatomic) id<MNWidgetModalViewDelegate> delegate;

- (void)initWithDictionary:(NSMutableDictionary *)dict;

- (void)cancelButtonClicked;
- (void)doneButtonClicked;

@end
