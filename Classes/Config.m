//
//  Config.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Config.h"

@implementation Config

+(NSString*)getConfigString:(NSString*)name {
	NSString* value = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:name];
	if ((value == nil) || ([value length] <= 0)) {
		NSLog(@"!!!!!!!YOU MUST SET THE %@ VALUE IN THE INFO PLIST FOR THIS APP TO RUN!!!!!!!!!", name);
		[NSThread exit];
	}
	return value;
}	

+(NSString*)consumerKey {
	return [Config getConfigString:@"PPConsumerKey"];
}

+(NSString*)callbackUrl {
	return [Config getConfigString:@"PPCallbackUrl"];
}

+(NSString*)loginUrl {
	return [Config getConfigString:@"PPLoginUrl"];
}

+(NSString*)tokenUrlServer {
	return [Config getConfigString:@"PPTokenUrlServer"];
}

+(NSString*)tokenUrlPath {
	return [Config getConfigString:@"PPTokenUrlPath"];
}

@end
