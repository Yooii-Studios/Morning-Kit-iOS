//
//  MNWidgetLoadSaver.h
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 21..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNWidgetView.h"
#import "MNWidgetData.h"

@interface MNWidgetLoadSaver : NSObject

+ (MNWidgetData*) loadWidgets;
+ (void) saveWidgets:(MNWidgetData *)widgets;

@end
