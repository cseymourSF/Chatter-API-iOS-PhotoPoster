//
//  Config.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Config : NSObject {

}

+(NSString*)consumerKey;
+(NSString*)callbackUrl;
+(NSString*)tokenUrlServer;
+(NSString*)tokenUrlPath;
+(NSString*)loginUrl;

@end
