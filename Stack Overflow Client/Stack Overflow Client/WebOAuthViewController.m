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
  
  WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:webView];
  webView.navigationDelegate = self;
  
  NSString *urlString = @"https://stackexchange.com/oauth/dialog?client_id=4276&scope=no_expiry&redirect_uri=https://stackexchange.com/oauth/login_success";
  NSURL *url = [NSURL URLWithString:urlString];
  [webView loadRequest:[NSURLRequest requestWithURL:url]];
} // viewDidLoad

- (void) webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
  NSURLRequest *request = navigationAction.request;
  NSURL *url = request.URL;
  
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
  
  decisionHandler(WKNavigationActionPolicyAllow);
} // webView()



@end
