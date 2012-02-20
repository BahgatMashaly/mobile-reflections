    //
//  ServerSettingScreenViewController.m
//  MobileJabber
//
//  Created by Shivang Vyas on 8/8/11.
//  Copyright 2011 company. All rights reserved.
//

#import "ServerSettingScreenViewController.h"


@implementation ServerSettingScreenViewController

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
	aryServerSetting = [[NSMutableArray alloc] init];
	//[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) ]
	NSMutableDictionary * ApplicationSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath];
	[aryServerSetting addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Server", @"field", [ApplicationSettings objectForKey:@"ServerLocation"], @"value", nil]];
	[aryServerSetting addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Port", @"field", [NSString stringWithFormat:@"%d", [[ApplicationSettings objectForKey:@"ServerPort"] intValue]], @"value", nil]];
	//[tblView setBackgroundView:nil];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    // return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);	
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
#pragma mark TableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [aryServerSetting count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = [NSString stringWithFormat:@"(%i)(%i)",indexPath.section,indexPath.row];
	
	UITableViewCell * cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	//cell=nil; // temperary...!
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"ServerSettingViewCell" owner:self options:nil];
		cell = tbcCustomCell;
	}
	UILabel *lblField = (UILabel*)[cell viewWithTag:1];
	[lblField setText:[[aryServerSetting objectAtIndex:indexPath.row] objectForKey:@"field"]];
	
	UITextField *txtValue = (UITextField*)[cell viewWithTag:2];
	[txtValue setDelegate:self];
	if ([[aryServerSetting objectAtIndex:indexPath.row] objectForKey:@"value"] != nil) {
		[txtValue setText:[[aryServerSetting objectAtIndex:indexPath.row] objectForKey:@"value"]];
	}
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return cell;						
}

#pragma mark -
#pragma mark TextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark Actions

- (IBAction)btnDoneTapped {
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	NSIndexPath *indxPath = [NSIndexPath indexPathForRow:0 inSection:0];
	UITableViewCell *cell = [tblView cellForRowAtIndexPath:indxPath];
	UITextField *txtField = (UITextField*)[cell viewWithTag:2];
	[dict setObject:txtField.text forKey:@"ServerLocation"];
	
	indxPath = [NSIndexPath indexPathForRow:1 inSection:0];
	cell = [tblView cellForRowAtIndexPath:indxPath];
	txtField = (UITextField*)[cell viewWithTag:2];
	[dict setObject:txtField.text forKey:@"ServerPort"];
	[dict writeToFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath atomically:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SERVER_CONFIG_CHANGE object:nil];
}

@end
