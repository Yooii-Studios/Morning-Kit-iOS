//
//  MNCalendarEventLoader.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 9. 28..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNCalendarEvent.h"

@protocol MNCalendarEventDelegate <NSObject>

//- (void)requestGranted:(NSMutableArray *)events;
- (void)requestGrantedWithTodayEvents:(NSMutableArray *)todayEvents withTomorrowEvents:(NSMutableArray *)tomorrowEvents;

@end

@interface MNCalendarEventLoader : NSObject

#define WIDGETKEY_SHOW_BIRTHDAY @"show_birthday"
#define WIDGETKEY_SHOW_SCHEDULE @"show_schedule"

#define SHARED_WIDGETKEY_SHOW_BIRTHDAY @"shared_show_birthday"
#define SHARED_WIDGETKEY_SHOW_SCHEDULE @"shared_show_schedule"

- (void)loadEvents;

@property (strong, nonatomic) NSMutableArray *todayEvents;
@property (strong, nonatomic) NSMutableArray *tomorrowEvents;
@property (strong, nonatomic) id<MNCalendarEventDelegate> delegate;

@end
