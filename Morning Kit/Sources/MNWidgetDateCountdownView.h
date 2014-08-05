//
//  MNWidgetDateCountdownView.h
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//
#pragma once

#import "MNWidgetView.h"

@interface MNWidgetDateCountdownView : MNWidgetView

@property (strong, nonatomic) NSString *contentString;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
