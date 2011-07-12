//
//  ObjectFetcher.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@protocol ObjectFetcherDelegate<NSObject>
- (void)retrievalCompleted:(NSString*)tag withSuccess:(bool)succeeded; 
@end

@interface ObjectFetcher : NSObject<RKObjectLoaderDelegate> {
	NSString* tag;
	id obj;
	NSObject<ObjectFetcherDelegate>* delegate;
}

@property(nonatomic, retain) NSString* tag;
@property(nonatomic, retain) id obj;
@property(nonatomic, assign) NSObject<ObjectFetcherDelegate>* delegate;

// We assume the delegate will outlive this object, it is not retained.
- initWithTag:(NSString*)inTag object:(id)inObj delegate:(NSObject<ObjectFetcherDelegate>*)inDelegate;

- (void)fetch;

@end
