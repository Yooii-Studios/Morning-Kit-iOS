//
//  MNWidgetModalController.m
//  Morning Kit
//
//  Created by Yong Bin Bae on 13. 3. 24..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNWidgetModalControllerFactory.h"
#import "MNDefinitions.h"
#import "MNEffectSoundPlayer.h"
#import "MNTheme.h"
#import "MNStoreController.h"
#import "MNUnlockManager.h"
#import "Flurry.h"

static NSString *WidgetLocalizeKey[10] =
{
    @"",
    @"weather",
    @"calendar",
    @"reminder",
    @"world_clock",
    @"saying",
    @"flickr",
    @"exchange_rate",
    @"memo",
    @"date_calculator"
};

@implementation MNWidgetModalController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

// ovveride it after [super initWithDictionary:dict]
- (void)initWithDictionary:(NSMutableDictionary *)dict
{
    self.widgetDictionary = dict;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MNTheme setThemeForConfigure];
//    NSLog(@"widgetModal viewWillAppear");
    
    // 새로 보일 때마다 UI색을 바꾸어주기(Unlock 관련해서 필요)
    if (self.selector) {
        [self.selector setThemeColor];
        [self.selector indicateCurrentWidget:[self.widgetDictionary[@"Type"] integerValue]];
    }
}

// please do not override
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int type = [self.widgetDictionary[@"Type"] integerValue];
    self.title = MNLocalizedString(WidgetLocalizeKey[type], @"Title");
    
    [MNTheme setThemeForConfigure];
//    NSLog(@"widgetModal viewDidLoad");
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:MNLocalizedString(@"cancel", @"Cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonClicked)];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:MNLocalizedString(@"done", @"Done") style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClicked)];
    
    self.navigationItem.leftBarButtonItem = cancelItem;
    self.navigationItem.rightBarButtonItem = doneItem;
    
    // attatch widget selector
    self.selector = [[[NSBundle mainBundle] loadNibNamed:WIDGET_SELECTOR_NIB_NAME owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:self.selector];
    [self.selector.scrollView setClipsToBounds:YES];
    [self.selector.scrollView setContentSize:CGSizeMake(2*WIDGET_SELECTOR_CONTENTS_WIDTH, WIDGET_SELECTOR_CONTENTS_HEIGHT)];
    int posY = self.view.frame.size.height - WIDGET_SELECTOR_TOTAL_HEIGHT;
    [self.selector setFrame:CGRectMake(0, posY, WIDGET_SELECTOR_CONTENTS_WIDTH, WIDGET_SELECTOR_TOTAL_HEIGHT)];
    [self.selector makeRoundRect];
    [self.selector setThemeColor];
    self.selector.backgroundColor = [UIColor clearColor];
    [self.selector localize];
    [self.selector orderSelectorItems];
    
    int p;
    if ((p = [self.widgetDictionary[@"SelectorPage"] integerValue])) {
        [self.selector gotoPageWithInt:p Animated:NO];
        [self.widgetDictionary removeObjectForKey:@"SelectorPage"];
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.translucent = NO;
        //        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        
        self.title = [self.title stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        // 타이틀
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeFont : [UIFont fontWithName:@"helvetica-bold" size:20]};
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // take touch event
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    for (UITouch* touch in touches) {
        switch (touch.view.tag) {
            case 0: // default touch
                break;
                
            // Widget selector's Tag
            case WEATHER:
            case CALENDAR:
            case WORLDCLOCK:
            case QUOTES:
            case FLICKR:
            case EXCHANGE_RATE:
            case REMINDER:
                [self changeWidgetDictionaryID:touch.view.tag];
                break;
                
            case DATE_COUNTDOWN:
                // 해당 위젯이 언락되었는지 확인하기
                if ([userDefaults boolForKey:STORE_PRODUCT_ID_WIDGET_DATE_COUNTDOWN]) {
                    [self changeWidgetDictionaryID:touch.view.tag];
                }else{
                    [MNUnlockManager showUnlockControllerWithProductID:STORE_PRODUCT_ID_WIDGET_DATE_COUNTDOWN withController:self];
                }
                break;
                
            case MEMO:
                if ([userDefaults boolForKey:STORE_PRODUCT_ID_WIDGET_MEMO]) {
                    [self changeWidgetDictionaryID:touch.view.tag];
                }else{
                    [MNUnlockManager showUnlockControllerWithProductID:STORE_PRODUCT_ID_WIDGET_MEMO withController:self];
                }
                break;
                
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
                [self presentViewController:navigationController animated:YES completion:nil];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDictionary *param = [NSDictionary dictionaryWithObject:@"ModalView" forKey:@"From"];
                    
                    [Flurry logEvent:@"Store" withParameters:param];
                });
                
                break;
            }

            default:
                break;
        }
    }
}

- (void)changeWidgetDictionaryID:(int)ID
{
    int originalID = [[self.widgetDictionary objectForKey:@"Type"] integerValue];
    int pos = [[self.widgetDictionary objectForKey:@"Pos"] integerValue];
    
    if (originalID != ID)
    {
        NSMutableDictionary *prevWidgetDictionary = [self.widgetDictionary mutableCopy];
        
        [self.widgetDictionary removeAllObjects];
        [self.widgetDictionary setObject:[NSNumber numberWithInt:ID] forKey:@"Type"];
        [self.widgetDictionary setObject:[NSNumber numberWithInt:pos] forKey:@"Pos"];
        [self.widgetDictionary setObject:[NSNumber numberWithInteger:self.selector.pageControl.currentPage] forKey:@"SelectorPage"];
        
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        MNWidgetModalController *modal = [MNWidgetModalControllerFactory getModalControllerWithDictionary:self.widgetDictionary];
        modal.delegate = self.delegate;
        
        if (!self.prevWidgetDictionary)
        {
            modal.prevWidgetDictionary = prevWidgetDictionary;
        }
        else
        {
            modal.prevWidgetDictionary = self.prevWidgetDictionary;
        }
        
        if (viewControllers.count > 0)
        {
            [viewControllers replaceObjectAtIndex:0 withObject:modal];
            [self.navigationController setViewControllers:viewControllers];
        }
    }
}

// Override it after super call
- (void)doneButtonClicked
{
    if (self.prevWidgetDictionary) {
        [self.delegate widgetChangedOnModalView:[self.widgetDictionary[@"Pos"] integerValue]];
    }
    else {
        [self.delegate reloadWidgetIndex:[(NSNumber *)[self.widgetDictionary objectForKey:@"Pos"] integerValue]];
    }
    
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK_CLOSE];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelButtonClicked
{
    if (self.prevWidgetDictionary)
    {
        [self.widgetDictionary removeAllObjects];
        [self.widgetDictionary addEntriesFromDictionary:self.prevWidgetDictionary];
        [self.delegate widgetChangedOnModalView:[self.widgetDictionary[@"Pos"] integerValue]];
    }
    [MNEffectSoundPlayer playEffectSoundWithName:EFFECT_SOUND_VIEW_CLICK_CLOSE];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadModalView
{
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [MNTheme setThemeForMain];    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


#pragma mark - rotate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}


// for over iOS 6.0
- (BOOL)shouldAutorotate {
    return NO;
}


// Tell the system which initial orientation we want to have
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


// Tell the system what we support
-(NSUInteger)supportedInterfaceOrientations
{
    // return UIInterfaceOrientationMaskLandscapeRight;
    // return UIInterfaceOrientationMaskAll;
    return UIInterfaceOrientationMaskPortrait;
}

@end