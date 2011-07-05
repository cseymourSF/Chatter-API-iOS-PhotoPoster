//
//  User.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "include/RestKit/RestKit.h"

@interface User : NSObject {
	NSString* userId;
	NSString* firstName;
	NSString* lastName;
	NSString* name;
	NSString* title;
	NSString* largePhotoUrl;
}

@property(nonatomic, retain) NSString* userId;
@property(nonatomic, retain) NSString* firstName;
@property(nonatomic, retain) NSString* lastName;
@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) NSString* largePhotoUrl;

+(void)setupMapping:(RKObjectManager*)manager;

@end