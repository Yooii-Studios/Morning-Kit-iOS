//
//  SKPhotoScaleFrameView.h
//  SKPhotoPicker
//
//  Created by 김우성 on 13. 4. 5..
//  Copyright (c) 2013년 SK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKPhotoCropFrameView.h"

// View - manipulating image view to crop frame
@interface SKPhotoScaleView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic) SKPhotoCropOrientation photoCropOrientation;

- (void)initializeScrollView;

@end
