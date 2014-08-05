//
//  MNConfigureWidgetController.m
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 30..
//  Copyright (c) 2012년. All rights reserved.
//

#import "MNConfigureWidgetController.h"
#import "MNDefinitions.h"
#import "MNWidgetMatrixLoadSaver.h"
#import "MNTheme.h"
#import "MNRoundRectedViewMaker.h"
#import "MNWidgetMatrix.h"
#import "MNWidgetIconLoader.h"
#import "MNUnlockManager.h"
#import "MNStoreController.h"
#import "MNEffectSoundPlayer.h"
#import "Flurry.h"
#import <QuartzCore/QuartzCore.h>

#define ALPHA_SELECTED 0.4f
#define ALPHA_ANIMATION 0.7f

@interface MNConfigureWidgetController ()

@end

@implementation MNConfigureWidgetController
{
    CGRect widgetImageRect2;
    CGRect widgetImageRect3;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initView
{
    
}

- (void)viewDidLoad
{
//    NSLog(@"viewDidLoad");
    
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.translucent = NO;
//        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        
        // 타이틀
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeFont : [UIFont fontWithName:@"helvetica-bold" size:iOS7_NAV_TITLE_FONT_SIZE]};
    }
    
    // Load WidgetDictionaryArray
    self.widgetDictionaryArray = [[MNWidgetMatrixLoadSaver loadWidgetMatrix] mutableCopy];
    
    // load WidgetSelector
    self.widgetSelector = [[[NSBundle mainBundle] loadNibNamed:WIDGET_SELECTOR_NIB_NAME owner:self options:nil] objectAtIndex:0];
    [self.widgetSelector.scrollView setClipsToBounds:YES];
    [self.widgetSelector.scrollView setContentSize:CGSizeMake(2 * WIDGET_SELECTOR_CONTENTS_WIDTH, WIDGET_SELECTOR_CONTENTS_HEIGHT)];
    [self.view addSubview:self.widgetSelector];

//    NSLog(@"%f", self.widgetSelector.pageControl.frame.size.height);
    
    int posY;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        posY = (self.tabBarController.tabBar.frame.origin.y) - WIDGET_SELECTOR_CONTENTS_HEIGHT - 21; // 21은 pageControl 눈으로 보기에 정확한 사이즈 // - self.widgetSelector.pageControl.frame.size.height; // + 10;
        //    self.widgetSelector.backgroundColor = [UIColor redColor];
    }else{
        posY = (self.tabBarController.tabBar.frame.origin.y) - WIDGET_SELECTOR_CONTENTS_HEIGHT + 10;
    }
    [self.widgetSelector setFrame:CGRectMake(0, posY, WIDGET_SELECTOR_CONTENTS_WIDTH, WIDGET_SELECTOR_TOTAL_HEIGHT)];
    [self.widgetSelector localize];
    
    //

    
    //
    [self setArt];
    
    // Sort WidgetImage Collector
    self.WidgetImages = [self.WidgetImages sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return(
               ([obj1 tag] < [obj2 tag]) ? NSOrderedAscending  :
               ([obj1 tag] > [obj2 tag]) ? NSOrderedDescending :
               NSOrderedSame);
    }];
    
    self.WidgetLabels = [self.WidgetLabels sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return(
               ([obj1 tag] < [obj2 tag]) ? NSOrderedAscending  :
               ([obj1 tag] > [obj2 tag]) ? NSOrderedDescending :
               NSOrderedSame);
    }];
    
    // Sort WidgetSelector
    [self.widgetSelector orderSelectorItems];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadWidgetImages];
    [self setThemeFontColorOfLabels];
    
    self.title = MNLocalizedString(@"tab_widget", @"위젯");
    self.navigationItem.leftBarButtonItem.title = MNLocalizedString(@"cancel", "취소");
    self.navigationItem.rightBarButtonItem.title = MNLocalizedString(@"done", "완료");
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
    
    // Set image from Widgetmatrix
    [self setImageViewWithTag:101 widgetID:[[[self.widgetDictionaryArray objectAtIndex:0] objectForKey:@"Type"] integerValue]];
    [self setImageViewWithTag:102 widgetID:[[[self.widgetDictionaryArray objectAtIndex:1] objectForKey:@"Type"] integerValue]];
    [self setImageViewWithTag:201 widgetID:[[[self.widgetDictionaryArray objectAtIndex:2] objectForKey:@"Type"] integerValue]];
    [self setImageViewWithTag:202 widgetID:[[[self.widgetDictionaryArray objectAtIndex:3] objectForKey:@"Type"] integerValue]];
    
    postSelectedWidget = -1;
    postSelectedWidgetSlot = -1;
    selectedWidgetSlot = -1;
    selectedWidget = -1;
    
    [self.widgetSelector localize];
    [self checkWidgetMatrix];
    self.view.backgroundColor = [MNTheme getBackwardBackgroundUIColor];
    
    for (UIView *view in self.WidgetImages) {
//        view.superview.backgroundColor = [UIColor clearColor];
        view.backgroundColor = [MNTheme getForwardBackgroundUIColor];
    }
    
    [self.widgetSelector setThemeColor];
    [self.widgetSelector makeRoundRect];
}

- (void)setThemeFontColorOfLabels {
    for (UILabel *label in self.WidgetLabels) {
        label.textColor = [MNTheme getMainFontUIColor];
    }
}

- (void)checkWidgetMatrix
{
    if ([MNWidgetMatrix getCurrentMatrixType] == 1)
    {
        [self.WidgetImages[2] removeFromSuperview];
        [self.WidgetImages[3] removeFromSuperview];
        [self.WidgetLabels[2] removeFromSuperview];
        [self.WidgetLabels[3] removeFromSuperview];
    }
    else
    {
        if (self.WidgetImages[2] != nil)
        {
            [self.view addSubview:self.WidgetImages[2]];
            [self.view addSubview:self.WidgetImages[3]];
            [self.view addSubview:self.WidgetLabels[2]];
            [self.view addSubview:self.WidgetLabels[3]];
            
            [self setImageViewWithTag:201 widgetID:[[[self.widgetDictionaryArray objectAtIndex:2] objectForKey:@"Type"] integerValue]];
            [self setImageViewWithTag:202 widgetID:[[[self.widgetDictionaryArray objectAtIndex:3] objectForKey:@"Type"] integerValue]];
        }
    }
}

- (void)setArt
{
    for (UIView *view in self.WidgetImages) {
        [MNRoundRectedViewMaker makeRoundRectedView:view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - touch handling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // take touch event
    
    for (UITouch* touch in touches) {
        switch (touch.view.tag) {
            case 0: // default touch
                selectedWidget = -1;
                selectedWidgetSlot = -1;
                [self stopAllAnimations];
                break;
                
            // Widget selector's Tag
            case WEATHER:
            case CALENDAR:
            case WORLDCLOCK:
            case QUOTES:
            case FLICKR:
            case EXCHANGE_RATE:
            case REMINDER:
//                NSLog(@"widget selector");
                postSelectedWidget = selectedWidget;
                selectedWidget = touch.view.tag;
                break;
                
            // 아래 두 케이스는 구매 확인 필요
            case DATE_COUNTDOWN: {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                if ([userDefaults boolForKey:STORE_PRODUCT_ID_WIDGET_DATE_COUNTDOWN]) {
                    postSelectedWidget = selectedWidget;
                    selectedWidget = touch.view.tag;
                }else{
                    [MNUnlockManager showUnlockControllerWithProductID:STORE_PRODUCT_ID_WIDGET_DATE_COUNTDOWN withController:self];
                    selectedWidget = -1;
                    selectedWidgetSlot = -1;
                    [self stopAllAnimations];
                }
                break;
            }
                
            case MEMO: {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                if ([userDefaults boolForKey:STORE_PRODUCT_ID_WIDGET_MEMO]) {
                    postSelectedWidget = selectedWidget;
                    selectedWidget = touch.view.tag;
                }else{
                    [MNUnlockManager showUnlockControllerWithProductID:STORE_PRODUCT_ID_WIDGET_MEMO withController:self];
                    selectedWidget = -1;
                    selectedWidgetSlot = -1;
                    [self stopAllAnimations];
                }
                break;
            }
                
            case WIDGET_STORE: {
                // 스토어 컨트롤러를 호출
                UIStoryboard *storyboard;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    storyboard = [UIStoryboard storyboardWithName:@"IAPStoryboard_iPad" bundle:[NSBundle mainBundle]];
                }else{
                    storyboard = [UIStoryboard storyboardWithName:@"IAPStoryboard" bundle:[NSBundle mainBundle]];
                }
                UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"Nav_MNStoreController"];
                //        MNStoreController *storeController = [[UIStoryboard storyboardWithName:@"IAPStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MNStoreController"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDictionary *param = [NSDictionary dictionaryWithObject:@"Widget Configure" forKey:@"From"];
                    
                    [Flurry logEvent:@"Store" withParameters:param];
                });
                
                [self presentViewController:navigationController animated:YES completion:nil];
                break;
            }
                
            //
            // Widget image's Tag
            case 101:
            case 102:
            case 201:
            case 202:
//                NSLog(@"widget image");
                postSelectedWidgetSlot = selectedWidgetSlot;
                selectedWidgetSlot = touch.view.tag;
                break;
                
            // etc.
            default:
                selectedWidget = -1;
                selectedWidgetSlot = -1;
                [self stopAllAnimations];
                break;
        }
    }
    
    // logic
    
    // Widget is selected but WidgetSlot is not selected
    if ((selectedWidgetSlot == -1) && (selectedWidget != -1)) {
        if (selectedWidget == postSelectedWidget) {
            selectedWidget = -1;
            postSelectedWidget = -1;
            [self stopAllAnimations];
        }
        else
        {
            [self guideToSelectWidgetSlot];
        }
    }
    // WidgetSlot is selected but Widget is not selected
    else if ((selectedWidget == -1) && (selectedWidgetSlot != -1))
    {
        if (selectedWidgetSlot == postSelectedWidgetSlot) {
            selectedWidgetSlot = -1;
            postSelectedWidgetSlot = -1;
            [self stopAllAnimations];
        }
        else
        {
            [self guideToSelectWidgetWithWidgetSlotTag:selectedWidgetSlot];
        }
    }
    // Needs to change widget matrix
    else if ((selectedWidgetSlot != -1) && (selectedWidget != -1))
    {
        [self setImageViewWithTag:selectedWidgetSlot widgetID:selectedWidget];
    }
}

#pragma mark - Methods About Widget Dictionary array

#pragma mark - Processing Images & Animations

- (void)loadWidgetImages
{
//    NSLog(@"loadWidgetImages");
    for (int i=0; i<9; i++) {
        widgetImages[i] = [MNWidgetIconLoader getWidgetIconWithIndex:i];
    }
    /*
    widgetImages[0] = [UIImage imageNamed:@"btn_weather_transparent"];
    widgetImages[1] = [UIImage imageNamed:@"btn_calendar_transparent"];
    widgetImages[2] = [UIImage imageNamed:@"btn_dday_transparent"];
    widgetImages[3] = [UIImage imageNamed:@"btn_wclock_transparent"];
    widgetImages[4] = [UIImage imageNamed:@"btn_maxim_transparent"];
    widgetImages[5] = [UIImage imageNamed:@"btn_flickr_transparent"];
    widgetImages[6] = [UIImage imageNamed:@"btn_note_transparent"];
    widgetImages[7] = [UIImage imageNamed:@"btn_currency_transparent"];
     */
}

- (void)guideToSelectWidgetWithWidgetSlotTag:(int)tag
{
    [self stopAllAnimations];
    
    for (UIView *view in self.WidgetImages) {
        if (view.tag == tag)
            ;
        else
        {
            [UIView animateWithDuration:0.2f animations:^{
                view.alpha = ALPHA_SELECTED;
            }];
        }
    }
    
    for (UIView *view in self.WidgetLabels) {
        if (view.tag == tag)
            ;
        else
        {
            [UIView animateWithDuration:0.2f animations:^{
                view.alpha = ALPHA_SELECTED;
            }];
        }
    }
    
    for (int j=0; j<2; j++) {
        for (int i=0; i<6; i++) {
            [self performSelector:@selector(runTwinkleAnimation:) withObject:self.widgetSelector.selectorItems[i] afterDelay:(1.5f*i)+(9*j)];
        }
    }
    
    for (int j=0; j<2; j++) {
        for (int i=0; i<3; i++) {
            [self performSelector:@selector(runTwinkleAnimation:) withObject:self.widgetSelector.selectorItems[i+6] afterDelay:18+(1.5f*i)+(4.5*j)];
        }
    }
    
    [self performSelector:@selector(runScrollAnimation) withObject:NULL afterDelay:18];
    [self performSelector:@selector(runScrollAnimation) withObject:NULL afterDelay:27];
}

- (void)guideToSelectWidgetSlot
{
    [self stopAllAnimations];
    
    for (UIView *view in self.widgetSelector.selectorItems) {
        if (view.tag == selectedWidget)
            ;
        else
        {
            [UIView animateWithDuration:0.2f animations:^{
                view.alpha = ALPHA_SELECTED;
            }];
        }
    }

    for (UIView *view in self.widgetSelector.selectorItems) {
        if (view.tag == selectedWidget)
            ;
        else
        {
            [UIView animateWithDuration:0.2f animations:^{
                view.alpha = ALPHA_SELECTED;
            }];
        }
    }
    
    for (int j=0; j<2; j++) {
        for (int i=0; i< 2 * [MNWidgetMatrix getCurrentMatrixType]; i++) {
            [self performSelector:@selector(runTwinkleAnimation:) withObject:self.WidgetImages[i] afterDelay:(1.5*i)+(3*[MNWidgetMatrix getCurrentMatrixType])*j];
//            [self performSelector:@selector(runTwinkleAnimation:) withObject:self.WidgetLabels[i] afterDelay:(1.5*i)+(3*[MNWidgetMatrix getCurrentMatrixType])*j];
        }
    }
}

- (void)runScrollAnimation
{
    int i = self.widgetSelector.pageControl.currentPage;
    [self.widgetSelector gotoPageWithInt:i==0?1:0 Animated:YES];
}

- (void)runTwinkleAnimation:(UIView *)view
{
    [UIView animateWithDuration:0.75f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^
    {
            view.backgroundColor = [MNTheme getSelectedWidgetBackgroundUIColor];
    } completion:^(BOOL finished)
    {
        [UIView animateWithDuration:0.75f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^
        {
            switch (view.tag)
            {
                case DATE_COUNTDOWN:
                {
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    if ([userDefaults boolForKey:STORE_PRODUCT_ID_WIDGET_DATE_COUNTDOWN])
                    {
                        view.backgroundColor = [MNTheme getForwardBackgroundUIColor];
                    }
                    else
                    {
                        view.backgroundColor = [MNTheme getLockedBackgroundUIColor];
                    }
                    break;
                }
                    
                case MEMO:
                {
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    if ([userDefaults boolForKey:STORE_PRODUCT_ID_WIDGET_MEMO])
                    {
                        view.backgroundColor = [MNTheme getForwardBackgroundUIColor];
                    }
                    else
                    {
                        view.backgroundColor = [MNTheme getLockedBackgroundUIColor];
                    }
                    break;
                }
                
                default:
                {
                    view.backgroundColor = [MNTheme getForwardBackgroundUIColor];
                    break;
                }
            }
            
        } completion:nil];
    }];
}

- (void)stopAllAnimations
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    for (UIView *view in self.WidgetImages)
    {
        [UIView animateWithDuration:0.2f animations:^{
            view.alpha = 1.0f;
            view.userInteractionEnabled = YES;
        }];
    }
    
    for (UIView *view in self.WidgetLabels)
    {
        [UIView animateWithDuration:0.2f animations:^{
            view.alpha = 1.0f;
            view.userInteractionEnabled = YES;
        }];
    }
    
    for (UIView *view in self.widgetSelector.selectorItems)
    {
        [UIView animateWithDuration:0.2f animations:^{
            view.alpha = 1.0f;
            view.userInteractionEnabled = YES;
        }];
    }
}

- (void)setImageViewWithTag:(int)tag widgetID:(int)ID
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    switch (tag) {
        case 101:
            [dict setObject:[NSNumber numberWithInt:ID] forKey:@"Type"];
            [dict setObject:[NSNumber numberWithInt:0] forKey:@"Pos"];
            if (dict[@"Type"] != self.widgetDictionaryArray[0][@"Type"])
                [self.widgetDictionaryArray replaceObjectAtIndex:0 withObject:dict];
            [self.WidgetImages[0] setImage:widgetImages[ID-1]];
            [self setLabelWithPos:0 widgetID:ID];
            break;
            
        case 102:
            [dict setObject:[NSNumber numberWithInt:ID] forKey:@"Type"];
            [dict setObject:[NSNumber numberWithInt:1] forKey:@"Pos"];
            if (dict[@"Type"] != self.widgetDictionaryArray[1][@"Type"])
                [self.widgetDictionaryArray replaceObjectAtIndex:1 withObject:dict];
            [self.WidgetImages[1] setImage:widgetImages[ID-1]];
            [self setLabelWithPos:1 widgetID:ID];
            break;
            
        case 201:
            [dict setObject:[NSNumber numberWithInt:ID] forKey:@"Type"];
            [dict setObject:[NSNumber numberWithInt:2] forKey:@"Pos"];
            if (dict[@"Type"] != self.widgetDictionaryArray[2][@"Type"])
                [self.widgetDictionaryArray replaceObjectAtIndex:2 withObject:dict];
            [self.WidgetImages[2] setImage:widgetImages[ID-1]];
            [self setLabelWithPos:2 widgetID:ID];
            break;
            
        case 202:
            [dict setObject:[NSNumber numberWithInt:ID] forKey:@"Type"];
            [dict setObject:[NSNumber numberWithInt:3] forKey:@"Pos"];
            if (dict[@"Type"] != self.widgetDictionaryArray[3][@"Type"])
                [self.widgetDictionaryArray replaceObjectAtIndex:3 withObject:dict];
            [self.WidgetImages[3] setImage:widgetImages[ID-1]];
            [self setLabelWithPos:3 widgetID:ID];
            break;
            
        default:
//            NSMutableDictionary *details = [NSMutableDictionary dictionary];
//            [NSError errorWithDomain:@"WidgetConfigure" code:200 userInfo:details];
            break;
    }
    
    selectedWidget = -1;
    selectedWidgetSlot = -1;
    postSelectedWidget = -1;
    postSelectedWidgetSlot = -1;
    [self stopAllAnimations];
}

- (void)setLabelWithPos:(int)pos widgetID:(int)ID
{
    switch (ID) {
        case WEATHER:
            ((UILabel *)self.WidgetLabels[pos]).text = MNLocalizedString(@"weather", "날씨");
            break;
            
        case CALENDAR:
            ((UILabel *)self.WidgetLabels[pos]).text = MNLocalizedString(@"calendar", "달력");
            break;
            
        case DATE_COUNTDOWN:
            ((UILabel *)self.WidgetLabels[pos]).text = MNLocalizedString(@"date_calculator", "날짜계산");
            ((UILabel *)self.WidgetLabels[pos]).text = [((UILabel *)self.WidgetLabels[pos]).text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            break;
            
        case WORLDCLOCK:
            ((UILabel *)self.WidgetLabels[pos]).text = MNLocalizedString(@"world_clock", "세계시간");
            break;
            
        case QUOTES:
            ((UILabel *)self.WidgetLabels[pos]).text = MNLocalizedString(@"saying", "명언");
            break;
            
        case FLICKR:
            ((UILabel *)self.WidgetLabels[pos]).text = MNLocalizedString(@"flickr", "플리커");
            break;
            
        case MEMO:
            ((UILabel *)self.WidgetLabels[pos]).text = MNLocalizedString(@"memo", "메모");
            break;
            
        case EXCHANGE_RATE:
            ((UILabel *)self.WidgetLabels[pos]).text = MNLocalizedString(@"exchange_rate", "환율");
            ((UILabel *)self.WidgetLabels[pos]).text = [((UILabel *)self.WidgetLabels[pos]).text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            break;
            
        case REMINDER:
            ((UILabel *)self.WidgetLabels[pos]).text = MNLocalizedString(@"reminder", "리마인더");
            
        default:
            break;
    }
}

- (void)tabChanged
{
    [self stopAllAnimations];
}

- (void)localize
{
    
}

- (void)saveCurrentDictionaryArray
{
    if (self.widgetDictionaryArray != nil)
        [MNWidgetMatrixLoadSaver saveWidgetMatrix:self.widgetDictionaryArray];
}

#pragma mark - navigation button methods

- (IBAction)cancelButtonClicked:(id)sender {
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_SETTING];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [MNTheme setThemeForMain];
//    });
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonClicked:(id)sender {
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_SETTING];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [MNTheme setThemeForMain];
//    });
    [self saveCurrentDictionaryArray];
    [self stopAllAnimations];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
