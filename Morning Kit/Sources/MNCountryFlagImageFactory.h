//
//  MNCountryFlagImageFactory.h
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 4. 29..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNCountryFlagImageFactory : NSObject

+ (UIImage*) getImage:(NSString*)_countryCode bwImage:(BOOL) _bwImage;
+ (UIImage*) getImage:(NSString*) _countryCode;

@end
