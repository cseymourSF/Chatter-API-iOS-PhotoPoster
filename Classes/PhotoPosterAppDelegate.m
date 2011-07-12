//
//  PhotoPosterAppDelegate.m
//  PhotoPoster
//
//  Created by Chris Seymour on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoPosterAppDelegate.h"
#import "RootViewController.h"
#import "AuthContext.h"

@implementation PhotoPosterAppDelegate

@synthesize window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	[[AuthContext context] processCallbackUrl:url];
	return YES;	
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after application launch.
    
    // Set the navigation controller as the window's root view controller and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

