//
//  MNQuotesModalViewController.h
//  Morning Kit
//
//  Created by 김우성 on 13. 5. 8..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNWidgetModalController.h"
//#import <OHAttributedLabel/OHAttributedLabel.h>
#import "MNView.h"

@interface MNQuotesModalViewController : MNWidgetModalController<MNViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet MNView *roundRectedView;
@property (nonatomic, strong) IBOutlet UILabel *quoteLabel;

// 선택 UI
@property (nonatomic, strong) IBOutlet UILabel *englishLabel;
@property (nonatomic, strong) IBOutlet UISwitch *englishSwitch;

@property (nonatomic, strong) IBOutlet UILabel *koreanLabel;
@property (nonatomic, strong) IBOutlet UISwitch *koreanSwitch;

@property (nonatomic, strong) IBOutlet UILabel *japaneseLabel;
@property (nonatomic, strong) IBOutlet UISwitch *japaneseSwitch;

@property (nonatomic, strong) IBOutlet UILabel *simplifiedChineseLabel;
@property (nonatomic, strong) IBOutlet UISwitch *simplifiedChineseSwitch;

@property (nonatomic, strong) IBOutlet UILabel *traditionalChineseLabel;
@property (nonatomic, strong) IBOutlet UISwitch *traditionalChineseSwitch;

@end
