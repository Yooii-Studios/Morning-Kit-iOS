//
//  SKTutorialView.m
//  TestPopup
//
//  Created by Wooseong Kim on 13. 7. 4..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import "SKTutorialView.h"
#import <QuartzCore/QuartzCore.h>

#define NUMBER_OF_PAGES 3

@implementation SKTutorialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self = [[[NSBundle mainBundle] loadNibNamed:@"SKTutorialView_iPad" owner:self options:nil] objectAtIndex:0];            
        }else{
            self = [[[NSBundle mainBundle] loadNibNamed:@"SKTutorialView" owner:self options:nil] objectAtIndex:0];
        }

        // 처음은 터치를 막기
        self.themeScrollView.userInteractionEnabled = NO;
        self.confirmButton.userInteractionEnabled = NO;
        
        self.frame = frame;
        
        //        self.backgroundColor = [UIColor whiteColor];
        
        self.popupTutorialView.backgroundColor = UIColorFromHexCode(0xe6e6e6);
        
        // 그림자
        self.popupTutorialView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.popupTutorialView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            self.popupTutorialView.layer.cornerRadius = 8;
            self.popupTutorialView.layer.shadowRadius = 8.0f;
            self.popupTutorialView.layer.shadowOpacity = 0.4f;
        }else{
            self.popupTutorialView.layer.cornerRadius = 16;
            self.popupTutorialView.layer.shadowRadius = 10.0f;
            self.popupTutorialView.layer.shadowOpacity = 0.6f;
        }
        
        // 테마 색 각각 적용
        self.themeSelectLabel.text = MNLocalizedString(@"tutorial_select_theme", @"모닝 배경 화면 선택"); // @"모닝 배경 화면 선택";
        self.themeSelectLabel.textColor = UIColorFromHexCode(0x696969);
        
        self.themeNameLabel.text = [self getTitleWithIndex:self.themePageControl.currentPage];
        self.themeNameLabel.backgroundColor = UIColorFromHexCode(0xbcbcbc);
        self.themeNameLabel.textColor = UIColorFromHexCode(0x252525);
        
        // 이미지 스크롤뷰에 대입
        self.themeScrollView.pagingEnabled = YES;
        //        self.themeScrollView.delegate = self;
        [self.themeScrollView setContentSize:CGSizeMake(self.themeScrollView.frame.size.width * NUMBER_OF_PAGES, self.themeScrollView.frame.size.height)];
        
        CGRect imageFrame = CGRectMake(0, 0, self.themeScrollView.frame.size.width, self.themeScrollView.frame.size.height);
        
        // water lily
        UIButton *imageButton1 = [[UIButton alloc] initWithFrame:imageFrame];
        [imageButton1 setImage:[UIImage imageNamed:@"themeselection_waterlily"] forState:UIControlStateNormal];
        imageButton1.contentMode = UIViewContentModeScaleToFill;
        [self.themeScrollView addSubview:imageButton1];
        [imageButton1 addTarget:self action:@selector(themeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
//        UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"themeselection_scenery"]];
//        imageView1.frame = imageFrame;
//        imageView1.contentMode = UIViewContentModeScaleToFill;
//        [self.themeScrollView addSubview:imageView1];
        
        // themeselection_classicwhite
        imageFrame.origin.x += self.themeScrollView.frame.size.width;
        UIButton *imageButton2 = [[UIButton alloc] initWithFrame:imageFrame];
        [imageButton2 setImage:[UIImage imageNamed:@"themeselection_classicgrey"] forState:UIControlStateNormal];
        imageButton2.contentMode = UIViewContentModeScaleToFill;
        [self.themeScrollView addSubview:imageButton2];
        [imageButton2 addTarget:self action:@selector(themeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
//        UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"themeselection_classicwhite"]];
//        imageView2.frame = imageFrame;
//        imageView2.contentMode = UIViewContentModeScaleToFill;
//        [self.themeScrollView addSubview:imageView2];
        
        // themeselection_classicgrey
        imageFrame.origin.x += self.themeScrollView.frame.size.width;
        UIButton *imageButton3 = [[UIButton alloc] initWithFrame:imageFrame];
        [imageButton3 setImage:[UIImage imageNamed:@"themeselection_scenery"] forState:UIControlStateNormal];
        imageButton3.contentMode = UIViewContentModeScaleToFill;
        [self.themeScrollView addSubview:imageButton3];
        [imageButton3 addTarget:self action:@selector(themeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
//        UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"themeselection_classicgrey"]];
//        imageView3.frame = imageFrame;
//        imageView3.contentMode = UIViewContentModeScaleToFill;
//        [self.themeScrollView addSubview:imageView3];
        
        // 스크롤 뒷배경 그림자 넣기
        self.themeScrollBackgroundView.layer.cornerRadius = 0;
        self.themeScrollBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.themeScrollBackgroundView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.themeScrollBackgroundView.layer.shadowRadius = 2.0f;
        self.themeScrollBackgroundView.layer.shadowOpacity = 0.4f;
        self.themeScrollBackgroundView.layer.masksToBounds = NO;
        
        //        imageFrame.origin.x += self.themeScrollView.frame.size.width;
        //        UIImageView *imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"preview_classic_gray.png"]];
        //        imageView4.frame = imageFrame;
        //        imageView4.contentMode = UIViewContentModeScaleToFill;
        //        [self.themeScrollView addSubview:imageView4];
        
        self.themePageControl.currentPage = 0;
        self.themePageControl.numberOfPages = NUMBER_OF_PAGES;
//        self.themePageControl.pageIndicatorTintColor = UIColorFromHexCode(0xbababa);
        self.themePageControl.dotColorCurrentPage = UIColorFromHexCode(0x717171);
        self.themePageControl.dotColorOtherPage = UIColorFromHexCode(0xbababa);
        self.themePageControl.userInteractionEnabled = NO;
        // 그냥 Interaction 막자
        //        [self.themePageControl addTarget:self action:@selector(pageChangeValue:) forControlEvents:UIControlEventValueChanged];
        
        self.confirmButton.alpha = 0;
        
        // 설정 후에 애니메이션 동작
        self.popupTutorialView.alpha = 0;
        [UIView animateWithDuration:0.5f animations:^{
            self.popupTutorialView.alpha = 1;
        }completion:^(BOOL finished) {
            [self animateScrollView];
        }];
        //        [UIView beginAnimations:nil context:NULL];
        //        [UIView setAnimationDuration:1];
        //        [UIView commitAnimations];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - animation

- (void)animateScrollView {
    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionTransitionNone animations:^{
        
        [self.themeScrollView setContentOffset:CGPointMake(self.themeScrollView.frame.size.width, 0)];
        
    }completion:^(BOOL finished) {
        
        self.themePageControl.currentPage = SKTutorialThemeTypeClassicGray;
        [self.themePageControl setNeedsDisplay];
        self.themeNameLabel.text = [self getTitleWithIndex:self.themePageControl.currentPage];
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionTransitionNone animations:^{
            [self.themeScrollView setContentOffset:CGPointMake(self.themeScrollView.frame.size.width*2, 0)];
            
        }completion:^(BOOL finished) {
            
            self.themePageControl.currentPage = SKTutorialThemeTypeScenery;
            [self.themePageControl setNeedsDisplay];
            self.themeNameLabel.text = [self getTitleWithIndex:self.themePageControl.currentPage];
            [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionTransitionNone animations:^{
                //                [self.themeScrollView setContentOffset:CGPointMake(self.themeScrollView.frame.size.width*3, 0)];
                [self.themeScrollView setContentOffset:CGPointMake(0, 0)];
            }completion:^(BOOL finished) {
                
                self.themePageControl.currentPage = SKTutorialThemeTypeWaterLily;
                [self.themePageControl setNeedsDisplay];
                self.themeNameLabel.text = [self getTitleWithIndex:self.themePageControl.currentPage];
                self.confirmButton.alpha = 1;
                self.themeScrollView.delegate = self;

                self.themeScrollView.userInteractionEnabled = YES;
                self.confirmButton.userInteractionEnabled = YES;
                
                [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction animations:^{
                    [self.confirmButton setTransform:CGAffineTransformMakeScale(1.1f, 1.1f)];
                }completion:^(BOOL finished) {
                }];
                
                /*
                 self.themePageControl.currentPage = 3;
                 [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionTransitionNone animations:^{
                 [self.themeScrollView setContentOffset:CGPointMake(0, 0)];
                 
                 }completion:^(BOOL finished) {
                 
                 self.themePageControl.currentPage = 0;
                 self.confirmButton.alpha = 1;
                 self.themeScrollView.delegate = self;
                 
                 }];
                 */
            }];
        }];
    }];
}

#pragma mark - confirm

- (IBAction)confirmButtonClicked:(id)sender {
    if (self.SKDelegate) {
        MNThemeType themeType;
        switch (self.themePageControl.currentPage) {
            case SKTutorialThemeTypeScenery:
                themeType = MNThemeTypeScenery;
                break;
                
            case SKTutorialThemeTypeWaterLily:
                themeType = MNThemeTypeWaterLily;
                break;
                
            case SKTutorialThemeTypeClassicGray:
                themeType = MNThemeTypeClassicGray;
                break;
                
            default:
                themeType = MNThemeTypeClassicWhite;
                break;
        }
        [self.SKDelegate SKTutorialViewDelegateDidConfirm:themeType];
    }
    [self removeFromSuperview];
}


#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger previousPage = self.themePageControl.currentPage;
    self.themePageControl.currentPage = floor((scrollView.contentOffset.x - pageWidth / NUMBER_OF_PAGES) / pageWidth) + 1;
    [self.themePageControl setNeedsDisplay];
    
    // 페이지가 바뀔 때 타이틀도 변경
    if (previousPage != self.themePageControl.currentPage) {
        //        NSLog(@"pageChangeValue");
        self.themeNameLabel.text = [self getTitleWithIndex:self.themePageControl.currentPage];
    }
}

- (void)pageChangeValue:(id)sender {
    UIPageControl *pControl = (UIPageControl *) sender;
    [self.themeScrollView setContentOffset:CGPointMake(pControl.currentPage * self.themeScrollView.frame.size.width, 0) animated:YES];
}


#pragma mark - title maker

- (NSString *)getTitleWithIndex:(NSInteger)index {
    switch (index) {
        case SKTutorialThemeTypeScenery:
            return MNLocalizedString(@"setting_theme_scenery", @"Scenery");
            
        case SKTutorialThemeTypeWaterLily:
            return MNLocalizedString(@"store_item_water_lily", @"Water Lily");
            
        case SKTutorialThemeTypeClassicGray:
            return MNLocalizedString(@"setting_theme_color_classic_gray", @"Classic Gray");
    }
    return nil;
}


#pragma mark - theme button handler

- (void)themeButtonClicked {
    [self confirmButtonClicked:nil];
}

@end
