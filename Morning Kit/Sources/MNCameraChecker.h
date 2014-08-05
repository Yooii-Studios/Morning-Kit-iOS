//
//  MNCameraChecker.h
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 8. 14..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNCameraChecker : NSObject

+ (BOOL)isDeviceHasFrontCamera;
+ (BOOL)isDeviceHasBackCamera;

@end
