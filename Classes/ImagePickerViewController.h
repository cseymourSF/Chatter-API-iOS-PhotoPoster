//
//  ImagePickerViewController.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupPickerController;

@interface ImagePickerViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	UIImageView* imageView;
	UIButton* postButton;
	
	GroupPickerController* parent; // not retained
}

@property(nonatomic, retain) IBOutlet UIImageView* imageView;
@property(nonatomic, retain) IBOutlet UIButton* postButton;

-(id)initWithParent:(GroupPickerController*)parentIn;
-(IBAction)snapCameraPhoto:(id)sender;
-(IBAction)pickLibraryPhoto:(id)sender;
-(IBAction)postPhoto:(id)sender;
-(IBAction)cancel:(id)sender;

@end
