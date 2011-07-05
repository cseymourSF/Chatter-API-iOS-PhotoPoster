//
//  ImagePickerViewController.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "GroupPickerController.h"

@implementation ImagePickerViewController

@synthesize imageView;
@synthesize postButton;

- (id)initWithParent:(GroupPickerController*)parentIn {
	self = [super initWithNibName:@"ImagePickerViewController" bundle:nil];
	if (self != nil) {
		parent = parentIn;
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[self.postButton setEnabled:([self.imageView image] != nil)];
	
	[super viewWillAppear:animated];
}

-(IBAction)snapCameraPhoto:(id)sender {
	UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	[self presentModalViewController: picker animated:YES];
}

-(IBAction)pickLibraryPhoto:(id)sender {
	UIImagePickerController* picker = [[[UIImagePickerController alloc] init] autorelease];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
	[self presentModalViewController:picker animated:YES];
}

-(IBAction)postPhoto:(id)sender {
	[parent setPhoto:imageView.image];
	
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)cancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker
	  didFinishPickingImage : (UIImage *)image
				 editingInfo:(NSDictionary *)editingInfo {
	imageView.image = image;
	
	[picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {	
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[imageView release];
	[postButton release];
	
    [super dealloc];
}

@end
