    //
//  UserOptionPopoverViewController.m
//  MobileJabber
//
//  Created by jigar shah on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserOptionPopoverViewController.h"


@implementation UserOptionPopoverViewController

@synthesize tbcCustomCell;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	aryFields = [[NSMutableArray alloc] init];
	[aryFields addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Contact Information", @"field", @"peer review.png", @"icon", nil]];
	[aryFields addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Chat", @"field", @"Chat.png", @"icon", nil]];
    /*
	[aryFields addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"File Transfer", @"field", @"group file transfer.png", @"icon", nil]];
	[aryFields addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Email", @"field", @"assessment.png", @"icon", nil]];
     */
	objDatasource = [[UserPopOverTableViewDatasource alloc] initWithArray:aryFields parent:self];
	objDelegate = [[UserPopOverTableViewDelegate alloc] initWithArray:aryFields];
	[tblView setDataSource:objDatasource];
	[tblView setDelegate:objDelegate];
	[tblView reloadData];
	//[(MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate] setAryUserOption:[NSMutableArray arrayWithArray:aryFields]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

@end
