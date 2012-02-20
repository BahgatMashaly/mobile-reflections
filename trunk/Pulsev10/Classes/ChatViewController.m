    //
//  ChatViewController.m
//  MobileJabber
//
//  Created by Shivang Vyas on 6/30/11.
//  Copyright 2011 company. All rights reserved.
//

#import "ChatViewController.h"

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	//[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];	
	//[[UIDevice currentDevice] setOrientation:UIDeviceOrientationLandscapeRight];	
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.leftBarButtonItem = nil;
	
	IsNotificationShowed = NO;
	IsContactEditable = NO;
	IsActiveChatEditable = NO;
	txtMyStatus.delegate = self;
	
    
	[self UpdateContactList:self];	
	
	
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self UpdateActiveChatList:self];
	[self UpdateActivePollList:self];
	if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName != nil && 
		![((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName isEqualToString:@""]) {
		lblUserName.text = ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName;
	}
	else {
		lblUserName.text = [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"
								 ] objectAtIndex:0];
	}
	imvUserProfile.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getSelfImage];				
    
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(SetUserAvtarImage:) 
												 name:NSNOTIFICATION_USER_AVTAR 
											   object:nil];
	

	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(RedrawNavigationBar:) 
												 name:NSNOTIFICATION_DRAW_NAVIGATIONBAR 
											   object:nil];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(ShowEventList:) 
												 name:NSNOTIFICATION_SHOW_EVENTS 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(ShowPollWindow:) 
												 name:NSNOTIFICATION_SHOW_POLL_WINDOW 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(ShowChatWindow:) 
												 name:NSNOTIFICATION_SHOW_CHAT_WINDOW 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(UpdateActivePollList:) 
												 name:NSNOTIFICATION_UPDATE_ACTIVEPOLL 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(UpdateActiveChatList:) 
												 name:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(GoToHomeView:) 
												 name:NSNOTIFICATION_SHOW_HOME 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(LogOut:) 
												 name:NOTIFICATION_LOGOUT 
											   object:nil];
	

	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(UpdateContactList:) 
												 name:NOTIFICATION_RELOAD_CONTACTS 
											   object:nil];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(ChangeTheme:) 
												 name:NSNOTIFICATION_CHANGE_APPLICATION_THEME 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(showTransferedImage:) 
												 name:NSNOTIFICATION_SHOW_TRANSFERED_IMAGE 
											   object:nil];

	
	NSMutableDictionary * dictTheme = [[NSMutableDictionary alloc] initWithContentsOfFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath];
	
	if([[dictTheme valueForKey:@"ThemeNumber"] isEqualToString:@"1"]){
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ThemeNumber = 1;
    } else if([[dictTheme valueForKey:@"ThemeNumber"] isEqualToString:@"2"]){
        ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ThemeNumber = 2;
	}else {
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ThemeNumber = 3;		
	}
	[dictTheme release];
	
	
	if(((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ThemeNumber==1){
		imvBackground.image = [UIImage imageNamed:@"wood-floor-wallpapers_6855_1280x800.jpg"];
	}else if(((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ThemeNumber==2){
		imvBackground.image = [UIImage imageNamed:@"theme2.jpg"];
	}else if(((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ThemeNumber==3){
		imvBackground.image = [UIImage imageNamed:@"theme3.jpg"];
	}
	
	if(((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strStatusMessage!=nil
	   ){
		txtMyStatus.text = ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strStatusMessage;
	}

	if ([((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) chatActUser] != nil &&
		![[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) chatActUser] faultingState]) {
		[self ShowChatWindowWithoutNotification:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) chatActUser]];
	}
	else {
		[self ShowChatWindowWithoutNotification:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) dictChatActGroup]];
	}
	
	if(![[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight){
		[self willRotateToInterfaceOrientation:UIDeviceOrientationLandscapeRight duration:2
		 ];
	}
	[self UpdateContactList:self];	
	[self.view addSubview:
	 ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).menuToolBar];
	
}

- (void)viewWillDisappear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//	NSLog(@"%i",interfaceOrientation);	
	//(interfaceOrientation == UIInterfaceOrientationLandscapeRight) ? NSLog(@"YES"):NSLog(@"NO");
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
#pragma mark Custom Methods

-(IBAction)BtnViewUserProfileTabbed:(id)sender{
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) ShowUserProfile:sender info:nil
	 ];
}


-(IBAction)BtnCollapseActiveChat:(id)sender {
    if (!IsCollapsed) {
        IsCollapsed = YES;  
    }
    else {
        IsCollapsed = NO;
    }
    [self UpdateActiveChatList:self];
    
}


-(void)SetUserAvtarImage:(id)sender{
	//NSLog(@"%@",[sender description]);
	if([sender object]!=nil && [[sender object] length] >0){
		imvUserProfile.image = [UIImage imageWithData:[sender object]];
	}
	else {
		imvUserProfile.image = [UIImage imageNamed:@"no_Img.jpg"];
	}
}

-(IBAction)BtnUserNameTabbed:(id)sender{
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) btnNameBarTapped:sender];	
}

-(IBAction)BtnThemesTabbed:(id)sender{
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) BtnThemesTabbed:sender];
}

-(IBAction)BtnSettingTabbed:(id)sender{
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) BtnSettingTabbed:sender];
}

-(void)FilterContacts:(UISearchBar*)searchBar{
	
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
	
	ObjTblContactListDataSource = [[TblContactListDataSource alloc]initWithArray:aryTemp Table:TblContactList
								   ];
	
	TblContactList.delegate = ObjTblContactListDelegate;
	TblContactList.dataSource = ObjTblContactListDataSource;
	
	[TblContactList reloadData];	
}

-(IBAction)BtnUpdateStatusTabbed:(id)sender{
	if([[txtMyStatus.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
		]
		length]>0){
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	[presence addAttributeWithName:@"from" 
					   stringValue:[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] full]
	 ];
	
	
	
	NSXMLElement	* statusElement = [NSXMLElement elementWithName:@"status" stringValue:txtMyStatus.text];
	
	
	[presence addChild:statusElement];
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:presence
	 ];
		
		
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strStatusMessage = txtMyStatus.text;
		
		NSMutableDictionary * dictApplicationSettings = [[NSMutableDictionary alloc] init];	
		[dictApplicationSettings setValue:@"2" forKey:@"ThemeNumber"];
		[dictApplicationSettings setValue:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strUserName 
								   forKey:@"UserName"];
		[dictApplicationSettings setValue:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPassword 
								   forKey:@"Password"];
		if(((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).IsAutoLoginEnabled
		   ){
			[dictApplicationSettings setValue:@"YES" forKey:@"IsAutoLoginEnabled"];
		}else {
			[dictApplicationSettings setValue:@"NO" forKey:@"IsAutoLoginEnabled"];		
		}
		
		[dictApplicationSettings setValue:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate
																	  ]).strStatusMessage
								   forKey:@"status"];
		
		
		[dictApplicationSettings writeToFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath atomically:YES];//?NSLog(@"Success"):NSLog(@"Failure");
		[dictApplicationSettings release];
		
	}else {
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" 
														 message:@"Enter Status Message, Please !" 
														delegate:nil 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil];
		[alert show];
		[alert release];
	}

	
}

-(void)RedrawNavigationBar:(id)sender{
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).NavigationBarType = 1;	
	[self.navigationController.navigationBar drawRect:self.navigationController.navigationBar.frame
	 ];
	
}

-(void)ShowEventList:(id)sender{

}

- (void)showChatBadgeOnGroup {
	NSInteger totalChatBadge = 0;
	for (NSDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers) {
		if ([[dict objectForKey:@"type"] isEqualToString:@"chat"]) {
			if ([((XMPPUserCoreDataStorage*)[dict objectForKey:@"user"]) isEqual:
				 ((XMPPUserCoreDataStorage*)((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).chatActUser)]) {
				continue;
			}
		}
		else {
			if ([((XMPPUserCoreDataStorage*)[dict objectForKey:@"user"]) isEqual:
				 ((XMPPUserCoreDataStorage*)((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictChatActGroup)]) {
				continue;
			}
		}

		
		totalChatBadge += [[dict objectForKey:@"chatBadge"] intValue];
	}
	if (totalChatBadge > 0) {
		CustomBadge *cstBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", totalChatBadge]];
		[cstBadge setFrame:CGRectMake(880, 58, 20, 20)];
		[self.view addSubview:cstBadge];
	}
	else {
		for (UIView *vw in  [self.view subviews]) {
			if ([vw class] == [CustomBadge class]) {
				[vw removeFromSuperview];
			}
		}
	}
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).globalChatMessageCount = totalChatBadge;
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) updateGlobalChatBadgeOnMenuBar];

}


										 
-(void)ShowChatWindowWithoutNotification:(id)sender {
    // if (sender == NULL) 
    //     return;
    [self removePollWindow:sender];
    
    @try {
        if (ObjChatWindowViewController != nil) {
        
            if ([[[sender object] objectForKey:@"user"] class] == [XMPPUserCoreDataStorage class]) {
                if (ObjChatWindowViewController.ObjXMPPUserCoreDataStorage == ((XMPPUserCoreDataStorage*)[[sender object] objectForKey:@"user"])) 
                    return;
            }
            else {
                if (ObjChatWindowViewController.dictGroupChatUser == [sender object]) 
                    return;
            }
        }
    } 
    @catch (NSException *exc) {
        // return;
    }

	if(ObjChatWindowViewController!=nil && [ObjChatWindowViewController retainCount]>0){
		[ObjChatWindowViewController.view removeFromSuperview];
		[ObjChatWindowViewController release];
		ObjChatWindowViewController = nil;
	}
	
	ObjChatWindowViewController = [[ChatWindowViewController alloc] initWithNibName:@"ChatWindowViewController" bundle:nil];
	ObjChatWindowViewController.view.frame = CGRectMake(287-20,44-15,491,667);
	if ([sender class] == [XMPPUserCoreDataStorage class]) {
		ObjChatWindowViewController.ObjXMPPUserCoreDataStorage = (XMPPUserCoreDataStorage*)sender;
	}
	else {
		ObjChatWindowViewController.dictGroupChatUser = sender;
	}

	
	[self.view addSubview:ObjChatWindowViewController.view];
	[ObjChatWindowViewController viewWillAppear:YES];
}
	 
-(void)ShowChatWindow:(id)sender{
    if (sender == NULL) 
        return;
    [self removePollWindow:sender];
    
    // Do we really need to do it ?
    @try {
        if (ObjChatWindowViewController != nil) {
            
            if ([[[sender object] objectForKey:@"user"] class] == [XMPPUserCoreDataStorage class]) {
                if (ObjChatWindowViewController.ObjXMPPUserCoreDataStorage == ((XMPPUserCoreDataStorage*)[[sender object] objectForKey:@"user"])) 
                    return;
            }
            else {
                if (ObjChatWindowViewController.dictGroupChatUser == [sender object]) 
                    return;
            }
        }
    } 
    @catch (NSException *exc) {
        return;
    }
    
	if(ObjChatWindowViewController!=nil && [ObjChatWindowViewController retainCount]>0){
		[ObjChatWindowViewController.view removeFromSuperview];
		[ObjChatWindowViewController release];
		ObjChatWindowViewController = nil;
	}
	
	ObjChatWindowViewController = [[ChatWindowViewController alloc] initWithNibName:@"ChatWindowViewController" bundle:nil];
	ObjChatWindowViewController.view.frame = CGRectMake(287-20,44-15,491,667);
	if ([[[sender object] objectForKey:@"user"] class] == [XMPPUserCoreDataStorage class]) {
		ObjChatWindowViewController.ObjXMPPUserCoreDataStorage = ((XMPPUserCoreDataStorage*)[[sender object] objectForKey:@"user"]);
	}
	else {
		ObjChatWindowViewController.dictGroupChatUser = [sender object];
	}
	
	[self.view addSubview:ObjChatWindowViewController.view];
	[ObjChatWindowViewController viewWillAppear:YES];
	[self showChatBadgeOnGroup];
}

-(void)ChangeTheme:(id)sender{
	if([[sender object] isEqualToString:@"1"]){
		imvBackground.image = [UIImage imageNamed:@"wood-floor-wallpapers_6855_1280x800.jpg"];
	}else if([[sender object] isEqualToString:@"2"]){
		imvBackground.image = [UIImage imageNamed:@"theme2.jpg"];
	}else if([[sender object] isEqualToString:@"3"]){
		imvBackground.image = [UIImage imageNamed:@"theme3.jpg"];
	}
}

-(void)ShowPollWindow:(id)sender
{
	
}

-(void)removePollWindow:(id)sender {
}

-(void)UpdateActiveChatList:(id)sender{
	if(ObjTblActiveChatListDataSource!=nil && [ObjTblActiveChatListDataSource retainCount]>0){
		[ObjTblActiveChatListDataSource release];
		ObjTblActiveChatListDataSource = nil;
	}
	ObjTblActiveChatListDataSource = [[TblActiveChatListDataSource alloc] initWithArray:
								   ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers 
								   ];
	ObjTblActiveChatListDataSource.isCollapsed = IsCollapsed;
	if(ObjTblActiveChatListDelegagte!=nil && [ObjTblActiveChatListDelegagte retainCount]>0){
		[ObjTblActiveChatListDelegagte release];
		ObjTblActiveChatListDelegagte = nil;
	}
	ObjTblActiveChatListDelegagte = [[TblActiveChatListDelegagte alloc] initWithArray:
						((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers];
	
	tblActiveChatList.dataSource = ObjTblActiveChatListDataSource;
	tblActiveChatList.delegate = ObjTblActiveChatListDelegagte;
	
	[tblActiveChatList reloadData];	
	[self showChatBadgeOnGroup];
}

-(void)UpdateActivePollList:(id)sender
{
	if(ObjTblActivePollListDataSource!=nil && [ObjTblActivePollListDataSource retainCount]>0)
	{
		[ObjTblActivePollListDataSource release];
		ObjTblActivePollListDataSource = nil;
	}
	ObjTblActivePollListDataSource = [[TblActivePollListDataSource alloc] initWithArray:
									  ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryPollMessages 
									  ];
	
	if(ObjTblActivePollListDelegate!=nil && [ObjTblActivePollListDelegate retainCount]>0)
	{
		[ObjTblActivePollListDelegate release];
		ObjTblActivePollListDelegate = nil;
	}
	ObjTblActivePollListDelegate = [[TblActivePollListDelegate alloc] initWithArray:
									((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryPollMessages];
	
	tblActivePollList.dataSource = ObjTblActivePollListDataSource;
	tblActivePollList.delegate = ObjTblActivePollListDelegate;
	[tblActivePollList reloadData];	
}


-(void)UpdateContactList:(id)sender{
	if(ObjTblContactListDataSource!=nil && [ObjTblContactListDataSource retainCount]>0){
		[ObjTblContactListDataSource release];
		ObjTblContactListDataSource = nil;
	}
	/*ObjTblContactListDataSource = [[TblContactListDataSource alloc] initWithArray:
								   [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
									fetchedResultsController]
								   ];*/
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
								  fetchedResultsController] Table:TblContactList
								 ];
	
	TblContactList.dataSource = ObjTblContactListDataSource;
	TblContactList.delegate = ObjTblContactListDelegate;
	
	[TblContactList reloadData];	
}


-(IBAction)BtnAddNewUserTabbed:(id)sender{
}


-(IBAction)BtnShowContactViewOptionsTabbed:(id)sender{
	ObjContactViewOptionsViewController = [[ContactViewOptionsViewController alloc] initWithNibName:@"ContactViewOptionsViewController" bundle:nil];
	
	if(ObjPopoverController_ContactListViewOptions!=nil && [ObjPopoverController_ContactListViewOptions retainCount]>0){
		[ObjPopoverController_ContactListViewOptions release];
		ObjPopoverController_ContactListViewOptions = nil;
	}
	
	ObjPopoverController_ContactListViewOptions = [[UIPopoverController alloc] initWithContentViewController:ObjContactViewOptionsViewController];
	ObjPopoverController_ContactListViewOptions.delegate = self;
	ObjPopoverController_ContactListViewOptions.popoverContentSize = CGSizeMake(365,100);
	CGRect popoverRect = [self.view convertRect:[sender frame] fromView:[sender superview]];
	
	[ObjPopoverController_ContactListViewOptions presentPopoverFromRect:popoverRect 
																 inView:self.view 
											   permittedArrowDirections:UIPopoverArrowDirectionUp
															   animated:YES];
	
	[ObjContactViewOptionsViewController release];
}


-(IBAction)BtnEditContactsTabbed:(id)sender{
	//if(!IsContactEditable){
//		IsContactEditable = YES;
//		TblContactList.editing = YES;
//	}else {
//		IsContactEditable = NO;
//		TblContactList.editing = NO;
//	}
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) ShowToogleContactList:sender];
}
-(IBAction)BtnEditActiveChatsTabbed:(id)sender{
	if(!IsActiveChatEditable){
		IsActiveChatEditable = YES;
		tblActiveChatList.editing = YES;
	}else {
		IsActiveChatEditable = NO;
		tblActiveChatList.editing = NO;
	}	
}

-(void)GoToHomeView:(id)sender{
	[self.navigationController popViewControllerAnimated:NO];
}
-(void)LogOut:(id)sender{
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ObjPopoverController_Menu dismissPopoverAnimated:YES];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showTransferedImage:(NSNotification*)notification {
    if (viewFileDisplay != nil) {
        @try {
            [viewFileDisplay removeFromSuperview];
            [viewFileDisplay release];
            viewFileDisplay = nil;
        } 
        @catch (NSException *exc) {
            
        }
    }
	viewFileDisplay = [[UIView alloc] initWithFrame:self.view.frame];
	[viewFileDisplay setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.70]];
    
    NSString *imagePath =  [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:
                            [NSString stringWithFormat:@"%@", [notification object]]];
    // NSData *photo = [NSData dataWithContentsOfFile:imagePath];
    // UIImage *img = [UIImage imageWithData:photo];
    // UIImage *timg = [[UIImage alloc] initWithContentsOfFile:imagePath];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    // CGSize imgsize = [img size];

    // NSLog(@"%@", imagePath);
    
	UIImageView *objImage = [[UIImageView alloc] initWithFrame:CGRectMake(212, 152, 600, 400)];
	// [objImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:
		//																	  [NSString stringWithFormat:@"%@.png", [notification object]]]]]];
    [objImage setImage:img];
    objImage.contentMode = UIViewContentModeScaleAspectFit;
    						
	[viewFileDisplay addSubview:objImage];
    [objImage release];
	UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnClose setBackgroundImage:[UIImage imageNamed:@"bg 3.png"] forState:UIControlStateNormal];
	[btnClose setTitle:@"Close" forState:UIControlStateNormal];
	[btnClose setFrame:CGRectMake(712, 122, 100, 30)];
	[btnClose addTarget:self action:@selector(btnCloseImageViewTapped:) forControlEvents:UIControlEventTouchUpInside];
	[viewFileDisplay addSubview:btnClose];
	[self.view addSubview:viewFileDisplay];
    // [viewFileDisplay release];
}

- (void)btnCloseImageViewTapped:(UIButton*)sender {
    // NSLog(@"In close image");
    @try {
        if (viewFileDisplay != nil) {
            [viewFileDisplay removeFromSuperview];
            //[viewFileDisplay release];
            //viewFileDisplay = nil;
        }
    } 
    @catch (NSException *exc) {
        NSLog(@"Exception in close image - %@", [exc description]);        
    }
    // NSLog(@"Out close image");
}

#pragma mark -
#pragma mark UISearchBar delegate Methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	[self FilterContacts:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	[self FilterContacts:searchBar];	
}



@end
