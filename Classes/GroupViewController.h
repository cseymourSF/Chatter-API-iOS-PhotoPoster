//
//  GroupViewController.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Group.h"
#import "PhotoFetcher.h"
#import "ObjectFetcher.h"
#import "FeedItemPage.h"

@interface GroupViewController : UIViewController<PhotoFetcherDelegate, ObjectFetcherDelegate, UITableViewDataSource> {
	Group* group;
	PhotoFetcher* photoFetcher;
	ObjectFetcher* feedFetcher;
	FeedItemPage* feed;
	
	UIImageView* imageView;
	UITableView* feedTable;
	UILabel* nameLbl;
}

-(id)initWithGroup:(Group*)groupIn;
- (IBAction)postPhoto:(id)sender;

@property(nonatomic, retain) IBOutlet UILabel* nameLbl;
@property(nonatomic, retain) IBOutlet UIImageView* imageView;
@property(nonatomic, retain) IBOutlet UITableView* feedTable;

@end
