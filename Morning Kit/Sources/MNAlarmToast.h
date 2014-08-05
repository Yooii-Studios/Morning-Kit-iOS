//
//  MNAlarmToastMaker.h
//  Morning Kit
//
//  Created by 김우성 on 13. 3. 23..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNAlarmToast : NSObject

+ (void)showAlarmToast:(NSDate *)alarmDate;
+ (void)showAlarmToast:(NSDate *)alarmDate withDelay:(CGFloat)delay;
+ (void)showAlarmToast2:(NSDate *)alarmDate;

@end
