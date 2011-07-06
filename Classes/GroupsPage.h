//
//  GroupsPage.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "include/RestKit/RestKit.h"
#import "Group.h"

@interface GroupsPage : NSObject {
	NSString* currentPageUrl;
	NSString* nextPageUrl;
	NSString* previousPageUrl;
	int total;
	NSArray* groups; // Holds Groups
}

@property(nonatomic, retain) NSString* currentPageUrl;
@property(nonatomic, retain) NSString* nextPageUrl;
@property(nonatomic, retain) NSString* previousPageUrl;
@property(nonatomic, retain) NSArray* groups;

+(void)setupMapping:(RKObjectManager*)manager;

@end
