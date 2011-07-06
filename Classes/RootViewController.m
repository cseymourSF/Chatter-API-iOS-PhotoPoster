//
//  RootViewController.m
//  PhotoPoster
//
//  Created by Chris Seymour on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "include/RestKit/RestKit.h"
#import "AuthContext.h"
#import "RootViewController.h"
#import "User.h"
#import "GroupsPage.h"
#import "PhotoPosterController.h"

@implementation RootViewController

@synthesize postBtn;
@synthesize stateLbl;
@synthesize nameLbl;
@synthesize titleLbl;
@synthesize picView;
@synthesize infoView;

- (void)dealloc {
	[postBtn release];
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
	NSLog(@"UpdateUi Start");
	// Clear the UI.
	[nameLbl setText:@""];
	[titleLbl setText:@""];
	[picView setImage:nil];
	
	if ([[AuthContext context] accessToken] == nil) {
		[stateLbl setText:@"Not logged in"];
		[postBtn setEnabled:FALSE];
		[postBtn setAlpha:0.5];
		[infoView setHidden:TRUE];
	} else {
		// TODO: Verify the token actually works...
		
		[stateLbl setText:@"Logged in"];
		[postBtn setEnabled:TRUE];
		[postBtn setAlpha:1.0];
		[infoView setHidden:FALSE];
	}
	NSLog(@"UpdateUi end");
}

- (void)viewWillAppear:(BOOL)animated {	
	NSLog(@"ViewWillAppear start");
	[self updateUi];
	
	[super viewWillAppear:animated];
	NSLog(@"ViewWillAppear end");
}

- (void)viewDidAppear:(BOOL)animated {	
	if ([[AuthContext context] accessToken] != nil) {
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
	
	[super viewDidAppear:animated];
}

- (IBAction)login:(id)sender {
	// Retrieve the "PPConsumerKey" value from the info plist.	
	NSString* consumerKey = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"PPConsumerKey"];
	if ((consumerKey == nil) || ([consumerKey length] <= 0)) {
		NSLog(@"!!!!!!!YOU MUST SET THE PPConsumerKey VALUE IN THE INFO PLIST FOR THIS APP TO RUN!!!!!!!!!");
		[[NSThread mainThread] exit];
	}

	OAuthViewController* oauthViewController = 
		[[[OAuthViewController alloc] 
		 	initWithLoginUrl:@"https://login.salesforce.com/services/oauth2/authorize"
		         callbackUrl:@"https://login.salesforce.com/services/oauth2/success"
		         consumerKey:consumerKey] autorelease];
	
	[[self navigationController] pushViewController:oauthViewController animated:YES];
}

- (IBAction)logout:(id)sender {
	[[AuthContext context] clear];
	
	[self updateUi];
}

- (IBAction)postPhotoToGroup:(id)sender {
	[[self navigationController] pushViewController:[[[PhotoPosterController alloc] init] autorelease] animated:YES];
}

- (void)initRestKit {
	// Set-up the RestKit manager.
	RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[[AuthContext context] instanceUrl]];
	[RKObjectManager setSharedManager:manager];
	
	// Initialize mappings.
	[User setupMapping:manager];
	[GroupsPage setupMapping:manager];
	
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
