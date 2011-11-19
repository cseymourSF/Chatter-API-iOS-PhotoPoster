//
//  FeedItem.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedItem.h"


@implementation FeedItem

@synthesize feedItemId;
@synthesize bodyText;
@synthesize createdDate;
@synthesize parentId;
@synthesize parentName;
@synthesize author;
@synthesize type;

+ (RKObjectMapping*)objectMapping {
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[FeedItem class]];
	[mapping mapAttributes:@"createdDate", @"parentId", @"parentName", @"type", nil];
	[mapping addAttributeMapping:[RKObjectAttributeMapping mappingFromKeyPath:@"id" toKeyPath:@"feedItemId"]];
	[mapping addAttributeMapping:[RKObjectAttributeMapping mappingFromKeyPath:@"body.text" toKeyPath:@"bodyText"]];
	
	// Assuming that User already registered its mapping.
	RKObjectMapping* userMapping = [[[RKObjectManager sharedManager] mappingProvider] objectMappingForClass:[User class]];

	[mapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"actor" toKeyPath:@"author" withMapping:userMapping]];
	return mapping;	
}

- (void)dealloc {
	[feedItemId release];
	[bodyText release];
	[createdDate release];
	[parentId release];
	[parentName release];
	[author release];
	[type release];
	
	[super dealloc];
}

@end
