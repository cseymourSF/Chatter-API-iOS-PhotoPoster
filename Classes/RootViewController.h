//
//  RootViewController.h
//  PhotoPoster
//
//  Created by Chris Seymour on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthContext.h"
#import "OAuthViewController.h"
#import "User.h"
#import "PhotoFetcher.h"

@interface RootViewController : UIViewController<RKObjectLoaderDelegate, PhotoFetcherDelegate, AccessTokenRefreshDelegate> {
	UIButton* exploreBtn;
	UIButton* loginBtn;
	UIButton* logoutBtn;
	UILabel* stateLbl;
	UILabel* nameLbl;
	UILabel* titleLbl;
	UIImageView* picView;
	UIView* infoView;
	
	User* user;
	PhotoFetcher* photoFetcher;
}

@property (nonatomic, retain) IBOutlet UIButton* exploreBtn;
@property (nonatomic, retain) IBOutlet UIButton* loginBtn;
@property (nonatomic, retain) IBOutlet UIButton* logoutBtn;
@property (nonatomic, retain) IBOutlet UILabel* stateLbl;
@property (nonatomic, retain) IBOutlet UILabel* nameLbl;
@property (nonatomic, retain) IBOutlet UILabel* titleLbl;
@property (nonatomic, retain) IBOutlet UIImageView* picView;
@property (nonatomic, retain) IBOutlet UIView* infoView;

- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)exploreGroups:(id)sender;
- (void)processCallbackUrl:(NSURL*)callbackUrl;

@end
