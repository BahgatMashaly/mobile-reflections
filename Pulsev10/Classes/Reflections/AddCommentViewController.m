//
//  AddCommentViewController.m
//  MobileJabber
//
//  Created by Nguyen Thanh Son on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AddCommentViewController.h"

@implementation AddCommentViewController

- (IBAction)clickCancel:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)clickResetComment:(id)sender
{
	[txtCommentTitle setText:@""];
	[txtCommentContent setText:@""];
}

- (IBAction)clickPostComment:(id)sender
{
	if (reflection_id > 0)
	{
		//save to arrCommentList : id, title, content, date, reflection_id, user_id
		NSDate *date = [NSDate date];
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"EEEE MMMM d, YYYY"]; //example : Saturday November 22, 2008
		NSString *aDate = [dateFormat stringFromDate:date];  
		[dateFormat release];
		
		int max = [common findMax:[[appDelegate objOutput] arrCommentList]] + 1;
		NSArray *arrObject = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:max], [txtCommentTitle text], [txtCommentContent text], aDate, [NSNumber numberWithInt:reflection_id], [appDelegate strUserName], nil];
		[[[appDelegate objOutput] arrCommentList] addObject:arrObject];
		
		[self clickResetComment:nil];
		[common alertCommentPosted];
	}
}

- (void)setReflectionID:(int)aValue
{
	reflection_id = aValue;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	appDelegate = (MobileJabberAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

@end
