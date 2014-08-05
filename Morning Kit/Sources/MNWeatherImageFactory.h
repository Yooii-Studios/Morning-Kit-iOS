//
//  MNWeatherImageFactory.h
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 4. 25..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNWeatherData.h"

@interface MNWeatherImageFactory : NSObject

+ (UIImage*) getImage:(enum MNWeatherCondition) _condition;
+ (UIImage*) getWWOImage:(enum MNWWOWeatherCondition) _condition;

@end
