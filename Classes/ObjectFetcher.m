//
//  ObjectFetcher.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ObjectFetcher.h"
#import "AuthContext.h"

@implementation ObjectFetcher

@synthesize tag;
@synthesize obj;
@synthesize delegate;

- initWithTag:(NSString*)inTag object:(id)inObj delegate:(NSObject<ObjectFetcherDelegate>*)inDelegate {
	self = [super init];
	
	if (self != nil) {
		self.tag = inTag;
		self.obj = inObj;
		self.delegate = inDelegate;
	}
	
	return self;
}

- (void)dealloc {
	[tag release];
	[obj release];
	
	[super dealloc];
}

- (void)fetch {
	RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderForObject:self.obj method:RKRequestMethodGET delegate:self];
	[[AuthContext context] addOAuthHeader:loader];	

	[loader setObjectMapping:[[[RKObjectManager sharedManager] mappingProvider] objectMappingForClass:[self.obj class]]];
	[loader send];
}

// RKObjectLoaderDelegate implementation

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
	[delegate retrievalCompleted:self.tag withSuccess:TRUE];
}

- (void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader *)objectLoader {
	NSLog(@"Fetch for %@ failed unexpectedly", self.tag);
	[delegate retrievalCompleted:self.tag withSuccess:FALSE];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
	NSLog(@"Fetch for %@ failed with error: %@", self.tag, error); 
	[delegate retrievalCompleted:self.tag withSuccess:FALSE];
}

@end