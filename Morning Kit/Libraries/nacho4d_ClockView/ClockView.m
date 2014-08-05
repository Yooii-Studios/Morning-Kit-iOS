//
//  ClockView.m
//  clock
//
//  Created by Ignacio Enriquez Gutierrez on 1/31/11.
//  Copyright 2011 Nacho4D. All rights reserved.
//  See the file License.txt for copying permission.
//

#import "ClockView.h"
#import "MNDefinitions.h"
#import "MNTheme.h"
#import "MNAlarmDateFormat.h"


@implementation ClockView

#pragma mark - Public Methods

#define ANCHOR_SECHAND ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 0.08509 : 0.14)

// 시분초는 기본으로 포함되어야 하고, 가능하면 년원일도 포함되면 좋다

- (void)startWithOffset:(NSInteger)offsetHour {
    self.offsetHour = offsetHour;
    [self updateClock:nil];
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateClock:) userInfo:nil repeats:YES];
}

- (void)startWithHourOffset:(NSInteger)hourOffset withMinuteOffset:(NSInteger)minuteOffset {
    self.hourOffset = hourOffset;
    self.minuteOffset = minuteOffset;
    [self updateClock:nil];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateClock:) userInfo:nil repeats:YES];
}

- (void)stop
{
	[timer invalidate];
	timer = nil;
}

//customize appearence
- (void)setHourHandImage:(CGImageRef)image
{
	if (image == NULL) {
		hourHand.backgroundColor = [UIColor blackColor].CGColor;
		hourHand.cornerRadius = 3;
	}else{
		hourHand.backgroundColor = [UIColor clearColor].CGColor;
		hourHand.cornerRadius = 0.0;
		
	}
	hourHand.contents = (__bridge id)image;
}

- (void)setMinHandImage:(CGImageRef)image
{
	if (image == NULL) {
		minHand.backgroundColor = [UIColor grayColor].CGColor;
	}else{
		minHand.backgroundColor = [UIColor clearColor].CGColor;
	}
	minHand.contents = (__bridge id)image;
}

- (void)setSecHandImage:(CGImageRef)image
{
	if (image == NULL) {
		secHand.backgroundColor = [UIColor whiteColor].CGColor;
		secHand.borderWidth = 1.0;
		secHand.borderColor = [UIColor grayColor].CGColor;
	}else{
		secHand.backgroundColor = [UIColor clearColor].CGColor;
		secHand.borderWidth = 0.0;
		secHand.borderColor = [UIColor clearColor].CGColor;
	}
	secHand.contents = (__bridge id)image;
}

- (void)setClockBackgroundImage:(CGImageRef)image
{
	if (image == NULL) {
		containerLayer.borderColor = [UIColor blackColor].CGColor;
		containerLayer.borderWidth = 1.0;
		containerLayer.cornerRadius = 5.0;
	}else{
		containerLayer.borderColor = [UIColor clearColor].CGColor;
		containerLayer.borderWidth = 0.0;
		containerLayer.cornerRadius = 0.0;
	}
	containerLayer.contents = (__bridge id)image;
}

#pragma mark - Private Methods

//Default sizes of hands:
//in percentage (0.0 - 1.0)
#define HOURS_HAND_LENGTH 0.66
#define MIN_HAND_LENGTH 0.75
#define SEC_HAND_LENGTH 0.8
//in pixels
#define HOURS_HAND_WIDTH 3
#define MIN_HAND_WIDTH 3
#define SEC_HAND_WIDTH 3

float Degrees2Radians(float degrees) { return degrees * M_PI / 180; }

//timer callback
- (void) updateClock:(NSTimer *)theTimer{
    
    // GMT에서 세계 시간으로 변환
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSTimeInterval timeZoneOffset = self.offsetHour * 60 * 60;
    // 수정: hour 과 minute를 동시에 적용
    NSTimeInterval timeZoneOffset = (self.hourOffset * 60 * 60) + (self.minuteOffset * 60);
    NSTimeInterval GMTInterval = [[NSTimeZone localTimeZone] secondsFromGMTForDate:[NSDate date]];
    // GMT date 를 구해서, timeZone의 offset 만큼 더해서 세계 시간을 구함
    NSDate *calculatedDate = [[NSDate date] dateByAddingTimeInterval:(-1*GMTInterval + timeZoneOffset)];
    
    NSDateComponents *dateComponents = [gregorianCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:calculatedDate];
    
	NSInteger seconds = [dateComponents second];
	NSInteger minutes = [dateComponents minute];
	NSInteger hours = [dateComponents hour];
    
    self.clockDateComponents = dateComponents;
    
    // check am/pm
    [self checkAMPM];
    
    // check day difference
    [self checkDayDifference];
    
    // check background
    [self checkBackground];
    
	//NSLog(@"raw: hours:%d min:%d secs:%d", hours, minutes, seconds);
	if (hours > 12) {
        hours -=12; //PM
    }
    
    if (self.clockType == WORLD_CLOCK_TYPE_ANALOG) {
        containerLayer.opacity = 1;
        self.digitalClockLabel.alpha = 0;

        //set angles for each of the hands
        CGFloat tempSecAngle = Degrees2Radians((seconds+0.3)/60.0*360); // 우성: 초침이 약간 흔들리는 효과를 줌.
        CGFloat secAngle = Degrees2Radians(seconds/60.0*360);
        CGFloat minAngle = Degrees2Radians(minutes/60.0*360);
        CGFloat hourAngle = Degrees2Radians(hours/12.0*360) + minAngle/12.0;
        
        //reflect the rotations + 180 degres since CALayers coordinate system is inverted
        secHand.transform = CATransform3DMakeRotation (secAngle+M_PI, 0, 0, 1);
        minHand.transform = CATransform3DMakeRotation (minAngle+M_PI, 0, 0, 1);
        hourHand.transform = CATransform3DMakeRotation (hourAngle+M_PI, 0, 0, 1);
        
        // made by Wooseong Kim - 초침을 좀더 다이내믹하게 움직이고 싶다.
        CATransform3D secHandTransform = CATransform3DMakeRotation (tempSecAngle+M_PI, 0, 0, 1);
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        transformAnimation.duration = 0.1;
        transformAnimation.removedOnCompletion = YES;
        transformAnimation.toValue = [NSValue valueWithCATransform3D:secHandTransform];
        [secHand addAnimation:transformAnimation forKey:@"transformAnimation"];
        [CATransaction commit];

    }else{
        containerLayer.opacity = 0;
        self.digitalClockLabel.alpha = 1;
        
        MNAlarmDateFormat *clockDateFormat = [MNAlarmDateFormat alarmDateFormatWithDate:calculatedDate];
        
        // 시간 조립하기
        self.digitalClockLabel.textColor = [MNTheme getMainFontUIColor];
        self.digitalClockLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:self.digitalFontSize];
        NSString *timeString;
        NSMutableAttributedString *attributedString;
        if (self.isUsing24Hours) {
            if (clockDateFormat.hour < 10) {
                timeString = [NSString stringWithFormat:@"0%d:%@", clockDateFormat.hour, clockDateFormat.minuteString];
            }else{
                timeString = [NSString stringWithFormat:@"%d:%@", clockDateFormat.hour, clockDateFormat.minuteString];
            }
            self.digitalClockLabel.text = timeString;
        }else{
            NSString *ampmString = nil;
            if (clockDateFormat.hourForString < 10) {
                timeString = [NSString stringWithFormat:@"0%d:%@", clockDateFormat.hourForString, clockDateFormat.minuteString];
            }else{
                timeString = [NSString stringWithFormat:@"%d:%@", clockDateFormat.hourForString, clockDateFormat.minuteString];
            }
            if (self.clockDateComponents.hour >= 12) {
                ampmString = @" PM";
            }else{
                ampmString = @" AM";
            }
            timeString = [timeString stringByAppendingString:ampmString];
            self.digitalClockLabel.text = timeString;
            
            // AM/PM 사이즈 조절
            attributedString = [self.digitalClockLabel.attributedText mutableCopy];
            
            // 0 없애주기
            if (clockDateFormat.hourForString < 10) {
                NSRange zero_range;
                zero_range.location = 0;
                zero_range.length = 1;
                [attributedString setTextColor:[UIColor clearColor] range:zero_range];
            }
            
            NSRange ampmRange = [timeString rangeOfString:ampmString];
            [attributedString setFont:[UIFont fontWithName:@"Helvetica-Bold" size:self.digitalAMPMFontSize] range:ampmRange];
//            [attributedString setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15] range:NSMakeRange(attributedString.length-3, 3)];
            self.digitalClockLabel.attributedText = attributedString;
        }
        
        // 콤마 조절하기
        attributedString = [self.digitalClockLabel.attributedText mutableCopy];
        NSRange commaRange = [timeString rangeOfString:@":"];
        if (self.isCommaShown) {
            [attributedString setTextColor:[MNTheme getMainFontUIColor] range:commaRange];
            self.isCommaShown = NO;
        }else{
            [attributedString setTextColor:[UIColor clearColor] range:commaRange];
            self.isCommaShown = YES;
        }
        
        // 중앙 정렬 구현해보기
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
//        paragraphStyle.lineSpacing = 10;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:commaRange];
        
        self.digitalClockLabel.attributedText = attributedString;
//        NSLog(@"%@", NSStringFromRange(commaRange));
    }
}

#pragma mark - check ampm/day difference
- (void)checkDayDifference {
    // 현지 local 시간을 구함
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *localDateComponents = [gregorianCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    localDateComponents.second = 0;
    
    // local 과 clock의 비교
    // 년 비교
    if (self.clockDateComponents.year > localDateComponents.year) {
        [self.MNDelegate shouldChangeDayDifferenceTo:MNDayDifferenceTomorrow];
    }else if(self.clockDateComponents.year < localDateComponents.year) {
        [self.MNDelegate shouldChangeDayDifferenceTo:MNDayDifferenceYesterDay];
    }else{
        // 월 비교
        if (self.clockDateComponents.month > localDateComponents.month) {
            [self.MNDelegate shouldChangeDayDifferenceTo:MNDayDifferenceTomorrow];
        }else if(self.clockDateComponents.month < localDateComponents.month) {
            [self.MNDelegate shouldChangeDayDifferenceTo:MNDayDifferenceYesterDay];
        }else{
            // 일 비교
            if (self.clockDateComponents.day > localDateComponents.day) {
                [self.MNDelegate shouldChangeDayDifferenceTo:MNDayDifferenceTomorrow];
            }else if(self.clockDateComponents.day < localDateComponents.day) {
                [self.MNDelegate shouldChangeDayDifferenceTo:MNDayDifferenceYesterDay];
            }else{
                [self.MNDelegate shouldChangeDayDifferenceTo:MNDayDifferenceToday];
            }
        }
    }
}

- (void)checkAMPM {
    
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.clockDateComponents.hour >= 12) {
            [self.MNDelegate shouldChangeLabelTo:MNTimeStatePM];
        }else{
            [self.MNDelegate shouldChangeLabelTo:MNTimeStateAM];
        }
    });
    */
    
    if (self.clockDateComponents.hour >= 12) {
        [self.MNDelegate shouldChangeLabelTo:MNTimeStatePM];
    }else{
        [self.MNDelegate shouldChangeLabelTo:MNTimeStateAM];
    }
}

- (void)checkBackground {
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        // 낡이 밝을 경우 AM 이미지, 어두워질 경우 PM 이미지
        if (self.clockDateComponents.hour >= 6 && self.clockDateComponents.hour < 18) {
            [self.MNDelegate shouldChangeBackgroundTo:MNTimeStateAM];
        }else{
            [self.MNDelegate shouldChangeBackgroundTo:MNTimeStatePM];
        }
    });
    */
    
    // 낡이 밝은 시간일 경우 AM 이미지, 어두워질 경우 PM 이미지
    if (self.clockDateComponents.hour >= 6 && self.clockDateComponents.hour < 18) {
        [self.MNDelegate shouldChangeBackgroundTo:MNTimeStateAM];
    }else{
        [self.MNDelegate shouldChangeBackgroundTo:MNTimeStatePM];
    }
}

#pragma mark - Overrides

- (void) layoutSubviews
{
	[super layoutSubviews];

	containerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

	float length = MIN(self.frame.size.width, self.frame.size.height)/2;
    CGPoint c = CGPointMake(length, length);
	hourHand.position = minHand.position = secHand.position = c;

	CGFloat w, h;
	CGFloat scale = 1;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if ((orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight))
        {
            scale = 0.75;
        }
    }
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale *= [UIScreen mainScreen].scale;
    }
	
	if (hourHand.contents == NULL){
		w = HOURS_HAND_WIDTH;
		h = length*HOURS_HAND_LENGTH;
	}else{
		w = CGImageGetWidth((__bridge CGImageRef)hourHand.contents)/scale;
		h = CGImageGetHeight((__bridge CGImageRef)hourHand.contents)/scale;
	}
	hourHand.bounds = CGRectMake(0,0,w,h);
	
	if (minHand.contents == NULL){
		w = MIN_HAND_WIDTH;
		h = length*MIN_HAND_LENGTH;
	}else{
		w = CGImageGetWidth((__bridge CGImageRef)minHand.contents)/scale;
		h = CGImageGetHeight((__bridge CGImageRef)minHand.contents)/scale;
	}
	minHand.bounds = CGRectMake(0,0,w,h);
	
	if (secHand.contents == NULL){
		w = SEC_HAND_WIDTH;
		h = length*SEC_HAND_LENGTH;
	}else{
		w = CGImageGetWidth((__bridge CGImageRef)secHand.contents)/scale;
		h = CGImageGetHeight((__bridge CGImageRef)secHand.contents)/scale;
	}
    secHand.bounds = CGRectMake(0,0,w,h);

	hourHand.anchorPoint = CGPointMake(0.5,0.2);
	minHand.anchorPoint = CGPointMake(0.5,0.15);
	secHand.anchorPoint = CGPointMake(0.5, ANCHOR_SECHAND);
	containerLayer.anchorPoint = CGPointMake(0.5, 0.5);
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		
		containerLayer = [CALayer layer];
		minHand = [CALayer layer];
		secHand = [CALayer layer];
		hourHand = [CALayer layer];

		//default appearance
		[self setClockBackgroundImage:NULL];
		[self setHourHandImage:NULL];
		[self setMinHandImage:NULL];
		[self setSecHandImage:NULL];
		
		//add all created sublayers
		[containerLayer addSublayer:secHand];
		[containerLayer addSublayer:minHand];
		[containerLayer addSublayer:hourHand];
		[self.layer addSublayer:containerLayer];
        
        // frame.size.height/9 는 적당히 비율을 맞춘 것
        self.digitalClockLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(-frame.size.width, frame.size.height/9, frame.size.width*3, frame.size.height)];
        self.digitalClockLabel.backgroundColor = [UIColor clearColor];
//        self.digitalClockLabel.text = @"12:31";
        self.digitalClockLabel.textAlignment = NSTextAlignmentCenter;
        self.digitalClockLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:37.0];
//        self.digitalClockLabel.font = [UIFont boldSystemFontOfSize:37]; // 헬베티카 볼드가 : 위치가 제대로 맞지 않음.
        self.digitalClockLabel.textColor = [MNTheme getMainFontUIColor];
        self.isCommaShown = NO;
        [self addSubview:self.digitalClockLabel];
	}
    
	return self;
}

- (void)removeFromSuperview
{
	[self stop];
	[super removeFromSuperview];
}

- (void)dealloc
{
	[self stop];
}

@end