//
//  MNWidgetModalControllerFactory.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 5. 3..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import "MNWidgetModalController.h"

@interface MNWidgetModalControllerFactory : NSObject

+ (MNWidgetModalController *)getModalControllerWithDictionary:(NSMutableDictionary *)dict;

@end
