//
//  GroupPickerController.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "GroupsPage.h"
#import "ObjectFetcher.h"
#import "ImagePickerViewController.h";

@interface GroupPickerController : UIViewController<ObjectFetcherDelegate, UITableViewDataSource, UITableViewDelegate> {
	UITableView* tableView;
	
	ImagePickerViewController* imagePickerController;
	
	UIImage* photo;
	
	GroupsPage* currentGroups;
	ObjectFetcher* groupsFetcher;
	Group* selectedGroup; // not retained.
}

- (void)reset;

@property (nonatomic, retain) UIImage* photo;
@property (nonatomic, retain) IBOutlet UILabel* nameLbl;
@property (nonatomic, retain) IBOutlet UILabel* titleLbl;
@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end
