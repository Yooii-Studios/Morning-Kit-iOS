//
//  MNWidgetIconLoader.h
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 7. 3..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

// 동적으로 해당하는 아트를 반환
@interface MNWidgetIconLoader : NSObject

+ (UIImage *)getWidgetIconWithIndex:(NSInteger)index;
+ (UIImage *)makeConvertedImage:(UIImage *)image;

@end
