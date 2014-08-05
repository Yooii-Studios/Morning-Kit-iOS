//
//  MNWeatherSetting.h
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 4. 25..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNLocationInfo.h"

typedef NS_ENUM(NSInteger, MNWeatherTemperatureUnit) {
    eWTU_Celcius = 0,
    eWTU_Fahrenheit = 1
};

@interface MNWeatherSetting : NSObject < NSCoding >

@property (nonatomic) MNWeatherTemperatureUnit temperatureUnit;
@property BOOL useCurrentLocation;
@property BOOL displayLocalTime;


@end

