//
//  MNConfigureWidgetController.h
//  Morning Kit
//
//  Created by 김우성 on 12. 10. 30..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNWidgetSelector.h"

@protocol MNConfigureWidgetDelegate <NSObject>

-(void) WidgetConfigureChanged;

@end

@interface MNConfigureWidgetController : UIViewController
{
    int widgetRows;
    int widgetCols;
    
    int postSelectedWidgetSlot;
    int selectedWidgetSlot;
    int postSelectedWidget;
    int selectedWidget;
    
    UIImage *widgetImages[9];
}

- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;
- (void)tabChanged;
- (void)saveCurrentDictionaryArray;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *WidgetImages;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *WidgetLabels;

@property (strong, nonatomic) MNWidgetSelector *widgetSelector;

@property (strong, nonatomic) NSMutableArray *widgetDictionaryArray;

@end
