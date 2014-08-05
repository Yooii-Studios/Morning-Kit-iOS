//
//  MNView.h
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 8. 25..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MNViewDelegate <NSObject>

- (void)MNViewDidClicked;

@end

@interface MNView : UIView

@property (strong, nonatomic) id<MNViewDelegate> MNDelegate;

@end
