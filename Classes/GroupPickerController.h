//
//  GroupPickerController.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupsPage.h"
#import "ObjectFetcher.h"

@class PhotoPosterController;

@interface GroupPickerController : UIViewController<ObjectFetcherDelegate, UITableViewDataSource, UITableViewDelegate> {
	UITableView* tableView;	
	GroupsPage* followedGroups;
	ObjectFetcher* groupsFetcher;
	PhotoPosterController* parent; // not retained
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;

-(id)initWithParent:(PhotoPosterController*)parentIn;

@end
