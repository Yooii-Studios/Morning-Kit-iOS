//
//  MNWeatherParser.h
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 5. 4..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNWeatherData.h"
#import "MNWeatherSetting.h"

//@class MNWidgetWeatherView;

@interface MNWeatherParser : NSObject

+ (MNWeatherData*) parseWithLocation : (MNLocationInfo*) _location OfTemperatureUnit : (enum MNWeatherTemperatureUnit) _tempUnit;

@end
