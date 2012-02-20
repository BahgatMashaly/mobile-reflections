//
//  HomeViewController.m
//  MobileJabber
//
//  Created by Shivang Vyas on 6/20/11.
//  Copyright 2011 company. All rights reserved.
//

#import "HomeViewController.h"

@implementation HomeViewController
@synthesize imvBackgroundImage;

#pragma mark -
#pragma mark View Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];		
	
	
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	IsNotificationShowed = NO;
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.leftBarButtonItem = nil;

	ObjContactListViewController = [[ContactListViewController alloc] initWithNibName:@"ContactListViewController"
																			   bundle:nil];
	ObjContactListViewController.view.frame = CGRectMake(0,60,286,678);
	ObjContactListViewController.del=self;
	[self.view addSubview:ObjContactListViewController.view];
	
	// Update Online Presence
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) goOnline]; 

	// Get & Set User Profile/Avatar Image
	//[self GetUserProfileImage];

	
	[((MobileJabberAppDelegate*) [[UIApplication sharedApplication] delegate]) GetEventsWithUserId:[NSString stringWithFormat:@"%@",
							   [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"
								 ] objectAtIndex:0]
							   ]
	 ];
    
    [((MobileJabberAppDelegate*) [[UIApplication sharedApplication] delegate]) GetPollsWithUserId:[NSString stringWithFormat:@"%@",
        [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"] objectAtIndex:0]]];

	[self GetWeatherFromLocation:DEFAULT_LOCATION];

    // [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) SendPasswordUpdateRequest];
	
	
}

- (void)reinit {
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	IsNotificationShowed = NO;
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.leftBarButtonItem = nil;
    
    // [ObjContactListViewController removeFromParentViewController];
    [ObjContactListViewController release];
    ObjContactListViewController = nil;
    
    ObjContactListViewController = [[ContactListViewController alloc] initWithNibName:@"ContactListViewController"
																			   bundle:nil];
	ObjContactListViewController.view.frame = CGRectMake(0,60,286,678);
	ObjContactListViewController.del=self;
	[self.view addSubview:ObjContactListViewController.view];

    // Clear out events 
    [self reUpdateEventList];
	// Update Online Presence
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) goOnline]; 

	
	[((MobileJabberAppDelegate*) [[UIApplication sharedApplication] delegate]) GetEventsWithUserId:[NSString stringWithFormat:@"%@",
            [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"
            ] objectAtIndex:0]
        ]
	 ];
    
    [((MobileJabberAppDelegate*) [[UIApplication sharedApplication] delegate]) GetPollsWithUserId:[NSString stringWithFormat:@"%@",
            [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"] objectAtIndex:0]]];
	[self GetWeatherFromLocation:DEFAULT_LOCATION];
    
    // [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) SendPasswordUpdateRequest];
	
	[self.view addSubview:
	 ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).menuToolBar];
	
}


- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName != nil && 
		![((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName isEqualToString:@""]) {
		
		lblUserName.text = ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName;
	}
	else {
		lblUserName.text = [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"
		] objectAtIndex:0];
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(setUserFullName:) 
												 name:NSNOTIFICATION_SET_USER_FULL_NAME 
											   object:nil];
	
    /*
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(SetUserAvtarImage:) 
												 name:NSNOTIFICATION_USER_AVTAR 
											   object:nil];
     */

	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(AddEventIQSent:) 
												 name:NSNOTIFICATION_ADDEVENT 
											   object:nil];
	

	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(ShowTodaysWeather:) 
												 name:NSNOTIFICATION_SHOW_TODAYS_WEATHER 
											   object:nil];

	
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(CountryCitySelected:) 
												 name:NSNOTIFICATION_COUNTRY_CITY_SELECTED 
											   object:nil];

	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(UpdateEventList:) 
												 name:NSNOTIFICATION_SHOW_EVENTS 
											   object:nil];
	
	//[[NSNotificationCenter defaultCenter] addObserver:self 
//											 selector:@selector(GoToChatView:) 
//												 name:NSNOTIFICATION_SHOW_CHAT 
//											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(LogOut:) 
												 name:NOTIFICATION_LOGOUT 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(ChangeTheme:) 
												 name:NSNOTIFICATION_CHANGE_APPLICATION_THEME 
											   object:nil];
	
	/*[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(GoToChatViewFromUserOption:) 
												 name:NSNOTIFICATION_CHAT_FROM_USER_OPTION 
											   object:nil];*/
	
	
	
	NSMutableDictionary * dictTheme = [[NSMutableDictionary alloc] initWithContentsOfFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath];
	
	if([[dictTheme valueForKey:@"ThemeNumber"] isEqualToString:@"1"]){
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ThemeNumber = 1;
		imvBackgroundImage.image = [UIImage imageNamed:@"wood-floor-wallpapers_6855_1280x800.jpg"];
    }
    else if([[dictTheme valueForKey:@"ThemeNumber"] isEqualToString:@"2"]){
            ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ThemeNumber = 2;
            imvBackgroundImage.image = [UIImage imageNamed:@"theme2.jpg"];
	}else {
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ThemeNumber = 3;		
		imvBackgroundImage.image = [UIImage imageNamed:@"theme3.jpg"];
	}
	[dictTheme release];
	
    [self setUserFullName:nil];
	
	
    /*	
	if(((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strStatusMessage!=nil
	   ){
		txtUserStatus.text = ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strStatusMessage;
	}
     */

    /*
         
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) RequestUserProfileWithJid:
	 [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] full
	  ]
	 ];
     */
    /*
	if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName != nil && 
		![((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName isEqualToString:@""]) {
		
		lblUserName.text = ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName;
	}
	else {
		lblUserName.text = [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"
							 ] objectAtIndex:0];
	}
    imvUserProfile.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getSelfImage];
     */
	[self.view addSubview:
	 ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).menuToolBar];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	//NSLog(@"%i",interfaceOrientation);	
	// return(interfaceOrientation==UIInterfaceOrientationLandscapeRight);
	return(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)viewWillDisappear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewWillDisappear:animated];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	[imvBackgroundImage release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom or IBAction Methods

-(void)setUserFullName:(id)sender {
	if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName != nil && 
		![((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName isEqualToString:@""]) {
		
		lblUserName.text = ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName;
	}
	else {
		lblUserName.text = [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"
							 ] objectAtIndex:0];
	}
	imvUserProfile.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getSelfImage];				
}


-(IBAction)BtnViewUserProfileTabbed:(id)sender{
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) ShowUserProfile:sender info:nil
	 ];
}


-(IBAction)BtnThemesTabbed:(id)sender{
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) BtnThemesTabbed:sender];
}

-(IBAction)BtnSettingTabbed:(id)sender{
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) BtnSettingTabbed:sender];
}

-(IBAction)BtnMenuTabbed:(id)sender{
	//[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) BtnApplicationMenuTabbed:sender];
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) btnNameBarTapped:sender];
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
/*
-(IBAction)BtnUpdateUserStatusTabbed:(id)sender{
	if([[txtUserStatus.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
		 ]
		length]>0){
		NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
		[presence addAttributeWithName:@"from" 
						   stringValue:[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] full]
		 ];
		
		
		
		NSXMLElement	* statusElement = [NSXMLElement elementWithName:@"status" stringValue:txtUserStatus.text];
		
		
		[presence addChild:statusElement];
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:presence
		 ];
		
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strStatusMessage = txtUserStatus.text;
		
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
		
		
		[dictApplicationSettings writeToFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath atomically:YES]?NSLog(@"Success"):NSLog(@"Failure");
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
*/

-(void)GetUserProfileImage{

    /*
	NSData *photoData = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) xmppvCardAvatarModule] photoDataForJID:
						 [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID]
						 ];
	
	imvUserProfile.image = [UIImage imageWithData:photoData];			
     */
	imvUserProfile.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getSelfImage];			
    
	
}

-(IBAction)BtnAddEventTabbed:(id)sender{
}

-(void)ShowTodaysWeather:(id)sender{
}

-(void)GetWeatherFromLocation:(NSString*)strLocation{
}

-(void)AddEventIQSent:(id)sender{
	[ObjPopoverController_ContactListViewOptions dismissPopoverAnimated:YES];
}

-(void)CountryCitySelected:(id)sender{
}

-(IBAction)BtnEditWeatherTabbed:(id)sender{
}

-(void)reUpdateEventList {
	if(ObjEventListDelegate!=nil && [ObjEventListDelegate retainCount]>0){
		[ObjEventListDelegate release];
		ObjEventListDelegate = nil;
	}
    NSMutableArray * evtary = [[NSMutableArray alloc] init];
	ObjEventListDelegate = [[EventListDelegate alloc] initWithArray:evtary];	
	TblEvent.delegate = ObjEventListDelegate;	
	if(ObjEventListDataSource!=nil && [ObjEventListDataSource retainCount]>0){
		[ObjEventListDataSource release];
		ObjEventListDataSource = nil;
	}
	ObjEventListDataSource = [[EventListDataSource alloc] initWithArray:evtary];	
	TblEvent.dataSource = ObjEventListDataSource;
	[TblEvent reloadData];
    [evtary release];	
}

-(void)UpdateEventList:(id)sender{
	if(ObjEventListDelegate!=nil && [ObjEventListDelegate retainCount]>0){
		[ObjEventListDelegate release];
		ObjEventListDelegate = nil;
	}
	ObjEventListDelegate = [[EventListDelegate alloc] initWithArray:[sender object]];
	
	TblEvent.delegate = ObjEventListDelegate;
	
	if(ObjEventListDataSource!=nil && [ObjEventListDataSource retainCount]>0){
		[ObjEventListDataSource release];
		ObjEventListDataSource = nil;
	}
	ObjEventListDataSource = [[EventListDataSource alloc] initWithArray:[sender object]];
	
	TblEvent.dataSource = ObjEventListDataSource;
	
	[TblEvent reloadData];
	
}
-(void)showview:(NSString *)viewName{
}


/*-(void)GoToChatView:(id)sender{
	ObjChatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
	[self.navigationController pushViewController:ObjChatViewController animated:NO];
	[ObjChatViewController release];
}*/



-(void)ChangeTheme:(id)sender{
	if([[sender object] isEqualToString:@"1"]){
		imvBackgroundImage.image = [UIImage imageNamed:@"wood-floor-wallpapers_6855_1280x800.jpg"];
	}else if([[sender object] isEqualToString:@"2"]){
		imvBackgroundImage.image = [UIImage imageNamed:@"theme2.jpg"];
	}else if([[sender object] isEqualToString:@"3"]){
		imvBackgroundImage.image = [UIImage imageNamed:@"theme3.jpg"];
	}
}

-(void)LogOut:(id)sender{
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ObjPopoverController_Menu dismissPopoverAnimated:YES];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)BtnNotificationsTabbed:(id)sender{
	if(IsNotificationShowed){
		IsNotificationShowed = NO;
	}else {
		IsNotificationShowed = YES;
		
	}
}

#pragma mark -
#pragma mark UITextField delegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	textField.keyboardType =  UIKeyboardTypeDefault;
	return YES;
}

@end
