//
//  MNWidgetLoadingView.h
//  Morning Kit
//
//  Created by Yongbin Bae on 13. 4. 27..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum MNWidgetState
{
    MNWidgetStateFormal = 0,
    MNWidgetStateLoading,
    MNWidgetStateNoNetwork,
    MNWidgetStateNoLocation,
    MNWidgetStateError,
}MNWidgetState;

@protocol MNWidgetLoadingViewDelegate <NSObject>

- (NSString *)getWidgetTypeString;

@end

@interface MNWidgetLoadingView : UIView

- (void)startAnimating;
- (void)stopAnimating;
- (void)showNoNetwork;
- (void)showNOLocation;
- (void)showWidgetError:(NSString *)error;
- (void)onLanguageChanged;

@property (weak, nonatomic) IBOutlet UIImageView *loadingImageView;
@property (strong, nonatomic) IBOutlet UILabel *noNetworkLabel;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) NSString *latestErrorMsg;
@property (strong, nonatomic) id<MNWidgetLoadingViewDelegate> delegate;
@property (nonatomic) MNWidgetState state;

@end
