//
//  MNWidgetModalViewFactory.h
//  Morning Kit
//
//  Created by Yong Bin Bae on 13. 3. 31..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MNWidgetModalView;

@interface MNWidgetModalViewFactory : NSObject

+ (MNWidgetModalView *)getWidgetModalView:(NSDictionary *)dict;

@end
