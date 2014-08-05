//
//  ClockView.h
//  clock
//
//  Created by Ignacio Enriquez Gutierrez on 1/31/11.
//  Copyright 2011 Nacho4D. All rights reserved.
//  See the file License.txt for copying permission.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OHAttributedLabel/OHAttributedLabel.h>

typedef NS_ENUM(NSInteger, MNTimeState) {
    MNTimeStateAM = 0,
    MNTimeStatePM,
};

typedef NS_ENUM(NSInteger, MNDayDifference) {
    MNDayDifferenceYesterDay = 0,
    MNDayDifferenceToday,
    MNDayDifferenceTomorrow,
};

@protocol ClockViewDelegate <NSObject>

- (void)shouldChangeBackgroundTo:(MNTimeState)ampmState;
- (void)shouldChangeLabelTo:(MNTimeState)ampmState;
- (void)shouldChangeDayDifferenceTo:(MNDayDifference)dayDifference;

@end

@interface ClockView : UIView {

	CALayer *containerLayer;
	CALayer *hourHand;
	CALayer *minHand;
	CALayer *secHand;
	NSTimer *timer;

}

// 우성 추가
@property (nonatomic) NSInteger offsetHour;
@property (nonatomic, strong) id<ClockViewDelegate> MNDelegate;
@property (nonatomic, strong) NSDateComponents *clockDateComponents;

@property (nonatomic) NSInteger hourOffset;
@property (nonatomic) NSInteger minuteOffset;

@property (nonatomic) NSInteger clockType; // Digital, Analog

// for digital
@property (nonatomic, strong) OHAttributedLabel *digitalClockLabel;
@property (nonatomic) BOOL isUsing24Hours;
@property (nonatomic) BOOL isCommaShown;

// 용빈 추가
@property (nonatomic) NSUInteger digitalFontSize;
@property (nonatomic) NSUInteger digitalAMPMFontSize;

//basic methods
- (void)startWithOffset:(NSInteger)offsetHour;
- (void)startWithHourOffset:(NSInteger)hourOffset withMinuteOffset:(NSInteger)minuteOffset;
- (void)stop;

//customize appearence
- (void)setHourHandImage:(CGImageRef)image;
- (void)setMinHandImage:(CGImageRef)image;
- (void)setSecHandImage:(CGImageRef)image;
- (void)setClockBackgroundImage:(CGImageRef)image;



//to customize hands size: adjust following values in .m file
//HOURS_HAND_LENGTH
//MIN_HAND_LENGTH
//SEC_HAND_LENGTH
//HOURS_HAND_WIDTH
//MIN_HAND_WIDTH
//SEC_HAND_WIDTH

@end
