//
//  MNWidgetFlickrView.h
//  Morning Kit
//
//  Created by Yong Bin Bae on 12. 11. 22..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//
#pragma once

#import "MNWidgetView.h"

@interface MNWidgetFlickrView : MNWidgetView

@property (strong, nonatomic) IBOutlet UIImageView *flickrImageView;
@property (strong, nonatomic) NSString *keywordString;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) UIImage *originalFlickrImage;
@property (strong, nonatomic) UIImage *croppedFlickrImage;

@property (strong, nonatomic) UIImage *landscapeImage;
@property (strong, nonatomic) UIImage *portraitImage;

@property (nonatomic) NSInteger totalNumberOfPhtos;

@property (nonatomic) BOOL isGrayscaleOn;

@property (strong, nonatomic) IBOutlet UILabel *widgetNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *networkFailLabel;

@end
