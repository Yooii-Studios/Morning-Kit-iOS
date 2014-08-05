//
//  MNWidgetNameMaker.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 9. 4..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetNameMaker.h"
#import "MNDefinitions.h"

@implementation MNWidgetNameMaker

+ (NSString *)getWidgetNameWithType:(NSInteger)type {
    switch (type) {
        case WEATHER:
            return MNLocalizedString(@"weather", "날씨");
            
        case CALENDAR:
            return MNLocalizedString(@"calendar", "달력");
            
        case DATE_COUNTDOWN:
            return MNLocalizedString(@"date_calculator", "날짜계산");
            
        case WORLDCLOCK:
            return MNLocalizedString(@"world_clock", "세계시간");
            
        case QUOTES:
            return MNLocalizedString(@"saying", "명언");
            
        case FLICKR:
            return MNLocalizedString(@"flickr", "플리커");
            
        case MEMO:
            return MNLocalizedString(@"memo", "메모");
            
        case EXCHANGE_RATE:
            return MNLocalizedString(@"exchange_rate", "환율");
            
        default:
            return nil;
    }
}

@end
