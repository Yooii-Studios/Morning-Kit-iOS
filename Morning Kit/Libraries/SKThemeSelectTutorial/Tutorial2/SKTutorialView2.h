//
//  SKTutorialView2.h
//  TestPopup
//
//  Created by Wooseong Kim on 13. 7. 6..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SKTutorialView2Delegate <NSObject>

- (void)SKTutorialView2DelegateDoneTutorial;

@end

// 4번 설명을 보여주고 아무데나 클릭하면 뷰가 종료된다
@interface SKTutorialView2 : UIView

@property (strong, nonatomic) id<SKTutorialView2Delegate> SKDelegate;
@property (nonatomic) NSInteger clickCount;

@property (nonatomic) BOOL isAnimating;

@property (nonatomic, strong) IBOutlet UIButton *skipTutorialButton;

@property (nonatomic, strong) IBOutlet UIImageView *tutorial_1_circle1;
@property (nonatomic, strong) IBOutlet UIImageView *tutorial_1_circle2;
@property (nonatomic, strong) IBOutlet UIImageView *tutorial_1_circle3;
@property (nonatomic, strong) IBOutlet UIImageView *tutorial_1_circle4;
@property (nonatomic, strong) IBOutlet UIImageView *tutorial_1_circle1_scale;
@property (nonatomic, strong) IBOutlet UIImageView *tutorial_1_circle2_scale;
@property (nonatomic, strong) IBOutlet UIImageView *tutorial_1_circle3_scale;
@property (nonatomic, strong) IBOutlet UIImageView *tutorial_1_circle4_scale;
@property (nonatomic, strong) IBOutlet UILabel *tutorial_1_label;

@property (nonatomic, strong) IBOutlet UIImageView *tutorial_2_clock;
@property (nonatomic, strong) IBOutlet UIImageView *tutorial_2_circle1;
@property (nonatomic, strong) IBOutlet UIImageView *tutorial_2_circle1_scale;
@property (nonatomic, strong) IBOutlet UILabel *tutorial_2_label;

@property (nonatomic, strong) IBOutlet UIImageView *tutorial_3_circle1;
@property (nonatomic, strong) IBOutlet UIImageView *tutorial_3_circle1_scale;
@property (nonatomic, strong) IBOutlet UILabel *tutorial_3_label;

@property (nonatomic, strong) IBOutlet UIImageView *tutorial_4_circle1;
@property (nonatomic, strong) IBOutlet UIImageView *tutorial_4_circle1_scale;
@property (nonatomic, strong) IBOutlet UILabel *tutorial_4_label;

@property (nonatomic, strong) IBOutlet UIImageView *tutorial_5_circle1;
@property (nonatomic, strong) IBOutlet UIImageView *tutorial_5_circle1_scale;
@property (nonatomic, strong) IBOutlet UILabel *tutorial_5_label;
@property (nonatomic, strong) IBOutlet UIImageView *tutorial_5_refresh;
@property (nonatomic, strong) IBOutlet UIImageView *tutorial_5_setting;

@property (nonatomic, strong) IBOutlet UILabel *tutorial_6_label;

@property (nonatomic, strong) IBOutlet UILabel *tutorial_tap_screen_label;

- (IBAction)skipTutorialButtonClicked:(id)sender;

@end
