//
//  PhotoPosterController.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Group.h"

@interface PhotoPosterController : UIViewController {
	UIImage* image;
	Group* group;
	
	UIImageView* imageView;
	UITextField* descField;
	UITextField* messageField;
	UIButton* postBtn;
	
	CGFloat keyboardOffset;
	
	NSMutableData* responseData;
	int statusCode;
}

- (id)initWithGroup:(Group*)groupIn;
- (IBAction)post:(id)sender;
- (IBAction)choosePhoto:(id)sender;

@property(nonatomic,retain) UIImage* image;
@property(nonatomic, retain) IBOutlet UIImageView* imageView;
@property(nonatomic, retain) IBOutlet UITextField* descField;
@property(nonatomic, retain) IBOutlet UITextField* messageField;
@property(nonatomic, retain) IBOutlet UIButton* postBtn;

@end
