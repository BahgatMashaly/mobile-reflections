    //
//  LoginViewController.m
//  MobileJabber
//
//  Created by Shivang Vyas on 6/16/11.
//  Copyright 2011 company. All rights reserved.
//

#import "LoginViewController.h"
#import <sqlite3.h>


@implementation LoginViewController
static sqlite3 *database;

- (void)viewDidLoad {
    [super viewDidLoad];
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	/*[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];	
	[[UIDevice currentDevice] setOrientation:UIDeviceOrientationLandscapeRight];	*/

	
	self.title = @"";
	IsBtnLogMeInAutomaticallyTabbed = NO;
	IsBtnLogInWithOfflineModeTabbed = NO;
	

	self.navigationController.navigationBarHidden = YES;
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(ChangeTheme:) 
												 name:NSNOTIFICATION_CHANGE_APPLICATION_THEME 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(LoginSuccessful:) 
												 name:NOTIFICATION_LOGIN_SUCCESSFUL 
											   object:nil];

	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(getForgotPasswordStatus:) 
												 name:FORGOTPASSWORD_NOTIFICATION 
											   object:nil];
	

	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(getServerConfigChanged:) 
												 name:NSNOTIFICATION_SERVER_CONFIG_CHANGE 
											   object:nil];
		
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];

	NSMutableDictionary * dictLastSavedInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath];	

	// We want to auto remember the last name
    txtUsername.text =  [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strUserName componentsSeparatedByString:@"@"] objectAtIndex:0];

    if([[dictLastSavedInfo valueForKey:@"IsAutoLoginEnabled"] boolValue]){
		txtPassword.text =  [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPassword componentsSeparatedByString:@"@"] objectAtIndex:0
							 ];
		IsAutoLoginEnabled = YES;
		[BtnLogMeInAutomatically setImage:[UIImage imageNamed:@"checklist checked.png"] 
								 forState:UIControlStateNormal];
		
	}else {
		[BtnLogMeInAutomatically setImage:[UIImage imageNamed:@"checklist not checked.png"]
								 forState:UIControlStateNormal];
		IsAutoLoginEnabled = NO;
	}
    
	
	//===========Getting last saved theme and setting it accordingly........!!
	if([[dictLastSavedInfo valueForKey:@"ThemeNumber"] isEqualToString:@"1"]){
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ThemeNumber = 1;
    } else if([[dictLastSavedInfo valueForKey:@"ThemeNumber"] isEqualToString:@"2"]){
            ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ThemeNumber = 2;
	}else {
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ThemeNumber = 3;		
	}
	
	if(((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ThemeNumber==1){
		imvBackground.image = [UIImage imageNamed:@"wood-floor-wallpapers_6855_1280x800.jpg"];
	}else if(((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ThemeNumber==2){
		imvBackground.image = [UIImage imageNamed:@"theme2.jpg"];
	}else if(((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ThemeNumber==3){
		imvBackground.image = [UIImage imageNamed:@"theme3.jpg"];
	}

	[dictLastSavedInfo release];

    int hlogout = ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).hardLogout;
    	
	if(IsAutoLoginEnabled && hlogout == 0){
		// IsAutoLoginEnabled = NO;
		if(txtUsername.text != nil && txtPassword.text != nil){
			if(([[txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet
																  ]
				 ] length] > 0) && ([[txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet
																					   ]
									  ] length] > 0)){
				[self BtnLoginTabbed:self];
			}
		}
	}else {
		txtPassword.text=@"";
        if([[txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
            [txtUsername becomeFirstResponder];
        else
            [txtPassword becomeFirstResponder];
	}
    
    if (CONNECTION_MODE == 1) 
        [BtnServerSetting setHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// NSLog(@"%i",interfaceOrientation);
	return(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [BtnServerSetting release];
    BtnServerSetting = nil;
    [super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc {
    [BtnServerSetting release];
    [super dealloc];
}


#pragma mark -
#pragma mark IBAction or Custom Methods
-(IBAction)BtnLoginMeInAutomaticallyTabbed:(id)sender{
	if(IsBtnLogMeInAutomaticallyTabbed){
		IsBtnLogMeInAutomaticallyTabbed = NO;
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).IsAutoLoginEnabled = NO;
		[BtnLogMeInAutomatically setImage:[UIImage imageNamed:@"checklist not checked.png"] 
								 forState:UIControlStateNormal];

		/*
		NSMutableDictionary * dictAppSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath
												 ];
		
		
		[dictAppSettings setValue:[NSString stringWithFormat:@"%i",
								   ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate
																]).ThemeNumber]
						   forKey:@"ThemeNumber"];

		[dictAppSettings setValue:@"NO" forKey:@"IsAutoLoginEnabled"];
		[dictAppSettings setValue:txtUsername.text forKey:@"UserName"];
		[dictAppSettings setValue:txtPassword.text forKey:@"Password"];
		[dictAppSettings setValue:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate
															  ]).strStatusMessage
						   forKey:@"status"];
		
		[dictAppSettings writeToFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath atomically:YES]?NSLog(@"Success"):NSLog(@"Failure");
		[dictAppSettings release];
         */
		
	}else {
		IsBtnLogMeInAutomaticallyTabbed = YES;
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).IsAutoLoginEnabled = YES;		
		[BtnLogMeInAutomatically setImage:[UIImage imageNamed:@"checklist checked.png"] 
								 forState:UIControlStateNormal];

        /*
		NSMutableDictionary * dictAppSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath
												 ];
		
		
		[dictAppSettings setValue:[NSString stringWithFormat:@"%i",
								   ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate
															   ]).ThemeNumber]
						   forKey:@"ThemeNumber"];
		
		[dictAppSettings setValue:@"YES" forKey:@"IsAutoLoginEnabled"];
		[dictAppSettings setValue:txtUsername.text forKey:@"UserName"];
		[dictAppSettings setValue:txtPassword.text forKey:@"Password"];
		[dictAppSettings setValue:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate
															  ]).strStatusMessage
						   forKey:@"status"];
		
		[dictAppSettings writeToFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath atomically:YES]?NSLog(@"Success"):NSLog(@"Failure");
		[dictAppSettings release];
         */
		
	}

}

-(IBAction)BtnLogInWithOfflineModeTabbed:(id)sender{
	if(IsBtnLogInWithOfflineModeTabbed){
		IsBtnLogInWithOfflineModeTabbed = NO;
		[BtnLogInWithOfflineMode setImage:[UIImage imageNamed:@"checklist not checked.png"] 
								 forState:UIControlStateNormal];
	}else {
		IsBtnLogInWithOfflineModeTabbed = YES;
		[BtnLogInWithOfflineMode setImage:[UIImage imageNamed:@"checklist checked.png"] 
								 forState:UIControlStateNormal];		
	}
}

-(IBAction)btnEmojiTabbed:(id)sender{
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

-(void)SaveSettings {
    
    NSMutableDictionary * dictAppSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath];

    if(!IsBtnLogMeInAutomaticallyTabbed)
    {		
		[dictAppSettings setValue:@"NO" forKey:@"IsAutoLoginEnabled"];
		[dictAppSettings setValue:txtUsername.text forKey:@"UserName"];
		[dictAppSettings setValue:txtPassword.text forKey:@"Password"];		
	}else {
		[dictAppSettings setValue:@"YES" forKey:@"IsAutoLoginEnabled"];
		[dictAppSettings setValue:txtUsername.text forKey:@"UserName"];
		[dictAppSettings setValue:txtPassword.text forKey:@"Password"];
	}
    [dictAppSettings writeToFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath atomically:YES]?NSLog(@"Success"):NSLog(@"Failure");
    [dictAppSettings release];
}

-(void)LoginSuccessful:(id)sender{
	[self SaveSettings];
	[LoadingAlert HideLoadingAlert];

    /*
	if (ObjHomeViewController != nil) {
        [ObjHomeViewController.view removeFromSuperview];
        [ObjHomeViewController release];
        ObjHomeViewController = nil;
    }
     */
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).menuToolBar setSelectedItem:
	 [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).menuToolBar items] objectAtIndex:0]
	 ];
	if (ObjHomeViewController == nil) {
        ObjHomeViewController = [[HomeViewController alloc] init];
		[self.navigationController pushViewController:ObjHomeViewController animated:YES];
        // [homeViewController release];        
    } else {
        [ObjHomeViewController reinit];
		[self.navigationController pushViewController:ObjHomeViewController animated:YES];        
    }

	//ObjHomeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
//	[self.navigationController pushViewController:ObjHomeViewController animated:YES];
//	[ObjHomeViewController release];
	
    /*
	HomeViewController *homeViewController = [[HomeViewController alloc] init];
		[self.navigationController pushViewController:homeViewController animated:YES];
	[homeViewController release];
     */
	
/*
 <iq id="3" type="get" to="services.mqcommunicator"><query xmlns="services:iq:getuserroles"><jid>victor</jid></query></iq>
 */
	// Rakesh
	NSXMLElement * iqRole = [NSXMLElement elementWithName:@"iq"];
	[iqRole addAttributeWithName:@"type" stringValue:@"get"];
	[iqRole addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"services.%@",SERVERNAME]
	 ];
	
	NSXMLElement * queryRole = [NSXMLElement elementWithName:@"query" xmlns:@"services:iq:getuserroles"];
	NSXMLElement * jId = [NSXMLElement elementWithName:@"jid" stringValue:txtUsername.text];
	[queryRole addChild:jId];
	[iqRole addChild: queryRole];
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:iqRole];		
}

-(void)EnableEmojiKeyboard {
	NSMutableDictionary *idict = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"../../Library/Preferences/"] stringByAppendingPathComponent:@"com.apple.Preferences.plist"]];	
	NSString *status = [idict objectForKey:@"KeyboardEmojiEverywhere"];
	if (![status boolValue]) {
		[idict setObject:[NSNumber numberWithBool:TRUE] forKey:@"KeyboardEmojiEverywhere"];
        [idict writeToFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"../../Library/Preferences/"] stringByAppendingPathComponent:@"com.apple.Preferences.plist"] atomically:NO]?NSLog(@"success"):NSLog(@"fail");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" 
														 message:@"To use emoticons in your messages, you'll need to turn on the Japanese Emoji keyboard.\n\nGo to \"Settings\" ➔ \"General\" ➔ \"Keyboard\" ➔ \"International Keyboards\" ➔ \"Japanese\" ➔ Turn \"Emoji\" to ON." 
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
}

-(IBAction)BtnSearchTabbed:(id)sender{
	NSXMLElement * iq1 = [NSXMLElement elementWithName:@"iq"];
	[iq1 addAttributeWithName:@"type" stringValue:@"set"];
	[iq1 addAttributeWithName:@"from" stringValue:@"admin@localhost.localdomain"];	
	[iq1 addAttributeWithName:@"to" stringValue:@"search.localhost.localdomain"];
	[iq1 addAttributeWithName:@"id" stringValue:@"search2"];
	[iq1 addAttributeWithName:@"xml:lang" stringValue:@"en"];
	
	NSXMLElement * query1 = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:search"];
	NSXMLElement * email = [NSXMLElement elementWithName:@"email" stringValue:@"shivang.vyas@triforce.co.in"];
	[query1 addChild:email];
	[iq1 addChild:query1];
	
	// NSLog(@"%@",iq1);
	
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:iq1];		
	
}

-(IBAction)BtnTest:(id)sender{
	/*	
	 <iq type='get'
	 from='romeo@montague.net/home'
	 to='characters.shakespeare.lit'
	 id='search1'
	 xml:lang='en'>
	 <query xmlns='jabber:iq:search'/>
	 </iq>
	 */

	NSXMLElement * iq = [NSXMLElement elementWithName:@"iq"];
	[iq addAttributeWithName:@"type" stringValue:@"get"];
	[iq addAttributeWithName:@"from" stringValue:@"admin@localhost.localdomain"];	
	[iq addAttributeWithName:@"to" stringValue:@"search.localhost.localdomain"];
	[iq addAttributeWithName:@"id" stringValue:@"search1"];
	[iq addAttributeWithName:@"xml:lang" stringValue:@"en"];
	
	NSXMLElement * query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:search"];
	[iq addChild:query];
	
	// NSLog(@"%@",iq);
	
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:iq];

	
	/*	<iq type="get" 
	 from="shivang@localhost.localdomain" 
	 to="localhost.localdomain" 
	 id="search1" 
	 xml:lang="en">
	 <query xmlns="jabber:iq:search"></query xmlns="jabber:iq:search"></iq>
     */
	 
	 /*	
	 <iq type='set'
	 from='romeo@montague.net/home'
	 to='characters.shakespeare.lit'
	 id='search2'
	 xml:lang='en'>
	 <query xmlns='jabber:iq:search'>
	 <last>Capulet</last>
	 </query>
	 </iq>
	 */

/*	
	<iq from="sister@realworld.lit/home" id="p982bs61"
	to="alice@wonderland.lit/rabbithole"
	type="get"> <query xmlns="http://jabber.org/protocol/disco#info"/>
	</iq>
*/
/*	
	NSXMLElement * iq = [NSXMLElement elementWithName:@"iq"];
	[iq addAttributeWithName:@"from" stringValue:@"admin@localhost.localdomain"];	
	[iq addAttributeWithName:@"to" stringValue:SERVERNAME];
	[iq addAttributeWithName:@"type" stringValue:@"get"];
	NSXMLElement * query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"];
	
	[iq addChild:query];

*/	
}

-(IBAction)BtnLoginTabbed:(id)sender{
	NSString * ErrMsg = @"";
	flag = 0;
	
	if([[txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
		 ] length] == 0){
		ErrMsg = @"Please enter a valid username.";
		flag = 1;
	}else if([[txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
			   ] length] == 0){
		ErrMsg = @"Please enter you password.";
		flag = 2;
	}
	
	if(![ErrMsg isEqualToString:@""]){
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" 
														 message:ErrMsg 
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	}else{
        // We do this as jabber is always lowercased
        txtUsername.text = [txtUsername.text lowercaseString];        
		[LoadingAlert ShowLoadingAlert];
        
        [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) resetFirstTimeLogin];

        if (IsBtnLogInWithOfflineModeTabbed){
            NSLog(@"offlineloginMode");
        
       BOOL isLoginCorrect = [self checkUserOfflineLoging];
            
            if (isLoginCorrect) {
                NSLog(@"loginCorrect");
                ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strUserName = [NSString stringWithFormat:@"%@@%@",txtUsername.text,SERVERNAME];
                ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPassword = txtPassword.text;
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESSFUL object:nil];
            }
            else{
                
                [LoadingAlert HideLoadingAlert];
                NSLog(@"loginIncorrect");
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" 
                                                                 message:@"User not available offline." 
                                                                delegate:self 
                                                       cancelButtonTitle:@"OK" 
                                                       otherButtonTitles:nil];
                
                [alert show];
                [alert release];
            
            }
            
            
       
		}
        else{
        
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strUserName = [NSString stringWithFormat:@"%@@%@",txtUsername.text,SERVERNAME];
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPassword = txtPassword.text;
	
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) InitializeChattingwithHostName:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strServerLocation
																						 PortNum:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ServerPort
																						UserName:[NSString stringWithFormat:@"%@@%@",txtUsername.text,SERVERNAME] //[NSString stringWithFormat:@"%@@jabbear.com",txtUserName.text]
																						Password:txtPassword.text
		 ];
        } 
	}
}

-(void)getForgotPasswordStatus:(id)sender{
	NSLog(@"%@",[sender description]);
	
	if([[[sender object] valueForKey:@"result"] isEqualToString:@"ok"]){
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message"
														 message:@"Password has been changed Successfully !" 
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil];
		[alert show];
		[alert release];
	}else {
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" 
														 message:[[sender object] valueForKey:@"error"] 
														delegate:nil 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
}

-(IBAction)BtnSubmitTabbed:(id)sender{
	NSURL * RegisterURL = [NSURL URLWithString:
						   [NSString stringWithFormat:FORGOT_PASSWORD_URL,
							txt_f_Username.text,
							txt_f_NewPassword.text]
						   ];
	
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:RegisterURL];
	
	ObjURLRequestHandler = [[URLRequestHandler alloc] initWithRequest:request delegate:nil NotificationName:FORGOTPASSWORD_NOTIFICATION];
	
}

-(void)BtnChangePasswordTabbed:(id)sender{
	if([popoverController isPopoverVisible])
	{
		[self dismissModalViewControllerAnimated:YES];	
		[popoverController dismissPopoverAnimated:YES];
		return;
	}
	
	//build our custom popover view
	popoverContent.modalInPopover = TRUE;
	popoverContent.view = popoverChangePassword;
	
	//resize the popover view shown
	//in the current view to the view's size
	popoverContent.contentSizeForViewInPopover = CGSizeMake(550, 350);
	
	//create a popover controller
	popoverController = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
	
	//present the popover view non-modal with a
	//refrence to the toolbar button which was pressed
	[popoverController 
	 presentPopoverFromBarButtonItem:sender                           
	 permittedArrowDirections:UIPopoverArrowDirectionAny 
	 animated:YES];
}

-(void)BtnRegisterTabbed:(id)sender{
}


-(IBAction)BtnDismissTabbed:(id)sender{
	[self dismissModalViewControllerAnimated:YES];	
	[popoverController dismissPopoverAnimated:YES];
}

- (IBAction)btnPulseLogoTapped:(UIButton*)sender {
	if (ObjPopoverController != nil && [ObjPopoverController retainCount] > 0) {
		ObjPopoverController = nil;
	}
	ServerSettingScreenViewController *objServerSetting = [[ServerSettingScreenViewController alloc] initWithNibName:@"ServerSettingScreenViewController" bundle:nil];
	ObjPopoverController = [[UIPopoverController alloc] initWithContentViewController:objServerSetting];
	CGRect popOverRect = [self.view convertRect:[sender frame] fromView:[sender superview]];
	[ObjPopoverController setPopoverContentSize:CGSizeMake(300, 170)];
	[ObjPopoverController presentPopoverFromRect:popOverRect inView:[sender superview] permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (void)getServerConfigChanged:(NSNotification*)notification {
	[ObjPopoverController dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark UIAlertView delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex==0){
		if(flag == 1){
			[txtUsername becomeFirstResponder];
		}else if(flag == 2){
			[txtPassword becomeFirstResponder];
		}
	}
}


#pragma mark -
#pragma mark UITextField delegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	textField.keyboardType =  UIKeyboardTypeDefault;
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;	
}


#pragma mark -
#pragma mark OfflineLogin Methods
-(void) storeUserName{


  //  NSString *usrname = [NSString stringWithString:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strUserName];
    
   // NSString *passw = [NSString stringWithString:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPassword];
    
   // NSString *fullname = [NSString stringWithString:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName];
    
 //   usrname = [usrname stringByReplacingOccurrencesOfString:SERVERNAME withString:@""];
    //usrname = [usrname stringByReplacingOccurrencesOfString:@"@" withString:@""];
  //  NSLog(@"username: %@",usrname);
 //   NSLog(@"pass: %@",passw);
   // NSLog(@"fullname: %@",fullname);
    
    
    
    
   
    
    NSString *dbPath = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getDBPathForDB];
	
	sqlite3_stmt *selectstmt = nil;//
    
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
    
    
    NSString *sql = [NSString stringWithFormat:@"insert into users(userid, password) values ('%@', '%@');",txtUsername.text,txtPassword.text];
        
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &selectstmt, NULL) != SQLITE_OK) {
            NSAssert1(0,@"error preparing statement",sqlite3_errmsg(database));
            return;
        } else {
            NSLog(@"sql: %@",sql);
            sqlite3_step(selectstmt);
            
        }
        sqlite3_reset(selectstmt);
        
    }
}

-(BOOL) checkUserOfflineLoging{

    NSString *dbPath = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getDBPathForDB];
	
	sqlite3_stmt *selectstmt = nil;//
    
    NSString *dbPassword = @"";
    
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        
        NSString *sql = [NSString stringWithFormat:@"select password from users where userid = '%@';",txtUsername.text];
        
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &selectstmt, NULL) != SQLITE_OK) {
            NSAssert1(0,@"error preparing statement",sqlite3_errmsg(database));
            return NO;
        } else {
            NSLog(@"sql: %@",sql);
            //sqlite3_step(selectstmt);
            if(sqlite3_step(selectstmt) == SQLITE_ROW) {
                 dbPassword = sqlite3_column_text(selectstmt, 0) != NULL ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)] : @"";
                NSLog(@"dbPassword %@",dbPassword);
                //sqlite3_reset(selectstmt);
                //sqlite3_close(database);
                if ([dbPassword isEqualToString:txtPassword.text]) {
                    NSLog(@"password match");
                    return YES;
                }
                else{
                    NSLog(@"password donot match");
                    return NO;
                }
                
            }
            
        }
        sqlite3_reset(selectstmt);
        
    }
    else{
    
        return NO;
    
    }
    return NO;
    



}
@end
