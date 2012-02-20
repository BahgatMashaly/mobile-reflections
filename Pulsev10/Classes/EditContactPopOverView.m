    //
//  EditContactPopOverView.m
//  MobileJabber
//
//  Created by Shivang Vyas on 9/15/11.
//  Copyright 2011 company. All rights reserved.
//

#import "EditContactPopOverView.h"


@implementation EditContactPopOverView

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
	appDelegate = (MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate];
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


#pragma mark -
#pragma mark DATASOURCE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"EditContactCell" owner:self options:nil];
		cell = tbcCustomCell;
	}
	UISwitch *swtch = (UISwitch*)[cell viewWithTag:1];
	if (appDelegate.isShowOnlineSelected) {
		swtch.on = YES;
	}
	else {
		swtch.on = NO;
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[swtch addTarget:self action:@selector(SwtchValueChanged:) forControlEvents:UIControlEventValueChanged];
	return cell;
}

#pragma mark -
#pragma mark Methods

- (void)SwtchValueChanged:(UISwitch*)swtch {
	if (swtch.on) {
		appDelegate.isShowOnlineSelected = YES;
	}
	else {
		appDelegate.isShowOnlineSelected = NO;
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CONTACTS object:nil];	 
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) dismissToogleContactProfile];
}

- (IBAction)backButtonTapped:(id)sender {
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) dismissToogleContactProfile];
}

@end
