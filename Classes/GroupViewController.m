//
//  GroupViewController.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupViewController.h"
#import "PhotoPosterController.h"
#import "FeedItem.h"

@implementation GroupViewController

@synthesize imageView;
@synthesize feedTable;
@synthesize nameLbl;

-(id)initWithGroup:(Group*)groupIn {
	self = [super init];
	if (self != nil) {
		group = [groupIn retain];
	}	
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[nameLbl setText:group.name];
	
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	// Fetch the group photo.
	[photoFetcher release];
	photoFetcher = [[PhotoFetcher alloc] initWithTag:@"groupPhoto" photoUrl:group.largePhotoUrl delegate:self];
	[photoFetcher fetch];
	
	// Fetch the group feed.
	[feed release];
	feed = [[FeedItemPage alloc] init];
	[feed setRecordId:[group groupId]];
	
	[feedFetcher release];
	feedFetcher = [[ObjectFetcher alloc] initWithTag:@"groupFeed" object:feed delegate:self];
	[feedFetcher fetch];
	
	[super viewDidAppear:animated];
}

- (void)dealloc {
	[feed release];
	[group release];
	[photoFetcher release];
	[feedFetcher release];
	[nameLbl release];
	[feedTable release];
	[imageView release];
	
    [super dealloc];
}

- (IBAction)postPhoto:(id)sender {
	PhotoPosterController* photoPosterController = [[[PhotoPosterController alloc] initWithGroup:group] autorelease];
	[self.navigationController pushViewController:photoPosterController animated:YES];
}

// PhotoFetcherDelegate implementation.
- (void)retrievalCompleted:(NSString*)tag image:(UIImage*)image {
	[imageView setImage:image];
}

// ObjectFetcherDelegate implementation.
- (void)retrievalCompleted:(NSString*)tag withSuccess:(bool)succeeded {
	// feed is populated, so tell the table to reload its data.
	[feedTable reloadData];
}

// UITableViewDataSource implementation.
- (UITableViewCell *)tableView:(UITableView *)tableViewIn cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* cellIdent = @"groupFeedCell";
	
	UITableViewCell *cell = [feedTable dequeueReusableCellWithIdentifier:cellIdent];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent] autorelease];
	}
	
	FeedItem* feedItem = [[feed items] objectAtIndex:indexPath.row];
	[[cell textLabel] setText:[NSString stringWithFormat:@"%@: %@", [[feedItem author] name], [feedItem bodyText]]];
	[[cell textLabel] setFont:[UIFont systemFontOfSize:11.0]];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (feed == nil || section != 0) {
		return 0;
	} else {
		return [[feed items] count];
	}
}

@end
