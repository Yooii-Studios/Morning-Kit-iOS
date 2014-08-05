//
//  MNAlarmSongValidator.h
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 14..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNAlarmSong.h"

// 기존 선택한 노래가 iPod 라이브러리에 여전히 존재하는지 체크하는 클래스
@interface MNAlarmSongValidator : NSObject

+ (BOOL)isAlarmSongValidate:(MNAlarmSong *)alarmSong;

@end
