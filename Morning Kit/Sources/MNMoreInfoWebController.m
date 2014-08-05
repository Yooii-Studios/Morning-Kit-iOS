//
//  MNMoreInfoWebController.m
//  Morning Kit
//
//  Created by Wooseong Kim on 13. 8. 13..
//  Copyright (c) 2013년 Yooii Studios. All rights reserved.
//

#import "MNMoreInfoWebController.h"

@interface MNMoreInfoWebController ()

@end

@implementation MNMoreInfoWebController

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
//    NSLog(@"%@", self.urlString);
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
//	NSLog(@"webViewDidStartLoad:webView");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
//	NSLog(@"webViewDidFinishLoad:webView");
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//	NSLog(@"webView:didFailLoadWithError");
    [[[UIAlertView alloc] initWithTitle:MNLocalizedString(@"app_name", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:MNLocalizedString(@"ok", nil) otherButtonTitles:nil] show];
    [self.activityIndicator stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//	NSLog(@"webView:shouldStartLoadWithRequest:navigationType");
    [self.activityIndicator startAnimating];
	return TRUE;
}

@end
