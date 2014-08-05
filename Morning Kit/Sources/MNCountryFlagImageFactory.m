//
//  MNCountryFlagImageFactory.m
//  Morning Kit
//
//  Created by Yong Sub Kwak on 13. 4. 29..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNCountryFlagImageFactory.h"

@implementation MNCountryFlagImageFactory


+ (UIImage*) getImage:(NSString*) _countryCode
{
    return [self getImage:_countryCode bwImage:NO];
}

+ (UIImage*) getImage:(NSString*)_countryCode bwImage:(BOOL)_bwImage
{
    UIImage* image = NULL;
    
    NSString* imageFileSrc = @"flag_";
    
    imageFileSrc = [imageFileSrc stringByAppendingString:[_countryCode lowercaseString]];
    
    if( _bwImage )
        imageFileSrc = [imageFileSrc stringByAppendingString:@"_bw"];
    
    imageFileSrc = [imageFileSrc stringByAppendingString:@".gif\0"];
    
    image = [UIImage imageNamed:imageFileSrc];
    
    return image;
}


@end
