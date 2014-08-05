//
//  MNTimeZone.h
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 3..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNWorldClockData : NSObject

@property (strong, nonatomic) NSString *cityName;
@property (strong, nonatomic) NSString *timeZoneName;
@property (strong, nonatomic) NSDate *worldClockDate;
@property (nonatomic) NSInteger timeOffSet;

@end
