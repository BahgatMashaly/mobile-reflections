//
//  UpdatePresenceStatus.m
//  MobileJabber
//
//  Created by Shivang Vyas on 11/11/11.
//  Copyright 2011 company. All rights reserved.
//

#import "UpdatePresenceStatus.h"


@implementation UpdatePresenceStatus

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
	appDelegate = (MobileJabberAppDelegate*)[[UIApplication sharedApplication]delegate];
	aryStatus = [[NSMutableArray alloc] init];
	[aryStatus addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Online", @"displayText", @"online", @"showText", @"green small.png", @"img", nil]];
	[aryStatus addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Away", @"displayText", @"away", @"showText",@"orange small.png", @"img", nil]];
	[aryStatus addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Not Available", @"displayText", @"dnd", @"showText", @"red small.png", @"img", nil]];
	// [aryStatus addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Offline", @"displayText", @"unavailable", @"showText", @"", @"img", nil]];
	[aryStatus addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Sign out", @"displayText", @"unavailable", @"showText", @"logout.png", @"img", nil]];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
#pragma mark Actions

- (IBAction)btnBackTapped:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_CLOSE_UPDATE_STATUS object:nil];
}

- (IBAction)btnUpdateTapped:(id)sender {
	/*<presence xml:lang='en'>
	 <show>away</show>
	 <status>I shall return!</status>
	 <priority>1</priority>
	 </presence>*/
	//UIButton *btn = (UIButton*) sender;
	
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	//[presence addAttributeWithName:@"xml:lang" stringValue:@"en"];
	NSXMLElement *show = [NSXMLElement elementWithName:@"show"];
	[show setStringValue:[[aryStatus objectAtIndex:appDelegate.statusSelectedIndx] objectForKey:@"showText"]];
	
	NSXMLElement *status = [NSXMLElement elementWithName:@"status"];
	[status setStringValue:txtUpdateText.text];
	NSXMLElement *priority = [NSXMLElement elementWithName:@"priority"];
	[priority setStringValue:@"24"];
	[presence addChild:show];
	[presence addChild:status];
	[presence addChild:priority];
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:presence];
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_CLOSE_UPDATE_STATUS object:nil];

}

#pragma mark -
#pragma mark TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [aryStatus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellId = @"Cell";
	UITableViewCell * cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
	
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
	}
	cell.textLabel.text = [[aryStatus objectAtIndex:indexPath.row] objectForKey:@"displayText"];
	cell.imageView.image = [UIImage imageNamed:[[aryStatus objectAtIndex:indexPath.row] objectForKey:@"img"]];
	cell.accessoryType = UITableViewCellAccessoryNone;
	if (appDelegate.statusSelectedIndx == indexPath.row) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int rowid = indexPath.row;
    if (rowid == 3) {
        [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_CLOSE_UPDATE_STATUS object:nil];
        /*
        [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) goOffline];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGOUT object:nil];
         */
            
    }
    else {
        appDelegate.statusSelectedIndx = indexPath.row;
        [tblView reloadData];
    }
}

@end
