//
//  MNImagePickerController.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 10. 1..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNImagePickerController.h"

@interface MNImagePickerController ()

@end

@implementation MNImagePickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
