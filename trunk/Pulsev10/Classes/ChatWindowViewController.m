//
//  ChatWindowViewController.m
//  MobileJabber
//
//  Created by Shivang Vyas on 7/2/11.
//  Copyright 2011 company. All rights reserved.
//

#import "ChatWindowViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>


@implementation ChatWindowViewController
@synthesize ObjXMPPUserCoreDataStorage, dictGroupChatUser;


- (void)viewDidLoad {
    [super viewDidLoad];
	queue = [NSOperationQueue new];
	self.navigationController.delegate = self;
	txtMessage.layer.cornerRadius = 0.0;
	txtMessage.layer.borderWidth = 0.0;
	
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[TblChatConversation setEditing:NO];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(UpdateUserChat:) 
												 name:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(ReceiveResponderAction:) 
												 name:NSNOTIFICATION_FILEACTION 
											   object:nil];

	if (self.ObjXMPPUserCoreDataStorage != nil) {
		lblUserName.text = self.ObjXMPPUserCoreDataStorage.displayName;
	}
	else {
		NSString *strUserName = @"";
        // Patch for user close group chat and someone sends message
        @try {
            // NSLog(@"%@", dictGroupChatUser);
            strUserName = [[dictGroupChatUser objectForKey:@"user"] objectForKey:@"GroupName"];
            
            /*
            for (XMPPUserCoreDataStorage *user in [[dictGroupChatUser objectForKey:@"user"] objectForKey:@"GroupUsers"]) {
                strUserName = [NSString stringWithFormat:@"%@%@,", strUserName, user.displayName];						   
            }
            if ([strUserName length] > 0) {
                strUserName = [strUserName substringToIndex:[strUserName length] - 1];
            }
             */
            // We are in a group - we need to check if we have file transfer capabilities
            if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strSelfRole != nil &&
                ([((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strSelfRole isEqualToString:@"Teacher"] || 
                 [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strSelfRole isEqualToString:@"Instructor"])) {
                    [btnFileSend setHidden:NO];
                } else {
                    [btnFileSend setHidden:YES];
                }
        }
        @catch (NSException *error) {
            NSLog (@"Exception ChatWindowViewController - %@", [error description]);
        }
		
		lblUserName.text = strUserName;
	}

	
	
	//NSLog(@"conv: %@",((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages
//		  );
	
	[self UpdateUserChat:self];
	if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).isFileSendingSelected) {
		//[UIModa dismissWithClickedButtonIndex:1 animated:NO];
		[self dismissModalViewControllerAnimated:NO];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File Sending"
														message:@"Select a file by tapping the directory button"
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).isFileSendingSelected = NO;
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	//NSLog(@"%i",interfaceOrientation);
	// return(interfaceOrientation==UIInterfaceOrientationLandscapeRight);
	return(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewWillDisappear:animated];
	ObjXMPPUserCoreDataStorage = nil;
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[ObjXMPPUserCoreDataStorage release];
    [super dealloc];
}

#pragma mark -
#pragma mark IBAction or Custom Methods
-(void)StartFileTransferProcess:(id)sender{

	/*
//	FileTransfer * ObjFileTransfer = [[FileTransfer alloc] initWithSenderJID:
//									  [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] full
//									   ]
//												  ReceiverJID:[NSString stringWithFormat:@"%@/%@",ObjXMPPUserCoreDataStorage.jidStr,RESOURCES
//															   ] 
//													 FileName: [NSString stringWithFormat:@"%@To%@On%@-%@.png",
//																[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] full] componentsSeparatedByString:@"@"
//																  ] objectAtIndex:0],
//																[[ObjXMPPUserCoreDataStorage.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0
//																 ],[[[[NSDate date] description] componentsSeparatedByString:@" "] objectAtIndex:0
//																	],[[[[NSDate date] description] componentsSeparatedByString:@" "] objectAtIndex:1
//																	   ]
//																
//																]
//													 FileSize:
//					   [[NSData dataWithData:UIImagePNGRepresentation(sender)] length]
//					   
//												 FileContents:
//									  [NSData dataWithData:UIImagePNGRepresentation(sender)]
//					   ];
	
	
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ObjFileTransfer.strFileName = [NSString stringWithFormat:@"%@To%@On%@-%@.png",
								   [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] full] componentsSeparatedByString:@"@"
									 ] objectAtIndex:0],
								   [[ObjXMPPUserCoreDataStorage.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0
									],[[[[NSDate date] description] componentsSeparatedByString:@" "] objectAtIndex:0
									   ],[[[[NSDate date] description] componentsSeparatedByString:@" "] objectAtIndex:1
										  ]
								   
								   ];
	
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ObjFileTransfer.strReceiverJID = [NSString stringWithFormat:@"%@/%@",ObjXMPPUserCoreDataStorage.jidStr,RESOURCES
									  ];
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ObjFileTransfer.strSenderJID = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] full
									];
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ObjFileTransfer.fileSize = [[NSData dataWithData:UIImagePNGRepresentation(sender)] length];
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ObjFileTransfer.dtFileContents = [NSData dataWithData:UIImagePNGRepresentation(sender)];
	
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ObjFileTransfer CreateAndSendFileTransferRequest];
	
	*/
}


-(void)ReceiveResponderAction:(id)Action{
	//NSLog(@"%@",[Action description]);
	
/**************if accepted then send *************************
	<iq id="JN_27" type="get" to="amanda@mqcommunicator/Messenger">
		<query xmlns="file:iq:accept">
			C:\Docs\BusinessCV.doc
		</query>
	</iq> 
*/
	
/**************if rejected then send *************************
	 <iq id="JN_27" type="get" to="amanda@mqcommunicator/Messenger">
	 <query xmlns="file:iq:cancel">
	 C:\Docs\BusinessCV.doc
	 </query>
	 </iq> 
*/

/*
 {name = FILE_ACTION; object = {
 ACTION = ACCEPT;
 FILE = "<FileTransfer: 0xf327bd0>";
 }}
 
 */
	if([[[Action object] valueForKey:@"ACTION"] isEqualToString:@"ACCEPT"]){
		NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
		[iq addAttributeWithName:@"type" stringValue:@"get"];
		[iq addAttributeWithName:@"to" stringValue:((FileTransfer*)[[Action object] valueForKey:@"FILE"]).strSenderJID
		 ];
		//NSLog(@"%@",((FileTransfer*)[[Action object] valueForKey:@"FILE"]).strFileName);
		
		NSXMLElement *query = [NSXMLElement elementWithName:@"query" stringValue:((FileTransfer*)[[Action object] valueForKey:@"FILE"]).strFileName];
		
		[query setXmlns:@"file:iq:accept"];
		
		[iq addChild:query];
		
		//NSLog(@"%@",[iq description]);
		
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:iq];
		
		
	}else if([[[Action object] valueForKey:@"ACTION"] isEqualToString:@"REJECT"]){
		NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
		[iq addAttributeWithName:@"type" stringValue:@"get"];
		[iq addAttributeWithName:@"to" stringValue:((FileTransfer*)[[Action object] valueForKey:@"FILE"]).strSenderJID
		 ];
		
		NSXMLElement *query = [NSXMLElement elementWithName:@"query" stringValue:((FileTransfer*)[[Action object] valueForKey:@"FILE"]).strFileName];
		[query setXmlns:@"file:iq:cancel"];
		
		[iq addChild:query];
		
		//NSLog(@"%@",[iq description]);

		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:iq];
	}
}

-(IBAction)BtnCloseTabbed:(id)sender {
	[self.view removeFromSuperview];
	if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).chatActUser != nil) {
		for (NSDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers) {
			if ([[dict objectForKey:@"type"] isEqualToString:@"chat"] && 
				[dict objectForKey:@"user"] == ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).chatActUser) {
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers removeObject:dict];
				break;
			}
		}
		
	}
	if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictChatActGroup != nil) {
		for (NSDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers) {
			if ([[dict objectForKey:@"type"] isEqualToString:@"groupChat"] && 
				[dict objectForKey:@"user"] == ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictChatActGroup) {
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers removeObject:dict];
				break;
			}
		}
	}
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).chatActUser = nil;
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictChatActGroup = nil;
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS object:nil];
}

-(IBAction)BtnSendFileTabbed:(id)sender {
	imgpkctrl_File.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgpkctrl_File.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).NavigationBarType = 0;
	
	if(popCtrl_OpenFile!=nil && [popCtrl_OpenFile retainCount]>0){
		[popCtrl_OpenFile release];
		popCtrl_OpenFile = nil;
	}
	
	popCtrl_OpenFile = [[UIPopoverController alloc] initWithContentViewController:imgpkctrl_File];
	popCtrl_OpenFile.delegate = self;
	popCtrl_OpenFile.popoverContentSize = CGSizeMake(350,540);
	CGRect popoverRect = [[[UIApplication sharedApplication] keyWindow
						   ] convertRect:[sender frame] fromView:[sender superview]];
 
	[popCtrl_OpenFile presentPopoverFromRect:popoverRect 
									  inView:[[UIApplication sharedApplication] keyWindow
											  ] 
					permittedArrowDirections:UIPopoverArrowDirectionDown
									animated:YES];
}

-(void)UpdateUserChat:(id)sender {
	if (self.ObjXMPPUserCoreDataStorage != nil && ![self.ObjXMPPUserCoreDataStorage faultingState]) {
		@try {
			[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) GetMessagesForUserWithJid:
			 [
			  [self.ObjXMPPUserCoreDataStorage.jidStr componentsSeparatedByString:@"/"]
			  objectAtIndex:0]
			 ];
		}
		@catch (NSException * e) {
			
		}
		@finally {
			
		}
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) GetMessagesForUserWithJid:
		 [
		  [self.ObjXMPPUserCoreDataStorage.jidStr componentsSeparatedByString:@"/"]
		  objectAtIndex:0]
		 ];
	}
	else if (self.dictGroupChatUser != nil){
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) GetMessagesForUserWithGroupName:
		 [[self.dictGroupChatUser objectForKey:@"user"] objectForKey:@"GroupName"]];
	}
	

	if(ObjTblChatConversationDataSource!=nil && [ObjTblChatConversationDataSource retainCount]>0){
		[ObjTblChatConversationDataSource release];
		ObjTblChatConversationDataSource = nil;
	}
	ObjTblChatConversationDataSource = [[TblChatConversationDataSource alloc] initWithArray:
										((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserConversation
										];
	
	ObjTblChatConversationDataSource.ChatUser = self.ObjXMPPUserCoreDataStorage;
	
	if(ObjTblChatConversationDelegate!=nil && [ObjTblChatConversationDelegate retainCount]>0){
		[ObjTblChatConversationDelegate release];
		ObjTblChatConversationDelegate = nil;
	}
	ObjTblChatConversationDelegate = [[TblChatConversationDelegate alloc] initWithArray:
										((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserConversation
										];	
	
	ObjTblChatConversationDelegate.ChatUser = self.ObjXMPPUserCoreDataStorage;
	
	TblChatConversation.dataSource = ObjTblChatConversationDataSource;
	TblChatConversation.delegate = ObjTblChatConversationDelegate;
	
	[TblChatConversation reloadData];
	//[TblChatConversation scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:NO];
	if ([((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserConversation count] > 0) {
		NSInteger rowInd = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserConversation count]-1;
		NSIndexPath *indxPath = [NSIndexPath indexPathForRow:rowInd inSection:0];
		[TblChatConversation scrollToRowAtIndexPath:indxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}
	
}

-(void)BtnSendMessageTabbed:(id)sender {
	if (self.ObjXMPPUserCoreDataStorage == nil && self.dictGroupChatUser == nil) {
		NSString *strMsg;
		if (isFileSend) {
			strMsg = @"Please select an online contact whom you wish to send the file to.";
		}
		else {
			strMsg = @"The contact is currently offline. We are unable to send a message.";
		}

		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
														message:strMsg
													   delegate:nil
												cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([[txtMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 && !isFileSend){
		// UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" 
		// 												 message:@"Enter Message, Please !" 
		// 												delegate:nil 
		//									   cancelButtonTitle:@"OK" 
		//									   otherButtonTitles:nil];
		//[alert show];
		//[alert release];
	}else {		
		if (isFileSend) {
			isFileSend = NO;
			if (self.ObjXMPPUserCoreDataStorage != nil) {
				if ([self.ObjXMPPUserCoreDataStorage.sectionNum intValue] != 0) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
																	message:@"The contact is currently offline and hence we are unable to send the file."
																   delegate:nil
														  cancelButtonTitle:@""
														  otherButtonTitles:nil];
					[alert show];
					[alert release];
				}
				else {
					//Setting message attributes
					NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
					[message addAttributeWithName:@"type" stringValue:FILE_SENDING_TEXT];
					[message addAttributeWithName:@"to" stringValue:self.ObjXMPPUserCoreDataStorage.jidStr];
					[message addAttributeWithName:@"from" stringValue:[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare]
					 ];
					NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
					NSXMLElement *sequece = [NSXMLElement elementWithName:@"seq"];
					NSXMLElement *fileSentDate = [NSXMLElement elementWithName:@"Date"];
					NSXMLElement *fileId = [NSXMLElement elementWithName:@"UniqueId"];
					NSXMLElement *action = [NSXMLElement elementWithName:@"Action"];
					[sequece setStringValue:@"0"];
					
					NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
					[formatter setLocale:[NSLocale currentLocale]];
					[formatter setDateFormat:@"dd-MMM-yyyy hh:mm"];
					NSString* localDateString = [formatter stringFromDate:[NSDate date]];
					[formatter release];
					[fileSentDate setStringValue:localDateString];
					
					[fileId setStringValue:strUniqueFileId];
					
					[action setStringValue:@""];
					[body addChild:sequece];			
					[body addChild:fileId];
					[body addChild:action];
					[message addChild:fileSentDate];
					[message addChild:body];
					
					//Send Message
					[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:message];
					
					NSMutableDictionary * dictSendMessage = [[NSMutableDictionary alloc] init];
					[dictSendMessage setValue:[message attributeStringValueForName:@"to"] forKey:@"to"];
					[dictSendMessage setValue:[message attributeStringValueForName:@"from"] forKey:@"from"];	
					[dictSendMessage setObject:@"File rejected" forKey:@"body"];
					[dictSendMessage setValue:localDateString forKey:@"Date"];
					[dictSendMessage setValue:FILE_SENDING_TEXT forKey:@"type"];
					[dictSendMessage setValue:[[[message elementForName:@"body"] elementForName:@"UniqueId"] stringValue] forKey:@"UniqueId"];
					[dictSendMessage setValue:[[[message elementForName:@"body"] elementForName:@"seq"] stringValue] forKey:@"seq"];
					[dictSendMessage setValue:[[[message elementForName:@"body"] elementForName:@"action"] stringValue] forKey:@"action"];
					
					[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages addObject:dictSendMessage];
					[dictSendMessage release];
					[self UpdateUserChat:self];
					strUniqueFileId = @"";
				}	
			}
			else {
				//Setting message attributes
				NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
				[message addAttributeWithName:@"type" stringValue:@"groupchat"];
				
				[message addAttributeWithName:@"to" stringValue:[[self.dictGroupChatUser objectForKey:@"user"] objectForKey:@"roomId"]];
				[message addAttributeWithName:@"from" stringValue:[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID]
																	 description] componentsSeparatedByString:@"@"] objectAtIndex:0]];
				NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
				NSXMLElement *sequece = [NSXMLElement elementWithName:@"seq"];
				NSXMLElement *fileSentDate = [NSXMLElement elementWithName:@"Date"];
				NSXMLElement *fileId = [NSXMLElement elementWithName:@"UniqueId"];
				NSXMLElement *action = [NSXMLElement elementWithName:@"Action"];
				[sequece setStringValue:@"0"];
				NSXMLElement *type = [NSXMLElement elementWithName:@"type" stringValue:GROUP_FILE_SENDING_TEXT];
				
				NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
				[formatter setLocale:[NSLocale currentLocale]];
				[formatter setDateFormat:@"dd-MMM-yyyy hh:mm"];
				NSString* localDateString = [formatter stringFromDate:[NSDate date]];
				[formatter release];
				[fileSentDate setStringValue:localDateString];
				
				[fileId setStringValue:strUniqueFileId];
				
				[action setStringValue:@""];
				[body addChild:type];
				[body addChild:sequece];			
				[body addChild:fileId];
				[body addChild:action];
				[message addChild:fileSentDate];
				[message addChild:body];
                
                // NSLog(@"%@", strUniqueFileId);
				
				//Send Message
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:message];
				
				NSInteger onlineUser = 0;
				
				for (id obj in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers) {
					if ([[obj objectForKey:@"user"] class] != [XMPPUserCoreDataStorage class]) {
						if ([[[[obj objectForKey: @"user"]objectForKey:@"GroupName"] lowercaseString] isEqualToString:[[[[[self.dictGroupChatUser objectForKey:@"user"] objectForKey:@"roomId"] description] componentsSeparatedByString:@"#"] objectAtIndex:0]
							 ]) {
							for (XMPPUserCoreDataStorage *user in [[obj objectForKey: @"user"]objectForKey:@"GroupUsers"]) {
								if ([user.sectionNum intValue] == 0) {
									onlineUser++;
								}					
							}
						}
					}
				}
									
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileSendingList addObject:
				 [NSDictionary dictionaryWithObjectsAndKeys:strUniqueFileId, @"fileId", @"NO", @"IsUploaded",
				  @"0", @"rejectCount", [NSString stringWithFormat:@"%d", onlineUser], @"maxReject",
				  [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID]
					 description] componentsSeparatedByString:@"@"] objectAtIndex:0], @"sender",nil]];
				strUniqueFileId = @"";
				// NSLog(@"%@", [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileSendingList description]);
			}			
		}
		else {
			if (self.ObjXMPPUserCoreDataStorage != nil) {
				NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
                NSString *mesgText = txtMessage.text;
                NSString *nmesg = [NSString stringWithUTF8String:[mesgText cStringUsingEncoding:NSUTF8StringEncoding]];
                nmesg = [nmesg stringByReplacingOccurrencesOfString:@"\\" withString:@"\5c"];
                
				[body setStringValue:txtMessage.text];
				
				//Setting message attributes
				NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
				[message addAttributeWithName:@"type" stringValue:@"chat"];
				[message addAttributeWithName:@"to" stringValue:self.ObjXMPPUserCoreDataStorage.jidStr];				
					
				[message addAttributeWithName:@"from" stringValue:[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare]
				 ];
				
				//Setting message send date
				NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
				[formatter setLocale:[NSLocale currentLocale]];
				[formatter setDateFormat:@"dd-MMM-yyyy hh:mm"];
				NSString* localDateString = [formatter stringFromDate:[NSDate date]];
				[formatter release];
				
				NSXMLElement * MsgSendDate = [NSXMLElement elementWithName:@"Date" stringValue:localDateString];
				[message addChild: MsgSendDate];
				[message addChild:body];
				
				//Send Message
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:message];
				
				//Also add message to chat conversation.....!
				NSMutableDictionary * dictSendMessage = [[NSMutableDictionary alloc] init];
				[dictSendMessage setValue:[message valueForKey:@"to"] forKey:@"to"];
				[dictSendMessage setValue:[message valueForKey:@"from"] forKey:@"from"];	
				[dictSendMessage setValue:[[message elementForName:@"body"] stringValue] forKey:@"body"];
				[dictSendMessage setValue:localDateString forKey:@"Date"];
				[dictSendMessage setValue:@"chat" forKey:@"type"];
				
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages addObject:dictSendMessage];
				[dictSendMessage release];
				[self UpdateUserChat:self];
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) insertChatHistory:dictSendMessage];
				txtMessage.text=@"";
				
			}
			else {
/*<message id="JN_26"
	from="victor" 
	to="class-ocs1#24263202#room@conference.mqcommunicator" 
	type="groupchat">
	<body>&lt;Paragraph FontFamily="Segoe UI" FontStyle="Normal" FontWeight="Normal" FontSize="12" Foreground="#FF000000" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"&gt;hi&lt;/Paragraph&gt;</body>
		<subject>
			RichTextChat|
		</subject>
 </message>
				*/
				NSXMLElement *message = [NSXMLElement elementWithName:@"message"];				
				[message addAttributeWithName:@"to" stringValue:[[self.dictGroupChatUser objectForKey:@"user"] objectForKey:@"roomId"]];
				[message addAttributeWithName:@"from" stringValue:
				 [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID]
				   description] componentsSeparatedByString:@"@"] objectAtIndex:0]];
				[message addAttributeWithName:@"type" stringValue:@"groupchat"];
				
				NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
				//[body setStringValue:@"&lt;Paragraph FontFamily=\"Segoe UI\" FontStyle=\"Normal\" FontWeight=\"Normal\" FontSize=\"12\" Foreground=\"#FF000000\" xmlns=\"http://schemas.microsoft.com/winfx/2006/xaml/presentation\"&gt;hi&lt;/Paragraph&gt;"];
//				NSXMLElement *subject = [NSXMLElement elementWithName:@"subject" stringValue:txtMessage.text];
//				[body addChild:subject];
//				NSXMLElement *sender = [NSXMLElement elementWithName:@"sender"
//														 stringValue: [[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare]
//																							   description]]; 
//				[body addChild:sender];
				[body setStringValue:txtMessage.text];
				[message addChild:body];
				
				//Setting message send date
				//NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//				[formatter setLocale:[NSLocale currentLocale]];
//				[formatter setDateFormat:@"dd-MMM-yyyy hh:mm"];
//				NSString* localDateString = [formatter stringFromDate:[NSDate date]];
//				[formatter release];
				
				//NSXMLElement * MsgSendDate = [NSXMLElement elementWithName:@"Date" stringValue:localDateString];
				//[message addChild: MsgSendDate];

				
				//Send Message				
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:message];
				
				/*//Also add message to chat conversation.....!
				NSMutableDictionary * dictSendMessage = [[NSMutableDictionary alloc] init];
				[dictSendMessage setValue:[message valueForKey:@"to"] forKey:@"to"];
				[dictSendMessage setValue:[message valueForKey:@"from"] forKey:@"from"];	
				[dictSendMessage setValue:[[[message elementForName:@"body"] elementForName:@"subject"] stringValue] forKey:@"body"];
				[dictSendMessage setValue:localDateString forKey:@"Date"];
				[dictSendMessage setValue:@"groupChat" forKey:@"type"];
				
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages addObject:dictSendMessage];
				[dictSendMessage release];
				[self UpdateUserChat:self];
				*/
				txtMessage.text=@"";						 
			}			
		}

	}
}

#pragma mark -
#pragma mark UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
    
        UIImage *PhotoLibImage = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
        isFileSend = YES;
	
        //NSInteger uinqId1;
        //	do{
        //	 uinqId1 = rand() % 9999;
        //	}while(uinqId1 < 1000);
        //	
        //	NSInteger uinqId2;
        //	do{
        //		uinqId2 = rand() % 9999;
        //	}while(uinqId2 < 1000);
        //	
        //	//NSLog(@"%i%i",uinqId1,uinqId2);
        //	if (self.ObjXMPPUserCoreDataStorage != nil) {
        //		strUniqueFileId = [NSString stringWithFormat:@"%@%i%i",[[self.ObjXMPPUserCoreDataStorage.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0], uinqId1,uinqId2];
        //	}
        //	else {		
        //		strUniqueFileId = [NSString stringWithFormat:@"%@%i%i",[[[[self.dictGroupChatUser objectForKey:@"user"] objectForKey:@"roomId"] componentsSeparatedByString:@"#"] objectAtIndex:0], uinqId1,uinqId2];
        //	}
        
        if (self.ObjXMPPUserCoreDataStorage != nil) {
            if (USEJPEGCOMPRESSION == 1) {
                strUniqueFileId = [NSString stringWithFormat:@"%@%ld%@",[[self.ObjXMPPUserCoreDataStorage.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0], (long)[[NSDate date] timeIntervalSince1970], @".jpg"];
            } else {
                strUniqueFileId = [NSString stringWithFormat:@"%@%ld%@",[[self.ObjXMPPUserCoreDataStorage.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0], (long)[[NSDate date] timeIntervalSince1970], @".png"];
            }
        }
        else {		
            if (USEJPEGCOMPRESSION == 1) {
                strUniqueFileId = [NSString stringWithFormat:@"%@%ld%@",[[[[self.dictGroupChatUser objectForKey:@"user"] objectForKey:@"roomId"] componentsSeparatedByString:@"#"] objectAtIndex:0], (long)[[NSDate date] timeIntervalSince1970], @".jpg"];
            } else {
                strUniqueFileId = [NSString stringWithFormat:@"%@%ld%@",[[[[self.dictGroupChatUser objectForKey:@"user"] objectForKey:@"roomId"] componentsSeparatedByString:@"#"] objectAtIndex:0], (long)[[NSDate date] timeIntervalSince1970], @".png"];
            }
        }
        
        /*
        // We need to get this working so that files are optimised
        if ([PhotoLibImage size].width > 640 || [PhotoLibImage size].height > 480) {
            UIImage * newimg = [self scaleImage:PhotoLibImage toSize:CGSizeMake(640, 480)];
            [PhotoLibImage release];
            PhotoLibImage = nil;
            PhotoLibImage = newimg;
        }
         */
	
        NSData *imgData = nil;

        if (USEJPEGCOMPRESSION == 1) {
            // imgData = UIImageJPEGRepresentation(newImg, JPEGCOMPRESSION);
            imgData = UIImageJPEGRepresentation(PhotoLibImage, JPEGCOMPRESSION);
        } else {
            // imgData = UIImagePNGRepresentation(newImg);
            imgData = UIImagePNGRepresentation(PhotoLibImage);
        }
        fileType = 0;
        
        NSLog (@"Finished Picking File - %@", strUniqueFileId);
        NSLog (@"File Size : %d", [imgData length]);
        // NSLog (@"%@", [imgData length]);
	
        [imgData writeToFile:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:strUniqueFileId] atomically:YES];
        
        // [imgData release];
	
        [self BtnSendMessageTabbed:self];
	 
        //[[NSFileManager defaultManager] createFileAtPath:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", strUniqueFileId]] 
        //											contents:UIImagePNGRepresentation(PhotoLibImage) 
        //										  attributes:nil];
        /*
         <iq	id="JN_35" type="get" to="victor@mqcommunicator/Messenger">
         <query xmlns="file:iq:transfer">
			C:\Docs\BusinessCV.doc|54 KB
         </query>
         </iq> 
         */
	
        /*	NSOperationQueue * Queue = [NSOperationQueue new];
         NSInvocationOperation * operation = [[NSInvocationOperation alloc] initWithTarget:self 
																			 selector:@selector(StartFileTransferProcess:) 
																			   object:PhotoLibImage
										 ];
	
         [Queue addOperation:operation];
         [operation release];	*/		
	
        /*	
         NSXMLElement * iq = [NSXMLElement elementWithName:@"iq"];		
         [iq addAttributeWithName:@"type" stringValue:@"get"];	
         [iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@/%@",ObjXMPPUserCoreDataStorage.jidStr,RESOURCES
												]];
	
         NSString * strFileName = [NSString stringWithFormat:@"%@To%@On%@-%@.png",
							  [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] full] componentsSeparatedByString:@"@"
								] objectAtIndex:0],
							  [[ObjXMPPUserCoreDataStorage.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0
							   ],[[[[NSDate date] description] componentsSeparatedByString:@" "] objectAtIndex:0
								  ],[[[[NSDate date] description] componentsSeparatedByString:@" "] objectAtIndex:1
									 ]
							  
							  ];
	
         NSInteger fileSize = [[NSData dataWithData:UIImagePNGRepresentation(PhotoLibImage)] length];
	
	
         NSXMLElement * query = [NSXMLElement elementWithName:@"query" 
											 stringValue:[NSString stringWithFormat:
														  @"%@|%d",strFileName,fileSize
														  ]
							];
	
         [query setXmlns:@"file:iq:transfer"];
         [iq addChild:query];
         NSLog(@"%@",[iq description]);
         [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:iq];
         */
    }
    else if (CFStringCompare((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog (@"%@", videoURL);
        NSData *webdata = [NSData dataWithContentsOfURL:videoURL];
        fileType = 1;
        isFileSend = YES;
        
        if (self.ObjXMPPUserCoreDataStorage != nil) {
            strUniqueFileId = [NSString stringWithFormat:@"%@%ld%@",[[self.ObjXMPPUserCoreDataStorage.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0], (long)[[NSDate date] timeIntervalSince1970], @".mov"];
        }
        else {		
            strUniqueFileId = [NSString stringWithFormat:@"%@%ld%@",[[[[self.dictGroupChatUser objectForKey:@"user"] objectForKey:@"roomId"] componentsSeparatedByString:@"#"] objectAtIndex:0], (long)[[NSDate date] timeIntervalSince1970], @".mov"];
        }
        [webdata writeToFile:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:strUniqueFileId] atomically:YES];    
 
        /*
        MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
        UIImage *thumbnail = [[moviePlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame] retain];
        NSData *imgData = UIImagePNGRepresentation(thumbnail);
         */
        // [imgData writeToFile:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", strUniqueFileId]] atomically:YES];        
        // [imgData release];
        //[moviePlayer release];
        //[thumbnail release];
        [self BtnSendMessageTabbed:self];
    }
	[imgpkctrl_File dismissModalViewControllerAnimated:YES];
	[popCtrl_OpenFile dismissPopoverAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[imgpkctrl_File dismissModalViewControllerAnimated:YES];
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)targetSize {
    //If scaleFactor is not touched, no scaling will occur      
    CGFloat scaleFactor = 1.0;
    
    //Deciding which factor to use to scale the image (factor = targetSize / imageSize)
    if (image.size.width > targetSize.width || image.size.height > targetSize.height)
        if (!((scaleFactor = (targetSize.width / image.size.width)) > (targetSize.height / image.size.height))) //scale to fit width, or
            scaleFactor = targetSize.height / image.size.height; // scale to fit heigth.
    
    UIGraphicsBeginImageContext(targetSize); 
    
    //Creating the rect where the scaled image is drawn in
    CGRect rect = CGRectMake((targetSize.width - image.size.width * scaleFactor) / 2,
                             (targetSize.height -  image.size.height * scaleFactor) / 2,
                             image.size.width * scaleFactor, image.size.height * scaleFactor);
    
    //Draw the image into the rect
    [image drawInRect:rect];
    
    //Saving the image, ending image context
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

#pragma mark -
#pragma mark UITextField delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self.view bringSubviewToFront:textField];
	[self.view bringSubviewToFront:viwSendMessage];
	[textField resignFirstResponder];
	[self BtnSendMessageTabbed:self];
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	textField.keyboardType =  UIKeyboardTypeDefault;
	[self.view bringSubviewToFront:textField];
	[self.view bringSubviewToFront:viwSendMessage];
	viwSendMessage.frame = CGRectMake(20,290,450,75);	
 
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
	[self.view bringSubviewToFront:textField];
	[self.view bringSubviewToFront:viwSendMessage];	
	viwSendMessage.frame = CGRectMake(20,586,450,75);
	return YES;
	
}

- (BOOL)textField:(UITextField *)textField 
shouldChangeCharactersInRange:(NSRange)range 
replacementString:(NSString *)string {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:
					((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strEmoziPath];
	NSString *strTempReplacement = [dict objectForKey:string];
	if (strTempReplacement != nil && ![strTempReplacement isEqualToString:@""]) {
		txtMessage.text = [NSString stringWithFormat:@"%@%@", txtMessage.text, strTempReplacement];
		return NO;
	}
#endif
	return YES;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_DRAW_NAVIGATIONBAR 
														object:nil];	
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

}

@end
