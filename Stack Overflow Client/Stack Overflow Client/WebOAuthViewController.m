//
//  WebOAuthViewController.m
//  Stack Overflow Client
//
//  Created by John Leonard on 2/16/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "WebOAuthViewController.h"
#import <WebKit/WebKit.h>

@interface WebOAuthViewController () <WKNavigationDelegate>

@end

@implementation WebOAuthViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // set up the web view frame to be the same size as the current view's frame,
  // and add it as a subview to the current view, covering it
  WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:webView];
  webView.navigationDelegate = self;
  
  // get the https request ready and send it out
  NSString *urlString = @"https://stackexchange.com/oauth/dialog?client_id=4276&scope=no_expiry&redirect_uri=https://stackexchange.com/oauth/login_success";
  NSURL *url = [NSURL URLWithString:urlString];
  [webView loadRequest:[NSURLRequest requestWithURL:url]];
} // viewDidLoad

// decide whether or not to allow the web view to display the new web page
- (void) webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
  NSURLRequest *request = navigationAction.request;
  NSURL *url = request.URL;
  
  // pull the access token out of the URL
  if ([url.description containsString:@"access_token"])
  {
    // parse the URL for the token
    NSArray *components = [[url description] componentsSeparatedByString:@"="];
    NSString *token = components.lastObject;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // save the token in user defaults
    [userDefaults setObject:token forKey:@"token"];
    [userDefaults synchronize];
    
    // close the web view
    [self dismissViewControllerAnimated:true completion:nil];
  } // if containsString
  
  // we'll always allow the request
  decisionHandler(WKNavigationActionPolicyAllow);
} // webView()

@end
