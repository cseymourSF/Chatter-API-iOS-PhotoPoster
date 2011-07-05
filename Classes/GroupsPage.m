//
//  GroupsPage.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupsPage.h"


@implementation GroupsPage

@synthesize currentPageUrl;
@synthesize nextPageUrl;
@synthesize previousPageUrl;
@synthesize groups;

+(void)setupMapping:(RKObjectManager*)manager {
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[GroupsPage class]];
	[mapping mapAttributes:@"currentPageUrl", @"previousPageUrl", @"nextPageUrl", @"total", nil];
	[mapping hasMany:@"groups" withObjectMapping:[Group objectMapping]];
	
	[manager.router routeClass:[GroupsPage class] toResourcePath:@"/services/data/v22.0/chatter/users/me/groups" forMethod:RKRequestMethodGET];
	[manager.mappingProvider addObjectMapping:mapping];
}

- (void)dealloc {
	[currentPageUrl release];
	[nextPageUrl release];
	[previousPageUrl release];
	[groups release];
	
	[super dealloc];
}

@end
