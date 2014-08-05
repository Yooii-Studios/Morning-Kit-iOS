//
//  MNWidgetMatrixLoadSaver.m
//  Morning Kit
//
//  Created by Yong Bin Bae on 13. 3. 14..
//  Copyright (c) 2013년 Yooii. All rights reserved.
//

#import "MNWidgetMatrixLoadSaver.h"
#import "MNWidgetMatrix.h"

@implementation MNWidgetMatrixLoadSaver

+ (NSMutableArray *)loadWidgetMatrix
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSObject *matrixObject = [defaults objectForKey:@"WidgetDictionaryArray"];
    NSMutableArray *matrix;
    if (matrixObject == nil) {
        matrix = [NSMutableArray array];
    }else{
        matrix = [[defaults mutableArrayValueForKey:@"WidgetDictionaryArray"] mutableCopy];
    }
    
    if (matrix.count == 0) {
        matrix = [NSMutableArray array];

        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
        NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
        
        [dict1 setObject:[NSNumber numberWithInt:WEATHER] forKey:@"Type"];
        [dict2 setObject:[NSNumber numberWithInt:CALENDAR] forKey:@"Type"];
        [dict3 setObject:[NSNumber numberWithInt:WORLDCLOCK] forKey:@"Type"];
        // 기획 변경: 최초 일정 관리 위젯을 보여 주되, 로드 후 일정이 없을 경우에 다시 명언 위젯으로 교체를 해 주자.
        // 취소
//        [dict4 setObject:[NSNumber numberWithInt:REMINDER] forKey:@"Type"];
        [dict4 setObject:[NSNumber numberWithInt:QUOTES] forKey:@"Type"];
        
        [matrix addObject:dict1];
        [matrix addObject:dict2];
        [matrix addObject:dict3];
        [matrix addObject:dict4];
        
        [MNWidgetMatrix setMatrixType:MNWidgetMatrixType2x2];
    }else{
//        NSLog(@"matrix exist");
        
        NSMutableDictionary *dict[4];
        
        for (int i=0; i<4; i++) {
            dict[i] = [[matrix objectAtIndex:i] mutableCopy];
            [matrix replaceObjectAtIndex:i withObject:dict[i]];
        }
    }
    
    [self saveWidgetMatrix:matrix];
    
    return matrix;
}

+ (void)saveWidgetMatrix:(NSMutableArray *)matrix
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:matrix forKeyPath:@"WidgetDictionaryArray"];
    [defaults synchronize];
}

@end
