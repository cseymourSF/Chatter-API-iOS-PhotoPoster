//
//  GroupPickerController.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupPickerController.h"
#import "AuthContext.h"
#import "PhotoPosterController.h"
#import "GroupViewController.h"

@implementation GroupPickerController

@synthesize tableView;

-(id)init {
	self = [super initWithNibName:@"GroupPickerController" bundle:nil];
	if (self != nil) {
	}
	return self;
}

- (void)dealloc {
	[groupsFetcher release];
	[followedGroups release];
	[tableView release];
	
    [super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
		
	// Request population of first followed groups page.
	followedGroups = [[GroupsPage alloc] init];
	groupsFetcher = [[ObjectFetcher alloc] initWithTag:@"groups" object:followedGroups delegate:self];
	[groupsFetcher fetch];
}

// ObjectFetcherDelegate implementation.
- (void)retrievalCompleted:(NSString*)tag withSuccess:(bool)succeeded {
	[tableView reloadData];
}

// UITableViewDataSource implementation.
- (UITableViewCell *)tableView:(UITableView *)tableViewIn cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* cellIdent = @"groupListCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent] autorelease];
	}
	
	Group* group = [[followedGroups groups] objectAtIndex:indexPath.row];
	[[cell textLabel] setText:[group name]];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (followedGroups == nil || section != 0) {
		return 0;
	} else {
		return [[followedGroups groups] count];
	}
}

// UITableViewDelegate implementation.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Push in a new GroupViewController using the selected group.
	Group* selectedGroup = [[followedGroups groups] objectAtIndex:indexPath.row];
	GroupViewController* groupViewController = [[[GroupViewController alloc] initWithGroup:selectedGroup] autorelease];
	[self.navigationController pushViewController:groupViewController animated:YES];
}

@end
