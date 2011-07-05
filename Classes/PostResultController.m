//
//  PostResultController.m
//  PhotoPoster
//
//  Created by Chris Seymour on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PostResultController.h"
#import "AuthContext.h"

@implementation PostResultController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@synthesize image;
@synthesize imageView;
@synthesize groupLbl;
@synthesize resultLbl;
@synthesize group;
@synthesize descField;
@synthesize textField;

- (id)initWithGroup:(Group*)groupIn image:(UIImage*)imageIn {
	self = [super initWithNibName:@"PostResultController" bundle:nil];
	if (self != nil) {
		self.image = imageIn;
		self.group = groupIn;
		keyboardOffset = 0;
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[self.imageView setImage:self.image];
	[self.groupLbl setText:[self.group name]];
	[self.resultLbl setText:@""];
	
	keyboardOffset = 0;
	
	[super viewWillAppear:animated];
}

+ (NSString*)addTextParam:(NSString*)param value:(NSString*)value body:(NSString*)body boundary:(NSString*)boundary {
	NSString* start = [NSString stringWithFormat:@"%@Content-Disposition: form-data; name=\"%@\"\r\n\r\n", body, param];
	return [NSString stringWithFormat:@"%@%@%@", start, value, boundary];
}

-(IBAction)post:(id)sender {
	[self recenter];
	
	// Post the photo to the group, using a regular HTTP POST because
	// RestKit doesn't support multipart posts yet.
	NSString* targetUrl = [NSString stringWithFormat:@"%@/services/data/v22.0/chatter/feeds/record/%@/feed-items", [[AuthContext context] instanceUrl], [self.group groupId]];
	
	// Make the request.
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:targetUrl]
										   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData // Don't use the cache.
									   timeoutInterval:60];
	
	[[AuthContext context] addOAuthHeaderToNSRequest:request];
	[request setHTTPMethod:@"POST"];
	
	NSString* boundary = @"-----------------2342342352342343";
	
	[request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
			 forHTTPHeaderField:@"Content-Type"];
	
	// Write the body.
	NSString* boundaryBreak = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];
	NSString* body = boundaryBreak;
	
	body = [PostResultController addTextParam:@"text" value:[textField text] body:body boundary:boundaryBreak];
	body = [PostResultController addTextParam:@"desc" value:[descField text] body:body boundary:boundaryBreak];
	
	NSDateFormatter* dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"M/d/y h:m:s"];
	NSString* date = [dateFormat stringFromDate:[NSDate date]];
	
	NSString* filenameStr = [NSString stringWithFormat:@"blah %@.jpg", date];
	
	body = [PostResultController addTextParam:@"fileName" value:filenameStr body:body boundary:boundaryBreak];

	body = [NSString stringWithFormat:@"%@Content-Disposition: form-data; name=\"feedItemFileUpload\"; filename=\"%@\"\r\n", body, filenameStr];
	body = [NSString stringWithFormat:@"%@Content-Type: application/octet-stream\r\n\r\n", body];

	NSMutableData* bodyData = [NSMutableData data];
	[bodyData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSData* imageData = UIImageJPEGRepresentation(self.image, 90);
	[bodyData appendData:imageData];

	NSData* boundaryDataEnd = [[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
	[bodyData appendData:boundaryDataEnd];
	
	[request setHTTPBody:bodyData];
	
	// Send the request asynchronously.
	conn = [[NSURLConnection connectionWithRequest:request delegate:self] retain];
}

- (IBAction)done:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc {
	[conn release];
	[responseData release];
	[image release];
	[group release];
	[imageView release];
	[groupLbl release];
	[resultLbl release];
	[textField release];
	[descField release];
	
    [super dealloc];
}

// ================
// NSURLConnection delegate methods

- (void)clearConnectionState {
	// Reset state.
	[conn release];
	[responseData release];
	conn = nil;
	responseData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Failed to finish photo post: %@", error);
	
	[self clearConnectionState];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData release];
	responseData = [[NSMutableData dataWithCapacity:1024] retain];
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)inData {
	[responseData appendData:inData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString* responseStr = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"Response: %@", responseStr);
	
	if ([responseStr rangeOfString:@"error"].location == NSNotFound) {
		resultLbl.text = @"Successful";
	} else {
		resultLbl.text = @"Failure";
	}
	
	// TODO: Use RestKit to translate response into a feed item representation...
	
	[self clearConnectionState];
}

// =================
// Text field delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textFieldIn {
	// From http://cocoawithlove.com/2008/10/sliding-uitextfields-around-to-avoid.html
	
    CGRect textFieldRect = [self.view.window convertRect:textFieldIn.bounds fromView:textFieldIn];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
	
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
	CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
	CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
	CGFloat heightFraction = numerator / denominator;
	if (heightFraction < 0.0)
	{
        heightFraction = 0.0;
	}
	else if (heightFraction > 1.0)
	{
		heightFraction = 1.0;
	}
	
	UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
	if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
		keyboardOffset = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
	}
	else {
		keyboardOffset = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
	}
	
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y -= keyboardOffset;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	
	[self.view setFrame:viewFrame];
	
	[UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self recenter];
}

- (void)recenter {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += keyboardOffset;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
	
	keyboardOffset = 0;
	
	// Clear the keyboard.
	[self.textField resignFirstResponder];
	[self.descField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textFieldIn {
    [textFieldIn resignFirstResponder];
    return YES;
}

@end
