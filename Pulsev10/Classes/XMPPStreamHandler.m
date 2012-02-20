//
//  XMPPStreamHandler.m
//  MobileJabber
//
//  Created by Shivang Vyas on 6/20/11.
//  Copyright 2011 company. All rights reserved.
//

#import "XMPPStreamHandler.h"


@implementation XMPPStreamHandler

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	// NSLog(@"---------- xmppStream:willSecureWithSettings: ----------");
	
	if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream.hostName;
		NSString *virtualDomain = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else
		{
			expectedCertName = serverDomain;
		}
        
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];		
        [settings setObject:[NSNumber numberWithBool:NO]  forKey:(NSString *)kCFStreamSSLValidatesCertificateChain];

		// [settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	// NSLog(@"---------- xmppStreamDidSecure: ----------");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
	// NSLog(@"---------- xmppStreamDidConnect: ----------");
	NSError *error = nil;	
		isOpen = YES;
	if (![[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) xmppStream] authenticateWithPassword:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPassword error:&error]){
		//NSLog(@"Error authenticating: %@", error);
		
		[LoadingAlert HideLoadingAlert];
		//NSLog(@"Error authenticating: %@", error);
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" 
														 message:[NSString stringWithFormat:@"Error while authenticating: %@", error]
														delegate:nil 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil];
		[alert show];
		[alert release];

	}	
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
	// NSLog(@"---------- xmppStreamDidAuthenticate: ----------");
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).isLoggedIn = YES;
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication]delegate]).aryActiveUsers = [[NSMutableArray alloc] init];
	[LoadingAlert HideLoadingAlert];
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName = @"";
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strSelfEmail = @"";
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication]delegate]).aryFileRequestArray = [[NSMutableArray alloc] init];
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryOwnedGroupChat = [[NSMutableArray alloc] init];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESSFUL object:nil];
	
}



- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
	// NSLog(@"---------- xmppStream:didNotAuthenticate: ----------");
	[LoadingAlert HideLoadingAlert];	
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" 
													 message:@"Incorrect Username or Password, Please Try Again !" 
													delegate:nil 
										   cancelButtonTitle:@"OK" 
										   otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
	// NSLog(@"---------- xmppStream:didReceiveIQ: ----------");

	if([[iq type] isEqualToString:@"result"])
	{		
		if([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"assessment:iq:addpoll"])
		{ 
			// NSLog(@"--------------------------------------------------  %@ ",iq);
			NSString *  temp = [[iq childElement]  stringValue];
			// NSLog(@"---------#######---------------- { %@ } -------------#####------------",temp);
			[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SEND_POLL_TO_STUDENTS object:temp];
		}
	}
	if([[iq type] isEqualToString:@"get"]){		
		if([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"file:iq:accept"]){ 
	/* <iq	type="get" 
			to="amanda@mqcommunicator/Messenger" 
			from="devika@mqcommunicator/Messenger">
			<query xmlns="file:iq:accept">
				amandaTodevikaOn2011-07-15-22:38:49.png
			</query>
		</iq>
	*/			
	//	start the file transfer now....!
			
		}
	}

	if([[iq type] isEqualToString:@"get"]){		
		if([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"file:iq:transfer"]){
			
			/*
			 <iq type="get" to="devika@mqcommunicator/Messenger" from="amanda@mqcommunicator/Messenger">
			 <query xmlns="file:iq:transfer">
			 amandaTodevikaOn2011-07-15-19:40:28.png|205748
			 </query>
			 </iq> 
			 */

			
			//NSLog(@"%f",[[[[[iq childElement] stringValue] componentsSeparatedByString:@"|"] objectAtIndex:1
//						  ] doubleValue]);
			

			
			UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"File Transfer Request" 
															 message:[NSString stringWithFormat:@"You have received file - %@ from %@",
																	  [[[[iq childElement] stringValue] componentsSeparatedByString:@"|"] objectAtIndex:0
																	   ],
																	  [iq valueForKey:@"from"]
																	  ]
															delegate:self 
												   cancelButtonTitle:@"Accept" 
												   otherButtonTitles:@"Reject",nil];
			[alert show];
			[alert release];
		}
	}
	
/*	
	RECV: <iq to="victor@mqcommunicator/b8542c0" from="services.mqcommunicator" type="result" id="1">
		<query xmlns="services:iq:getevents">
			<result type="dataset">
				<NewDataSet>
					<Table>
						<id>1</id>
						<userid>victor</userid>
						<eventname>Exercise Ex-Hedron</eventname>
						<eventdate>2011-08-12T00:00:00-07:00</eventdate>
						<eventduration>Half day</eventduration>
					</Table>
					<Table>
						<id>2</id>
						<userid>victor</userid>
						<eventname>Complete eCyberSmart</eventname>
						<eventdate>2011-07-16T00:00:00-07:00</eventdate>
						<eventduration>Half day</eventduration>
						</Table>
					<Table>
						<id>3</id>
						<userid>victor</userid>
						<eventname>Complete Peer Review</eventname>
						<eventdate>2011-07-18T00:00:00-07:00</eventdate>
						<eventduration>Half day</eventduration>
					</Table>
				</NewDataSet>
			</result>
		</query>
	</iq>
*/
	
/*
	<iq to="devika@mqcommunicator/1fdf5ef3" from="services.mqcommunicator" type="result">
		<query xmlns="services:iq:addevent">
			<result type="bool">
				True
			</result>
		</query>
	</iq>
 */
	
	if([[iq type] isEqualToString:@"result"]){
		if([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"services:iq:addevent"]){
			NSXMLElement * query = [iq childElement];
			NSXMLElement * result = [query elementForName:@"result"];
			//NSLog(@"%@",[result stringValue]);
			
			if([[[result stringValue] uppercaseString] isEqualToString:@"TRUE"]){
				//NSLog(@"new events are added successfully !");
				UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" 
																 message:@"Event added Successfuly !" 
																delegate:nil 
													   cancelButtonTitle:@"OK" 
													   otherButtonTitles:nil];
				[alert show];
				[alert release];
				
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) GetEventsWithUserId:
				 [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"
					] objectAtIndex:0]];
			}
		}
	}
	
	if([[iq type] isEqualToString:@"result"]){
	}

/*	
	if([[[[iq fromStr] componentsSeparatedByString:@"@"] objectAtIndex:0] isEqualToString:
		[[[iq toStr] componentsSeparatedByString:@"@"] objectAtIndex:0]
		]){
		NSData *photoData = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) xmppvCardAvatarModule] photoDataForJID:
							 [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID]
							 ];
		
		if(photoData!=nil){
			if([photoData length]>0){
				((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).imvProfileImage.image = [UIImage imageWithData:photoData];
				
//				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).navigationController.navigationBar drawRect:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).navigationController.navigationBar.frame
//				 ];
				NSLog(@"user profile photo changed");
			}
		}
		
		
	}
*/	
	
	if([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"vcard-temp"]){
		/* 
		 <iq type="result" to="devika@mqcommunicator/Messenger">
		 <vCard xmlns="vcard-temp">
		 <NICKNAME>devi</NICKNAME>
		 </vCard>
		 </iq>		 
		 */
		
		if([[[iq valueForKey:@"to"] description] isEqualToString:
			[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] full
			 ]
			]){
			//this is a profile info for current login user...!
			/*NSLog(@"%@",[iq description]);
			ObjProfileIQParser = [[ProfileIQParser alloc] initWithData:[[iq description] dataUsingEncoding:NSUTF8StringEncoding
																		]
													  NotificationName:NSNOTIFICATION_SHOW_PROFILE
								  ];
			if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactEmail == nil ||
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactEmail retainCount] <= 0) {
				((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactEmail = [[NSMutableArray alloc] init];
			}
			/* <iq> <vCard><EMAIL><INTERNET> */ 
			/*[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactEmail addObject:
			 [NSDictionary dictionaryWithObjectsAndKeys:[iq valueForKey:@"from"], @"jid", 
			  [[[[iq elementForName:@"vCard"] elementForName:@"EMAIL"] elementForName:@"INTERNET"] stringValue], @"email", nil]];*/
			if ([[iq elementForName:@"vCard"] elementForName:@"PHOTO"] != nil) {
				[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CONTACTS object:nil];	
			}
			
		
		}else{
			[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CONTACTS object:nil];
		}
	}


	
	if([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"services:iq:getuserroles"]){
		if(ObjUserRolesIQParser!=nil && [ObjUserRolesIQParser retainCount]>0){
			[ObjUserRolesIQParser release];
			ObjUserRolesIQParser = nil;
		}
		ObjUserRolesIQParser = [[UserRolesIQParser alloc] initWithData:[[iq description] dataUsingEncoding:NSUTF8StringEncoding] 
												NotificationName:@""];		
	}
	

	
	
	if([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"jabber:iq:roster"]){
        [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) SendPasswordUpdateRequest];
        // It's related to roster item....!
		if(ObjRosterIQParser!=nil && [ObjRosterIQParser retainCount]>0){
			[ObjRosterIQParser release];
			ObjRosterIQParser = nil;
		}
		
		ObjRosterIQParser = [[RosterIQParser alloc] initWithData:[[iq description] dataUsingEncoding:NSUTF8StringEncoding] 
												NotificationName:NOTIFICATION_RELOAD_CONTACTS];
        
            
		
	}

	if([[iq type] isEqualToString:@"result"]){
		if([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"jabber:iq:search"]){
		}
	}
	
    if ([[iq type] isEqualToString:@"result"]) {
        if ([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"services:iq:getuserbyid"]) {
          
            if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactEmail == nil ||
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactEmail retainCount] <= 0) {
				((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactEmail = [[NSMutableArray alloc] init];
			}

            
            ObjProfileIQParser = [[ProfileIQParser alloc] initWithData:[[iq description] dataUsingEncoding:NSUTF8StringEncoding
																		]
													  NotificationName:NSNOTIFICATION_SHOW_PROFILE
								  ];		

        }
    }
    
/*
<iq to="student1@mqcommunicator/Messenger" 
	from="services.mqcommunicator" 
	type="result">
	<query xmlns="services:iq:updateuserinfo">
		<result type="bool">True</result>
	</query>
 </iq>
*/
	if ([[iq type] isEqualToString:@"result"]) {
		if ([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"services:iq:updateuserinfo"]) {
			[[NSNotificationCenter defaultCenter] postNotificationName:NSSNOTIFICATION_EDIT_PROFILE_SUCCEED object:[[[iq childElement] elementForName:@"result"] stringValue]];
		}
	}
	
	/*
	 <iq type="get" to="student3@mqcommunicator/Messenger" from="student1@mqcommunicator/Messenger">
	 <query xmlns="chat:iq:invite">
	 class-test2#1316641921#room@conference.mqcommunicator
	 </query>
	 </iq>
	 */
	if ([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"chat:iq:invite"] && ![[iq type] isEqualToString:@"error"]) {
		/* <presence to="class-ocs1#24263202#room@conference.mqcommunicator/benny">
		 <status>Available</status>
		 <priority>0</priority>
		 </presence>*/
		NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
		[presence addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@/%@",
														  [[iq childElement] stringValue],
														  [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"
															] objectAtIndex:0]
														  ]];
		
		NSXMLElement *status = [NSXMLElement elementWithName:@"status" stringValue:@"Available"];
		NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"0"];
		[presence addChild:status];
		[presence addChild:priority];
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:presence];
		
		BOOL isAvailable = NO;
		int i = 0;
		NSString *strFrom = [[[[[iq childElement] stringValue] componentsSeparatedByString:@"#"] objectAtIndex:0] lowercaseString];
		for (id obj in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers) {
			if ([[obj objectForKey:@"user"] class] != [XMPPUserCoreDataStorage class]) {
				if ([strFrom isEqualToString:[[[obj objectForKey:@"user"] objectForKey: @"GroupName"] lowercaseString]]) {
					int chatBadgeCount = [[obj objectForKey:@"chatBadge"] intValue];
					NSMutableDictionary *dictObj = [NSMutableDictionary dictionaryWithDictionary:obj];
													
					[dictObj setValue:[NSString stringWithFormat:@"%d", chatBadgeCount] forKey:@"chatBadge"];
					[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers replaceObjectAtIndex:i withObject:dictObj];
					isAvailable = YES;
					break;
				}
			}
			i++;
		}
		if (!isAvailable) {
			NSArray *aryUserList = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
									 fetchedResultsController];
			
			for (NSDictionary *dict in aryUserList) {//((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactLists) {
				if ([[[dict objectForKey:@"GroupName"] lowercaseString] isEqualToString:strFrom]) {
					NSMutableDictionary *dictTemp = [NSMutableDictionary dictionaryWithDictionary:dict];
					[dictTemp setObject:[[iq childElement] stringValue] forKey:@"roomId"];
					[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers
					 addObject:[NSDictionary dictionaryWithObjectsAndKeys:dictTemp, @"user", @"0",@"chatBadge", @"groupChat", @"type", nil]];
					//NSLog([((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers description]);
				}
			}
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS object:nil];
		
		return YES;
	}
    if([[iq type] isEqualToString:@"get"]){
        if([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"poll:iq:refreshalert"])
        {
            [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) GetPollsWithUserId:
             [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"
               ] objectAtIndex:0]];
        }
    }
	if([[iq type] isEqualToString:@"get"])
	{		
		if([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"poll:iq:start"] && ![[iq type] isEqualToString:@"error"])
		{ 
            BOOL isAvailable = NO;
            int i = 0;
            NSString *pid = [[[iq childElement] elementForName:@"id"] stringValue];
            NSMutableArray *array = ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryPollMessages;
            int arrayCount = [array count];
            // NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];
            for (i = 0; i < arrayCount; i++) {
                if ([[[array objectAtIndex:i] valueForKey:@"id"] isEqualToString:pid]) {
                    isAvailable = YES;
                }
            }
            // [pool release];                         
            // [pid release];
            if (isAvailable) { 
                return YES;
            }
            
            NSMutableDictionary * dictPoll = [[NSMutableDictionary alloc] init];
            [dictPoll setValue:[[[iq childElement] elementForName:@"id"] stringValue] forKey:@"id"];
            NSInteger pollType = [[[[iq childElement] elementForName:@"type"] stringValue] integerValue];
            [dictPoll setValue:[[[iq childElement] elementForName:@"type"] stringValue] forKey:@"type"];
            [dictPoll setValue:[[[[iq childElement] elementForName:@"data"] elementForName:@"QUESTION"] stringValue] forKey:@"QUESTION"];
            [dictPoll setValue:[[[iq childElement] elementForName:@"anonymous"] stringValue] forKey:@"anonymous"];
            [dictPoll setValue:[[[iq childElement] elementForName:@"attempttime"] stringValue] forKey:@"attempttime"];
            // [dictPoll setValue:@"30" forKey:@"attempttime"];
            [dictPoll setValue:[iq valueForKey:@"from"] forKey:@"user"];
            [dictPoll setValue:[NSDate date] forKey:@"date"];
            [dictPoll setValue:@"1" forKey:@"mode"];
            
            if (pollType == 1) {
                // MCQ
                [dictPoll setValue:[[[[iq childElement] elementForName:@"data"] elementForName:@"OPTIONS"] stringValue] forKey:@"OPTIONS"];
                NSArray *tary = [[[[iq childElement] elementForName:@"data"] elementForName:@"OPTIONS"] elementsForName:@"OPTION"];
                [dictPoll setValue:[[tary objectAtIndex:0] attributeStringValueForName:@"TEXT"] forKey:@"OPTION1"];
                [dictPoll setValue:[[tary objectAtIndex:1] attributeStringValueForName:@"TEXT"] forKey:@"OPTION2"];
                [dictPoll setValue:[[tary objectAtIndex:2] attributeStringValueForName:@"TEXT"] forKey:@"OPTION3"];
                [dictPoll setValue:[[tary objectAtIndex:3] attributeStringValueForName:@"TEXT"] forKey:@"OPTION4"];
            }
            if (pollType == 2) {
                // True False
                [dictPoll setValue:[[[[iq childElement] elementForName:@"data"] elementForName:@"OPTIONS"] stringValue] forKey:@"OPTIONS"];
                NSArray *tary = [[[[iq childElement] elementForName:@"data"] elementForName:@"OPTIONS"] elementsForName:@"OPTION"];
                if ([tary count] == 2) {
                    [dictPoll setValue:[[tary objectAtIndex:0] attributeStringValueForName:@"TEXT"] forKey:@"OPTION1"];
                    [dictPoll setValue:[[tary objectAtIndex:1] attributeStringValueForName:@"TEXT"] forKey:@"OPTION2"];                    
                } else {
                    [dictPoll setValue:@"True" forKey:@"OPTION1"];
                    [dictPoll setValue:@"False" forKey:@"OPTION2"];                    
                }
            }
            if (pollType == 3) {
                // True False
                [dictPoll setValue:[[[[iq childElement] elementForName:@"data"] elementForName:@"OPTIONS"] stringValue] forKey:@"OPTIONS"];
                [dictPoll setValue:[[[[iq childElement] elementForName:@"data"] elementForName:@"OPTION1"] stringValue] forKey:@"OPTION1"];
                [dictPoll setValue:[[[[iq childElement] elementForName:@"data"] elementForName:@"OPTION2"] stringValue] forKey:@"OPTION2"];
                [dictPoll setValue:[[[[iq childElement] elementForName:@"data"] elementForName:@"SCALE"] stringValue] forKey:@"SCALE"];
            }
            if (pollType == 4) {
            }
            
            /*
            [dictSendMessage setValue:[message attributeStringValueForName:@"to"] forKey:@"to"];
            [dictSendMessage setValue:[message attributeStringValueForName:@"from"] forKey:@"from"];	
            [dictSendMessage setObject:@"File rejected" forKey:@"body"];
            [dictSendMessage setValue:localDateString forKey:@"Date"];
            [dictSendMessage setValue:FILE_SENDING_TEXT forKey:@"type"];
            [dictSendMessage setValue:[[[message elementForName:@"body"] elementForName:@"UniqueId"] stringValue] forKey:@"UniqueId"];
            [dictSendMessage setValue:[[[message elementForName:@"body"] elementForName:@"seq"] stringValue] forKey:@"seq"];
            [dictSendMessage setValue:[[[message elementForName:@"body"] elementForName:@"action"] stringValue] forKey:@"action"];
             */
            
            [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryPollMessages addObject:dictPoll];
            [dictPoll release];

            [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPDATE_ACTIVEPOLL object:nil];
			return YES;
		}
        
	}
    
    if([[iq type] isEqualToString:@"result"]){
	}
    
    if([[iq type] isEqualToString:@"result"]){
		if([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"services:iq:addalert"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPDATE_SOCIALFEEDS object:nil];
		}
	}
    
    if([[iq type] isEqualToString:@"result"]){
		if([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"services:iq:updateuserpassword"])
        {
            NSString *res = [[[iq childElement] elementForName:@"result"] stringValue];
            
            if ([res isEqualToString:@"1"] ) {
                UIAlertView *alert = [[UIAlertView alloc] 
                                  initWithTitle:@"Password Change" 
                                  message:@"Your password has been updated." 
                                  delegate:nil 
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
                [alert show];
                [alert release];        
            } else {
                UIAlertView *alert = [[UIAlertView alloc] 
                                      initWithTitle:@"Password Change" 
                                      message:@"Your password was not updated. Please review the password changing policies." 
                                      delegate:nil 
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];        
            }
		}
	}
    
    if([[iq type] isEqualToString:@"result"]){
		if([[[iq childElement] valueForKey:@"xmlns"] isEqualToString:@"services:iq:mustchangepassword"])
        {
            int result = [[[[iq childElement] elementForName:@"result"] stringValue] intValue];
            if (result > 0 && result <= 3) {
                UIAlertView *alert = [[UIAlertView alloc] 
                                      initWithTitle:@"Password Change" 
                                      message:[NSString stringWithFormat:@"Your password will expire in %d days. Please change it now.", result] 
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];        
            }
            /*
            if (result <= 0) {
                UIAlertView *alert = [[UIAlertView alloc] 
                                      initWithTitle:@"Password Expired" 
                                      message:@"Please contact LTB to reset your password." 
                                      delegate:self 
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];        
            }
             */
		}
	}

    return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
	// NSLog(@"---------- xmppStream:didReceiveMessage: ----------");	
/*
	<message type="chat" 
			to="devika@mqcommunicator" 
			from="amanda@mqcommunicator/136636a">
		<body>
			hi test
		</body>
	</message>
*/
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).globalChatMessageCount++;
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) updateGlobalChatBadgeOnMenuBar];

	if([message isChatMessage]){
		if([((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) IsSilenced]){
			///now vibrate iphone
			//NSLog(@"device is in silence mode");
			AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); 
		}
		NSString *strMessage = @"";
		if ([message elementForName:@"body"] != nil && [message elementForName:@"subject"] != nil) {
			NSString *strTempMessage = [[message elementForName:@"body"] stringValue];
			strTempMessage = [[strTempMessage componentsSeparatedByString:@"&gt;"] objectAtIndex:1];
			strMessage = [[strTempMessage componentsSeparatedByString:@"&lt;"] objectAtIndex:0];			
		}
		else {
			strMessage = [[message elementForName:@"body"] stringValue];
		}
		//if a message is a single user chat message...
		NSMutableDictionary * dictRecvMessage = [[NSMutableDictionary alloc] init];
		[dictRecvMessage setValue:[message valueForKey:@"to"] forKey:@"to"];
		[dictRecvMessage setValue:[message valueForKey:@"from"] forKey:@"from"];	
		// This is new code - to test this out ---
		[dictRecvMessage setValue:strMessage forKey:@"body"];
		// [dictRecvMessage setValue:[[message elementForName:@"body"] stringValue] forKey:@"body"];
		[dictRecvMessage setValue:@"chat" forKey:@"type"];
		NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
		[formatter setLocale:[NSLocale currentLocale]];
		[formatter setDateFormat:@"dd-MMM-yyyy hh:mm"];
		NSString* localDateString = [formatter stringFromDate:[NSDate date]];
		[formatter release];
		
		
		[dictRecvMessage setValue:localDateString forKey:@"Date"];
		
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages addObject:dictRecvMessage];
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) insertChatHistory:dictRecvMessage];
	//	NSLog(@"conv: %@",((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages
//			  );
//		
	//	NSLog(@"count: %i",[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages count]);
        @try {
            XMPPUserCoreDataStorage * MessageUser = (XMPPUserCoreDataStorage*)[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) fetchedUserwithJid:[[[[dictRecvMessage valueForKey:@"from"] description] componentsSeparatedByString:@"/"] objectAtIndex:0]] objectAtIndex:0];
		
            NSString *strJid = [[MessageUser.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0];
            if(![((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) IsFoundInActiveUserList:strJid
                 ]){
                [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers addObject:
                 [NSDictionary dictionaryWithObjectsAndKeys:MessageUser, @"user", @"chat", @"type", @"0", @"chatBadge", nil]];
            }
            else {
                int i = 0;
                for (NSDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers) {
				
                    XMPPUserCoreDataStorage *tempUser = [dict objectForKey:@"user"];
                    if ([tempUser isEqual:MessageUser]) {
                        NSInteger chatCount = [[dict objectForKey:@"chatBadge"] intValue];
                        chatCount++;
                        NSDictionary *dictTemp = [NSDictionary dictionaryWithObjectsAndKeys:tempUser, @"user", @"chat", @"type", [NSString stringWithFormat:@"%d", chatCount], @"chatBadge", nil];
										 					
                        [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers replaceObjectAtIndex:i withObject:dictTemp];
                        break;
                    }
                    i++;
                }
            }
        }
        @catch (NSException *exc) {
            NSLog (@"%@", [exc description]);
            
        }

		[dictRecvMessage release];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS object:nil];
		
    }
	else if ([[[message attributeForName:@"type"] stringValue] isEqualToString:FILE_SENDING_TEXT]) {
		//NSMutableDictionary *dictFileSendingInfo = [[[NSMutableDictionary alloc] init] autorelease];
		if ([message elementForName:@"delay"] == nil) {
			NSMutableDictionary * dictRecvMessage = [[NSMutableDictionary alloc] init];
			[dictRecvMessage setValue:[message valueForKey:@"to"] forKey:@"to"];
			[dictRecvMessage setValue:[message valueForKey:@"from"] forKey:@"from"];	
			
			[dictRecvMessage setValue:FILE_SENDING_TEXT forKey:@"type"];
			NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
			[formatter setLocale:[NSLocale currentLocale]];
			[formatter setDateFormat:@"dd-MMM-yyyy hh:mm"];
			NSString* localDateString = [formatter stringFromDate:[NSDate date]];
			[formatter release];
			[dictRecvMessage setValue:[[[message elementForName:@"body"] elementForName:@"UniqueId"] stringValue] forKey:@"UniqueId"];
			[dictRecvMessage setValue:[[[message elementForName:@"body"] elementForName:@"seq"] stringValue] forKey:@"seq"];
			[dictRecvMessage setValue:[[[message elementForName:@"body"] elementForName:@"action"] stringValue] forKey:@"action"];
			
			
			[dictRecvMessage setValue:localDateString forKey:@"Date"];
			
			if ([[[[message elementForName:@"body"] elementForName:@"seq"] stringValue] isEqualToString:@"0"]) {
				if ([[[[message elementForName:@"body"] elementForName:@"action"] stringValue] isEqualToString:@"Accept"]) {
					[dictRecvMessage setValue:@"File transfer started" forKey:@"body"];
					//[self sendFileUrl:[dictRecvMessage valueForKey:@"UniqueId"]];//[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages
					[self uploadFileToWebservice:[dictRecvMessage valueForKey:@"UniqueId"]];
					
				}
				else if ([[[[message elementForName:@"body"] elementForName:@"action"] stringValue] isEqualToString:@"Reject"]) {
					
					[dictRecvMessage setValue:@"File rejected" forKey:@"body"];
					//[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages
				}
				else {
					/*
					[dictRecvMessage setObject:[NSString stringWithFormat:@"%@ sent a file to %@",[[[[message valueForKey:@"from"] description]
																									componentsSeparatedByString:@"@"] objectAtIndex:0], [[[[message valueForKey:@"to"] description] componentsSeparatedByString:@"@"] objectAtIndex:0]] forKey:@"body"];
                     */
					[dictRecvMessage setObject:@"has sent you a file" forKey:@"body"];
					
				}			
			}		
			else if ([[[[message elementForName:@"body"] elementForName:@"seq"] stringValue] isEqualToString:@"1"]) {
				[dictRecvMessage setValue:@"File transfer Completed" forKey:@"body"];			
				[dictRecvMessage setValue:[[[message elementForName:@"body"] elementForName:@"fileUrl"] stringValue] forKey:@"fileUrl"];			
			}
			
			NSInteger ind = 0;
			BOOL isReplace = NO;
			for (NSMutableDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages) {
				if ([[dict objectForKey:@"UniqueId"] isEqualToString:[dictRecvMessage objectForKey:@"UniqueId"]]) {
					if([[[dict valueForKey:@"from"] description] isEqualToString:
						[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]
						   ).xmppStream myJID] bare] ]) {
						[dict setObject:[dictRecvMessage valueForKey:@"seq"] forKey:@"seq"];
						if ([dictRecvMessage valueForKey:@"action"] != nil) {
							[dict setObject:[dictRecvMessage valueForKey:@"action"] forKey:@"action"];
						}						
						[dict setObject:[dictRecvMessage valueForKey:@"body"] forKey:@"body"];
					}
					else {
						[dict setObject:[dictRecvMessage valueForKey:@"seq"] forKey:@"seq"];
						[dict setObject:[dictRecvMessage valueForKey:@"action"] forKey:@"action"];
						[dict setObject:[dictRecvMessage valueForKey:@"body"] forKey:@"body"];
						[dict setObject:[dictRecvMessage valueForKey:@"fileUrl"] forKey:@"fileUrl"];
					}
					
					//				//[dict setObject:[dictRecvMessage valueForKey:@"seq"] forKey:@"seq"];
					//				[dict setObject:[dictRecvMessage valueForKey:@"action"] forKey:@"action"];
					//				[dict setObject:[dictRecvMessage valueForKey:@"body"] forKey:@"body"];
					//				//[dict setObject:[dictRecvMessage valueForKey:@"fileUrl"] forKey:@"fileUrl"];
					//				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages replaceObjectAtIndex:ind withObject:dict];
					//				
					isReplace = YES;
					break;
				}
				ind++;
			}
			if (!isReplace) {
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages addObject:dictRecvMessage];
				XMPPUserCoreDataStorage * MessageUser = (XMPPUserCoreDataStorage*)[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) fetchedUserwithJid:[[[[dictRecvMessage valueForKey:@"from"] description] componentsSeparatedByString:@"/"] objectAtIndex:0]
																					] objectAtIndex:0];
				NSString *strJid = [[MessageUser.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0];
				if(![((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) IsFoundInActiveUserList:strJid
					 ]){
					[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers addObject:
					 [NSDictionary dictionaryWithObjectsAndKeys:MessageUser, @"user", @"0", @"chatBadge", @"chat", @"type", nil]];
				}
				else {					
					int i = 0;
					for (NSDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers) {
						
						XMPPUserCoreDataStorage *tempUser = [dict objectForKey:@"user"];
						if ([tempUser isEqual:MessageUser]) {
							NSInteger chatCount = [[dict objectForKey:@"chatBadge"] intValue];
							chatCount++;
							NSDictionary *dictTemp = [NSDictionary dictionaryWithObjectsAndKeys:tempUser, @"user", [NSString stringWithFormat:@"%d", chatCount], @"chatBadge", @"chat", @"type", nil];
							
							[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers replaceObjectAtIndex:i withObject:dictTemp];
							break;
						}
						i++;
					}
				}			
			}
			[dictRecvMessage release];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS object:nil];
		}		
	}
/*
	 <message type="chat" 
	 to="devika@mqcommunicator" 
	 from="amanda@mqcommunicator/136636a">
	<action>
		0
	</action>
	<status>
		YES
	</status>
	<body>
	 hi test
	 </body>
	 </message>
 */
	
/*	
//	<message 
//	  from="class-test2@conference.mqcommunicator" 
//	  to="student3@mqcommunicator">
//		<x 
//		  xmlns="http://jabber.org/protocol/muc#user">
//			<invite 
//			  from="student1@mqcommunicator">
//				<reason>Join this group chat</reason>
//			</invite>
//		</x>
//		<x
//		  xmlns="jabber:x:conference" 
//		  jid="class-test2@conference.mqcommunicator"/>
//	</message>
 */
	else if(![[[message attributeForName:@"type"] stringValue] isEqualToString:@"groupchat"]) {
		NSString *strFrom = [[[[message valueForKey:@"from"] description] componentsSeparatedByString:@"#"] objectAtIndex:0
							 ];
		if ([[message elementForName:@"x"] elementForName:@"invite"] != nil) {
			/*<presence to="class-ocs1#24263202#room@conference.mqcommunicator/benny">
				<status>Available</status>
				<priority>0</priority>
			 </presence>*/
			NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
			[presence addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@/%@", [[message valueForKey:@"from"] description],
															  [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"
																] objectAtIndex:0]]];
			NSXMLElement *status = [NSXMLElement elementWithName:@"status" stringValue:@"Available"];
			NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"0"];
			[presence addChild:status];
			[presence addChild:priority];
			[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:presence];		
			
			BOOL isAvailable = NO;
			int i = 0;
			for (id obj in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers) {
				if ([[obj objectForKey:@"user"] class] != [XMPPUserCoreDataStorage class]) {
					if ([strFrom isEqualToString:[[[obj objectForKey:@"user"] objectForKey: @"GroupName"] lowercaseString]]) {
						int chatBadgeCount = [[obj objectForKey:@"chatBadge"] intValue];
						[obj setValue:[NSString stringWithFormat:@"%d", chatBadgeCount] forKey:@"chatBadge"];
						[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers replaceObjectAtIndex:i withObject:obj];
						isAvailable = YES;
						break;
					}
				}
				i++;
			}
			if (!isAvailable) {
				/*for (NSDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactLists) {
					if ([[[dict objectForKey:@"GroupName"] lowercaseString] isEqualToString:strFrom]) {
						NSMutableDictionary *dictTemp = [NSMutableDictionary dictionaryWithDictionary:dict];
						[dictTemp setObject:[message valueForKey:@"from"] forKey:@"roomId"];
						[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) aryActiveUsers] 
						 addObject:[NSDictionary dictionaryWithObjectsAndKeys:dictTemp, @"user", @"1",@"chatBadge", @"groupChat", @"type", nil]];
					}
				}*/
				NSArray *aryUserList = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
										fetchedResultsController];
				
				for (NSDictionary *dict in aryUserList) {//((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactLists) {
					if ([[[dict objectForKey:@"GroupName"] lowercaseString] isEqualToString:strFrom]) {
						NSMutableDictionary *dictTemp = [NSMutableDictionary dictionaryWithDictionary:dict];
						[dictTemp setObject:[message valueForKey:@"from"] forKey:@"roomId"];
						[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers
						 addObject:[NSDictionary dictionaryWithObjectsAndKeys:dictTemp, @"user", @"0",@"chatBadge", @"groupChat", @"type", nil]];
						//NSLog([((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers description]);
					}
				}
			}
			[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS object:nil];
		}
		else {
			[[message elementForName:@"x"] elementForName:@"invite"];
			//[message 
			NSMutableDictionary * dictRecvMessage = [[NSMutableDictionary alloc] init];
			[dictRecvMessage setValue:[message valueForKey:@"to"] forKey:@"to"];
			[dictRecvMessage setValue:[[[[message elementForName:@"x"] elementForName:@"invite"] attributeForName:@"from"] stringValue] forKey:@"sender"];	
			[dictRecvMessage setValue:[message valueForKey:@"from"] forKey:@"from"];
			[dictRecvMessage setValue:[[[[message elementForName:@"x"] elementForName:@"invite"] elementForName:@"reason"] stringValue] forKey:@"body"];
			[dictRecvMessage setValue:@"groupChat" forKey:@"type"];
			
			[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages addObject:dictRecvMessage];
			
		//	NSLog(@"conv: %@",((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages
//				  );
//			
//			NSLog(@"count: %i",[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages count]);
			//	XMPPUserCoreDataStorage * MessageUser = (XMPPUserCoreDataStorage*)[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) fetchedUserwithJid:[[[[dictRecvMessage valueForKey:@"from"] description] componentsSeparatedByString:@"/"] objectAtIndex:0]
			//																			] objectAtIndex:0];
			BOOL isAvailable = NO;
			int i = 0;
			for (id obj in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers) {
				if ([[obj objectForKey:@"user"] class] != [XMPPUserCoreDataStorage class]) {
					if ([strFrom isEqualToString:[[[obj objectForKey:@"user"] objectForKey: @"GroupName"] lowercaseString]]) {
						int chatBadgeCount = [[obj objectForKey:@"chatBadge"] intValue];
						[obj setValue:[NSString stringWithFormat:@"%d", chatBadgeCount] forKey:@"chatBadge"];
						[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers replaceObjectAtIndex:i withObject:obj];
						isAvailable = YES;
						break;
					}
				}
				i++;
			}
			if (!isAvailable) {
				for (NSDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactLists) {
					if ([[[dict objectForKey:@"GroupName"] lowercaseString] isEqualToString:strFrom]) {
						NSMutableDictionary *dictTemp = [NSMutableDictionary dictionaryWithDictionary:dict];
						[dictTemp setObject:[dictRecvMessage objectForKey:@"from"] forKey:@"roomId"];
						[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) aryActiveUsers] 
						 addObject:[NSDictionary dictionaryWithObjectsAndKeys:dictTemp, @"user", @"1",@"chatBadge", @"groupChat", @"type", nil]];
					}
				}
			}
			[dictRecvMessage release];
			[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS object:nil];			
			
		}		
}
/*
 <message to="student1@mqcommunicator/Messenger" 
	from="class-test2#1316734047#room@conference.mqcommunicator/student3" type="groupchat">
	<body>hi..</body>
</message>
 
 <body>&lt;Paragraph FontFamily="Segoe UI" FontStyle="Normal" FontWeight="Normal" 
	FontSize="12" Foreground="#FF000000" 
	xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"&gt;
		hi
	&lt;/Paragraph&gt;
 </body>
 <subject>RichTextChat|</subject>
 */
	
	else if ([[[message attributeForName:@"type"] stringValue] isEqualToString:@"groupchat"]) {
		NSString *strFrom = [[[[message valueForKey:@"from"] description] componentsSeparatedByString:@"#"] objectAtIndex:0
							 ];
		NSMutableDictionary * dictRecvMessage = [[NSMutableDictionary alloc] init];
		if ([[message elementForName:@"body"] elementForName:@"type"] != nil) {
			/*
			 <message type="groupchat" to="student8@mqcommunicator/Messenger" 
			 from="class-test1#1#room@conference.mqcommunicator/student8">
				<Date>30-Sep-2011 04:10</Date>
				<body>
					<type>groupFileSending</type>
					<seq>0</seq>
					<UniqueId>class-test123542162</UniqueId>
					<Action/>
				</body>
			 </message>
			*/
			
			NSXMLElement *bodyElem = [message elementForName:@"body"];
			BOOL isConsider = NO;
			NSArray *aryPart = [[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"/"];
			if ([aryPart count] <= 1) {
				return;
			}
			NSString *strMessage;
			if ([[aryPart objectAtIndex:1] isEqualToString:[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID
																						] bare] componentsSeparatedByString:@"@"] objectAtIndex:0]]) {
				if ([[[bodyElem elementForName:@"seq"] stringValue] intValue] == 0) {
					if ([[bodyElem elementForName:@"action"] stringValue] == nil) {
						strMessage = [NSString stringWithFormat:@"Sending file to %@", strFrom];
						[dictRecvMessage setValue:[[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"/"] lastObject] forKey:@"sender"];	
						//[dictRecvMessage setValue:[message valueForKey:@"to"] forKey:@"to"];
//						[dictRecvMessage setValue:[[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"/"] lastObject] forKey:@"sender"];	
//						[dictRecvMessage setValue:[[message attributeForName:@"from"] stringValue] forKey:@"from"];					
					}
					else if ([[[bodyElem elementForName:@"action"] stringValue] isEqualToString:@"Reject"]) {
						strMessage = @"File Rejected";
						for (NSDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileRecvList) {
							if ([[dict objectForKey:@"fileId"] isEqualToString:[[bodyElem elementForName:@"UniqueId"] stringValue]]) {
								NSString *strName = [dict objectForKey:@"sender"];
								[dictRecvMessage setValue:[dict objectForKey:@"sender"] forKey:@"sender"];	
								//[dictRecvMessage setValue:[message valueForKey:@"to"] forKey:@"to"];
//								[dictRecvMessage setValue:strName forKey:@"sender"];	
//								[dictRecvMessage setValue:[NSString stringWithFormat:@"%@@%@", strName, SERVERNAME] forKey:@"from"];
								break;
							}
							
						}
						
					}
					else if ([[[bodyElem elementForName:@"action"] stringValue] isEqualToString:@"Accept"]) {
						strMessage = @"File transfer started";
						for (NSDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileRecvList) {
							if ([[dict objectForKey:@"fileId"] isEqualToString:[[bodyElem elementForName:@"UniqueId"] stringValue]]) {
								//NSString *strName = [dict objectForKey:@"sender"];
								[dictRecvMessage setValue:[dict objectForKey:@"sender"] forKey:@"sender"];	
								//[dictRecvMessage setValue:[message valueForKey:@"to"] forKey:@"to"];
//								[dictRecvMessage setValue:strName forKey:@"sender"];	
//								[dictRecvMessage setValue:[NSString stringWithFormat:@"%@@%@", strName, SERVERNAME] forKey:@"from"];
								break;
							}
							
						}
					}
					isConsider = YES;
					
				}
				else if([[[bodyElem elementForName:@"seq"] stringValue] intValue] == 1) {
					for (NSDictionary *dictFile in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileSendingList) {
						if ([[dictFile objectForKey:@"fileId"] isEqualToString:[[bodyElem elementForName:@"UniqueId"] stringValue]]) {
							NSInteger rejectCount = [[dictFile objectForKey:@"rejectCount"] intValue];
							[dictRecvMessage setValue:[dictFile objectForKey:@"sender"] forKey:@"sender"];	
							if ([[dictFile objectForKey:@"maxReject"] intValue] == rejectCount) {
								
								strMessage = @"File transfer completed";
							}
							else {
								strMessage = [NSString stringWithFormat:@"Sending file to %@", strFrom];
							}
						}
					}
					isConsider = YES;
				}
			}
			else {
				if ([[[bodyElem elementForName:@"seq"] stringValue] intValue] == 0) {
					if ([[bodyElem elementForName:@"action"] stringValue] == nil) {
						strMessage = [NSString stringWithFormat:@"%@ is sending file", [aryPart objectAtIndex:1]];
						[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileRecvList addObject:
						 [NSDictionary dictionaryWithObjectsAndKeys:[[bodyElem elementForName:@"UniqueId"] stringValue], @"fileId",
						  @"", @"RecvStatus", [aryPart objectAtIndex:1], @"sender", nil]];
						isConsider = YES;
						[dictRecvMessage setValue:[[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"/"] lastObject] forKey:@"sender"];	
						//[dictRecvMessage setValue:[message valueForKey:@"to"] forKey:@"to"];
//						[dictRecvMessage setValue:[[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"/"] lastObject] forKey:@"sender"];	
//						[dictRecvMessage setValue:[[message attributeForName:@"from"] stringValue] forKey:@"from"];
					}
					else if ([[[bodyElem elementForName:@"action"] stringValue] isEqualToString:@"Reject"]) {
						NSInteger indx = 0;
						for (NSDictionary *dictFile in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileSendingList) {
							if ([[dictFile objectForKey:@"fileId"] isEqualToString:[[bodyElem elementForName:@"UniqueId"] stringValue]]) {
								[dictRecvMessage setValue:[dictFile objectForKey:@"sender"] forKey:@"sender"];	
								NSInteger rejectCount = [[dictFile objectForKey:@"rejectCount"] intValue];
								rejectCount++;
								if ([[dictFile objectForKey:@"maxReject"] intValue] == rejectCount) {
									[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileSendingList removeObject:dictFile];							
									strMessage = @"File Rejected";	
									//[dictRecvMessage setValue:[message valueForKey:@"to"] forKey:@"to"];
//									[dictRecvMessage setValue:[[[[message attributeForName:@"to"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0] forKey:@"sender"];	
//									[dictRecvMessage setValue:[[message attributeForName:@"to"] stringValue] forKey:@"from"];
								}
								else {
									NSMutableDictionary *dictTemp = [NSMutableDictionary dictionaryWithDictionary:dictFile];
									[dictTemp setObject:[NSString stringWithFormat:@"%d", rejectCount] forKey:@"rejectCount"];
									strMessage = [NSString stringWithFormat:@"Sending file to %@", strFrom];
									[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileSendingList replaceObjectAtIndex:indx withObject:dictTemp];
									//[dictRecvMessage setValue:[message valueForKey:@"to"] forKey:@"to"];
//									[dictRecvMessage setValue:[[[[message attributeForName:@"to"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0] forKey:@"sender"];	
//									[dictRecvMessage setValue:[[message attributeForName:@"to"] stringValue] forKey:@"from"];
								}	
								
								isConsider = YES;
								break;
							}
							indx++;
						}
						
					}
					else if ([[[bodyElem elementForName:@"action"] stringValue] isEqualToString:@"Accept"]) {
						NSInteger indx = 0;
						for (NSDictionary *dictFile in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileSendingList) {
							if ([[dictFile objectForKey:@"fileId"] isEqualToString:[[bodyElem elementForName:@"UniqueId"] stringValue]]) {
								if ([[dictFile objectForKey:@"IsUploaded"] isEqualToString:@"NO"]) {
									NSMutableDictionary *dictTemp = [NSMutableDictionary dictionaryWithDictionary:dictFile];
									[dictTemp setObject:@"YES" forKey:@"IsUploaded"];
									[dictRecvMessage setValue:[dictFile objectForKey:@"sender"] forKey:@"sender"];
									NSInteger rejectCount = [[dictFile objectForKey:@"rejectCount"] intValue];
									rejectCount++;
									[self uploadFileToWebservice:[dictFile objectForKey:@"fileId"]];
									//if ([[dictFile objectForKey:@"maxReject"] intValue] == rejectCount) {
										//[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileSendingList removeObject:dictFile];							
									strMessage = @"File transfer started";
									//}	
									//else {									
								//		strMessage = @"File transfer started";										
								//	}
									[dictTemp setObject:[NSString stringWithFormat:@"%d", rejectCount] forKey:@"rejectCount"];
									[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileSendingList replaceObjectAtIndex:indx withObject:dictTemp];
									
								//	[dictRecvMessage setValue:[message valueForKey:@"to"] forKey:@"to"];
//									[dictRecvMessage setValue:[[[[message attributeForName:@"to"] stringValue] componentsSeparatedByString:@"@"] objectAtIndex:0] forKey:@"sender"];	
//									[dictRecvMessage setValue:[[message attributeForName:@"to"] stringValue] forKey:@"from"];
									isConsider = YES;	
								}
								else {
									NSLog(@"File is already uploaded");
									NSInteger rejectCount = [[dictFile objectForKey:@"rejectCount"] intValue];
									rejectCount++;
									[self sendFileUrlToGroup:[dictFile objectForKey:@"fileId"] url:[dictFile objectForKey:@"fileUrl"]];
									if ([[dictFile objectForKey:@"maxReject"] intValue] == rejectCount) {
										//[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileSendingList removeObject:dictFile];							
										strMessage = @"File transfer completed";
										[dictRecvMessage setValue:[dictFile objectForKey:@"sender"] forKey:@"sender"];	
										isConsider = YES;
									}
									//else {
									NSMutableDictionary *dictTemp = [NSMutableDictionary dictionaryWithDictionary:dictFile];
										
									//}
									[dictTemp setObject:[NSString stringWithFormat:@"%d", rejectCount] forKey:@"rejectCount"];
									[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileSendingList replaceObjectAtIndex:indx withObject:dictTemp];
									
									
								}

							
								break;
							}
							indx++;
						}
					}
				}
				else if ([[[bodyElem elementForName:@"seq"] stringValue] intValue] == 1) {
					NSInteger indx = 0;
					for (NSDictionary *dictFile in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileRecvList) {
						if ([[dictFile objectForKey:@"fileId"] isEqualToString:[[bodyElem elementForName:@"UniqueId"] stringValue]]) {
							if ([[dictFile objectForKey:@"RecvStatus"] isEqualToString:@"Accept"]) {
								//NSMutableDictionary *dictTemp = [NSDictionary dictionaryWithDictionary:dictFile];
//								[dictTemp setObject:@"Accepted" forKey:@"RecvStatus"];
//								[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileRecvList replaceObjectAtIndex:indx withObject:dictTemp]; 
								if ([[bodyElem elementForName:@"fileUrl"] stringValue] != nil &&
									![[[bodyElem elementForName:@"fileUrl"] stringValue] isEqualToString:@""]) {
									strMessage = @"File transfer completed";
									[dictRecvMessage setValue:[dictFile objectForKey:@"sender"] forKey:@"sender"];	
									[dictRecvMessage setObject:[[bodyElem elementForName:@"fileUrl"] stringValue] forKey:@"fileUrl"];
									[dictFile setObject:@"Accepted" forKey:@"RecvStatus"];
									[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileRecvList removeObject:dictFile]; 
									
									isConsider = YES;									
								}
								else {
									isConsider = NO;
								}
								
								break;
							}					
							
						}
						indx++;
					}
				}
			}
						
			//NSMutableDictionary * dictRecvMessage = [[NSMutableDictionary alloc] init];
			if (isConsider) {
				[dictRecvMessage setValue:[message valueForKey:@"to"] forKey:@"to"];
				//[dictRecvMessage setValue:[[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"/"] lastObject] forKey:@"sender"];	
				[dictRecvMessage setValue:[[message attributeForName:@"from"] stringValue] forKey:@"from"];
				[dictRecvMessage setValue:strMessage forKey:@"body"];
				[dictRecvMessage setValue:@"groupFileSending" forKey:@"type"];
				[dictRecvMessage setValue:[[bodyElem elementForName:@"seq"] stringValue] forKey:@"seq"];
				[dictRecvMessage setValue:[[bodyElem elementForName:@"UniqueId"] stringValue] forKey:@"UniqueId"];
				[dictRecvMessage setValue:[[bodyElem elementForName:@"action"] stringValue] forKey:@"Action"];
				BOOL isFileAvailable = NO;
				NSInteger indx1 = 0;
				for (NSDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages) {
					if ([[dict objectForKey:@"UniqueId"] isEqualToString:[dictRecvMessage objectForKey:@"UniqueId"]]) {
						isFileAvailable = YES;
						[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages replaceObjectAtIndex:indx1 withObject:dictRecvMessage];
						break;
					}
					indx1++;
				}
				if (!isFileAvailable) {
					[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages addObject:dictRecvMessage];
				}
				
				
			}
						
			
			
		}
		else {
			NSString *strMessage = @"";
			NSArray *aryPart = [[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"/"];
			if ([aryPart count] <= 1) {
				return;
			}
			if ([message elementForName:@"body"] != nil && [message elementForName:@"subject"] != nil) {
				NSString *strTempMessage = [[message elementForName:@"body"] stringValue];
				strTempMessage = [[strTempMessage componentsSeparatedByString:@"&gt;"] objectAtIndex:1];
				strMessage = [[strTempMessage componentsSeparatedByString:@"&lt;"] objectAtIndex:0];			
			}
			else {
				strMessage = [[message elementForName:@"body"] stringValue];
			}
			
			
			//[[message elementForName:@"x"] elementForName:@"invite"];
			//[message 
			
			[dictRecvMessage setValue:[message valueForKey:@"to"] forKey:@"to"];
			//	class-test2#1317061329#room@conference.mqcommunicator/student3
			//NSLog(@"%@", [[message attributeForName:@"from"] stringValue]);
			//NSLog(@"%@", [[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"/"] description]);
			[dictRecvMessage setValue:[[[[message attributeForName:@"from"] stringValue] componentsSeparatedByString:@"/"] lastObject] forKey:@"sender"];	
			[dictRecvMessage setValue:[[message attributeForName:@"from"] stringValue] forKey:@"from"];
			[dictRecvMessage setValue:strMessage forKey:@"body"];
			[dictRecvMessage setValue:@"groupChat" forKey:@"type"];
			
			[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages addObject:dictRecvMessage];
			
			//NSLog(@"conv: %@",((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages
			//			  );
			//		
			//		NSLog(@"count: %i",[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages count]);
			//	XMPPUserCoreDataStorage * MessageUser = (XMPPUserCoreDataStorage*)[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) fetchedUserwithJid:[[[[dictRecvMessage valueForKey:@"from"] description] componentsSeparatedByString:@"/"] objectAtIndex:0]
			//																			] objectAtIndex:0];
			
			
		}
		BOOL isAvailable = NO;
		int i = 0;
		for (id obj in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers) {
			if ([[obj objectForKey:@"user"] class] != [XMPPUserCoreDataStorage class]) {
				if ([strFrom isEqualToString:[[[obj objectForKey:@"user"] objectForKey: @"GroupName"] lowercaseString]]) {
					int chatBadgeCount = [[obj objectForKey:@"chatBadge"] intValue];
					NSMutableDictionary *dictTemp = [NSMutableDictionary dictionaryWithDictionary:obj];
					[dictTemp setValue:[NSString stringWithFormat:@"%d", chatBadgeCount] forKey:@"chatBadge"];
					[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers replaceObjectAtIndex:i withObject:dictTemp];
					isAvailable = YES;
					break;
				}
			}
			i++;
		}
		if (!isAvailable) {
			/*for (NSDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactLists) {
				if ([[[dict objectForKey:@"GroupName"] lowercaseString] isEqualToString:strFrom]) {
					NSMutableDictionary *dictTemp = [NSMutableDictionary dictionaryWithDictionary:dict];
					[dictTemp setObject:[dictRecvMessage objectForKey:@"from"] forKey:@"roomId"];
					
					[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) aryActiveUsers] 
					 addObject:[NSDictionary dictionaryWithObjectsAndKeys:dictTemp, @"user", @"1",@"chatBadge", @"groupChat", @"type", nil]];
				}
			}*/
			NSArray *aryUserList = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) 
									fetchedResultsController];
			
			for (NSDictionary *dict in aryUserList) {//((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactLists) {
				if ([[[dict objectForKey:@"GroupName"] lowercaseString] isEqualToString:strFrom]) {
					NSMutableDictionary *dictTemp = [NSMutableDictionary dictionaryWithDictionary:dict];
					[dictTemp setObject:[message valueForKey:@"from"] forKey:@"roomId"];
					[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers
					 addObject:[NSDictionary dictionaryWithObjectsAndKeys:dictTemp, @"user", @"0",@"chatBadge", @"groupChat", @"type", nil]];
					//NSLog([((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers description]);
				}
			}
		}
		[dictRecvMessage release];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS object:nil];
		
	}
	
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
	// NSLog(@"------------xmppStream:didReceivePresence----------");
	//NSLog(@"%@",[presence description]);
	
/*	<presence from="student1@mqcommunicator/Messenger" to="student3@mqcommunicator"><status></status><x xmlns="vcard-temp:x:update"><photo></photo></x></presence>*/
	/// Invite User in Group Chat
	if ([[[presence elementForName:@"x"] valueForKey:@"xmlns"] isEqualToString:@"vcard-temp:x:update"]) {
		for (NSDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryOwnedGroupChat) {
			for (NSDictionary *dictContactList in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactLists) {
				//NSLog(@"%@",[dictContactList description]);
				if ([[[dict objectForKey:@"groupName"] lowercaseString] isEqualToString:[[dictContactList objectForKey:@"GroupName"] lowercaseString]]) {
					for (NSDictionary *dictUser in [dictContactList objectForKey:@"GroupUsers"]) {
						if ([[dictUser objectForKey:@"jid"] isEqualToString:
							 [[[[presence valueForKey:@"from"] description] componentsSeparatedByString:@"/"] objectAtIndex:0]
							  ]) {
							NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
							[iq addAttributeWithName:@"type" stringValue:@"get"];
							[iq addAttributeWithName:@"to" stringValue:[[presence valueForKey:@"from"] description]];
							
							NSXMLElement *query = [NSXMLElement elementWithName:@"query" stringValue:[dict objectForKey:@"groupRoomName"]];
							[query addAttributeWithName:@"xmlns" stringValue:@"chat:iq:invite"];
							[iq addChild:query];
							[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:iq];
							break;
						}
					}
				}
				
			}
		}
	}
/*
 <presence from="amanda@mqcommunicator/Messenger" to="devika@mqcommunicator">
	<status>testing</status>
	<x xmlns="vcard-temp:x:update"><photo></photo>
	</x>
 </presence>
 */
	if ([[[presence valueForKey:@"type"] description]isEqualToString:@"unavailable"]) {
		NSString *strFrom = [[[[presence valueForKey:@"from"] description] componentsSeparatedByString:@"/"] objectAtIndex:0];
		
		for (int i = 0; i < [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages count]; i++) {
			NSMutableDictionary *dict = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages objectAtIndex:i];
			if ([[dict objectForKey:@"type"] isEqualToString:@"groupFileSending"]) {
				
				if ([[[dict objectForKey:@"sender"] description] isEqualToString:[[[[presence valueForKey:@"from"] description]componentsSeparatedByString:@"@"] objectAtIndex:0]]) {
					if (![[dict objectForKey:@"Action"] isEqualToString:@"Accept"] && ![[dict objectForKey:@"Action"] isEqualToString:@"Accepted"]) {
						[dict setValue:@"File Transfer Failed" forKey:@"body"];
						[dict setValue:@"Failed" forKey:@"action"];
						[dict setValue:@"seq" forKey:@"2"];
						[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS object:nil];
					}					
				}
			}
			if ([[dict objectForKey:@"type"] isEqualToString:FILE_SENDING_TEXT]) {
				if ([[[dict objectForKey:@"from"] description] isEqualToString:[[presence valueForKey:@"from"] description]]) {
					if ([[dict objectForKey:@"seq"] isEqualToString:@"0"]) {
						//NSLog(@"disconnected - File sending Failed");
						[dict setValue:@"File Transfer Failed" forKey:@"body"];
						[dict setValue:@"Failed" forKey:@"action"];
						[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS object:nil];
					}
				}
				else if ([[[dict objectForKey:@"to"] description] isEqualToString:strFrom]) {
					if ([[dict objectForKey:@"seq"] isEqualToString:@"0"]) {
						//NSLog(@"disconnected - File sending Failed");
						[dict setValue:@"File Transfer Failed" forKey:@"body"];
						[dict setValue:@"Failed" forKey:@"action"];
						[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS object:nil];
					}				
				}
			}
		}
	}
	
/*
<presence from="class-test2#1316720077#room@conference.mqcommunicator/student3" 
	to="student3@mqcommunicator/Messenger">
	<x xmlns="http://jabber.org/protocol/muc#user">
		<item jid="student3@mqcommunicator/Messenger" affiliation="owner" role="moderator"></item>
		<status code="201"></status>
	</x>
 </presence>
 */
	if ([[[presence elementForName:@"x"] valueForKey:@"xmlns"] isEqualToString:@"http://jabber.org/protocol/muc#user"]) {
		if ([[[[[presence elementForName:@"x"] elementForName:@"status"] attributeForName:@"code"] stringValue] isEqualToString:@"201"] &&
			[[[[[presence elementForName:@"x"] elementForName:@"item"] attributeForName:@"affiliation"] stringValue] isEqualToString:@"owner"]) {
			
			[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryOwnedGroupChat addObject:
			 [NSDictionary dictionaryWithObjectsAndKeys:[[[[presence valueForKey:@"from"] description] componentsSeparatedByString:@"/"] objectAtIndex:0], @"groupRoomName",
 			  [[[[presence valueForKey:@"from"] description] componentsSeparatedByString:@"#"] objectAtIndex:0], @"groupName",
			  nil]];
			//aryOwnedGroupChat
		}
	}
    // Rakesh Bad - kills group chat
	// [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CONTACTS object:nil];
		
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error{
	// NSLog(@"---------- xmppStream:didReceiveError: ----------");
	[LoadingAlert HideLoadingAlert];
	
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender{
	// NSLog(@"---------- xmppStreamDidDisconnect: ----------");
	[LoadingAlert HideLoadingAlert];
	
	if (!isOpen)
	{		
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" 
														 message:@"Server Connection Error ! Unable to connect to server. Please, Try Again !" 
														delegate:nil 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		//NSLog(@"Unable to connect to server. Check xmppStream.hostName");
	}
	if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).isLoggedIn) {
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" 
														 message:@"Server Connection Error ! Unable to connect to server. Please, Try Again !" 
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void)xmppStream:(XMPPStream *)sender willSendPresence:(XMPPPresence *)presence{
	
}

#pragma mark -
#pragma mark UIAlertView delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex==0){ // if accept is selected
		NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									  @"ACCEPT",@"ACTION",
									  ObjFileTransfer,@"FILE",nil];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_FILEACTION object:dict];
		
	}else if(buttonIndex == 1){ // if reject is selected
		

		NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									  @"REJECT",@"ACTION",
									  ObjFileTransfer,@"FILE",nil];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_FILEACTION object:dict];
		
	}
}

- (void)sendFileUrlToGroup:(NSString*)strFileId url:(NSString*)strFileUrl {
	NSMutableDictionary *dict = nil;	
	for (NSMutableDictionary *tempDict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages) {
		if ([[tempDict valueForKey:@"UniqueId"] isEqualToString:strFileId]) {
			dict = tempDict;
			break;
		}
	}
    
    if (dict == nil) {
        return;
    }
    
	NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
	[message addAttributeWithName:@"type" stringValue:@"groupchat"];
	[message addAttributeWithName:@"to" stringValue:[[[[dict valueForKey:@"from"] description] componentsSeparatedByString:@"/"] objectAtIndex:0]];
	[message addAttributeWithName:@"from" stringValue:[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare]
														componentsSeparatedByString:@"@"] objectAtIndex:0]];
	
	NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
	NSXMLElement *sequece = [NSXMLElement elementWithName:@"seq"];
	NSXMLElement *fileSentDate = [NSXMLElement elementWithName:@"Date"];
	NSXMLElement *fileId = [NSXMLElement elementWithName:@"UniqueId"];
	NSXMLElement *action = [NSXMLElement elementWithName:@"action"];
	NSXMLElement *fileUrl = [NSXMLElement elementWithName:@"fileUrl"];
	NSXMLElement *type = [NSXMLElement elementWithName:@"type" stringValue:GROUP_FILE_SENDING_TEXT];
	[sequece setStringValue:@"1"];
	[fileUrl setStringValue:strFileUrl];
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateFormat:@"dd-MMM-yyyy hh:mm"];
	NSString* localDateString = [formatter stringFromDate:[NSDate date]];
	[formatter release];
	[fileSentDate setStringValue:localDateString];
	
	[fileId setStringValue:[dict objectForKey:@"UniqueId"]];
	
	[action setStringValue:@"Accept"];
	[body addChild:type];
	[body addChild:sequece];			
	[body addChild:fileId];
	[body addChild:action];
	[body addChild:fileUrl];
	
	[message addChild:fileSentDate];
	[message addChild:body];
	
	//Send Message
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:message];
	
	
	
}
   

- (void)sendFileUrl:(NSString*)strFileId url:(NSString*)strFileUrl {
	NSMutableDictionary *dict;	
	for (NSMutableDictionary *tempDict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages) {
		if ([[tempDict valueForKey:@"UniqueId"] isEqualToString:strFileId]) {
			dict = tempDict;
			break;
		}
	}
	
	NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
	[message addAttributeWithName:@"type" stringValue:FILE_SENDING_TEXT];
	[message addAttributeWithName:@"to" stringValue:[dict valueForKey:@"to"]];
	[message addAttributeWithName:@"from" stringValue:[dict valueForKey:@"from"]];
	
	NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
	NSXMLElement *sequece = [NSXMLElement elementWithName:@"seq"];
	NSXMLElement *fileSentDate = [NSXMLElement elementWithName:@"Date"];
	NSXMLElement *fileId = [NSXMLElement elementWithName:@"UniqueId"];
	NSXMLElement *action = [NSXMLElement elementWithName:@"action"];
	NSXMLElement *fileUrl = [NSXMLElement elementWithName:@"fileUrl"];
	[sequece setStringValue:@"1"];
	[fileUrl setStringValue:strFileUrl];
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateFormat:@"dd-MMM-yyyy hh:mm"];
	NSString* localDateString = [formatter stringFromDate:[NSDate date]];
	[formatter release];
	[fileSentDate setStringValue:localDateString];
	
	[fileId setStringValue:[dict objectForKey:@"UniqueId"]];
	
	[action setStringValue:@"Accept"];
	[body addChild:sequece];			
	[body addChild:fileId];
	[body addChild:action];
	[body addChild:fileUrl];
	 
	[message addChild:fileSentDate];
	[message addChild:body];
	
	//Send Message
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:message];
	
	NSMutableDictionary * dictSendMessage = [[NSMutableDictionary alloc] init];
	[dictSendMessage setValue:[message attributeStringValueForName:@"to"] forKey:@"to"];
	[dictSendMessage setValue:[message attributeStringValueForName:@"from"] forKey:@"from"];	
	[dictSendMessage setObject:@"File Transfer Completed" forKey:@"body"];
	[dictSendMessage setValue:localDateString forKey:@"Date"];
	[dictSendMessage setValue:FILE_SENDING_TEXT forKey:@"type"];
	[dictSendMessage setValue:[[[message elementForName:@"body"] elementForName:@"UniqueId"] stringValue] forKey:@"UniqueId"];
	[dictSendMessage setValue:[[[message elementForName:@"body"] elementForName:@"seq"] stringValue] forKey:@"seq"];
	[dictSendMessage setValue:[[[message elementForName:@"body"] elementForName:@"action"] stringValue] forKey:@"action"];
	[dictSendMessage setValue:strFileUrl forKey:@"fileUrl"];
	NSInteger ind = 0;
	BOOL isReplace = NO;
	for (NSMutableDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages) {
		if ([[dict objectForKey:@"UniqueId"] isEqualToString:[dictSendMessage objectForKey:@"UniqueId"]]) {
			[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages replaceObjectAtIndex:ind withObject:dictSendMessage];
			[dict setObject:[dictSendMessage valueForKey:@"seq"] forKey:@"seq"];
			[dict setObject:[dictSendMessage valueForKey:@"action"] forKey:@"action"];
			[dict setObject:[dictSendMessage valueForKey:@"body"] forKey:@"body"];
			[dict setObject:[dictSendMessage valueForKey:@"fileUrl"] forKey:@"fileUrl"];
			[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages replaceObjectAtIndex:ind withObject:dict];
			isReplace = YES;
			break;
		}
		ind++;
	}
	if (!isReplace) {
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages addObject:dictSendMessage];
	}
	[dictSendMessage release];
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS object:nil];
	[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath, strFileId] error:nil];
}


- (void)uploadFileToWebservice:(NSString*)fileName {
	//NSLog(@"%@", [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:@"hi.txt"]);
	
	NSMutableData *imageData = [NSMutableData dataWithContentsOfFile:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]]];
	
    static NSString * const BOUNDRY = @"0xKhTmLbOuNdArY";
	static NSString * const FORM_FLE_INPUT = @"file";
	
	
	//NSLog(@"=================");
	
    //	NSUInteger len = [imageData length];
    //	Byte *byteData = (Byte*)malloc(len);
    //	memcpy(byteData, [imageData bytes], len);
    //	NSLog(@"%s",byteData);
    
	//NSLog(@"%@",imageData);
	
	//NSLog(@"=================");
	    
	//NSString *urlString = [NSString stringWithFormat:@"%@%@.png",URL_FILE_SENDING_WEBSERVICE, fileName];
    //NSLog(@"%@", urlString);
    NSString *urlString = @"";
    if (CONNECTION_MODE == 1) {
        urlString = [NSString stringWithFormat:@"%@%@%@",HTTPS_WEB_SERVER,URL_FILE_SENDING_WEBSERVICE, fileName];
        
    } else {
        urlString = [NSString stringWithFormat:@"http://%@%@%@",((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strServerLocation,URL_FILE_SENDING_WEBSERVICE, fileName];
    }
	NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDRY]  forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postData = [NSMutableData dataWithCapacity:[imageData length] + 512];
    [postData appendData: [[NSString stringWithFormat:@"--%@\r\n", BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData: [[NSString stringWithFormat:
							@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n\r\n", FORM_FLE_INPUT , fileName]
						   dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:imageData];
    [postData appendData:
     [[NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDRY] dataUsingEncoding:NSUTF8StringEncoding]];
	
    [urlRequest setHTTPBody:postData];
	//NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
//	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//	NSLog(@"%@", returnString);
    //[self sendFileUrl:fileName url:returnString];
	[[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
	
	responseData = [[NSMutableData alloc
					 ] init];	
}

#pragma mark -
#pragma mark delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	//[[NSNotificationCenter defaultCenter] postNotificationName:NotificationName object:nil];
    // NSLog (@"%@", [error description]);
    // NSLog (@"%@", [error debugDescription]);
    // int i = 0;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	//[[NSNotificationCenter defaultCenter] postNotificationName:NotificationName object:responseString];	
	NSLog(responseString);
	//http://mqspectrum.zapto.org/pulse/resource/832695c5-21ed-44ec-9a18-ff418eb32148_23542162.png
    @try {
        /*
	if (([responseString rangeOfString:@"http://"]).location == NSNotFound) {
        if (([responseString rangeOfString:@"https://"]).location == NSNotFound) {
            return;
        }
	}
         */
	// NSString *strFilename = [[[[responseString componentsSeparatedByString:@"_"] lastObject] componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *strFilename = [[responseString componentsSeparatedByString:@"_"] lastObject];
	NSInteger indx = 0;
        
	//if (([responseString rangeOfString:@"class-"]).location != NSNotFound)
    if (([strFilename rangeOfString:@"-"]).location != NSNotFound) 
    {
        //strFilename = [[[strFilename substringFromIndex:([strFilename rangeOfString:@"-"]).location] componentsSeparatedByString:@"."] objectAtIndex:0];
		// strFilename = [[[responseString substringFromIndex:([responseString rangeOfString:@"class-"]).location] componentsSeparatedByString:@"."] objectAtIndex:0];
		//NSLog(@"%@", [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileSendingList description]);
		for (NSDictionary *dictFile in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileSendingList) {
			if ([[dictFile objectForKey:@"fileId"] isEqualToString:strFilename]) {
				NSMutableDictionary *dictTemp = [NSMutableDictionary dictionaryWithDictionary:dictFile];
				[dictTemp setObject:responseString forKey:@"fileUrl"];
				[self sendFileUrlToGroup:strFilename url:responseString];
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileSendingList replaceObjectAtIndex:indx withObject:dictTemp];
				return;
			}
			indx++;
		}
	}
        [self sendFileUrl:strFilename url:responseString];
        [responseString release];
    }
    @catch (NSException *error) {
        // To noitfy user that file transfer did not succeed
    }
}

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SELECTED_MENU_ITEM 
														object:@"8"];
}
@end
																
