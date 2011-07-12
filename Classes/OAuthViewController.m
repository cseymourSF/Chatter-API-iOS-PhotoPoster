//
//  OAuthViewController.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 Salesforce. All rights reserved.
//
// TODO: Add error handling!

#import "OAuthViewController.h"
#import "Config.h"
#import "AuthContext.h"

@implementation OAuthViewController

@synthesize webView;

- (id)initWithLoginUrl:(NSURL*)loginUrl {
	// Make the login request.
	loginRequest = [[NSMutableURLRequest requestWithURL:loginUrl
										   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData // Don't use the cache.
									   timeoutInterval:60] retain];
	
	// Load up UI.
	self = [self initWithNibName:@"OAuthViewController" bundle:nil];
	if (self != nil) {
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
	// Load request in web view.
	[self.webView loadRequest:loginRequest];
	
	[super viewWillAppear:animated];
}

- (BOOL)webView:(UIWebView *)webViewIn
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {		
	NSURL* callbackUrl = [NSURL URLWithString:[Config callbackUrl]];
	
	if ([[callbackUrl host] isEqual:[[request URL] host]] &&
		[[callbackUrl path] isEqual:[[request URL] path]]) {
		// Extract auth values from the callback URL.
		[[AuthContext context] processCallbackUrl:[request URL]];
		
		// Pop back out.
		[self.navigationController popViewControllerAnimated:YES];
		
		// Web view should not request the url.
		return NO;
	} else {
		// Not done yet. Web view should request the url.
		return YES;
	}
}

- (void)dealloc {
	[self.webView release];
	[loginRequest release];
	
    [super dealloc];
}

@end
