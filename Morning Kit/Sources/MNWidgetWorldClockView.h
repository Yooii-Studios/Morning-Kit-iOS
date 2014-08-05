//
//  MNWidgetWorldClockView.h
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNWidgetView.h"
#import "ClockView.h"
#import "MNWorldClockData.h"
#import "SKInnerShadowLayer.h"
#import "MNTimeZone.h"

@interface MNWidgetWorldClockView : MNWidgetView<ClockViewDelegate>

@property (strong, nonatomic) ClockView *clockView;
@property (strong, nonatomic) IBOutlet UIImageView *clockBaseImageView;

@property (strong, nonatomic) IBOutlet UIView *superViewOfAMPM;
@property (strong, nonatomic) IBOutlet UILabel *ampmLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayDifferenceLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityNameLabel;
//@property (strong, nonatomic) IBOutlet UIPageControl *dayDifferencePageControl;
@property (strong, nonatomic) SKInnerShadowLayer *innerShadowLayer;

// 이전 데이터
//@property (strong, nonatomic) MNWorldClockData *worldClockData;
// 수정된 데이터
@property (strong, nonatomic) MNTimeZone *selectedTimeZone;

@property (nonatomic) NSInteger clockType;

//@property (nonatomic) CGRect dayDifferenceLabelFrame;
//@property (nonatomic) CGRect cityNameLabelFrame;

@property (nonatomic) NSInteger dayDifferneceLabelOffsetY;
@property (nonatomic) NSInteger cityNameLabelOffsetY;

@end
