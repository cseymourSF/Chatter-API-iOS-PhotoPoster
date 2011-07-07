//
//  ImagePickerViewController.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "PhotoPosterController.h"

@implementation ImagePickerViewController

@synthesize imageView;
@synthesize useBtn;

- (id)initWithParent:(PhotoPosterController*)parentIn {
	self = [super initWithNibName:@"ImagePickerViewController" bundle:nil];
	if (self != nil) {
		parent = parentIn;
	}
	return self;
}

- (void)dealloc {
	[imageView release];
	[useBtn release];
	
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	if ([self.imageView image] == nil) {
		[self.useBtn setEnabled:NO];
		[self.useBtn setAlpha:0.5];
	} else {
		[self.useBtn setEnabled:YES];
		[self.useBtn setAlpha:1.0];
	}
	
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

-(IBAction)usePhoto:(id)sender {
	[parent setImage:imageView.image];
	
	// Exit.
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

@end
