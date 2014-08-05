//
//  MNWidgetModalView.h
//  Morning Kit
//
//  Created by Yong Bin Bae on 13. 3. 31..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//
#pragma once

#import <UIKit/UIKit.h>

@interface MNWidgetModalView : UIView

@property (strong, nonatomic) NSMutableDictionary *widgetDictionary;

- (void)initWithDictionary:(NSMutableDictionary *)dict;
- (void)doneSetting;

@end
