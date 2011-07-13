//
//  PhotoFetcher.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoFetcher.h"
#import "AuthContext.h"

@implementation PhotoFetcher

@synthesize tag;
@synthesize delegate;
@synthesize url;
@synthesize conn;
@synthesize data;

- initWithTag:(NSString*)inTag photoUrl:(NSString*)photoUrl delegate:(NSObject<PhotoFetcherDelegate>*)inDelegate {
	self = [super init];
	
	if (self != nil) {
		self.url = [NSURL URLWithString:photoUrl];
		self.tag = inTag;
		self.delegate = inDelegate;
	}
	
	return self;
}

- (void)dealloc {
	[tag release];
	[url release];
	[conn release];
	[data release];
	
	[super dealloc];
}

- (void)fetch {
	// Make a request.
	NSMutableURLRequest* photoRequest = [[[NSMutableURLRequest alloc] initWithURL:self.url] autorelease];
	[photoRequest setHTTPMethod:@"GET"];
	[[AuthContext context] addOAuthHeaderToNSRequest:photoRequest];
	self.conn = [NSURLConnection connectionWithRequest:photoRequest delegate:self];
}

// ================
// NSURLConnection delegate implementation

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Failed to finish user photo retrieval: %@", error);
	
	// Report to the delegate.
	[self.delegate photoRetrievalCompleted:self.tag image:nil];
	
	// Reset state.
	self.data = nil;
	self.conn = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	self.data = [NSMutableData dataWithCapacity:1024];
	[self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)inData {
	[self.data appendData:inData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	UIImage* image = [UIImage imageWithData:self.data];
	
	// Report to the delegate.
	[self.delegate photoRetrievalCompleted:self.tag image:image];
	
	// Reset state.
	self.data = nil;
	self.conn = nil;
}

@end
