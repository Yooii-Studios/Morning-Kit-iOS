//
//  MNWidgetLoadSaver.m
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 21..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNWidgetLoadSaver.h"

@implementation MNWidgetLoadSaver

+ (void) saveWidgets:(MNWidgetData *)widgets
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *widgetData = [NSKeyedArchiver archivedDataWithRootObject:widgets];
    
    [ud setObject:widgetData forKey:@"WidgetMatrix"];
}

+ (MNWidgetData *) loadWidgets
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *nsdWidgetData = [ud valueForKey:@"WidgetMatrix"];
    MNWidgetData *widgetData;
    
    if (widgetData)
    {
        widgetData = [NSKeyedUnarchiver unarchiveObjectWithData:nsdWidgetData];
    }
    else
    {
        widgetData = [[MNWidgetData alloc] init];
    }
    
    return widgetData;
}

@end
