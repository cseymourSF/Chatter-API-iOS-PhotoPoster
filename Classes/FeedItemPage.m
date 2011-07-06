//
//  FeedItemPage.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedItemPage.h"
#import "FeedItem.h"

@implementation FeedItemPage

@synthesize currentPageUrl;
@synthesize nextPageUrl;
@synthesize items;
@synthesize recordId;

+(void)setupMapping:(RKObjectManager*)manager {
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[FeedItemPage class]];
	[mapping mapAttributes:@"currentPageUrl", @"nextPageUrl", nil];
	[mapping hasMany:@"items" withObjectMapping:[FeedItem objectMapping]];

	[manager.router routeClass:[FeedItemPage class] toResourcePath:@"/services/data/v22.0/chatter/feeds/record/(recordId)/feed-items" forMethod:RKRequestMethodGET];
	[manager.mappingProvider addObjectMapping:mapping];
}

- (void)dealloc {
	[currentPageUrl release];
	[nextPageUrl release];
	[recordId release];
	[items release];
	
	[super dealloc];
}

@end
