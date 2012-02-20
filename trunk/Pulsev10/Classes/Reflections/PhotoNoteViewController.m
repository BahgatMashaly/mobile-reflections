//
//  PhotoNoteViewController.m
//  MobileJabber
//
//  Created by Nguyen Thanh Son on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoNoteViewController.h"
#define kResizeThumbSize 44

@implementation PhotoNoteViewController

- (void)refreshPhoto
{
	//set image to image view
	imgPhoto.image = nil;
	CGFloat width = source.size.width;
	CGFloat height = source.size.height;
	
	CGFloat screenWidth = self.view.frame.size.width;
	CGFloat screenHeight = self.view.frame.size.height;
	
	if (width > screenWidth) width = screenWidth;
	if (height > screenHeight) height = screenHeight;
	
	[imgPhoto setFrame:CGRectMake(0, 0, width, height)];
	[imgPhoto setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
	[imgPhoto setImage:source];
}

- (void)showToolbar
{
	[toolbar setHidden:NO];
	[imgResize setHidden:NO];
}

- (void)hideToolbar
{
	[toolbar setHidden:YES];
}

- (void)showHideToolbar
{
	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: 0.75];
	
	if ([toolbar alpha] == 0.0) [toolbar setAlpha:1.0];
	else [toolbar setAlpha:0.0];
	
	[UIView commitAnimations];
	
	if ([toolbar alpha] == 0.0) [self hideToolbar];
	else [self showToolbar];
}

- (IBAction)clickChangePicture:(id)sender
{
	if (sourceType == 1)
	{
		if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		{
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
			picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
			picker.allowsEditing = NO;
			picker.delegate = self;
			
			[self presentModalViewController:picker animated:YES];
			[picker release];
		}
		else [common alertCameraNotSupport];
	}
	else
	{
		if (aPopover) [aPopover dismissPopoverAnimated:NO];
		
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		
		aPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
		[aPopover setPopoverContentSize:picker.view.frame.size];
		[picker release];
		[aPopover setDelegate:self];
		[aPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:NO];
	}
}

- (IBAction)clickDelete:(id)sender
{
	[self.view removeFromSuperview];
}

- (IBAction)clickDone:(id)sender
{
	[self hideToolbar];
	
	[imgResize setHidden:YES];
}

- (void)setSource:(UIImage *)img
{
	if ([img isKindOfClass:[UIImage class]])
	{
		source = [img retain];
		[self refreshPhoto];
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	source = [info objectForKey:UIImagePickerControllerOriginalImage];
	[self refreshPhoto];
	[aPopover dismissPopoverAnimated:NO];
}

#pragma mark - Photo Gesture Recognizer : Pan, Pinch, Rotation

- (void)forceBoundaryCheck
{
	// Uncomment to force boundary checks
	CGAffineTransform concat;
	
	if (imgPhoto.frame.origin.x < 0)
	{
		concat = CGAffineTransformConcat(imgPhoto.transform, CGAffineTransformMakeTranslation(-imgPhoto.frame.origin.x, 0.0f));
		imgPhoto.transform = concat;
	}
	
	if (imgPhoto.frame.origin.y < 0)
	{
		concat = CGAffineTransformConcat(imgPhoto.transform, CGAffineTransformMakeTranslation(0.0f, -imgPhoto.frame.origin.y));
		imgPhoto.transform = concat;
	}
	
	float dx = (imgPhoto.frame.origin.x + imgPhoto.frame.size.width) - imgPhoto.superview.frame.size.width;
	if (dx > 0.0f)
	{
		concat = CGAffineTransformConcat(imgPhoto.transform, CGAffineTransformMakeTranslation(-dx, 0.0f));
		imgPhoto.transform = concat;
	}
	
	float dy = (imgPhoto.frame.origin.y + imgPhoto.frame.size.height) - imgPhoto.superview.frame.size.height;
	if (dy > 0.0f)
	{
		concat = CGAffineTransformConcat(imgPhoto.transform, CGAffineTransformMakeTranslation(0.0f, -dy));
		imgPhoto.transform = concat;
	}
	
	//NSLog(@"X=%f - Y=%f - Width=%f - Height=%f", imgPhoto.frame.origin.x, imgPhoto.frame.origin.y, imgPhoto.frame.size.width, imgPhoto.frame.size.height);
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer
{
	[self showToolbar];

	CGPoint translation = [recognizer translationInView:self.view];
	recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
	[recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
	/*
	if (recognizer.state == UIGestureRecognizerStateEnded)
	{
		CGPoint velocity = [recognizer velocityInView:self.view];
		CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
		CGFloat slideMult = magnitude / 200;
		//NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
		
		float slideFactor = 0.1 * slideMult; // Increase for more of a slide
		CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor), 
										 recognizer.view.center.y + (velocity.y * slideFactor));
		finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
		finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
		
		[UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{recognizer.view.center = finalPoint;} completion:nil];
	}
	*/
	[self forceBoundaryCheck];
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
	[self showToolbar];

	recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
	recognizer.scale = 1;
	
	[self forceBoundaryCheck];
}

- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer
{
	[self showToolbar];

	recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
	recognizer.rotation = 0;
	
	[self forceBoundaryCheck];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

- (void)forceSelfViewBoundaryCheck
{
	// Uncomment to force boundary checks
	CGAffineTransform concat;
	
	if (self.view.frame.origin.x < 0)
	{
		concat = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeTranslation(-self.view.frame.origin.x, 0.0f));
		self.view.transform = concat;
	}
	
	if (self.view.frame.origin.y < 0)
	{
		concat = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeTranslation(0.0f, -self.view.frame.origin.y));
		self.view.transform = concat;
	}
	
	float dx = (self.view.frame.origin.x + self.view.frame.size.width) - self.view.superview.frame.size.width;
	if (dx > 0.0f)
	{
		concat = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeTranslation(-dx, 0.0f));
		self.view.transform = concat;
	}
	
	float dy = (self.view.frame.origin.y + self.view.frame.size.height) - self.view.superview.frame.size.height;
	if (dy > 0.0f)
	{
		concat = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeTranslation(0.0f, -dy));
		self.view.transform = concat;
	}
	
	//NSLog(@"X=%f - Y=%f - Width=%f - Height=%f", imgPhoto.frame.origin.x, imgPhoto.frame.origin.y, imgPhoto.frame.size.width, imgPhoto.frame.size.height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	touchStart = [[touches anyObject] locationInView:self.view];
	isResizing = (self.view.bounds.size.width - touchStart.x < kResizeThumbSize && self.view.bounds.size.height - touchStart.y < kResizeThumbSize);
	
	if (isResizing)
	{
		touchStart = CGPointMake(touchStart.x - self.view.bounds.size.width, touchStart.y - self.view.bounds.size.height);
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
	
	if (isResizing)
	{
		CGFloat width = touchPoint.x - touchStart.x;
		CGFloat height = touchPoint.y - touchStart.y;
		CGFloat imgWidth = imgPhoto.frame.size.width;
		CGFloat imgHeight = imgPhoto.frame.size.height + 44;
		
		if (width < imgWidth) width = imgWidth;
		if (height < imgHeight) height = imgHeight;
		
		self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, width, height);
		
		//resize all objects
		CGRect frame;
		CGFloat viewWidth = self.view.frame.size.width;
		CGFloat viewHeight = self.view.frame.size.height;
		int x, y;
		
		x = viewWidth - kResizeThumbSize - 1;
		y = viewHeight - kResizeThumbSize - 1;
		frame = CGRectMake(x, y, kResizeThumbSize, kResizeThumbSize);
		[imgResize setFrame:frame];
		//[imgTextBG setFrame:self.view.bounds];
		[toolbar setFrame:CGRectMake(0, height - 44, width, 44)];
	}
	else
	{
		self.view.center = CGPointMake(self.view.center.x + touchPoint.x - touchStart.x, self.view.center.y + touchPoint.y - touchStart.y);
		[self forceSelfViewBoundaryCheck];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2)
	{
		[self showToolbar];
	}
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	[source release];
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

@end
