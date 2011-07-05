//
//  Group.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "include/RestKit/RestKit.h"

@interface Group : NSObject {
	NSString* groupId;
	NSString* description;
	int memberCount;
	NSString* name;
	NSString* url;
	NSString* visibility;
}

@property(nonatomic, retain) NSString* groupId;
@property(nonatomic, retain) NSString* description;
@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSString* url;
@property(nonatomic, retain) NSString* visibility;
@property(readwrite, assign) int memberCount;

+ (RKObjectMapping*)objectMapping;

@end
