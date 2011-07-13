//
//  PhotoFetcher.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@protocol PhotoFetcherDelegate<NSObject>
- (void)photoRetrievalCompleted:(NSString*)tag image:(UIImage*)image;
@end

@interface PhotoFetcher : NSObject {
	NSString* tag;
	NSURL* url;
	NSURLConnection* conn;
	NSMutableData* data;
	NSObject<PhotoFetcherDelegate>* delegate;
}

@property(nonatomic, retain) NSURLConnection* conn;
@property(nonatomic, retain) NSMutableData* data;
@property(nonatomic, retain) NSURL* url;
@property(nonatomic, retain) NSString* tag;
@property(nonatomic, assign) NSObject<PhotoFetcherDelegate>* delegate;

// We assume the delegate will outlive this object, it is not retained.
- initWithTag:(NSString*)inTag photoUrl:(NSString*)photoUrl delegate:(NSObject<PhotoFetcherDelegate>*)inDelegate;

- (void)fetch;

@end
