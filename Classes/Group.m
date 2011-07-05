//
//  Group.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Group.h"


@implementation Group

@synthesize groupId;
@synthesize description;
@synthesize memberCount;
@synthesize name;
@synthesize url;
@synthesize visibility;

+ (RKObjectMapping*)objectMapping {
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[Group class]];
	[mapping mapAttributes:@"description", @"memberCount", @"name", @"url", @"visibility", nil];
	[mapping addAttributeMapping:[RKObjectAttributeMapping mappingFromKeyPath:@"id" toKeyPath:@"groupId"]];
	return mapping;
}

- (void)dealloc {
	[groupId release];
	[description release];
	[name release];
	[url release];
	[visibility release];
	
	[super dealloc];
}

@end
