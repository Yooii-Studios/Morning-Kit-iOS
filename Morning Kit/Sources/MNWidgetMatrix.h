//
//  MNWidgetMatrix.h
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 13..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MNWidgetMatrixType) {
    MNWidgetMatrixType2x1 = 1,
    MNWidgetMatrixType2x2 = 2,
};

@interface MNWidgetMatrix : NSObject

+ (NSString *)getMatrixStringFromIndex:(NSInteger)matrixIndex;
+ (MNWidgetMatrixType)getCurrentMatrixType;
+ (void)setMatrixType:(MNWidgetMatrixType)matrixType;

@end
