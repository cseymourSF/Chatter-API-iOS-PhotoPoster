//
//  RootViewController.m
//  PhotoPoster
//
//  Created by Chris Seymour on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Config.h"
#import "AuthContext.h"
#import "RootViewController.h"
#import "GroupPickerController.h"
#import "MappingManager.h"

@implementation RootViewController

@synthesize exploreBtn;
@synthesize loginBtn;
@synthesize logoutBtn;
@synthesize stateLbl;
@synthesize nameLbl;
@synthesize titleLbl;
@synthesize picView;
@synthesize infoView;

- (void)dealloc {
	[exploreBtn release];
	[loginBtn release];
	[logoutBtn release];
	[stateLbl release];
	[nameLbl release];
	[titleLbl release];
	[picView release];
	[infoView release];
	
	[user release];
	[photoFetcher release];
	
    [super dealloc];
}
	
- (void)updateUi {
	// Clear the UI.
	[nameLbl setText:@""];
	[titleLbl setText:@""];
	[picView setImage:nil];
	
	if ([[AuthContext context] accessToken] == nil) {
		[stateLbl setText:@"Not logged in"];
		[exploreBtn setEnabled:FALSE];
		[exploreBtn setAlpha:0.5];
		[infoView setHidden:TRUE];
	} else {
		// TODO: Verify the token actually works...
		
		[stateLbl setText:@"Logged in"];
		[exploreBtn setEnabled:TRUE];
		[exploreBtn setAlpha:1.0];
		[infoView setHidden:FALSE];
	}
}

- (void)viewWillAppear:(BOOL)animated {	
	[self updateUi];
	
	[super viewWillAppear:animated];
}

- (void)initRestKitAndUser {
	// Re-initialize RestKit with the current instance URL.
	[MappingManager initialize];
	
	// Request population of the User by RestKit.
	[user release];
	user = [[User alloc] init];
	user.userId = @"me";
	
	RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderForObject:user method:RKRequestMethodGET delegate:self];
	[[AuthContext context] addOAuthHeader:loader];	
	[loader setObjectMapping:[[[RKObjectManager sharedManager] mappingProvider] objectMappingForClass:[User class]]];
	[loader send];
}

- (void)viewDidAppear:(BOOL)animated {	
	if ([[AuthContext context] accessToken] == nil) {
		BOOL isGetting = [[AuthContext context] startGettingAccessTokenWithDelegate:self];
		if (isGetting) {
			[stateLbl setText:@"Fetching access token..."];
			[loginBtn setEnabled:FALSE];
			[logoutBtn setEnabled:FALSE];
		}
	} else {
		[self initRestKitAndUser];
	}
	
	[super viewDidAppear:animated];
}

- (void)processCallbackUrl:(NSURL*)callbackUrl {
	[[AuthContext context] processCallbackUrl:callbackUrl];
	
	[self updateUi];
	if ([[AuthContext context] accessToken] != nil) {
		[self initRestKitAndUser];
	}
}

- (void)refreshCompleted {
	NSLog(@"Finished trying to fetch access token: %@", [[AuthContext context] accessToken]);
	
	[loginBtn setEnabled:TRUE];
	[logoutBtn setEnabled:TRUE];
	
	[self updateUi];
	if ([[AuthContext context] accessToken] != nil) {
		[self initRestKitAndUser];
	}
}

- (IBAction)login:(id)sender {	
	// We support two options for logging in.
	if (TRUE) {
		// Embedded UIWebView (may use a callback URL with a custom scheme
		// or the "success" https URL).
		OAuthViewController* oauthViewController = [[[OAuthViewController alloc] init] autorelease];
		[[self navigationController] pushViewController:oauthViewController animated:YES];
	} else {
		// Mobile Safari (must use a callback URL with a custom scheme).
		[[UIApplication sharedApplication] openURL:[AuthContext fullLoginUrl]];
	}
}

- (IBAction)logout:(id)sender {
	[[AuthContext context] clear];
	
	[self updateUi];
}

- (IBAction)exploreGroups:(id)sender {
	[[self navigationController] pushViewController:[[[GroupPickerController alloc] init] autorelease] animated:YES];
}

// RKObjectLoaderDelegate implementation.

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
	[nameLbl setText:[user name]];
	[titleLbl setText:[user title]];
	
	// Retrieve the user's photo.
	photoFetcher = [[PhotoFetcher alloc] initWithTag:@"userPhoto" photoUrl:[user largePhotoUrl] delegate:self];
	[photoFetcher fetch];
}

- (void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader *)objectLoader {
	NSLog(@"User fetch failed unexpectedly");
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
	NSLog(@"User fetch failed with error: %@", error);
}

// PhotoFetcherDelegate implementation.

- (void)photoRetrievalCompleted:(NSString*)tag image:(UIImage*)image {
	[picView setImage:image];
}

@end
