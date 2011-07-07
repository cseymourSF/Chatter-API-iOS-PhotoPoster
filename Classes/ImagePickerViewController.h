//
//  ImagePickerViewController.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class PhotoPosterController;

@interface ImagePickerViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	UIImageView* imageView;
	UIButton* useBtn;
	
	PhotoPosterController* parent; // not retained
}

@property(nonatomic, retain) IBOutlet UIImageView* imageView;
@property(nonatomic, retain) IBOutlet UIButton* useBtn;

-(id)initWithParent:(PhotoPosterController*)parentIn;

-(IBAction)snapCameraPhoto:(id)sender;
-(IBAction)pickLibraryPhoto:(id)sender;
-(IBAction)usePhoto:(id)sender;

@end
