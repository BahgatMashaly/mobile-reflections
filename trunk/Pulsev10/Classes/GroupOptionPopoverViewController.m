    //
//  GroupOptionPopoverViewController.m
//  MobileJabber
//
//  Created by jigar shah on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupOptionPopoverViewController.h"



@implementation GroupOptionPopoverViewController

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
    if (ISDEVELOPMENT) {
        [aryFields addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Start Class", @"field", @"group chat.png", @"icon", nil]];
    }
	[aryFields addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Group Chat", @"field", @"group chat.png", @"icon", nil]];
    /*
    if (ISDEVELOPMENT) {
        [aryFields addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Group File Transfer", @"field", @"group file transfer.png", @"icon", nil]];
    }
     */
	[aryFields addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Poll", @"field", @"poll.png", @"icon", nil]];
    if (ISDEVELOPMENT) {
        [aryFields addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Asessment", @"field", @"assessment.png", @"icon", nil]];
    }
    [aryFields addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Progress Tracker", @"field", @"iprogress.png", @"icon", nil]];

	objDatasource = [[GroupPopoverTableDatasource alloc] initWithArray:aryFields parent:self];
	objDelegate = [[GroupPopoverTableDelegate alloc] initWithArray:aryFields];
	[tblOptionView setDataSource:objDatasource];
	[tblOptionView setDelegate:objDelegate];
	[tblOptionView reloadData];
//	[(MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate] setAryGroupOption:[NSMutableArray arrayWithArray:aryFields]];
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
	[tbcCustomCell release];
    [super dealloc];
}


@end
