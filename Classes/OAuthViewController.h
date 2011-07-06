//
//  OAuthViewController.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface OAuthViewController : UIViewController<UINavigationControllerDelegate, UIWebViewDelegate> {
	UIWebView* webView;
	NSURLRequest* loginRequest;
	NSURL* callbackUrl;
}

@property(nonatomic, retain) IBOutlet UIWebView* webView;

- (id)initWithLoginUrl:(NSString*)loginUrl 
           callbackUrl:(NSString*)callbackUrlIn
		   consumerKey:(NSString*)consumerKey;

@end
