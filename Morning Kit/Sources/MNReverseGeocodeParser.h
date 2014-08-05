//
//  MNReverseGeocodeParser.h
//  Morning Kit
//
//  Created by 김우성 on 13. 6. 20..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNReverseGeocodeParser : NSObject

+ (NSString *)getCityNameFromLatitude:(CGFloat)latitude withLongitude:(CGFloat)longitude;
+ (NSString *)getCityNameFromLatitude:(CGFloat)latitude withLongitude:(CGFloat)longitude withLanguage:(NSString *)languageCode;

@end
