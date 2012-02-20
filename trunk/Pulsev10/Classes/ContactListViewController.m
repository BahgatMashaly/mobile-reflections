//
//  ContactListViewController.m
//  MobileJabber
//
//  Created by Shivang Vyas on 7/25/11.
//  Copyright 2011 company. All rights reserved.
//

#import "ContactListViewController.h"
@implementation ContactListViewController
@synthesize del;

#pragma mark -
#pragma mark View Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
	
	IsContactEditable = NO;
	TblContactList.showsVerticalScrollIndicator = NO;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	// Registering for Remote Notification
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(UpdateContactList:) 
												 name:NOTIFICATION_RELOAD_CONTACTS 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(showUserOptionPopover:) 
												 name:NSNOTIFICATION_SHOW_USER_OPTIONS
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(showGroupOptionPopover:) 
												 name:NSNOTIFICATION_SHOW_GROUP_OPTIONS
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(didUserOptionSelected:) 
												 name:NSNOTIFICATION_USER_OPTION_SELECTED
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(didGroupOptionSelected:) 
												 name:NSNOTIFICATION_GROUP_OPTION_SELECTED
											   object:nil];
    TblContactList.opaque = NO;
    TblContactList.backgroundColor = UIColor.clearColor;
    for (UIView* view in TblContactList.subviews) {
        view.backgroundColor = UIColor.clearColor;
    }
	
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    if (ISDEVELOPMENT)
        [BtnAddContact setHidden:NO];
    else
        [BtnAddContact setHidden:YES];
	[self UpdateContactList:self];	//	Updating contact list
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}

- (void)viewDidUnload {
	[[NSNotificationCenter defaultCenter] removeObserver:self];	//Removing from remote notification	
    [BtnAddContact release];
    BtnAddContact = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    [BtnAddContact release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark -
#pragma mark IBAction or Custom Methods

-(IBAction)BtnShowContactViewOptionsTabbed:(id)sender{
/*
 -	This popup will show when user tabbed on "contact".
 -	It has Online (on/off)
 -	If Online - On, means only online user will be shown in contact list
 -	If Online - Off, means all users - online, offline & away will be shown in contact list.
 - "Back" button or clicking outside popover view dismisses popover.
 */
	ObjContactViewOptionsViewController = [[ContactViewOptionsViewController alloc] initWithNibName:@"ContactViewOptionsViewController" bundle:nil];
	
	if(ObjPopoverController_ContactListViewOptions!=nil && [ObjPopoverController_ContactListViewOptions retainCount]>0){
		[ObjPopoverController_ContactListViewOptions release];
		ObjPopoverController_ContactListViewOptions = nil;
	}
	
	ObjPopoverController_ContactListViewOptions = [[UIPopoverController alloc] initWithContentViewController:ObjContactViewOptionsViewController];
	ObjPopoverController_ContactListViewOptions.delegate = self;
	// set popover size
	ObjPopoverController_ContactListViewOptions.popoverContentSize = CGSizeMake(365,100);
	CGRect popoverRect = [self.view convertRect:[sender frame] fromView:[sender superview]];
	
	//Present popover
	[ObjPopoverController_ContactListViewOptions presentPopoverFromRect:popoverRect 
																 inView:self.view 
											   permittedArrowDirections:UIPopoverArrowDirectionUp
															   animated:YES];
	
	[ObjContactViewOptionsViewController release];
}

-(IBAction)BtnAddNewUserTabbed:(id)sender{
}



#pragma mark -
#pragma mark popover delegate Methods
// Dismisses selected popover...
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
	return YES;
}


-(void)FilterContacts:(UISearchBar*)searchBar{
/*
 This is used for filtering roster list/ contact list based on search-bar text,
 same as hotspot search.
 */
	NSMutableArray *aryTemp = [[NSMutableArray alloc]init];
	NSMutableArray *aryContacts = [[NSMutableArray alloc] initWithArray:
								   [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
									fetchedResultsController]
								   ];
	
	if([searchBar.text length]>0){
		[aryTemp removeAllObjects];
		
		for(int i=0;i<[aryContacts count];i++){
			NSMutableArray * aryTempContacts = [[NSMutableArray alloc] init];
			NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
			
			for(int j=0;j<[[[aryContacts objectAtIndex:i] valueForKey:@"GroupUsers"] count];j++)
			{
				
				NSRange titleResultsRange = [((XMPPUserCoreDataStorage*)[[[aryContacts objectAtIndex:i] valueForKey:@"GroupUsers"] objectAtIndex:j
																		 ]
											  ).displayName  rangeOfString:searchBar.text options:NSCaseInsensitiveSearch
											 ];
				if (titleResultsRange.length > 0){
					//				[aryTemp addObject:[aryContacts objectAtIndex:i]];
					[aryTempContacts addObject:((XMPPUserCoreDataStorage*)[[[aryContacts objectAtIndex:i] valueForKey:@"GroupUsers"] objectAtIndex:j
																		   ]
												)];				
				}
			}
			[dict setValue:[[aryContacts objectAtIndex:i] valueForKey:@"GroupName"] 
					forKey:@"GroupName"];
			[dict setValue:aryTempContacts forKey:@"GroupUsers"];
			[aryTemp addObject:dict];
			[dict release];
			
		}
	}else{
		[aryTemp removeAllObjects];
		[aryTemp addObjectsFromArray:aryContacts];
	}
	
	// now we have search data, now reload table based on those search data !
	if(ObjTblContactListDelegate!=nil && [ObjTblContactListDelegate retainCount]>0){
		[ObjTblContactListDelegate release];
		ObjTblContactListDelegate = nil;
	}
	ObjTblContactListDelegate = [[TblContactListDelegate alloc]initWithArray:aryTemp Table:TblContactList
								 ];
	
	if(ObjTblContactListDataSource!=nil && [ObjTblContactListDataSource retainCount]>0){
		[ObjTblContactListDataSource release];
		ObjTblContactListDataSource = nil;
	}
	
	ObjTblContactListDataSource = [[TblContactListDataSource alloc]initWithArray:aryTemp Table: TblContactList
								   ];
	
	TblContactList.delegate = ObjTblContactListDelegate;
	TblContactList.dataSource = ObjTblContactListDataSource;
	
	[TblContactList reloadData];	
}


-(void)ShowContactList:(id)sender{
/* 
 -	Used to show roster list and make them grouped...! 
 -	One user can appear in more than one group.
 -	and then show them in a table format.
 
 */
	[self GroupByRosters:
	 ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictRoster];
	
	if(ObjTblContactListDataSource!=nil && [ObjTblContactListDataSource retainCount]>0){
		[ObjTblContactListDataSource release];
		ObjTblContactListDataSource = nil;
	}
	ObjTblContactListDataSource = [[TblContactListDataSource alloc] initWithArray:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactLists
																			Table: TblContactList
								   ];
	
	TblContactList.dataSource = ObjTblContactListDataSource;
	
	
	if(ObjTblContactListDelegate!=nil && [ObjTblContactListDelegate retainCount]>0){
		[ObjTblContactListDelegate release];
		ObjTblContactListDelegate = nil;
	}
	
	ObjTblContactListDelegate = [[TblContactListDelegate alloc] initWithArray:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactLists
																		Table :TblContactList];
	
	TblContactList.delegate = ObjTblContactListDelegate;
	
	[TblContactList reloadData];
}

-(void)GroupByRosters:(NSMutableDictionary*)dictRosterList{
/*	
	-	Used to modify roster list and make them grouped...! 
	-	One user can appear in more than one group.
*/
	
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactLists removeAllObjects];
	
	NSMutableArray *aryGroups = [[NSMutableArray alloc] init];
    
    int itemcount = [[[dictRosterList valueForKey:@"Query"] valueForKey:@"Items"] count];
    
    // NSLog (@"%@", dictRosterList);
    
	for(int i=0;i<itemcount;i++) {
        NSObject * iobj = [[[dictRosterList valueForKey:@"Query"] valueForKey:@"Items"] objectAtIndex:i];
        NSObject * gsobj = [iobj  valueForKey:@"Groups"];
        
        NSObject * gobj = [[[[[dictRosterList valueForKey:@"Query"] valueForKey:@"Items"] objectAtIndex:i] valueForKey:@"Groups"]
                        valueForKey:@"group"];
        [aryGroups addObject:gobj];
		// [aryGroups addObject:
		 // [[[[[dictRosterList valueForKey:@"Query"] valueForKey:@"Items"] objectAtIndex:i] valueForKey:@"Groups"]
		  // valueForKey:@"group"]
		 // ];
	}
	NSSet *setGroups = [NSSet setWithArray:aryGroups];
	[aryGroups release];
	
	//NSLog(@"%@",[setGroups description]);
	
	
	for(int i=0;i<[[setGroups allObjects] count];i++){
		NSMutableArray *aryTempRoster = [[NSMutableArray alloc] init];
		NSMutableDictionary *dictRosterGroups = [[NSMutableDictionary alloc] init];
		
		for(int j=0;j<itemcount;j++){
			if([[[setGroups allObjects] objectAtIndex:i] isEqualToString:
				[[[[[dictRosterList valueForKey:@"Query"] valueForKey:@"Items"] objectAtIndex:j] valueForKey:@"Groups"]
				 valueForKey:@"group"]
				]){
				[aryTempRoster addObject:[[[dictRosterList valueForKey:@"Query"] valueForKey:@"Items"] objectAtIndex:j]
				 ];
			}
		}
		if([aryTempRoster count]>0){
			[dictRosterGroups setValue:[[setGroups allObjects] objectAtIndex:i] forKey:@"GroupName"];
			[dictRosterGroups setValue:aryTempRoster forKey:@"GroupUsers"];
			
			[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactLists
			 addObject:dictRosterGroups];
			
		}
		[aryTempRoster release];
		[dictRosterGroups release];
		
	}
	
	//NSLog(@"%@",[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactLists description]
	//	  );
	if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactListExpandValue == nil) {
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactListExpandValue =
		[[NSMutableArray alloc] init];
		for (int i = 0; i < [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactLists count]; i++) {
			[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactListExpandValue addObject:@"NO"];
		}
	}
	
}


-(IBAction)BtnEditContactsTabbed:(id)sender{
// make roster list editable/uneditable...!	
	/*if(!IsContactEditable){
		IsContactEditable = YES;
		TblContactList.editing = YES;
	}else {
		IsContactEditable = NO;
		TblContactList.editing = NO;
	}*/
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) ShowToogleContactList:sender];
}


-(void)UpdateContactList:(id)sender{
/* 
 -	Used to update roster list and make them grouped- group by "GroupName"...! 
 -	One user can appear in more than one group.
 -	and then show them in a table format.
*/
	
	[self GroupByRosters:
	 ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictRoster];

	if(ObjTblContactListDataSource!=nil && [ObjTblContactListDataSource retainCount]>0){
		[ObjTblContactListDataSource release];
		ObjTblContactListDataSource = nil;
	}
	//user.sectionNum
	NSMutableArray *aryUserList = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
								   fetchedResultsController];
	NSMutableArray *aryUserUpdateList = [[NSMutableArray alloc] init];
	if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).isShowOnlineSelected) {
		for (NSDictionary *dict in aryUserList) {
			NSMutableArray *tempArr = [[[NSMutableArray alloc] init] autorelease];
			for (XMPPUserCoreDataStorage *user in [dict objectForKey:@"GroupUsers"]) {
				if ([user.sectionNum intValue] == 0) {
					[tempArr addObject:user];
				}
			}
			NSMutableDictionary *dictTemp = [NSMutableDictionary dictionaryWithDictionary:dict];
			[dictTemp setObject:tempArr forKey:@"GroupUsers"];
			[aryUserUpdateList addObject:dictTemp];
		}
	}
	else {
		[aryUserUpdateList addObjectsFromArray:aryUserList];
	}
	
	ObjTblContactListDataSource = [[TblContactListDataSource alloc] initWithArray:
								   aryUserUpdateList Table:TblContactList
								   ];
	
	if(ObjTblContactListDelegate!=nil && [ObjTblContactListDelegate retainCount]>0){
		[ObjTblContactListDelegate release];
		ObjTblContactListDelegate = nil;
	}
	
	ObjTblContactListDelegate = [[TblContactListDelegate alloc] initWithArray:
								 [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
								  fetchedResultsController]
																		Table:TblContactList];
	
	TblContactList.dataSource = ObjTblContactListDataSource;
	TblContactList.delegate = ObjTblContactListDelegate;
	
	[TblContactList reloadData];	
}

-(void)showUserOptionPopover:(NSNotification*)notification {
/* 
 -	Used to Display Popover with User Options
*/
	UIButton *btnSender = (UIButton*)[notification object];
	userIndexPathSection = [[btnSender titleForState:UIControlStateNormal] intValue];
	userIndexPathRow = [btnSender tag];
	if(ObjPopoverController_UserOptionListView!=nil && [ObjPopoverController_UserOptionListView retainCount]>0){
		//[ObjPopoverController_UserOptionListView release];
		ObjPopoverController_UserOptionListView = nil;
	}
	UserOptionPopoverViewController *objUserOption = [[[UserOptionPopoverViewController alloc] initWithNibName:@"UserOptionPopoverViewController" bundle:nil] autorelease];
	ObjPopoverController_UserOptionListView = [[UIPopoverController alloc] initWithContentViewController:objUserOption];
	ObjPopoverController_UserOptionListView.delegate = self;
	
	ObjPopoverController_UserOptionListView.popoverContentSize = CGSizeMake(225,100); //defining pop-over size
	CGRect popoverRect = [[[UIApplication sharedApplication] keyWindow
						   ] convertRect:[btnSender frame] fromView:[btnSender superview]];
	
	//present popover.
	[ObjPopoverController_UserOptionListView presentPopoverFromRect:popoverRect 
																 inView:[[UIApplication sharedApplication] keyWindow
																		 ]
											   permittedArrowDirections:UIPopoverArrowDirectionAny
															   animated:YES];
	
	
}

- (void)showGroupOptionPopover:(NSNotification*)notification {
/* 
 -	Used to Display Popover with Group Options
*/
	//if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strSelfRole != nil &&
//		([((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strSelfRole isEqualToString:@"Teacher"] || 
//		 [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strSelfRole isEqualToString:@"Instructor"])) {
		UIButton *btnSender = (UIButton*)[notification object];
		
		if(ObjPopoverController_GroupOptionListView!=nil && [ObjPopoverController_GroupOptionListView retainCount]>0){
			//[ObjPopoverController_GroupOptionListView release];
			ObjPopoverController_GroupOptionListView = nil;
			
		}
		groupIndexPathSection = [btnSender tag];
		GroupOptionPopoverViewController *objGroupOption = [[[GroupOptionPopoverViewController alloc] initWithNibName:@"GroupOptionPopoverViewController" bundle:nil] autorelease];
		ObjPopoverController_GroupOptionListView = [[UIPopoverController alloc] initWithContentViewController:objGroupOption];
		ObjPopoverController_GroupOptionListView.delegate = self;
		
        if (ISDEVELOPMENT) {
            ObjPopoverController_GroupOptionListView.popoverContentSize = CGSizeMake(225,250); //defining pop-over size
        } else {
            ObjPopoverController_GroupOptionListView.popoverContentSize = CGSizeMake(225,100); //defining pop-over size            
        }
		CGRect popoverRect = [[[UIApplication sharedApplication] keyWindow
							   ] convertRect:[btnSender frame] fromView:[btnSender superview]];
		
		//present popover.
		[ObjPopoverController_GroupOptionListView presentPopoverFromRect:popoverRect 
																  inView:[[UIApplication sharedApplication] keyWindow
																		  ] 
												permittedArrowDirections:UIPopoverArrowDirectionAny
																animated:YES];
	//}
}


- (void)didUserOptionSelected:(NSNotification*)notification {
/* 
 -	Used to Display Popover with Group Options
*/
	NSString *strSelectedOption = [[notification object] objectForKey:@"field"];
 	[ObjPopoverController_UserOptionListView dismissPopoverAnimated:YES];
	NSArray *aryUserList = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
							fetchedResultsController];
	XMPPUserCoreDataStorage *user = (XMPPUserCoreDataStorage*)[[[aryUserList objectAtIndex:userIndexPathSection] objectForKey:@"GroupUsers"] objectAtIndex:userIndexPathRow];
	if ([[strSelectedOption lowercaseString] isEqualToString:@"chat"]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_CHAT_FROM_USER_OPTION object:user];
	}
	else if ([[strSelectedOption lowercaseString] isEqualToString:@"file transfer"]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_FILE_SENDING_FROM_USER_OPTION object:user];
	}
	else if ([[strSelectedOption lowercaseString] isEqualToString:@"email"]) {
	//	NSLog(@"%@", user.jidStr);
		for (NSDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactEmail) {
			if ([[dict objectForKey:@"jid"] isEqualToString:[[[user.jidStr description] componentsSeparatedByString:@"@"] objectAtIndex:0]]) {
				MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
				controller.mailComposeDelegate = self;
				
				if ([dict objectForKey:@"email"] != nil) {
					[controller setToRecipients:[NSArray arrayWithObject:[dict objectForKey:@"email"]]];
					if (controller) {
						[self presentModalViewController:controller animated:YES];
					}					
				}	
				
				[controller release];
			}
		}
		/*MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
		 controller.mailComposeDelegate = self;
		 
		 //[controller setToRecipients:[NSArray arrayWithObject:[dict objectForKey:@"email"]]];
		 if (controller) {
		 [self presentModalViewController:controller animated:YES];
		 }
		 
		 [controller release];*/
	}
	else {
		UITableViewCell *tbc = [TblContactList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:userIndexPathRow inSection:userIndexPathSection]];
	//	UIButton *btnSender;
		for (UIView *vw in [tbc subviews]) {
			if ([vw class] == [UIButton class]) {				
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) ShowUserProfile:vw 
																									 info:[NSDictionary dictionaryWithObjectsAndKeys:[user.jid description], @"jid", nil]
				 ];
			}
		}
	}
}

- (void)didGroupOptionSelected:(NSNotification*)notification {
	NSString *strSelectedOption = [[notification object] objectForKey:@"field"];
	[ObjPopoverController_GroupOptionListView dismissPopoverAnimated:YES];    
	if ([[strSelectedOption lowercaseString] isEqualToString:@"start class"]) {
		NSArray *aryUserList = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
								fetchedResultsController] objectAtIndex:groupIndexPathSection];
		//[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_GROUP_CHAT_FROM_GROUP_OPTION object:aryUserList];
	}
	else if ([[strSelectedOption lowercaseString] isEqualToString:@"group chat"]) {
		NSArray *aryUserList = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
								fetchedResultsController] objectAtIndex:groupIndexPathSection];
		[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_GROUP_CHAT_FROM_GROUP_OPTION object:aryUserList];
	}
	else if ([[strSelectedOption lowercaseString] isEqualToString:@"poll"])
	{
		NSArray *aryUserList = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
                                 fetchedResultsController] objectAtIndex:groupIndexPathSection];
        [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) setPollWindowName:@"MCQNew"];
		[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_POLL_FROM_GROUP_OPTION object:aryUserList];
				//NSArray *aryUserList = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
//								 fetchedResultsController] objectAtIndex:groupIndexPathSection];
//		MultiView *multi=[[MultiView alloc]initWithNibName:@"MultiView" bundle:nil];
//	//multi.modalPresentationStyle=UIModalPresentationFormSheet;
//	  [self presentModalViewController:multi animated:YES];
		// [del showview:@"MultipleViewController"];
		
		//[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_GROUP_CHAT_FROM_GROUP_OPTION object:aryUserList];
	}
	else if ([[strSelectedOption lowercaseString] isEqualToString:@"asessment"]) {
		NSArray *aryUserList = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
								 fetchedResultsController] objectAtIndex:groupIndexPathSection];
		[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_ASSESSMENT_FROM_GROUP_OPTION object:aryUserList];						
		//[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_GROUP_CHAT_FROM_GROUP_OPTION object:aryUserList];
	}
	else if ([[strSelectedOption lowercaseString] isEqualToString:@"progress tracker"]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_PROGRESSTRACK_FROM_GROUP_OPTION object:[NSString stringWithFormat:@"%d",groupIndexPathSection] userInfo:nil];		
    }
	else {
		NSArray *aryUserList = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
								 fetchedResultsController] objectAtIndex:groupIndexPathSection];
		[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_GROUP_FILE_FROM_GROUP_OPTION object:aryUserList];
	}

}

#pragma mark -
#pragma mark UISearchBar delegate Methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	/*
	 when user selects cancel button in search bar, dismisses searchbar
	 */
	[searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	/*
	 when user started to begin editing in search bar, filter contactlist/rosterlist based on
	 searchbar text ...!
	 */
	[self FilterContacts:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	/*
	 when user update text in search bar, filter contactlist/rosterlist based on
	 searchbar text ...!
	 */
	[self FilterContacts:searchBar];	
}

#pragma mark -
#pragma mark MailComposerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller  
		  didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error {
	if (result == MFMailComposeResultSent) {
		
	}
	[self dismissModalViewControllerAnimated:YES];
}

@end
