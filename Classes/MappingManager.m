
#import "MappingManager.h"
#import "AuthContext.h"

#import "User.h"
#import "GroupsPage.h"
#import "FeedItemPage.h"

@implementation MappingManager

+ (void)initMappings {		
	// Set-up the RestKit manager.
	RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[[AuthContext context] instanceUrl]];
	[RKObjectManager setSharedManager:manager];
	
	// Initialize mappings.
	[User setupMapping:manager];
	[GroupsPage setupMapping:manager];
	[FeedItemPage setupMapping:manager];
	
	// RestKit logging.
	RKLogConfigureByName("RestKit", RKLogLevelDebug);
    RKLogConfigureByName("RestKit/Network", RKLogLevelDebug);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
    RKLogConfigureByName("RestKit/Network/Queue", RKLogLevelDebug);
}

+ (void)initialize
{
    static BOOL initialized = NO;
	if (initialized) {
		// Reset the base URL.
		[RKObjectManager sharedManager].client.baseURL = [[AuthContext context] instanceUrl];		
	} else {
		// Initialize the mappings.
		[MappingManager initMappings];
		
        initialized = YES;
    }
}

@end
