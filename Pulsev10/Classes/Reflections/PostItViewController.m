//
//  PostItViewController.m
//  MobileJabber
//
//  Created by Nguyen Thanh Son on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostItViewController.h"
#import "Define.h"

@implementation PostItViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	touchStart = [[touches anyObject] locationInView:self.view];
}

- (void)fixPosition
{
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
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
	
	self.view.center = CGPointMake(self.view.center.x + touchPoint.x - touchStart.x, self.view.center.y + touchPoint.y - touchStart.y);
	
	// Uncomment to force boundary checks
	[self fixPosition];
}

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

#pragma mark - View lifecycle

- (void)dealloc {
    RELEASE_SAFE(imgNoteBG);
    RELEASE_SAFE(txtContent);
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [txtContent becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

@end
