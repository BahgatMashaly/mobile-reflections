    //
//  MenuViewController.m
//  MobileJabber
//
//  Created by Shivang Vyas on 6/29/11.
//  Copyright 2011 company. All rights reserved.
//

#import "MenuViewController.h"


@implementation MenuViewController

#pragma mark -
#pragma mark view life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];

	aryMenuItems = [[NSMutableArray alloc] init];
	[aryMenuItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Home", @"value", @"Home.png", @"icon", nil]];
	[aryMenuItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Chat", @"value", @"Chat.png", @"icon", nil]];
    if (ISDEVELOPMENT == 1) {
        [aryMenuItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Resource Gallery", @"value", @"Resources.png", @"icon", nil]];        
        // [aryMenuItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Reflections", @"value", @"Reflections.png", @"icon", nil]];
        [aryMenuItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Learning Center", @"value", @"Learning-Center.png", @"icon", nil]];
        /*
        [aryMenuItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Student Progress", @"value", @"start class.png", @"icon", nil]];
         */
        // [aryMenuItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Settings", @"value", @"settings1.png", @"icon", nil]];
    }
    if (ISDEVELOPMENT == 0) {
        [aryMenuItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Change Password", @"value", @"settings1.png", @"icon", nil]];
    }
    [aryMenuItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Help", @"value", @"Learning-Center.png", @"icon", nil]];
	[aryMenuItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Logout", @"value", @"logout.png", @"icon", nil]];
	

	ObjTblMenuListDelegate = [[TblMenuListDelegate alloc] initWithArray:aryMenuItems];
	tblMenuList.delegate = ObjTblMenuListDelegate;
	
	ObjTblMenuListDataSource = [[TblMenuListDataSource alloc] initWithArray:aryMenuItems];
 	tblMenuList.dataSource = ObjTblMenuListDataSource;
	
	[tblMenuList reloadData];
	
}

- (void)didGroupOptionSelected:(NSNotification*)notification {
	NSString *strSelectedOption = [[notification object] objectForKey:@"field"];
	// [ObjPopoverController_GroupOptionListView dismissPopoverAnimated:YES];    
	if ([[strSelectedOption lowercaseString] isEqualToString:@"start class"]) {
		//NSArray *aryUserList = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
        //                         fetchedResultsController] objectAtIndex:groupIndexPathSection];
		////[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_GROUP_CHAT_FROM_GROUP_OPTION object:aryUserList];
	}
	else if ([[strSelectedOption lowercaseString] isEqualToString:@"group chat"]) {
		//NSArray *aryUserList = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
        //                         fetchedResultsController] objectAtIndex:groupIndexPathSection];
		//[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_GROUP_CHAT_FROM_GROUP_OPTION object:aryUserList];
	}
	else if ([[strSelectedOption lowercaseString] isEqualToString:@"poll"])
	{
		// [del showview:@"MultipleViewController"];
		// //[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_GROUP_CHAT_FROM_GROUP_OPTION object:aryUserList];
	}
	else if ([[strSelectedOption lowercaseString] isEqualToString:@"asessment"]) {
		// NSArray *aryUserList = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
		// 						 fetchedResultsController] objectAtIndex:groupIndexPathSection];
		// //[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_GROUP_CHAT_FROM_GROUP_OPTION object:aryUserList];
	}
	else {
		// NSArray *aryUserList = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
		// 						 fetchedResultsController] objectAtIndex:groupIndexPathSection];
		// [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_GROUP_FILE_FROM_GROUP_OPTION object:aryUserList];
	}
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark IBAction or Custom Methods
-(IBAction)BtnBackTabbed:(id)sender{
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_CLOSE_MENU object:nil];
}


-(IBAction)BtnHomeTabbed:(id)sender{
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ObjPopoverController_Menu dismissPopoverAnimated:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SHOW_HOME object:nil];
}

//-(IBAction)BtnChatTabbed:(id)sender{
//	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ObjPopoverController_Menu dismissPopoverAnimated:YES];	
//	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SHOW_CHAT object:nil];
//}

-(IBAction)BtnReflectionTabbed:(id)sender{

}

-(IBAction)BtnResourcesTabbed:(id)sender{

}

-(IBAction)BtnLogoutTabbed:(id)sender{
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) goOffline];
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGOUT object:nil];
	
}


@end
