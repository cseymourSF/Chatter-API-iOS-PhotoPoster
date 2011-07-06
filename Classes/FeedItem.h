//
//  FeedItem.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "include/RestKit/RestKit.h"
#import "User.h"

@interface FeedItem : NSObject {
	NSString* feedItemId;
	NSString* bodyText;
	NSString* createdDate;
	NSString* parentId;
	NSString* parentName;
	NSString* type;
	User* author;
}

+ (RKObjectMapping*)objectMapping;

@property(nonatomic, retain) NSString* feedItemId;
@property(nonatomic, retain) NSString* bodyText;
@property(nonatomic, retain) NSString* createdDate;
@property(nonatomic, retain) NSString* parentId;
@property(nonatomic, retain) NSString* parentName;
@property(nonatomic, retain) NSString* type;
@property(nonatomic, retain) User* author;

@end
