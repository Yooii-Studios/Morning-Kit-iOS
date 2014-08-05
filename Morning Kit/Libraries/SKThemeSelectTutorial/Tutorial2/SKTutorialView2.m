//
//  SKTutorialView2.m
//  TestPopup
//
//  Created by Wooseong Kim on 13. 7. 6..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import "SKTutorialView2.h"
#import "SKTutorialView.h"
#import "UIImage+MNImage.h"
#import <QuartzCore/QuartzCore.h>
#import "MNLanguage.h"

@implementation SKTutorialView2

//#define TUTORIAL_DEBUG 1
#define TUTORIAL_DEBUG 0

#define ANIMATION_TIME (TUTORIAL_DEBUG == 1) ? 0.3f : 0.7f
#define ANIMATION_TIME_1 (TUTORIAL_DEBUG == 1) ? 0.1f : 0.2f // 튜토리얼 1용
#define ANIMATION_TIME_1_Label (TUTORIAL_DEBUG == 1) ? 0.1f : 0.7f // 튜토리얼 1용
#define ANIMATION_FADE_OUT 0.5f
#define ANIMATION_DELAY_TIME 0.3f
#define ANIMATION_CLICK_TIME 0.25f

#define ANIMATION_CIRCLE_SCALE 5

#define TUTORIAL_2_OFFSET_Y 15
#define ANIMATION_TIME_TUTORIAL_2 0.7f
#define ANIMATION_TIME_TUTORIAL_2_DELAY_TIME 0.2f
        
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            self = [[[NSBundle mainBundle] loadNibNamed:@"SKTutorialView2" owner:self options:nil] objectAtIndex:0];
        }else{
            self = [[[NSBundle mainBundle] loadNibNamed:@"SKTutorialView2_iPad" owner:self options:nil] objectAtIndex:0];
        }
        self.frame = frame;
        
        self.clickCount = 0;
        self.isAnimating = NO;
        
//        self.contentLabel.text = @"Information Widget\nYou can change or rearrange it";

        UIImage *grayCircleImage = [self.tutorial_1_circle1_scale.image imageWithOverlayColor:UIColorFromHexCode(0x666666)];
        self.tutorial_1_circle1_scale.alpha = 0;
        self.tutorial_1_circle1.image = grayCircleImage;
        self.tutorial_1_circle2_scale.alpha = 0;
        self.tutorial_1_circle2.image = grayCircleImage;
        self.tutorial_1_circle3_scale.alpha = 0;
        self.tutorial_1_circle3.image = grayCircleImage;
        self.tutorial_1_circle4_scale.alpha = 0;
        self.tutorial_1_circle4.image = grayCircleImage;
        
        self.tutorial_1_label.alpha = 0;
        self.tutorial_1_label.text = MNLocalizedString(@"tutorial1_label1", nil);
        
        self.tutorial_2_clock.alpha = 0;
        self.tutorial_2_circle1.alpha = 0;
        self.tutorial_2_circle1_scale.alpha = 0;
        self.tutorial_2_label.alpha = 0;
        self.tutorial_2_label.text = MNLocalizedString(@"tutorial1_label2", nil);
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                self.tutorial_2_clock.frame = CGRectOffset(self.tutorial_2_clock.frame, 0, 14);
                self.tutorial_2_circle1.frame = CGRectOffset(self.tutorial_2_circle1.frame, 0, 14);
                self.tutorial_2_circle1_scale.frame = CGRectOffset(self.tutorial_2_circle1_scale.frame, 0, 14);
                self.tutorial_2_label.frame = CGRectOffset(self.tutorial_2_label.frame, 0, 14);
            }
        }

        self.tutorial_3_circle1.alpha = 0;
        self.tutorial_3_circle1_scale.alpha = 0;
        self.tutorial_3_label.alpha = 0;
        self.tutorial_3_label.text = MNLocalizedString(@"tutorial1_label3", nil);

        self.tutorial_4_circle1.alpha = 0;
        self.tutorial_4_circle1_scale.alpha = 0;
        self.tutorial_4_circle1.image = grayCircleImage;
        self.tutorial_4_label.alpha = 0;
        self.tutorial_4_label.text = MNLocalizedString(@"tutorial1_label4", nil);

        self.tutorial_5_circle1.alpha = 0;
        self.tutorial_5_circle1_scale.alpha = 0;
        self.tutorial_5_circle1.image = grayCircleImage;
        self.tutorial_5_refresh.alpha = 0;
        self.tutorial_5_setting.alpha = 0;
        self.tutorial_5_label.alpha = 0;
        self.tutorial_5_label.text = MNLocalizedString(@"tutorial1_label5", nil);
        
                
        self.tutorial_6_label.alpha = 0;
        self.tutorial_6_label.text = MNLocalizedString(@"tutorial1_label6", nil);

        self.tutorial_tap_screen_label.alpha = 0;
        self.tutorial_tap_screen_label.textColor = UIColorFromHexCode(0x0099ff);
        self.tutorial_tap_screen_label.text = MNLocalizedString(@"tutorial1_tap_screen", nil);
    
        // 스킵 버튼 초기화
        [self.skipTutorialButton setTitle:MNLocalizedString(@"tutorial1_skip_tutorial", nil) forState:UIControlStateNormal];
        self.skipTutorialButton.layer.cornerRadius = 8;
        [self.skipTutorialButton setTitleColor:UIColorFromHexCode(0xffcc00) forState:UIControlStateNormal];
        self.skipTutorialButton.backgroundColor = UIColorFromHexCodeWithAlpha(0x000000, 0.5);
        
        // 한글일 경우 네오산돌고딕으로 폰트 변경
        if ([[MNLanguage getCurrentLanguage] isEqualToString:@"ko"]) {
//            NSLog(@"Korean");
            [self setAppleSandolGothicBold:self.tutorial_1_label];
            [self setAppleSandolGothicBold:self.tutorial_2_label];
            [self setAppleSandolGothicBold:self.tutorial_3_label];
            [self setAppleSandolGothicBold:self.tutorial_4_label];
            [self setAppleSandolGothicBold:self.tutorial_5_label];
            [self setAppleSandolGothicBold:self.tutorial_6_label];
            [self setAppleSandolGothicBold:self.skipTutorialButton.titleLabel];
            [self setAppleSandolGothicBold:self.tutorial_tap_screen_label];
        }
        
        // 모든 폰트 이름 알아내기
//        for(NSString* family in [UIFont familyNames]) {
//            NSLog(@"%@", family);
//            for(NSString* name in [UIFont fontNamesForFamilyName: family]) {
//                NSLog(@"  %@", name);
//            }
//        }
        
        // 애니메이션 실행
//        [self animateTutorial5];
//        /*
        [self performSelector:@selector(animateTutorial1_1) withObject:nil afterDelay:ANIMATION_DELAY_TIME*3]; //self animateTutorial1];
        [self performSelector:@selector(animateTutorial1_2) withObject:nil afterDelay:ANIMATION_TIME_1*1.3 + ANIMATION_DELAY_TIME*3]; //self animateTutorial1];
        [self performSelector:@selector(animateTutorial1_3) withObject:nil afterDelay:ANIMATION_TIME_1*2*1.3 + ANIMATION_DELAY_TIME*3]; //self animateTutorial1];
        [self performSelector:@selector(animateTutorial1_4) withObject:nil afterDelay:ANIMATION_TIME_1*3*1.3 + ANIMATION_DELAY_TIME*3]; //self animateTutorial1];
//         */
        
        // 위에가 뻥 비길래 일단 채워넣어봤는데, 가현이 피드백을 받고 얘기했는데 원래대로 없는 것이 차라리 나을 것 같음.
        /*
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
            statusBarFrame.origin.y = -1 * [UIApplication sharedApplication].statusBarFrame.size.height;
            UIView *statusBarView = [[UIView alloc] initWithFrame:statusBarFrame];
            statusBarView.backgroundColor = self.backgroundColor;
            NSLog(@"%@", self.backgroundColor);
            
            [self addSubview:statusBarView];
            [self bringSubviewToFront:statusBarView];
        }
         */
    }
    return self;
}

#pragma mark - touchs

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesEnded %d", self.clickCount);
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [CATransaction begin];
    [self.layer removeAllAnimations];
    [CATransaction commit];
    
    [self.tutorial_tap_screen_label removeFromSuperview];
    
    // 애니메이션 중이라도 변경 가능해야함
//    if (self.isAnimating == NO) {
        self.clickCount += 1;
        
        if (self.clickCount == 4) {
            
            self.isAnimating = YES;
            
            [UIView animateWithDuration:ANIMATION_FADE_OUT delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
                
//                self.alpha = 0.5;
                self.tutorial_4_circle1.alpha = 0;
                self.tutorial_4_circle1_scale.alpha = 0;
                self.tutorial_4_label.alpha = 0;
                
                self.tutorial_5_circle1.alpha = 0;
                self.tutorial_5_circle1_scale.alpha = 0;
                self.tutorial_5_label.alpha = 0;
                self.tutorial_5_refresh.alpha = 0;
                self.tutorial_5_setting.alpha = 0;
                
                self.tutorial_tap_screen_label.alpha = 0;
            }completion:^(BOOL finished) {
                self.isAnimating = NO;
                if (self.SKDelegate) {
                    [self.SKDelegate SKTutorialView2DelegateDoneTutorial];
                }
                [self removeFromSuperview];
            }];
//        }else if(self.clickCount == 5){
//            [self showTutorialViewAtClickCount:self.clickCount];
//        }
        }else if(self.clickCount > 4) {
            
        }else{
            [self showTutorialViewAtClickCount:self.clickCount];
        }
//    }
}

- (void)showTutorialViewAtClickCount:(NSInteger)clickCount {
    switch (self.clickCount) {
        case 1:
            [self animateTutorial2];
            break;
            
        case 2:
            [self animateTutorial3];
            break;
            
        case 3:
            [self animateTutorial4];
            break;
            
        case 4:
            [self animateTutorial5];
            break;
            
        case 5:
            [self animateTutorial6];
            break;
    }
}


#pragma mark - Animations 

- (void)animateTutorial1_1 {
    self.tutorial_1_circle1_scale.alpha = 1;
    self.tutorial_1_circle1.image = [UIImage imageWithCGImage:self.tutorial_1_circle1_scale.image.CGImage];
    
    [UIView animateWithDuration:ANIMATION_TIME delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        [self.tutorial_1_circle1_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
        self.tutorial_1_circle1_scale.alpha = 0;
    }completion:nil];
}

- (void)animateTutorial1_2 {
    self.tutorial_1_circle2_scale.alpha = 1;
    self.tutorial_1_circle2.image = [UIImage imageWithCGImage:self.tutorial_1_circle2_scale.image.CGImage];
    [UIView animateWithDuration:ANIMATION_TIME delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        [self.tutorial_1_circle2_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
        self.tutorial_1_circle2_scale.alpha = 0;
        
    }completion:nil];
}

- (void)animateTutorial1_3 {
    self.tutorial_1_circle3_scale.alpha = 1;
    self.tutorial_1_circle3.image = [UIImage imageWithCGImage:self.tutorial_1_circle1_scale.image.CGImage];
    [UIView animateWithDuration:ANIMATION_TIME delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        [self.tutorial_1_circle3_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
        self.tutorial_1_circle3_scale.alpha = 0;
        
    }completion:nil];
}

- (void)animateTutorial1_4 {
    self.tutorial_1_circle4_scale.alpha = 1;
    self.tutorial_1_circle4.image = [UIImage imageWithCGImage:self.tutorial_1_circle1_scale.image.CGImage];
    [UIView animateWithDuration:ANIMATION_TIME_1_Label delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        [self.tutorial_1_circle4_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
        self.tutorial_1_circle4_scale.alpha = 0;
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:ANIMATION_TIME delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            self.tutorial_1_label.alpha = 1;
            
        }completion:^(BOOL finished) {
        
//            sleep(0.5);
            [NSThread sleepForTimeInterval:ANIMATION_DELAY_TIME];
            self.isAnimating = NO;
            self.tutorial_tap_screen_label.alpha = 1;
            
            [UIView animateWithDuration:ANIMATION_CLICK_TIME delay:0 options:(UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse) animations:^{
                // 탭 애니메이션
                self.tutorial_tap_screen_label.alpha = 0.5f;
                
            }completion:nil];
        }];
    }];
}

/*
- (void)animateTutorial1 {
    
    self.isAnimating = YES;

    UIImage *whiteImage = [UIImage imageWithCGImage:self.tutorial_1_circle1_scale.image.CGImage];
    self.tutorial_1_circle1_scale.alpha = 1;
    self.tutorial_1_circle1.image =  whiteImage;
    
    [UIView animateWithDuration:ANIMATION_TIME delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        [self.tutorial_1_circle1_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
        self.tutorial_1_circle1_scale.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        self.tutorial_1_circle2_scale.alpha = 1;
        self.tutorial_1_circle2.image =  whiteImage;
        [UIView animateWithDuration:ANIMATION_TIME delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.tutorial_1_circle2_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
            self.tutorial_1_circle2_scale.alpha = 0;
            
        }completion:^(BOOL finished) {
            
            self.tutorial_1_circle3_scale.alpha = 1;
            self.tutorial_1_circle3.image =  whiteImage;
            [UIView animateWithDuration:ANIMATION_TIME delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                
                [self.tutorial_1_circle3_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
                self.tutorial_1_circle3_scale.alpha = 0;
                
            }completion:^(BOOL finished) {
                self.tutorial_1_circle4_scale.alpha = 1;
                self.tutorial_1_circle4.image =  whiteImage;
                [UIView animateWithDuration:ANIMATION_TIME delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                    
                    [self.tutorial_1_circle4_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
                    self.tutorial_1_circle4_scale.alpha = 0;
                    
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:ANIMATION_TIME delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                        
                        self.tutorial_1_label.alpha = 1;
                        
                    }completion:^(BOOL finished) {
                        [UIView animateWithDuration:ANIMATION_TIME delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                            
                            
                        }completion:^(BOOL finished) {
                            self.isAnimating = NO;
                            
                            [UIView animateWithDuration:ANIMATION_CLICK_TIME delay:0 options:(UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse) animations:^{
                                
                                
                            }completion:nil];
                        }];
                    }];
                }];
            }];
        }];
    }];
}
 */

- (void)animateTutorial2 {

    NSInteger clickCounter = self.clickCount;
    
    [self.tutorial_1_circle1_scale removeFromSuperview];
    [self.tutorial_1_circle1 removeFromSuperview];
    [self.tutorial_1_circle2_scale removeFromSuperview];
    [self.tutorial_1_circle2 removeFromSuperview];
    [self.tutorial_1_circle3_scale removeFromSuperview];
    [self.tutorial_1_circle3 removeFromSuperview];
    [self.tutorial_1_circle4_scale removeFromSuperview];
    [self.tutorial_1_circle4 removeFromSuperview];
    [self.tutorial_1_label removeFromSuperview];
    
    self.tutorial_1_circle1_scale.alpha = 0;
    self.tutorial_1_circle1.alpha = 0;
    self.tutorial_1_circle2_scale.alpha = 0;
    self.tutorial_1_circle2.alpha = 0;
    self.tutorial_1_circle3_scale.alpha = 0;
    self.tutorial_1_circle3.alpha = 0;
    self.tutorial_1_circle4_scale.alpha = 0;
    self.tutorial_1_circle4.alpha = 0;
    self.tutorial_1_label.alpha = 0;
    
    self.isAnimating = YES;
    //    [self addSubview:self.tutorial_tap_screen_label];
    [self.tutorial_tap_screen_label.layer removeAllAnimations];
    self.tutorial_tap_screen_label.alpha = 0;
    
    self.tutorial_2_circle1.image = [self.tutorial_1_circle1_scale.image imageWithOverlayColor:UIColorFromHexCode(0x666666)];
    
    // 시계 아래로 이동
    [UIView animateWithDuration:ANIMATION_TIME_TUTORIAL_2 delay:ANIMATION_TIME_TUTORIAL_2_DELAY_TIME options:UIViewAnimationOptionTransitionNone animations:^{
        self.tutorial_2_clock.frame = CGRectOffset(self.tutorial_2_clock.frame, 0, TUTORIAL_2_OFFSET_Y);
        self.tutorial_2_clock.alpha = 1;
    }completion:nil];
    // 설명 아래로 이동
    [UIView animateWithDuration:ANIMATION_TIME_TUTORIAL_2 delay:ANIMATION_TIME_TUTORIAL_2_DELAY_TIME + ANIMATION_TIME_TUTORIAL_2 options:UIViewAnimationOptionTransitionNone animations:^{
        self.tutorial_2_label.frame = CGRectOffset(self.tutorial_2_label.frame, 0, TUTORIAL_2_OFFSET_Y);
        self.tutorial_2_label.alpha = 1;
    }completion:nil];
    // 점 아래로 이동
    [UIView animateWithDuration:ANIMATION_TIME_TUTORIAL_2 delay:ANIMATION_TIME_TUTORIAL_2_DELAY_TIME + ANIMATION_TIME_TUTORIAL_2*2 options:UIViewAnimationOptionTransitionNone animations:^{
        self.tutorial_2_circle1.frame = CGRectOffset(self.tutorial_2_circle1.frame, 0, TUTORIAL_2_OFFSET_Y);
        self.tutorial_2_circle1.alpha = 1;
    }completion:^(BOOL finished) {
        [NSThread sleepForTimeInterval:ANIMATION_DELAY_TIME];
        
        self.tutorial_2_circle1.image = [UIImage imageWithCGImage:self.tutorial_1_circle1.image.CGImage];
        self.tutorial_2_circle1_scale.alpha = 1;
        
        // 세번 깜빡임 -> 한번으로 수정
        // 3번째
        [UIView animateWithDuration:ANIMATION_TIME_TUTORIAL_2 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.tutorial_2_circle1_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
            self.tutorial_2_circle1_scale.alpha = 0;
            
        }completion:^(BOOL finished) {
            //                    sleep(0.5);
            [NSThread sleepForTimeInterval:ANIMATION_DELAY_TIME];
            self.isAnimating = NO;
            self.tutorial_tap_screen_label.alpha = 1;
            
            // 그 동안 클릭하지 않았으면 Tap screen 보여 주기
            if (clickCounter == self.clickCount) {
                [self addSubview:self.tutorial_tap_screen_label];
            }
            
            [UIView animateWithDuration:ANIMATION_CLICK_TIME delay:0 options:(UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse) animations:^{
                // 탭 애니메이션
                self.tutorial_tap_screen_label.alpha = 0.5f;
                
            }completion:nil];
        }];
        
        /*
        [UIView animateWithDuration:ANIMATION_TIME_TUTORIAL_2 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            
            [self.tutorial_2_circle1_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
            self.tutorial_2_circle1_scale.alpha = 0;
            
        }completion:^(BOOL finished) {
            [self.tutorial_2_circle1_scale setTransform:CGAffineTransformMakeScale(1, 1)];
            self.tutorial_2_circle1_scale.alpha = 1;
            
//            sleep(ANIMATION_TIME);
            // 2번째
            [UIView animateWithDuration:ANIMATION_TIME_TUTORIAL_2 delay:ANIMATION_DELAY_TIME options:UIViewAnimationOptionTransitionNone animations:^{
                
                [self.tutorial_2_circle1_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
                self.tutorial_2_circle1_scale.alpha = 0;
                
            }completion:^(BOOL finished) {
                [self.tutorial_2_circle1_scale setTransform:CGAffineTransformMakeScale(1, 1)];
                self.tutorial_2_circle1_scale.alpha = 1;
                
//                sleep(ANIMATION_TIME);
                // 3번째
                [UIView animateWithDuration:ANIMATION_TIME_TUTORIAL_2 delay:ANIMATION_DELAY_TIME options:UIViewAnimationOptionTransitionNone animations:^{
                    
                    [self.tutorial_2_circle1_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
                    self.tutorial_2_circle1_scale.alpha = 0;
                    
                }completion:^(BOOL finished) {
//                    sleep(0.5);
                    [NSThread sleepForTimeInterval:0.5f];
                    self.isAnimating = NO;
                    self.tutorial_tap_screen_label.alpha = 1;
                    
                    [UIView animateWithDuration:ANIMATION_CLICK_TIME delay:0 options:(UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse) animations:^{
                        // 탭 애니메이션
                        self.tutorial_tap_screen_label.alpha = 0.5f;
                        
                    }completion:nil];
                }];
            }];
        }];
         */
    }];
}

- (void)animateTutorial3 {
    
    NSInteger clickCounter = self.clickCount;
    
    [self.tutorial_2_clock removeFromSuperview];
    [self.tutorial_2_circle1 removeFromSuperview];
    [self.tutorial_2_circle1_scale removeFromSuperview];
    [self.tutorial_2_label removeFromSuperview];
    
    self.tutorial_2_clock.alpha = 0;
    self.tutorial_2_circle1.alpha = 0;
    self.tutorial_2_circle1_scale.alpha = 0;
    self.tutorial_2_label.alpha = 0;
    
    self.isAnimating = YES;
    self.tutorial_tap_screen_label.alpha = 0;
    [self.tutorial_tap_screen_label.layer removeAllAnimations];
    
    self.tutorial_3_circle1.alpha = 1;
    self.tutorial_3_circle1.image = [self.tutorial_1_circle1_scale.image imageWithOverlayColor:UIColorFromHexCode(0x666666)];
        
    [UIView animateWithDuration:0.05 delay:ANIMATION_DELAY_TIME options:UIViewAnimationOptionTransitionNone animations:^{

        self.tutorial_3_circle1.alpha = 0.999f;
        
    }completion:^(BOOL finished) {
        self.tutorial_3_circle1.alpha = 1;
        self.tutorial_3_circle1.image = [UIImage imageWithCGImage:self.tutorial_1_circle1_scale.image.CGImage];
        
        NSInteger offset = self.tutorial_3_circle1.frame.origin.x - self.tutorial_1_circle1.frame.origin.x;
        
        // 레이블 오른쪽으로 애니메이션 준비
        NSInteger offsetForLabel = TUTORIAL_2_OFFSET_Y;
        self.tutorial_3_label.frame = CGRectOffset(self.tutorial_3_label.frame, -offsetForLabel, 0);
        
        [UIView animateWithDuration:ANIMATION_TIME delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            // 레이블 오른쪽으로 애니메이션
            self.tutorial_3_label.frame = CGRectOffset(self.tutorial_3_label.frame, offsetForLabel, 0);
            self.tutorial_3_label.alpha = 1;
            
            // 점 왼쪽으로 이동
            self.tutorial_3_circle1.frame = CGRectOffset(self.tutorial_3_circle1.frame, -offset, 0);
        }completion:^(BOOL finished) {
            // 점 깜빡임
//            [NSThread sleepForTimeInterval:ANIMATION_DELAY_TIME];
            [UIView animateWithDuration:0.1f delay:0.1f options:UIViewAnimationOptionTransitionNone animations:^{
                self.tutorial_3_circle1.alpha = 0.998f;
                self.tutorial_3_circle1.image = [self.tutorial_1_circle1_scale.image imageWithOverlayColor:UIColorFromHexCode(0x666666)];
            }completion:^(BOOL finished) {
                self.tutorial_3_circle1.alpha = 1.0f;
                self.tutorial_3_circle1.image = [UIImage imageWithCGImage:self.tutorial_1_circle1_scale.image.CGImage];

                // 잠깐 쉬고 다시 오른쪽으로 이동
                [UIView animateWithDuration:ANIMATION_TIME delay:ANIMATION_DELAY_TIME options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    self.tutorial_3_circle1.frame = CGRectOffset(self.tutorial_3_circle1.frame, offset, 0);
                    
                }completion:^(BOOL finished) {
                    // 3번 깜빡이기 -> 1번으로 수정
                    self.tutorial_3_circle1_scale.alpha = 1;
                    
                    [UIView animateWithDuration:ANIMATION_TIME_TUTORIAL_2 delay:ANIMATION_DELAY_TIME options:UIViewAnimationOptionTransitionNone animations:^{
                        
                        [self.tutorial_3_circle1_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
                        self.tutorial_3_circle1_scale.alpha = 0;
                        
                    }completion:^(BOOL finished) {
                        //                    sleep(0.5);
                        //                                [NSThread sleepForTimeInterval:ANIMATION_DELAY_TIME];
                        
//                        // 레이블 오른쪽으로 애니메이션
//                        NSInteger offset = TUTORIAL_2_OFFSET_Y;
//                        self.tutorial_3_label.frame = CGRectOffset(self.tutorial_3_label.frame, -offset, 0);
//                        [UIView animateWithDuration:ANIMATION_TIME delay:ANIMATION_DELAY_TIME options:UIViewAnimationOptionTransitionNone animations:^{
//                            self.tutorial_3_label.frame = CGRectOffset(self.tutorial_3_label.frame, offset, 0);
//                            self.tutorial_3_label.alpha = 1;
//                        } completion:^(BOOL finished) {
//                            self.isAnimating = NO;
//                            [NSThread sleepForTimeInterval:ANIMATION_DELAY_TIME];
//                            self.tutorial_tap_screen_label.alpha = 1;
//                            
//                            // 그 동안 클릭하지 않았으면 Tap screen 보여 주기
//                            if (clickCounter == self.clickCount) {
//                                [self addSubview:self.tutorial_tap_screen_label];
//                            }
//                            
//                            [UIView animateWithDuration:ANIMATION_CLICK_TIME delay:0 options:(UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse) animations:^{
//                                // 탭 애니메이션
//                                self.tutorial_tap_screen_label.alpha = 0.5f;
//                                
//                            }completion:nil];
//                        }];
                        
                        self.isAnimating = NO;
                        [NSThread sleepForTimeInterval:ANIMATION_DELAY_TIME];
                        self.tutorial_tap_screen_label.alpha = 1;
                        
                        // 그 동안 클릭하지 않았으면 Tap screen 보여 주기
                        if (clickCounter == self.clickCount) {
                            [self addSubview:self.tutorial_tap_screen_label];
                        }
                        
                        [UIView animateWithDuration:ANIMATION_CLICK_TIME delay:0 options:(UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse) animations:^{
                            // 탭 애니메이션
                            self.tutorial_tap_screen_label.alpha = 0.5f;
                            
                        }completion:nil];
                    }];
                    
                    /*
                    [UIView animateWithDuration:ANIMATION_TIME_TUTORIAL_2 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                     
                        [self.tutorial_3_circle1_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
                        self.tutorial_3_circle1_scale.alpha = 0;
                        
                    }completion:^(BOOL finished) {
                        [self.tutorial_3_circle1_scale setTransform:CGAffineTransformMakeScale(1, 1)];
                        self.tutorial_3_circle1_scale.alpha = 1;
                        
                        //            sleep(ANIMATION_TIME);
                        // 2번째
                        [UIView animateWithDuration:ANIMATION_TIME_TUTORIAL_2 delay:ANIMATION_DELAY_TIME options:UIViewAnimationOptionTransitionNone animations:^{
                            
                            [self.tutorial_3_circle1_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
                            self.tutorial_3_circle1_scale.alpha = 0;
                            
                        }completion:^(BOOL finished) {
                            [self.tutorial_3_circle1_scale setTransform:CGAffineTransformMakeScale(1, 1)];
                            self.tutorial_3_circle1_scale.alpha = 1;
                            
                            //                sleep(ANIMATION_TIME);
                            // 3번째
                            [UIView animateWithDuration:ANIMATION_TIME_TUTORIAL_2 delay:ANIMATION_DELAY_TIME options:UIViewAnimationOptionTransitionNone animations:^{
                                
                                [self.tutorial_3_circle1_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
                                self.tutorial_3_circle1_scale.alpha = 0;
                                
                            }completion:^(BOOL finished) {
                                //                    sleep(0.5);
                                //                                [NSThread sleepForTimeInterval:ANIMATION_DELAY_TIME];
                                
                                // 레이블 오른쪽으로 애니메이션
                                NSInteger offset = TUTORIAL_2_OFFSET_Y;
                                self.tutorial_3_label.frame = CGRectOffset(self.tutorial_3_label.frame, -offset, 0);
                                [UIView animateWithDuration:ANIMATION_TIME delay:ANIMATION_DELAY_TIME options:UIViewAnimationOptionTransitionNone animations:^{
                                    self.tutorial_3_label.frame = CGRectOffset(self.tutorial_3_label.frame, offset, 0);
                                    self.tutorial_3_label.alpha = 1;
                                } completion:^(BOOL finished) {
                                    self.isAnimating = NO;
                                    [NSThread sleepForTimeInterval:ANIMATION_DELAY_TIME];
                                    self.tutorial_tap_screen_label.alpha = 1;
                                    
                                    [UIView animateWithDuration:ANIMATION_CLICK_TIME delay:0 options:(UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse) animations:^{
                                        // 탭 애니메이션
                                        self.tutorial_tap_screen_label.alpha = 0.5f;
                                        
                                    }completion:nil];
                                }];
                            }];
                        }];
                    }];
                     */
                }];
            }];
        }];
    }];
}

// Refresh, Setting 합침
- (void)animateTutorial4 {
    
    NSInteger clickCounter = self.clickCount;
    
    // 이전 애니메이션 감춤
    [self.tutorial_3_circle1 removeFromSuperview];
    [self.tutorial_3_circle1_scale removeFromSuperview];
    [self.tutorial_3_label removeFromSuperview];
    
    self.tutorial_3_circle1.alpha = 0;
    self.tutorial_3_circle1_scale.alpha = 0;
    self.tutorial_3_label.alpha = 0;
    
    self.isAnimating = YES;
    self.tutorial_tap_screen_label.alpha = 0;
    [self.tutorial_tap_screen_label.layer removeAllAnimations];
    
//    self.tutorial_4_circle1.alpha = 1;
//    
//    // 5번 애니메이션
//    self.tutorial_5_circle1.alpha = 1;
//    
//    [UIView animateWithDuration:ANIMATION_FADE_OUT delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
//    }completion:^(BOOL finished) {
//        
//        [NSThread sleepForTimeInterval:ANIMATION_DELAY_TIME*2];
//        self.tutorial_4_circle1_scale.alpha = 1;
//        self.tutorial_5_circle1_scale.alpha = 1;
//        
//        [UIView animateWithDuration:ANIMATION_TIME_TUTORIAL_2 delay:ANIMATION_DELAY_TIME options:UIViewAnimationOptionTransitionNone animations:^{
//            
//            self.tutorial_4_circle1.image = [UIImage imageWithCGImage:self.tutorial_1_circle1_scale.image.CGImage];
//            [self.tutorial_4_circle1_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
//            self.tutorial_4_circle1_scale.alpha = 0;
//            
//            self.tutorial_5_circle1.image = [UIImage imageWithCGImage:self.tutorial_1_circle1_scale.image.CGImage];
//            [self.tutorial_5_circle1_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
//            self.tutorial_5_circle1_scale.alpha = 0;
//            
//        }completion:^(BOOL finished) {            
//            [UIView animateWithDuration:ANIMATION_TIME delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
//                self.tutorial_4_label.alpha = 1;
//                self.tutorial_5_label.alpha = 1;
//            }completion:^(BOOL finished) {
//                self.isAnimating = NO;
//                [NSThread sleepForTimeInterval:ANIMATION_DELAY_TIME];
//                self.tutorial_tap_screen_label.alpha = 1;
//                
//                // 그 동안 클릭하지 않았으면 Tap screen 보여 주기
//                if (clickCounter == self.clickCount) {
//                    [self addSubview:self.tutorial_tap_screen_label];
//                }
//                
//                [UIView animateWithDuration:ANIMATION_CLICK_TIME delay:0 options:(UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse) animations:^{
//                    // 탭 애니메이션
//                    self.tutorial_tap_screen_label.alpha = 0.5f;
//                    
//                }completion:nil];
//            }];
//        }];
//    }];
    
    // 새 애니메이션: 좌우에서 프레임, 알파값 조정
    CGRect originalRefreshFrame = self.tutorial_5_refresh.frame;
    CGRect originalSettingFrame = self.tutorial_5_setting.frame;
    CGRect originalTutorialLabel_4 = self.tutorial_4_label.frame;
    CGRect originalTutorialLabel_5 = self.tutorial_5_label.frame;
    
    CGFloat offsetRefresh = self.tutorial_5_refresh.frame.origin.x + self.tutorial_5_refresh.frame.size.width;
    CGFloat offsetSettings = self.tutorial_5_setting.frame.origin.x + self.tutorial_5_setting.frame.size.width;
    
    self.tutorial_5_refresh.frame = CGRectOffset(self.tutorial_5_refresh.frame, -offsetRefresh, 0);
    self.tutorial_5_setting.frame = CGRectOffset(self.tutorial_5_setting.frame, offsetSettings, 0);
    self.tutorial_4_label.frame = CGRectOffset(self.tutorial_4_label.frame, -offsetRefresh, 0);
    self.tutorial_5_label.frame = CGRectOffset(self.tutorial_5_label.frame, offsetSettings, 0);

    // 1차: 아이콘, 조금 더 갔다가 다시 돌아옴
    [UIView animateWithDuration:ANIMATION_TIME delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        self.tutorial_5_refresh.frame = CGRectOffset(originalRefreshFrame, 5, 0);
        self.tutorial_5_setting.frame = CGRectOffset(originalSettingFrame, -5, 0);
        self.tutorial_5_refresh.alpha = 0.8;
        self.tutorial_5_setting.alpha = 0.8;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
            self.tutorial_5_refresh.frame = originalRefreshFrame;
            self.tutorial_5_setting.frame = originalSettingFrame;
            self.tutorial_5_refresh.alpha = 1;
            self.tutorial_5_setting.alpha = 1;
        }completion:nil];
    }];
    
    // 2차: 레이블 애니메이션
    [UIView animateWithDuration:ANIMATION_TIME delay:0.2f options:UIViewAnimationOptionTransitionNone animations:^{
        self.tutorial_4_label.frame = CGRectOffset(originalTutorialLabel_4, 5, 0);
        self.tutorial_5_label.frame = CGRectOffset(originalTutorialLabel_5, -5, 0);
        self.tutorial_4_label.alpha = 0.8;
        self.tutorial_5_label.alpha = 0.8;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
            self.tutorial_4_label.frame = originalTutorialLabel_4;
            self.tutorial_5_label.frame = originalTutorialLabel_5;
            self.tutorial_4_label.alpha = 1;
            self.tutorial_5_label.alpha = 1;
        }completion:^(BOOL finished) {
            self.isAnimating = NO;
            
            [NSThread sleepForTimeInterval:ANIMATION_DELAY_TIME];
            self.tutorial_tap_screen_label.alpha = 1;
            
            // 그 동안 클릭하지 않았으면 Tap screen 보여 주기
            if (clickCounter == self.clickCount) {
                [self addSubview:self.tutorial_tap_screen_label];
            }
            
            [UIView animateWithDuration:ANIMATION_CLICK_TIME delay:0 options:(UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse) animations:^{
                // 탭 애니메이션
                self.tutorial_tap_screen_label.alpha = 0.5f;
                
            }completion:nil];
        }];
    }];
}

- (void)animateTutorial5 {
    
    NSInteger clickCounter = self.clickCount;
    
    // 이전 애니메이션 감춤
    [self.tutorial_4_circle1 removeFromSuperview];
    [self.tutorial_4_circle1_scale removeFromSuperview];
    [self.tutorial_4_label removeFromSuperview];
    
    self.tutorial_4_circle1.alpha = 0;
    self.tutorial_4_circle1_scale.alpha = 0;
    self.tutorial_4_label.alpha = 0;
    
    self.isAnimating = YES;
    self.tutorial_tap_screen_label.alpha = 0;
    [self.tutorial_tap_screen_label.layer removeAllAnimations];
    
    self.tutorial_5_circle1.alpha = 1;
    
    [UIView animateWithDuration:ANIMATION_FADE_OUT delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
    }completion:^(BOOL finished) {
        [NSThread sleepForTimeInterval:ANIMATION_DELAY_TIME*2];
        self.tutorial_5_circle1_scale.alpha = 1;
        
        [UIView animateWithDuration:ANIMATION_TIME_TUTORIAL_2 delay:ANIMATION_DELAY_TIME options:UIViewAnimationOptionTransitionNone animations:^{
            
            self.tutorial_5_circle1.image = [UIImage imageWithCGImage:self.tutorial_1_circle1_scale.image.CGImage];
            [self.tutorial_5_circle1_scale setTransform:CGAffineTransformMakeScale(ANIMATION_CIRCLE_SCALE, ANIMATION_CIRCLE_SCALE)];
            self.tutorial_5_circle1_scale.alpha = 0;
            
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:ANIMATION_TIME delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
                self.tutorial_5_label.alpha = 1;
                
            }completion:^(BOOL finished) {
                // 변경 -> 레이블 5 위로 올리고, 6도 같이 보여줌
                [UIView animateWithDuration:ANIMATION_TIME delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
                    self.tutorial_5_label.frame = CGRectOffset(self.tutorial_5_label.frame, 0, -(self.tutorial_6_label.frame.size.height));
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:ANIMATION_TIME delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
                        self.tutorial_6_label.alpha = 1;
                    }completion:^(BOOL finished) {
                        self.isAnimating = NO;
                        [NSThread sleepForTimeInterval:ANIMATION_DELAY_TIME];
                        self.tutorial_tap_screen_label.alpha = 1;
                        
                        // 그 동안 클릭하지 않았으면 Tap screen 보여 주기
                        if (clickCounter == self.clickCount) {
                            [self addSubview:self.tutorial_tap_screen_label];
                        }
                        
                        [UIView animateWithDuration:ANIMATION_CLICK_TIME delay:0 options:(UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse) animations:^{
                            // 탭 애니메이션
                            self.tutorial_tap_screen_label.alpha = 0.5f;
                            
                        }completion:nil];
                    }];
                }];
            }];
        }];
    }];
}

// 사용안함
- (void)animateTutorial6 {
// 이전 애니메이션 감춤
    self.tutorial_5_label.alpha = 0;
    
    self.isAnimating = YES;
    self.tutorial_tap_screen_label.alpha = 0;
    [self.tutorial_tap_screen_label.layer removeAllAnimations];
    
    [UIView animateWithDuration:ANIMATION_FADE_OUT delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:ANIMATION_TIME delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
            self.tutorial_6_label.alpha = 1;
        }completion:^(BOOL finished) {
            self.isAnimating = NO;
            self.isAnimating = NO;
            [NSThread sleepForTimeInterval:ANIMATION_DELAY_TIME];
            self.tutorial_tap_screen_label.alpha = 1;
            
            [UIView animateWithDuration:ANIMATION_CLICK_TIME delay:0 options:(UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse) animations:^{
                // 탭 애니메이션
                self.tutorial_tap_screen_label.alpha = 0.5f;
                
            }completion:nil];
        }];
    }];
    
}

- (IBAction)skipTutorialButtonClicked:(id)sender {
    
    self.isAnimating = NO;
    if (self.SKDelegate) {
        [self.SKDelegate SKTutorialView2DelegateDoneTutorial];
    }
//    [self removeFromSuperview];
}

#pragma mark - Font

- (void)setAppleSandolGothicBold:(UILabel *)label {
    CGFloat actualFontSize;
    [label.text sizeWithFont:label.font
                 minFontSize:label.minimumScaleFactor
              actualFontSize:&actualFontSize
                    forWidth:label.bounds.size.width
               lineBreakMode:label.lineBreakMode];
    
    [label setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:actualFontSize]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
