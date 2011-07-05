//
//  AuthContext.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthContext.h"

@implementation AuthContext

static NSString *const kKeychainItemName = @"PhotoPoster app";
static NSString *const kAccessTokenKey = @"accessToken";
static NSString *const kRefreshTokenKey = @"refreshToken";
static NSString *const kInstanceUrlKey = @"instanceUrl";

static AuthContext* contextSingleton;

@synthesize accessToken;
@synthesize refreshToken;
@synthesize instanceUrl;

+ (void)initialize
{
    static BOOL initialized = NO;
    if (!initialized)
    {
        initialized = YES;
        contextSingleton = [[AuthContext alloc] init];
		[contextSingleton load];
    }
}

+ (AuthContext*)context {
	return contextSingleton;
}

- (void) clear {
	self.accessToken = nil;
	self.refreshToken = nil;
	self.instanceUrl = nil;
	
	[self save];
}

- (void)save {
	// Save config.
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:refreshToken
				 forKey:kRefreshTokenKey];
	[defaults setObject:accessToken 
				 forKey:kAccessTokenKey];
	[defaults setObject:instanceUrl
				 forKey:kInstanceUrlKey];
	[defaults synchronize];
}

- (void)load {
	// Load config.
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	self.accessToken = [defaults stringForKey:kAccessTokenKey];
	self.refreshToken = [defaults stringForKey:kRefreshTokenKey];
	self.instanceUrl = [defaults stringForKey:kInstanceUrlKey];
}

- (NSString*)getOAuthHeaderValue {
	return [NSString stringWithFormat:@"OAuth %@", [self accessToken]];
}

- (void)addOAuthHeader:(RKRequest*)request {
	NSMutableDictionary* headerDict = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
	[headerDict setObject:[self getOAuthHeaderValue] forKey:@"Authorization"];
	[request setAdditionalHTTPHeaders:headerDict];
}

- (void)addOAuthHeaderToNSRequest:(NSMutableURLRequest*)request {
	[request addValue:[self getOAuthHeaderValue] forHTTPHeaderField:@"Authorization"];
}

- (void)dealloc {
	[accessToken release];
	[refreshToken release];
	[instanceUrl release];
	[super dealloc];
}

@end
