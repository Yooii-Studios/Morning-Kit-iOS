//
//  MNWidgetCalendarView.h
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//
#pragma once

#import "MNWidgetView.h"

@interface MNWidgetCalendarView : MNWidgetView

@property (strong, nonatomic) IBOutlet UILabel *label_Month;
@property (strong, nonatomic) IBOutlet UILabel *label_Day;
@property (strong, nonatomic) IBOutlet UILabel *label_DayOfWeek;
@property (strong, nonatomic) IBOutlet UILabel *label_Lunar_Day;
@property (strong, nonatomic) IBOutlet UILabel *label_Lunar_DayOfWeek;
@property (strong, nonatomic) IBOutlet UILabel *label_Lunar_Month;

@property (nonatomic) BOOL isLunarCalendarOn;
@property (strong, nonatomic) NSTimer *widgetCalendarTimer;

@end
