//
//  RootViewController.m
//  PhotoPoster
//
//  Created by Chris Seymour on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthContext.h"
#import "RootViewController.h"
#import "GroupPickerController.h"

#import "User.h"
#import "GroupsPage.h"
#import "FeedItemPage.h"

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
	[self initRestKit];
	
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
	NSURL* loginUrl = [AuthContext fullLoginUrl];
	
	if ([[[loginUrl absoluteString] uppercaseString] hasPrefix:@"HTTP"]) {
		// If it starts with http or https, use an embedded UIWebView.
		OAuthViewController* oauthViewController = [[[OAuthViewController alloc] initWithLoginUrl:loginUrl] autorelease];
		[[self navigationController] pushViewController:oauthViewController animated:YES];
	} else {
		// If it starts with a custom prefix, spawn Mobile Safari.
		[[UIApplication sharedApplication] openURL:loginUrl];
	}
}

- (IBAction)logout:(id)sender {
	[[AuthContext context] clear];
	
	[self updateUi];
}

- (IBAction)exploreGroups:(id)sender {
	[[self navigationController] pushViewController:[[[GroupPickerController alloc] init] autorelease] animated:YES];
}

- (void)initRestKit {
	// TODO: Don't re-initialize everything every time, just adjust the base URL!
	
	// Set-up the RestKit manager.
	RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[[AuthContext context] instanceUrl]];
	[RKObjectManager setSharedManager:manager];
	
	// Initialize mappings.
	[User setupMapping:manager];
	[GroupsPage setupMapping:manager];
	[FeedItemPage setupMapping:manager];
	
	// RestKit logging.
	RKLogConfigureByName("RestKit", RKLogLevelDebug);
    RKLogConfigureByName("RestKit/Network", RKLogLevelDebug);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
    RKLogConfigureByName("RestKit/Network/Queue", RKLogLevelDebug);
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

- (void)retrievalCompleted:(NSString*)tag image:(UIImage*)image {
	[picView setImage:image];
}

@end
