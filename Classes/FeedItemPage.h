//
//  FeedItemPage.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@interface FeedItemPage : NSObject {
	NSString* recordId;
	NSString* currentPageUrl;
	NSString* nextPageUrl;
	NSArray* items; // Holds FeedItems
}

@property(nonatomic, retain) NSString* recordId;
@property(nonatomic, retain) NSString* currentPageUrl;
@property(nonatomic, retain) NSString* nextPageUrl;
@property(nonatomic, retain) NSArray* items;


+(void)setupMapping:(RKObjectManager*)manager;
@end
