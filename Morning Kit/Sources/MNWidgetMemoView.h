//
//  MNWidgetMemoView.h
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//
#pragma once

#import "MNWidgetView.h"

@interface MNWidgetMemoView : MNWidgetView

@property (strong, nonatomic) NSString *memoString;
@property (strong, nonatomic) NSString *archivedString;
@property (strong, nonatomic) IBOutlet UILabel *memoLabel;
@property (strong, nonatomic) IBOutlet UILabel *summarylabel;
@property (strong, nonatomic) IBOutlet UILabel *widgetNameLabel;

@end
