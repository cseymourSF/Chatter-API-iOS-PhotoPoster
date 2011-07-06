//
//  RootViewController.h
//  PhotoPoster
//
//  Created by Chris Seymour on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "include/RestKit/RestKit.h"

#import "OAuthViewController.h"
#import "GroupPickerController.h"
#import "User.h"
#import "PhotoFetcher.h"

@interface RootViewController : UIViewController<RKObjectLoaderDelegate, PhotoFetcherDelegate> {
	UIButton* postBtn;
	UILabel* stateLbl;
	UILabel* nameLbl;
	UILabel* titleLbl;
	UIImageView* picView;
	UIView* infoView;
	
	User* user;
	PhotoFetcher* photoFetcher;
}

@property (nonatomic, retain) IBOutlet UIButton* postBtn;
@property (nonatomic, retain) IBOutlet UILabel* stateLbl;
@property (nonatomic, retain) IBOutlet UILabel* nameLbl;
@property (nonatomic, retain) IBOutlet UILabel* titleLbl;
@property (nonatomic, retain) IBOutlet UIImageView* picView;
@property (nonatomic, retain) IBOutlet UIView* infoView;

- (void)initRestKit;
- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)postPhotoToGroup:(id)sender;

@end
