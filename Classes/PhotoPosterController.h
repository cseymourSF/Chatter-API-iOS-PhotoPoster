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
	UILabel* groupLbl;
	UITextField* descField;
	UITextField* messageField;
	UIButton* postBtn;
	
	CGFloat keyboardOffset;
	NSURLConnection* conn;
	NSMutableData* responseData;
}

- (IBAction)post:(id)sender;
- (IBAction)chooseGroup:(id)sender;
- (IBAction)choosePhoto:(id)sender;

@property(nonatomic,retain) UIImage* image;
@property(nonatomic,retain) Group* group;
@property(nonatomic, retain) IBOutlet UIImageView* imageView;
@property(nonatomic, retain) IBOutlet UILabel* groupLbl;
@property(nonatomic, retain) IBOutlet UITextField* descField;
@property(nonatomic, retain) IBOutlet UITextField* messageField;
@property(nonatomic, retain) IBOutlet UIButton* postBtn;

@end
