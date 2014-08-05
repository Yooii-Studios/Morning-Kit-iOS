//
//  MNMoreInfoWebController.h
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 8. 13..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNMoreInfoWebController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *urlString;

@end
