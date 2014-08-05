//
//  SKViewController.h
//  SKWaterLilyTest
//
//  Created by Wooseong Kim on 13. 10. 5..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKWaterLilyTheme.h"

@interface SKWaterLilyViewController : UIViewController

//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *waterLilyImageView;

@property (strong, nonatomic) UIImage *portraitWaterLilyImage;
@property (strong, nonatomic) UIImage *landscapeWaterLilyImage;
@property (strong, nonatomic) SKWaterLilyTheme *waterLilyTheme;

- (IBAction)selectImageButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
