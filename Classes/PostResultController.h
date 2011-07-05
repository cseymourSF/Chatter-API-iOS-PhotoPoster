//
//  PostResultController.h
//  PhotoPoster
//
//  Created by Chris Seymour on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Group.h"

@interface PostResultController : UIViewController {
	UIImage* image;
	Group* group;
	
	UIImageView* imageView;
	UILabel* groupLbl;
	UILabel* resultLbl;
	UITextField* descField;
	UITextField* textField;
	
	CGFloat keyboardOffset;
	NSURLConnection* conn;
	NSMutableData* responseData;
}

- (id)initWithGroup:(Group*)groupIn image:(UIImage*)imageIn;
- (void)recenter;

- (IBAction)post:(id)sender;
- (IBAction)done:(id)sender;

@property(nonatomic,retain) UIImage* image;
@property(nonatomic,retain) Group* group;
@property(nonatomic, retain) IBOutlet UIImageView* imageView;
@property(nonatomic, retain) IBOutlet UILabel* groupLbl;
@property(nonatomic, retain) IBOutlet UILabel* resultLbl;
@property(nonatomic, retain) IBOutlet UITextField* descField;
@property(nonatomic, retain) IBOutlet UITextField* textField;

@end
