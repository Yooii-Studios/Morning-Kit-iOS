//
//  MNWidgetMatrix.m
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 13..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetMatrix.h"
#import "MNDefinitions.h"

@implementation MNWidgetMatrix

+ (NSString *)getMatrixStringFromIndex:(NSInteger)matrixIndex {
    
    switch (matrixIndex) {
        case MNWidgetMatrixType2x1:
            return @"2 X 1";
            
        case MNWidgetMatrixType2x2:
            return @"2 X 2";
    }
    return nil;
}

+ (MNWidgetMatrixType)getCurrentMatrixType {
    
    int type = [[NSUserDefaults standardUserDefaults] integerForKey:WIDGET_MATRIX];
    
    return type;
}

+ (void)setMatrixType:(MNWidgetMatrixType)matrixType {    
    [[NSUserDefaults standardUserDefaults] setInteger:matrixType forKey:WIDGET_MATRIX];
}

@end
