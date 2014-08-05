//
//  MNTranslucentFont.h
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 7. 2..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MNTranslucentFontType) {
    MNTranslucentFontTypeDefault = 0,
    MNTranslucentFontTypeBlack,
    MNTranslucentFontTypeWhite,
};

@interface MNTranslucentFont : NSObject

+ (MNTranslucentFontType)getCurrentFontType;
+ (void)toggleFontType; // 검은색 -> 흰색, 흰색 -> 검은색으로 변경

@end
