//
//  User.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userId;
@synthesize firstName;
@synthesize lastName;
@synthesize name;
@synthesize title;
@synthesize largePhotoUrl;

+(void)setupMapping:(RKObjectManager*)manager {
	RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[User class]];
	[userMapping mapAttributes:@"name", @"title", @"firstName", @"lastName", nil ];
	[userMapping addAttributeMapping:[RKObjectAttributeMapping mappingFromKeyPath:@"id" toKeyPath:@"userId"]];
	[userMapping addAttributeMapping:[RKObjectAttributeMapping mappingFromKeyPath:@"photo.largePhotoUrl" toKeyPath:@"largePhotoUrl"]];

	[manager.router routeClass:[User class] toResourcePath:@"/services/data/v23.0/chatter/users/(userId)" forMethod:RKRequestMethodGET];
	[manager.mappingProvider addObjectMapping:userMapping];
}

- (void)dealloc {
	[userId release];
	[firstName release];
	[lastName release];
	[name release];
	[title release];
	[largePhotoUrl release];
	
	[super dealloc];
}

@end

