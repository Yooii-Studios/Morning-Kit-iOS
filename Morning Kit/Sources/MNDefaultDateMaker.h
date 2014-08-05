//
//  MNDefaultDateMaker.h
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 7. 3..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNDefaultDateMaker : NSObject

// 오늘 날짜를 얻어서, 내년 1월 1일로 설정해준다.
+ (NSDate *)getDefaultDate;

@end
