//
//  MNStoreButtonMaker.m
//  MNStoreControllerProj
//
//  Created by Wooseong Kim on 13. 7. 8..
//  Copyright (c) 2013년 Wooseong Kim. All rights reserved.
//

#import "MNStoreButtonMaker.h"
#import <QuartzCore/QuartzCore.h>

@implementation MNStoreButtonMaker

+ (void)makeStoreOnButton:(UIButton *)button {
    button.backgroundColor = UIColorFromHexCode(0xb0b0b0);
    
    button.layer.cornerRadius = 5.0f;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = UIColorFromHexCode(0xe0e0e0).CGColor;
    
    button.titleLabel.textColor = UIColorFromHexCode(0xffffff);
}

+ (void)makeStoreOffButton:(UIButton *)button {
    button.backgroundColor = UIColorFromHexCode(0x4a4a4a);
    
    button.layer.cornerRadius = 5.0f;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = UIColorFromHexCode(0x0a0a0a).CGColor;
    //    button.layer.borderColor = UIColorFromHexCode(0x4f0a0a).CGColor;
    
    button.titleLabel.textColor = UIColorFromHexCode(0xa5a5a5);
}

@end
