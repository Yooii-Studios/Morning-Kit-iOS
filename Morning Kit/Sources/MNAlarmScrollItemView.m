//
//  MNAlarmScrollItemView.m
//  Morning Kit
//
//  Created by 김우성 on 13. 4. 3..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNAlarmScrollItemView.h"
#import "MNDefinitions.h"
#import "MNTheme.h"
#import <QuartzCore/QuartzCore.h>
#import "MNRoundRectedViewMaker.h"
#import "MNEffectSoundPlayer.h"

@implementation MNAlarmScrollItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        // ScrollView
        [self initScrollView];
        self.delegate = self;
        
        // MNAlarmView - tableView에서 해줌
//        [self initAlarmView];
        
        /*
        // SwipeGestureRecognizer
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
        swipeGestureRecognizer.delegate = self;
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.alarmView addGestureRecognizer:swipeGestureRecognizer];
         */
    }
    return self;
}

- (void)initScrollView {
//    NSLog(@"scrollView page changed");
    
    // Color & Others
    self.backgroundColor = [MNTheme getBackwardBackgroundUIColor]; // [UIColor clearColor];
//    self.backgroundColor = [UIColor blueColor];    // 테스트로 흰색
    self.layer.masksToBounds = NO;
    self.multipleTouchEnabled = NO;
    self.delaysContentTouches = NO;
    [self setContentSize:CGSizeMake(ALARM_ITEM_WIDTH * 3, ALARM_SEPERATOR_HEIGHT)];
    
    // 원래대로 돌리고 지우기. 나중에 꺼내쓸때 제대로 된 것을 꺼내기 위함
//    self.tag = 1;
    
    // Frame
    CGRect scrollViewFrame = self.frame;
    // 1번 페이지로 이동
    scrollViewFrame.origin.x = scrollViewFrame.size.width * 1;
    scrollViewFrame.origin.y = 0;
    //    scrollView.frame = scrollViewFrame;   // 이 부분 주석 풀면 제대로 안됨. 이동할 때만 쓰는 건가?
//    NSLog(@"%@", NSStringFromCGRect(scrollViewFrame));
    [self scrollRectToVisible:scrollViewFrame animated:NO];
//    self.currentPage = 1;
    
//    NSLog(@"%d", [[[self superview] superview] superview].tag);
}

- (void)initAlarmView {
    // Grap reference from tag
    self.alarmView = (UIView *)[self viewWithTag:107];
    self.alarmView.multipleTouchEnabled = NO;
    
    // Background Color
    self.alarmView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
//    self.alarmView.backgroundColor = [UIColor whiteColor];
    
    // get Round-Rected View
    [MNRoundRectedViewMaker makeRoundRectedViewFromOriginalView:self.alarmView inSuperView:self isLeftBoundary:YES isTopBoundary:NO isRightBoundary:YES isBottomBoundary:NO];
    
    // TapGestureRecognizer
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [self.alarmView addGestureRecognizer:tapGestureRecognizer];
    
    // adjust frame - 스크롤뷰의 중앙으로 뷰를 정렬해준다.
    CGRect newFrame = self.alarmView.frame;
    newFrame.origin.x = newFrame.origin.x + ALARM_ITEM_WIDTH;
    self.alarmView.frame = newFrame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - Touches

// iOS7에서 생긴 딜레이 때문에
// 해당 로직 touchesShouldBegin:withEvent:inContentView: 로 이동
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesBegan");
    self.alarmView.backgroundColor = [MNTheme getTouchedBackgroundUIColor];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesCancelled");
    
    if (!self.isScrolling) {
        self.alarmView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesEnded");

    self.alarmView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    
    /*
     기존 로직은 이 로직이었는데, 한 셀에 손가락을 터치한 채로 한 손가락을 더 대면 색이 터치한 채로 남아 있어서 그냥 윗 부분으로 교체했다.
    CGPoint point;
    for (UITouch *touch in touches) {
        point = [touch locationInView:self];
        
        if (CGRectContainsPoint(self.alarmView.frame, point) == NO) {
            NSLog(@"touch outside alarmView");
            self.alarmView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
        }
    }
     */
}

//- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
//    NSLog(@"touchesShouldCancelInContentView");
//    
//    self.alarmView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
//    
//    return YES;
//}

// 테마색 터치로 변경하는데 알람 스위치는 터치하면 안됨.
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
//    NSLog(@"touchesSouldBegin inContentView");
    
    CGPoint point;
    for (UITouch *touch in touches) {
        point = [touch locationInView:self.alarmView];
    }
    
    if (CGRectContainsPoint(self.alarmSwitchButton.layer.frame, point)) {
//        NSLog(@"alarmSwitchButton touch");
        return NO;
    }
//    else{
//        self.alarmView.backgroundColor = [MNTheme getTouchedBackgroundUIColor];
//    }
    
//    NSLog(@"alarmSwitchButton not touched");
//    self.alarmView.backgroundColor = [MNTheme getTouchedBackgroundUIColor];
    return YES;
}

#pragma mark - UIScrollView delegate method

- (void)setScrollViewFrameToDefault:(UIScrollView *)scrollView {
//    NSLog(@"scrollView page changed");
    
    // 원래대로 돌리고 지우기. 나중에 꺼내쓸때 제대로 된 것을 꺼내기 위함
//    self.currentPage = 1;
    scrollView.alpha = 0;
    CGRect scrollViewFrame = scrollView.frame;
    // 1번 페이지로 이동
    scrollViewFrame.origin.x = scrollViewFrame.size.width * 1;
    scrollViewFrame.origin.y = 0;
    //    scrollView.frame = scrollViewFrame;   // 이 부분 주석 풀면 제대로 안됨. 이동할 때만 쓰는 건가?
    [scrollView scrollRectToVisible:scrollViewFrame animated:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@"alarmScrollView WillDragging");
    self.isScrolling = YES;
    self.isSwipeSoundTriggered = NO;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"alarmScrollView DidEndDragging");
    self.isScrolling = NO;
    self.alarmView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    NSLog(@"scrollViewDidScroll");
    
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    
//    NSLog(@"%f", fractionalPage);
    
    // 숫자가 완전히 바뀔 때만 페이지가 바뀌었다고 판단해야함
    if(fractionalPage <= 0 || fractionalPage >= 2) {
//        NSLog(@"page changed");
        [self setScrollViewFrameToDefault:scrollView];
//        self.currentPage = 1;
        // delegate(MainController)에서 삭제요구 - 다시 스크롤 가능하게 변경해줌
        if (self.MNDelegate != nil) {
//            [self.MNDelegate alarmItemHadSwipedToBeRemoved:[[self superview] superview].tag];
//            NSLog(@"%@", self.alarm);
//            NSLog(@"%d", self.alarm.alarmID);
            [self.MNDelegate alarmItemHadSwipedToBeRemovedWithAlarmID:self.alarm.alarmID];
            self.MNDelegate = nil;
        }
    }
    
    // 페이지 변경 체크
    NSInteger pageWillBeScrolled = lround(fractionalPage);
    // 스크롤될 페이지가 알람 페이지가 아니라면,
    if (pageWillBeScrolled != 1) {
        /* Page did change */
        if (self.isScrolling == NO && self.isSwipeSoundTriggered == NO) {
            self.isSwipeSoundTriggered = YES;
            [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_ALARM_SWIPE_REMOVE];
        }
    }
}


#pragma mark - gestureRecognizer delegate methods

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
//    NSLog(@"handleTapGesture");
    
    NSInteger index = self.superview.superview.tag;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        index = self.superview.superview.superview.tag;
    }
    
//    NSLog(@"%@", self.superview);
//    NSLog(@"%@", self.superview.superview);
//    NSLog(@"%@", self.superview.superview.superview);
//    NSLog(@"%d", self.superview.superview.superview.tag);
    
    self.alarmView.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    [self.MNDelegate alarmItemClickedToPresentAlarmPreferenceModalController:index];
}

// iOS 5 전용. 6 이하에서는 gestureRecognizer가 touch event 를 막는다. 
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self];
    
    // 알람 뷰가 2페이지에 있기 때문에 그만큼 빼 주어야 함
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    point.x -= screenBounds.size.width;
    
    if (CGRectContainsPoint(self.alarmSwitchButton.layer.frame, point)) {
//        NSLog(@"gestureShould Not Begin");
        return NO;
    }
//    NSLog(@"gestureShouldBegin");
    return YES;
}

@end
