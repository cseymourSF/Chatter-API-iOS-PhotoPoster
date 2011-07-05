//
//  GroupPickerController.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupPickerController.h"
#import "User.h"
#import "AuthContext.h"
#import "PostResultController.h"

@implementation GroupPickerController

@synthesize nameLbl;
@synthesize titleLbl;
@synthesize tableView;
@synthesize photo;

- (id)init {
	self = [super initWithNibName:@"GroupPickerController" bundle:nil];
	if (self != nil) {
	}
	return self;
}

- (void)dealloc {
	[nameLbl release];
	[titleLbl release];
	[groupsFetcher release];
	[currentGroups release];
	[tableView release];
	[imagePickerController release];
	[photo release];
	
    [super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
		
	// Request population of groups page by RestKit.
	currentGroups = [[GroupsPage alloc] init];
	groupsFetcher = [[ObjectFetcher alloc] initWithTag:@"groups" object:currentGroups delegate:self];
	[groupsFetcher fetch];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (self.photo != nil) {
		// Push on the PostResultController and reset state so this view controller can be re-used later.
		PostResultController* postResultController = [[[PostResultController alloc] initWithGroup:selectedGroup image:photo] autorelease];
		[self reset];
		[self.navigationController pushViewController:postResultController animated:YES];
	}
}

- (void)reset {
	self.photo = nil;
	selectedGroup = nil;
}

// ObjectFetcherDelegate implementation.
- (void)retrievalCompleted:(NSString*)tag withSuccess:(bool)succeeded {
	[tableView reloadData];
}

// UITableViewDataSource implementation.
- (UITableViewCell *)tableView:(UITableView *)tableViewIn cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* cellIdent = @"groupListCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent] autorelease];
	}
	
	Group* group = [[currentGroups groups] objectAtIndex:indexPath.row];
	[[cell textLabel] setText:[group name]];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (currentGroups == nil || section != 0) {
		return 0;
	} else {
		return [[currentGroups groups] count];
	}
}

// UITableViewDelegate implementation.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	selectedGroup = [[currentGroups groups] objectAtIndex:indexPath.row];

	// Show image picker.
	imagePickerController = [[ImagePickerViewController alloc] initWithParent:self];
	[[self navigationController] pushViewController:imagePickerController animated:YES];
}

@end
