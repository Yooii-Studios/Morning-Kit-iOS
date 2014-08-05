//
//  MNAlarmMessageMaker.h
//  Morning Kit
//
//  Created by 김우성 on 13. 6. 27..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNAlarmMessageMaker : NSObject

+ (NSString *)makeAlarmMessageWithDate:(NSDate *)targetDate withLabel:(NSString *)label;

@end
