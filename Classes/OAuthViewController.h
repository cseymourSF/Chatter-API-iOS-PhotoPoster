//
//  OAuthViewController.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@protocol OAuthViewControllerDelegate<NSObject>
-(void)authCompleted;
@end

@interface OAuthViewController : UIViewController<UINavigationControllerDelegate, UIWebViewDelegate> {
	UIWebView* webView;
	NSURLRequest* loginRequest;
	NSURL* callbackUrl;
	id<OAuthViewControllerDelegate> delegate;
}

@property(nonatomic, retain) IBOutlet UIWebView* webView;

- (id)initWithLoginUrl:(NSString*)loginUrl 
           callbackUrl:(NSString*)callbackUrlIn
		   consumerKey:(NSString*)consumerKey
			  delegate:(id<OAuthViewControllerDelegate>)delegateIn;

@end
