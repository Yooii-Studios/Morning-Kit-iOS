//
//  MNWorldWeatherOnlineParser.h
//  Morning Kit
//
//  Created by 김우성 on 13. 6. 17..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNWeatherData.h"
#import "MNWeatherSetting.h"

@interface MNWorldWeatherOnlineParser : NSObject

// 현재 위치 파서 새 구현
+ (MNWeatherData *)getWeatherDataFromWorldWeatherOnlineWithLocation:(MNLocationInfo *)locationInfo withTemperatureUnit:(enum MNWeatherTemperatureUnit)tempUnit;

// 도시 선택에서 날씨만 가져올 때 쓰는 메서드
+ (MNWeatherData *)getOnlyWeatherDataFromWorldWeatherOnlineWithLocation:(MNLocationInfo *)locationInfo withTemperatureUnit:(enum MNWeatherTemperatureUnit)tempUnit;
    
@end
