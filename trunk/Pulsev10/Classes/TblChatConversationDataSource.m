//
//  TblChatConversationDataSource.m
//  MobileJabber
//
//  Created by Shivang Vyas on 7/2/11.
//  Copyright 2011 company. All rights reserved.
//

#import "TblChatConversationDataSource.h"

@implementation TblChatConversationDataSource
@synthesize ChatUser;

-(id) initWithArray:(NSMutableArray*)aryChatConversations{
	if (self=[super init]) {
		ary = [[[NSMutableArray alloc]initWithArray:aryChatConversations] retain];	
		isSelfMessage = NO;
		isFirstMessage = YES;
		strLastUserName = @"";
	}
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [ary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = [NSString stringWithFormat:@"(%i)(%i)",indexPath.section,indexPath.row];
	UITableViewCell * cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell != nil) {
        if (cell.tag == 1) // Actions can be performed
            cell = nil;
        else if (cell.tag == 2) {
            for (UIView *subview in cell.subviews)
            {
                if([subview isKindOfClass:[UIButton class]])
                {
                    UIButton *btn = ((UIButton *) subview);
                    [btn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents]; 
                    [btn addTarget:self action:@selector(btnShowImageTapped:) forControlEvents:UIControlEventTouchUpInside];            
                }
            }
        }
    }
    
	// cell = nil;
    if (cell == nil) {        
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,450,100) reuseIdentifier:CellIdentifier] 
				autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor clearColor];
        cell.tag = 1; // to make the cell updateable

#pragma mark -
#pragma mark ChatUI
		if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"chat"]) {
            cell.tag = 0; // no further updates required
			CGSize MessageSize = [[[ary objectAtIndex:indexPath.row] valueForKey:@"body"] 
								  sizeWithFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE]
								  constrainedToSize:CGSizeMake(450,MAXFLOAT) 
								  lineBreakMode:UILineBreakModeWordWrap];
			
			UIImageView * CellBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 450, MAX(MessageSize.height + (2*20.0) ,70.0) + 10.0)];
			CellBackground.contentMode = UIViewContentModeScaleToFill;
			CellBackground.image = [UIImage imageNamed:@"main.png"];
			[cell addSubview:CellBackground];
			[CellBackground release];
			
			if([[[[ary objectAtIndex:indexPath.row
				   ] valueForKey:@"from"] description] isEqualToString:
				[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]
				   ).xmppStream myJID] bare] ])
			{ 
                //if a message is sent from current user to another user...!
				// if (!isSelfMessage) {
					UIImageView * ContactImageBackground = [[UIImageView alloc] initWithFrame:CGRectMake((450-46)-10, 10, 46, 46)];
					ContactImageBackground.contentMode = UIViewContentModeScaleToFill;
					ContactImageBackground.image = [UIImage imageNamed:@"image border 48 x 48.png"];
					[cell addSubview:ContactImageBackground];
					[ContactImageBackground release];
					
					UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake((450-46)-5,15,36,36)];
					userImage.contentMode = UIViewContentModeScaleToFill;

                    userImage.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getSelfImage];
                    /*
					NSData * dt = 
					[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppvCardAvatarModule  photoDataForJID:
					 [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID
					  ]
					 ];
					if(dt!=nil){
						if([dt length]>0){
							userImage.image = [UIImage imageWithData:dt];
						}else {
						}
					}else {
						
					}
                     */
					[cell addSubview:userImage];
					[userImage release];
				// }	
				isSelfMessage = YES;
                
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setLocale:[NSLocale currentLocale]];
                [formatter setDateFormat:@"(hh:mm)"];
                NSString* localDateString = [formatter stringFromDate:[NSDate date]];
                [formatter release];

                
				UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(10,10,450-46-10,20)];
				lblName.backgroundColor = [UIColor clearColor];
				//XMPPUserCoreDataStorage *user = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) fetchedUserwithJid:		
//																			 [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]
				// lblName.text = [NSString stringWithFormat:@"%@ %@", ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName, localDateString];
				lblName.text = [NSString stringWithFormat:@"%@", ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName];
                // [localDateString release];
				//lblName.text = [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]
//									).xmppStream myJID] bare] componentsSeparatedByString:@"@"] objectAtIndex:0];
				lblName.textAlignment = UITextAlignmentLeft;
				lblName.textColor = [UIColor whiteColor];			
				lblName.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				[cell addSubview:lblName];
				[lblName release];
				
				UILabel *lblMessageDescription = [[UILabel alloc] initWithFrame:CGRectMake(10,10+20,450-46-10,MessageSize.height)];
				lblMessageDescription.numberOfLines = 0;
				lblMessageDescription.textColor =[UIColor whiteColor];
				lblMessageDescription.textAlignment = UITextAlignmentLeft;
				lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
											   ] valueForKey:@"body"];
				lblMessageDescription.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				lblMessageDescription.backgroundColor=[UIColor clearColor];
				[cell addSubview:lblMessageDescription];
				[lblMessageDescription release];
			}
			else {
				// if (isSelfMessage || isFirstMessage) {
					UIImageView * ContactImageBackground = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 46, 46)];
					ContactImageBackground.contentMode = UIViewContentModeScaleToFill;
					ContactImageBackground.image = [UIImage imageNamed:@"image border 48 x 48.png"];
					[cell addSubview:ContactImageBackground];
					[ContactImageBackground release];
					
					UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(15,15,36,36)];
					userImage.contentMode = UIViewContentModeScaleToFill;	
                    
                    userImage.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getUserImage:ChatUser.jidStr];

					[cell addSubview:userImage];
					[userImage release];
				// }
				isSelfMessage = NO;
								
				UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(46+10,10,450-46-10,20)];
				lblName.backgroundColor = [UIColor clearColor];
				lblName.text = ChatUser.displayName;
				
				lblName.textColor = [UIColor whiteColor];
				lblName.textAlignment = UITextAlignmentLeft;
				lblName.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				[cell addSubview:lblName];
				[lblName release];
				
				UILabel *lblMessageDescription = [[UILabel alloc] initWithFrame:CGRectMake(46+10,10+20,450-46-10,MessageSize.height)];
				lblMessageDescription.numberOfLines = 0;
				lblMessageDescription.textColor =[UIColor whiteColor];
				lblMessageDescription.textAlignment = UITextAlignmentLeft;
				lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
											   ] valueForKey:@"body"];
				lblMessageDescription.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				lblMessageDescription.backgroundColor=[UIColor clearColor];
				[cell addSubview:lblMessageDescription];
				[lblMessageDescription release];
				
			}
		}
#pragma mark -
#pragma mark GroupChatUI
		else if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"groupChat"]) {
            cell.tag = 0; // No further updates required
			//NSLog(@"this is group chat");
			CGSize MessageSize = [[[ary objectAtIndex:indexPath.row] valueForKey:@"body"] 
								  sizeWithFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE]
								  constrainedToSize:CGSizeMake(450,MAXFLOAT) 
								  lineBreakMode:UILineBreakModeWordWrap];
			
			UIImageView * CellBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 450, MAX(MessageSize.height + (2*20.0) ,70.0) + 10.0)
											];
			CellBackground.contentMode = UIViewContentModeScaleToFill;
			CellBackground.image = [UIImage imageNamed:@"main.png"];
			[cell addSubview:CellBackground];
			[CellBackground release];
			//if([[[[ary objectAtIndex:indexPath.row
//				   ] valueForKey:@"from"] description] isEqualToString:
//				[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]
//				   ).xmppStream myJID] bare]] ||
//			   [[[ary objectAtIndex:indexPath.row] objectForKey:@"sender"] isEqualToString:[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]
//																							  ).xmppStream myJID] bare]]) {
			if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"sender"] isEqualToString:
				 [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] 
				   componentsSeparatedByString:@"@"] objectAtIndex:0]]
				) {
				
				// if (![strLastUserName isEqualToString:[[ary objectAtIndex:indexPath.row] objectForKey:@"sender"]]) {
					UIImageView * ContactImageBackground = [[UIImageView alloc] initWithFrame:CGRectMake((450-46)-10, 10, 46, 46)];
					ContactImageBackground.contentMode = UIViewContentModeScaleToFill;
					ContactImageBackground.image = [UIImage imageNamed:@"image border 48 x 48.png"];
					[cell addSubview:ContactImageBackground];
					[ContactImageBackground release];
					
					UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake((450-46)-5,15,36,36)];
					userImage.contentMode = UIViewContentModeScaleToFill;
                
                userImage.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getSelfImage];
					[cell addSubview:userImage];
					[userImage release];
					strLastUserName = [[ary objectAtIndex:indexPath.row] objectForKey:@"sender"];
				// }
				
				UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(10,10,450-46-10,20)];
				lblName.backgroundColor = [UIColor clearColor];
				lblName.text = ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName;
				lblName.textAlignment = UITextAlignmentLeft;
				lblName.textColor = [UIColor whiteColor];			
				lblName.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				[cell addSubview:lblName];
				[lblName release];
				
				UILabel *lblMessageDescription = [[UILabel alloc] initWithFrame:CGRectMake(10,10+20,450-46-10,MessageSize.height)];
				lblMessageDescription.numberOfLines = 0;
				lblMessageDescription.textColor =[UIColor whiteColor];
				lblMessageDescription.textAlignment = UITextAlignmentLeft;
				lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
											   ] valueForKey:@"body"];
				lblMessageDescription.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				lblMessageDescription.backgroundColor=[UIColor clearColor];
				[cell addSubview:lblMessageDescription];
				[lblMessageDescription release];
				
			}
			else {
				ChatUser = (XMPPUserCoreDataStorage*)[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) fetchedUserwithJid:
							[NSString stringWithFormat:@"%@@%@", [[ary objectAtIndex:indexPath.row] objectForKey:@"sender"], SERVERNAME]]objectAtIndex:0];
                UIImageView * ContactImageBackground = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 46, 46)];
                ContactImageBackground.contentMode = UIViewContentModeScaleToFill;
                ContactImageBackground.image = [UIImage imageNamed:@"image border 48 x 48.png"];
                [cell addSubview:ContactImageBackground];
                [ContactImageBackground release];
					
					
                UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(15,15,36,36)];
                userImage.contentMode = UIViewContentModeScaleToFill;	
                userImage.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getUserImage:ChatUser.jidStr];

                [cell addSubview:userImage];
                [userImage release];
                strLastUserName = [[ary objectAtIndex:indexPath.row] objectForKey:@"sender"];
				
				UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(46+10,10,450-46-10,20)];
				lblName.backgroundColor = [UIColor clearColor];
				lblName.text = ChatUser.displayName;
				
				lblName.textColor = [UIColor whiteColor];
				lblName.textAlignment = UITextAlignmentLeft;
				lblName.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				[cell addSubview:lblName];
				[lblName release];
				
				UILabel *lblMessageDescription = [[UILabel alloc] initWithFrame:CGRectMake(46+10,10+20,450-46-10,MessageSize.height)];
				lblMessageDescription.numberOfLines = 0;
				lblMessageDescription.textColor =[UIColor whiteColor];
				lblMessageDescription.textAlignment = UITextAlignmentLeft;
				lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
											   ] valueForKey:@"body"];
				lblMessageDescription.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				lblMessageDescription.backgroundColor=[UIColor clearColor];
				[cell addSubview:lblMessageDescription];
				[lblMessageDescription release];
				
			}
		}
#pragma mark -
#pragma mark GroupFileSendingUI

		else if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"groupFileSending"]) {
			NSInteger height;
            // NSLog(@"start1 - ary - %@", [ary description]);
            NSInteger clength = [ary count];
			if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"seq"] isEqualToString:@"0"]) {
				if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"Action"] isEqualToString:@"Accept"]) {
					height = 70;
				}
				else if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"Action"] isEqualToString:@"Reject"]) {
					height = 70;
				}
				else if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"Action"] isEqualToString:@"Failed"]) {
					height = 70;
				}
				else if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"sender"] isEqualToString:
						  [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] 
							componentsSeparatedByString:@"@"] objectAtIndex:0]]
						 ) {
					height = 70;
				}
				else {
					height = 110;
				}
			}
            NSInteger roidx = indexPath.row;
            // NSLog(@"start2 - roidx - %d", roidx);
            NSDictionary *ndict = [ary objectAtIndex:roidx];
            // NSLog(@"start3 - ndict - %@", [ndict description]);
            NSString *seqstr = [ndict objectForKey:@"seq"];
            // NSLog(@"start4 - seqstr - %@", seqstr);
            if ([seqstr isEqualToString:@"1"]) {
				height = 70;			                
            } else {
            }
            // NSLog(@"start5 - height - %d", height);
			
            if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"seq"] isEqualToString:@"1"]) {
				height = 70;			
			}
			
			UIImageView * CellBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 450, height)//MAX(MessageSize.height + (2*20.0) ,70.0) + 10.0)
											];
			CellBackground.contentMode = UIViewContentModeScaleToFill;
			CellBackground.image = [UIImage imageNamed:@"main.png"];
			[cell addSubview:CellBackground];
			[CellBackground release];
            // NSLog(@"start6 - ary - %@", [ary description]);
			if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"sender"] isEqualToString:
				 [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] 
				   componentsSeparatedByString:@"@"] objectAtIndex:0]]) 
            {
					UIImageView * ContactImageBackground = [[UIImageView alloc] initWithFrame:CGRectMake((450-46)-10, 10, 46, 46)];
					ContactImageBackground.contentMode = UIViewContentModeScaleToFill;
					ContactImageBackground.image = [UIImage imageNamed:@"image border 48 x 48.png"];
					[cell addSubview:ContactImageBackground];
					[ContactImageBackground release];
					
					UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake((450-46)-5,15,36,36)];
					userImage.contentMode = UIViewContentModeScaleToFill;
                
                userImage.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getSelfImage];
					[cell addSubview:userImage];
					[userImage release];
                    // NSLog(@"%@", [ary description]);
					strLastUserName = [[ary objectAtIndex:indexPath.row] objectForKey:@"sender"];
                    // NSLog(@"%@", [ndict description]);
                    strLastUserName = [ndict objectForKey:@"sender"];
				
				UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(10,10,450-46-10,20)];
				lblName.backgroundColor = [UIColor clearColor];
				lblName.text = ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName;
				lblName.textAlignment = UITextAlignmentLeft;
				lblName.textColor = [UIColor whiteColor];			
				lblName.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				[cell addSubview:lblName];
				[lblName release];
				
				UILabel *lblMessageDescription = [[UILabel alloc] initWithFrame:CGRectMake(46+10,10+20,450-46-10,20)];
				lblMessageDescription.numberOfLines = 0;
				lblMessageDescription.textColor =[UIColor whiteColor];
				lblMessageDescription.textAlignment = UITextAlignmentLeft;
				lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
											   ] valueForKey:@"body"];
				lblMessageDescription.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				lblMessageDescription.backgroundColor=[UIColor clearColor];
				[cell addSubview:lblMessageDescription];
				
				UIActivityIndicatorView *activityInd = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(5, 30, 30, 30)];
				[activityInd startAnimating];
				
                // NSLog(@"%@", [ary description]);
				if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"seq"] isEqualToString:@"0"]) {
					if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"Action"] isEqualToString:@""] || [[ary objectAtIndex:indexPath.row] objectForKey:@"Action"] == nil || [[[ary objectAtIndex:indexPath.row] objectForKey:@"Action"] isEqualToString:@"Accept"]) {
						[cell addSubview:activityInd];
					}				
				}
				else if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"seq"] isEqualToString:@"1"]) {
					if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] isEqualToString:@"Accept"]){
						lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
													   ] valueForKey:@"body"];
						[lblMessageDescription setFrame:CGRectMake(10,10+20,450-46-70,30)];
						
					}
					else if([[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] isEqualToString:@"Failed"]){
						lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
													   ] valueForKey:@"body"];
						[lblMessageDescription setFrame:CGRectMake(10,10+20,450-46-70,30)];
					}
				}
				
				[lblMessageDescription release];
				[activityInd release];
				
			}
			else {
                // NSLog(@"start7 - ary - %@", [ary description]);
                // Throws error when disconnected
                
                @try {
                    ChatUser = (XMPPUserCoreDataStorage*)[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) fetchedUserwithJid:
													   [NSString stringWithFormat:@"%@@%@", [[ary objectAtIndex:indexPath.row] objectForKey:@"sender"], SERVERNAME]]objectAtIndex:0];
                    // NSLog(@"%@", [ChatUser description]);
                }
                @catch (NSException *exc) {
                    NSLog(@"Exception tblChatConversationDataSource : %@", [exc description]);
                }
                UIImageView * ContactImageBackground = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 46, 46)];
                ContactImageBackground.contentMode = UIViewContentModeScaleToFill;
                ContactImageBackground.image = [UIImage imageNamed:@"image border 48 x 48.png"];
                [cell addSubview:ContactImageBackground];
                [ContactImageBackground release];
					
                UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(15,15,36,36)];
                userImage.contentMode = UIViewContentModeScaleToFill;
             
                if (ChatUser != nil) {
                    userImage.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getUserImage:ChatUser.jidStr];
                }

                [cell addSubview:userImage];
                [userImage release];
                // NSLog(@"start8 - ary - %@", [ary description]);
                strLastUserName = [[ary objectAtIndex:indexPath.row] objectForKey:@"sender"];
                // NSLog(@"start8 - strLastName - %@", strLastUserName);
                // NSLog(@"start9 - ndict - %@", [ndict description]);
                strLastUserName = [ndict objectForKey:@"sender"];
                //NSLog(@"start9 - strLastName - %@", strLastUserName);
				
				UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(46+10,10,450-46-10,20)];				
				lblName.backgroundColor = [UIColor clearColor];
				lblName.text = ChatUser.displayName;
				lblName.textAlignment = UITextAlignmentLeft;
				lblName.textColor = [UIColor whiteColor];			
				lblName.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				[cell addSubview:lblName];
				[lblName release];

				UILabel *lblMessageDescription = [[UILabel alloc] initWithFrame:CGRectMake(46+10,10+20,450-46-10,30)];
				lblMessageDescription.numberOfLines = 0;
				lblMessageDescription.textColor =[UIColor whiteColor];
				lblMessageDescription.textAlignment = UITextAlignmentLeft;
				lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
											   ] valueForKey:@"body"];
				lblMessageDescription.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				lblMessageDescription.backgroundColor=[UIColor clearColor];
				[cell addSubview:lblMessageDescription];
				[lblMessageDescription release];
				
				UIActivityIndicatorView *activityInd = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(56+450-46-45, 30, 30, 30)];
				[activityInd startAnimating];

				
				if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"seq"] isEqualToString:@"0"]) {
					if ([[ary objectAtIndex:indexPath.row] objectForKey:@"Action"] == nil || 
						[[[ary objectAtIndex:indexPath.row] objectForKey:@"Action"] isEqualToString:@""]) {
						
						UIButton *btnAccept = [UIButton buttonWithType:UIButtonTypeCustom];
						[btnAccept setTitle:@"Accept" forState:UIControlStateNormal];
						[btnAccept setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
						[btnAccept setBackgroundImage:[UIImage imageNamed:@"bg 3.png"] forState:UIControlStateNormal];
						[btnAccept addTarget:self action:@selector(btnGroupFileAcceptTapped:) forControlEvents:UIControlEventTouchUpInside];
						[btnAccept setTag:indexPath.row];
						[btnAccept setFrame:CGRectMake(cell.center.x - 100, 70, 70, 30)];
						[cell addSubview:btnAccept];
						
						UIButton *btnReject = [UIButton buttonWithType:UIButtonTypeCustom];
						[btnReject setTitle:@"Reject" forState:UIControlStateNormal];
						[btnReject setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
						[btnReject setBackgroundImage:[UIImage imageNamed:@"bg 3.png"] forState:UIControlStateNormal];
						[btnReject addTarget:self action:@selector(btnGroupFileRejectTapped:) forControlEvents:UIControlEventTouchUpInside];
						[btnReject setTag:indexPath.row];
						[btnReject setFrame:CGRectMake(cell.center.x + 30, 70, 70, 30)];
						[cell addSubview:btnReject];
                    }
					else if([[[ary objectAtIndex:indexPath.row] objectForKey:@"Action"] isEqualToString:@"Reject"]) {
						if (([lblMessageDescription.text rangeOfString:@"Sending"]).location != NSNotFound) {
							[cell addSubview:activityInd];
						}
						else {
							
						}
					}
				}
				else if  ([[[ary objectAtIndex:indexPath.row] objectForKey:@"seq"] isEqualToString:@"1"]) 
                {
					if([[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] isEqualToString:@"Failed"]){
						lblMessageDescription.text = [[ary objectAtIndex:indexPath.row] valueForKey:@"body"];
						[lblMessageDescription setFrame:CGRectMake(10,10+20,450-46-70,30)];
					}
					else {
                        NSString *fileName = [[ary objectAtIndex:indexPath.row] valueForKey:@"UniqueId"];
                        // NSLog(@"File Transfer Seq - 1 - filename - %@", fileName);
                        NSString *fullpath = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
                        // NSLog(@"File Transfer Full Path - %@", fullpath);
                        bool exists = NO;
                        // NSData *imageData = nil;
                        if ([[NSFileManager defaultManager] fileExistsAtPath:fullpath]) 
                        {
                            exists = YES;
                            /*
                            imageData = [NSData dataWithContentsOfFile:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:                                                                        
																	[NSString stringWithFormat:@"%@", fileName]]];
                            int lcount = 0;
                            // Wait for the file to become available if not there
                            while ([imageData length] == 0 && lcount < 5) {
                                [NSThread sleepForTimeInterval:1];
                                imageData = [NSData dataWithContentsOfFile:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:                                                                        
                                                                            [NSString stringWithFormat:@"%@", fileName]]];              
                                lcount++;
                            }
                             */
                        }
                        else {
                            BOOL isAvailable = NO;
                            for (int i = 0; i < [((MobileJabberAppDelegate*)[[UIApplication sharedApplication]delegate]).aryFileRequestArray count]; i++) {
                                if ([[[ary objectAtIndex:indexPath.row
								   ] valueForKey:@"fileUrl"] isEqualToString:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication]delegate]).aryFileRequestArray objectAtIndex:i]]) {
                                    isAvailable = YES;
                                }
                            }
                            if (!isAvailable) {
                                [((MobileJabberAppDelegate*)[[UIApplication sharedApplication]delegate]).aryFileRequestArray addObject:[[ary objectAtIndex:indexPath.row] valueForKey:@"fileUrl"]];							
                                // NSLog(@"start12 - ary - %@", [ary description]);
                                CustomURLConnection *connection = [[CustomURLConnection alloc] initWithUrl:[[ary objectAtIndex:indexPath.row] valueForKey:@"fileUrl"]
										FileName:[NSString stringWithFormat:@"%@", fileName]
										NotificationName:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS];
                            }
                        }
                        if (exists) {
                            // NSLog (@"%@", fullpath);
                            UIImage *timg = [[UIImage alloc] initWithContentsOfFile:fullpath];
                            // UIImage *timg = [UIImage imageWithData:imageData];
                            UIImageView *objImage = [[UIImageView alloc] initWithFrame:CGRectMake(450-46-60, 10, 60, 60)];
                            [objImage setImage:timg];
                            [cell addSubview:objImage];
                            [objImage release];
                            [timg release];          
                            [activityInd removeFromSuperview];
                            // [activityInd release];
                            UIButton *btnShowImage = [UIButton buttonWithType:UIButtonTypeCustom];
                            [btnShowImage setTag:indexPath.row];
                            [btnShowImage setFrame:objImage.frame];
                            [btnShowImage addTarget:self action:@selector(btnShowImageTapped:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btnShowImage];
                            lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
													   ] valueForKey:@"body"];
                            cell.tag = 2;
                        }
                        else {
                            [cell addSubview:activityInd];
                            lblMessageDescription.text = @"File transfer started";
						}
					}
				}
            }
		}
#pragma mark -
#pragma mark FileSendingUI

		else {
			NSInteger height;
			if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"seq"] isEqualToString:@"0"]) {
				if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] isEqualToString:@"Accept"]) {
					height = 70;
				}
				else if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] isEqualToString:@"Reject"]) {
					height = 70;
				}
				else if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] isEqualToString:@"Failed"]) {
					height = 70;
				}
				else {
					height = 110;
				}
			}
			if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"seq"] isEqualToString:@"1"]) {
				height = 70;
			}
				
			UIImageView * CellBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 450, height)];
			CellBackground.contentMode = UIViewContentModeScaleToFill;
			CellBackground.image = [UIImage imageNamed:@"main.png"];
			[cell addSubview:CellBackground];
			[CellBackground release];
			
			if([[[[ary objectAtIndex:indexPath.row] valueForKey:@"from"] description] isEqualToString:
				[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] ]) 
            {
					UIImageView * ContactImageBackground = [[UIImageView alloc] initWithFrame:CGRectMake((450-46)-10, 10, 46, 46)];
					ContactImageBackground.contentMode = UIViewContentModeScaleToFill;
					ContactImageBackground.image = [UIImage imageNamed:@"image border 48 x 48.png"];
					[cell addSubview:ContactImageBackground];
					[ContactImageBackground release];
						
					UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake((450-46)-5,15,36,36)];
					userImage.contentMode = UIViewContentModeScaleToFill;
                
                userImage.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getSelfImage];
					[cell addSubview:userImage];
					[userImage release];
					
				isSelfMessage = YES;

				UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(10,10,450-46-10,20)];
				lblName.backgroundColor = [UIColor clearColor];
				lblName.text = ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName;
				lblName.textAlignment = UITextAlignmentLeft;
				lblName.textColor = [UIColor whiteColor];			
				lblName.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				[cell addSubview:lblName];
				[lblName release];
				
                UILabel *lblMessageDescription = [[UILabel alloc] initWithFrame:CGRectMake(40,10+20,450-46-40,30)];
				lblMessageDescription.numberOfLines = 0;
				lblMessageDescription.textColor =[UIColor whiteColor];
				lblMessageDescription.textAlignment = UITextAlignmentLeft;
				
				lblMessageDescription.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				lblMessageDescription.backgroundColor=[UIColor clearColor];
		
				UIActivityIndicatorView *activityInd = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(5, 30, 30, 30)];
				[activityInd startAnimating];
				
				
				if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"seq"] isEqualToString:@"0"]) {
					if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] isEqualToString:@""] || [[ary objectAtIndex:indexPath.row] objectForKey:@"action"] == nil) {
						lblMessageDescription.text = [@"sending file to " stringByAppendingString:[[[[[ary objectAtIndex:indexPath.row
																									   ] valueForKey:@"to"] description] 
																									componentsSeparatedByString:@"@"] objectAtIndex:0]]; 
						[cell addSubview:activityInd];
					}
					else if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] isEqualToString:@"Accept"]){
						lblMessageDescription.text = @"File transfer started";
						[cell addSubview:activityInd];
					}
					else if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] isEqualToString:@"Reject"]){
						lblMessageDescription.text = @"File rejected";
					}
					else {
						lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
													   ] valueForKey:@"body"];
					}

				}
				else if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"seq"] isEqualToString:@"1"]) {
					 if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] isEqualToString:@"Accept"]){
						 lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
														] valueForKey:@"body"];
						 [lblMessageDescription setFrame:CGRectMake(10,10+20,450-46-70,30)];
                         cell.tag = 0;
												 
					}
				}

				[activityInd release];
				[cell addSubview:lblMessageDescription];
				[lblMessageDescription release];
				
			}
			else {			
				
				// if (isSelfMessage && !isFirstMessage) {
					UIImageView * ContactImageBackground = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 46, 46)];
					ContactImageBackground.contentMode = UIViewContentModeScaleToFill;
					ContactImageBackground.image = [UIImage imageNamed:@"image border 48 x 48.png"];
					[cell addSubview:ContactImageBackground];
					[ContactImageBackground release];
					UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(15,15,36,36)];
					userImage.contentMode = UIViewContentModeScaleToFill;	
                
                userImage.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getUserImage:ChatUser.jidStr];

					[cell addSubview:userImage];
					[userImage release];
				isSelfMessage = NO;
							
				UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(46+10,10,450-46-10,20)];
				lblName.backgroundColor = [UIColor clearColor];
				lblName.text = ChatUser.displayName;
				
				lblName.textColor = [UIColor whiteColor];
				lblName.textAlignment = UITextAlignmentLeft;
				lblName.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				[cell addSubview:lblName];
				[lblName release];
				
				UILabel *lblMessageDescription = [[UILabel alloc] initWithFrame:CGRectMake(46+10,10+20,450-46-50,20)];
				lblMessageDescription.numberOfLines = 0;
				lblMessageDescription.textColor =[UIColor whiteColor];
				lblMessageDescription.textAlignment = UITextAlignmentLeft;
				
				lblMessageDescription.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];
				lblMessageDescription.backgroundColor=[UIColor clearColor];
				
				UIActivityIndicatorView *activityInd = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(56+450-46-45, 30, 30, 30)];
				[activityInd startAnimating];
				
				
				if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"seq"] isEqualToString:@"0"]) {
					if ([[ary objectAtIndex:indexPath.row] objectForKey:@"action"] == nil || 
						[[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] isEqualToString:@""]) {
						lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
													   ] valueForKey:@"body"];
						
						UIButton *btnAccept = [UIButton buttonWithType:UIButtonTypeCustom];
						[btnAccept setTitle:@"Accept" forState:UIControlStateNormal];
						[btnAccept setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
						[btnAccept setBackgroundImage:[UIImage imageNamed:@"bg 3.png"] forState:UIControlStateNormal];
						[btnAccept addTarget:self action:@selector(btnFileAcceptTapped:) forControlEvents:UIControlEventTouchUpInside];
						[btnAccept setTag:indexPath.row];
						[btnAccept setFrame:CGRectMake(cell.center.x - 100, 70, 70, 30)];
						[cell addSubview:btnAccept];
						
						UIButton *btnReject = [UIButton buttonWithType:UIButtonTypeCustom];
						[btnReject setTitle:@"Reject" forState:UIControlStateNormal];
						[btnReject setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
						[btnReject setBackgroundImage:[UIImage imageNamed:@"bg 3.png"] forState:UIControlStateNormal];
						[btnReject addTarget:self action:@selector(btnFileRejectTapped:) forControlEvents:UIControlEventTouchUpInside];
						[btnReject setTag:indexPath.row];
						[btnReject setFrame:CGRectMake(cell.center.x + 30, 70, 70, 30)];
						[cell addSubview:btnReject];		
					}
					else if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] isEqualToString:@"Accept"]){
						lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
													   ] valueForKey:@"body"];
						[cell addSubview:activityInd];
					}
					else if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] isEqualToString:@"Reject"]){
						lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
													   ] valueForKey:@"body"];	
                        cell.tag = 0; // No more updates
					}
					else {
						lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
													   ] valueForKey:@"body"];
					}
					
				}
				else if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"seq"] isEqualToString:@"1"]) {
					if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] isEqualToString:@"Accept"]){
						if (![[[ary objectAtIndex:indexPath.row
							  ] valueForKey:@"body"] isEqualToString:@"File transfer Completed"]) {
							lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
														   ] valueForKey:@"body"];	
							
						}
						else {
							lblMessageDescription.text = @"File Transfer Started";
							[cell addSubview:activityInd];
						}
                        
                        NSString *fileName = [[ary objectAtIndex:indexPath.row] valueForKey:@"UniqueId"];
                        NSString *filePath = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:fileName];
                        // NSString *fileName = [[ary objectAtIndex:indexPath.row] valueForKey:@"UniqueId"];
                        
						// NSData *imageData = nil;                        
                        bool exists = NO;
                        // NSLog(@"%@", filePath);
                        
                        /*
						if ([[NSFileManager defaultManager] fileExistsAtPath:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]]]) {
							imageData = [NSData dataWithContentsOfFile:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:
																		[NSString stringWithFormat:@"%@", fileName]]];
						}
                         */
						if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                            exists = YES;
							// imageData = [NSData dataWithContentsOfFile:filename];
						}
						else {
							BOOL isAvailable = NO;
                            
                            // Was commented out
							for (int i = 0; i < [((MobileJabberAppDelegate*)[[UIApplication sharedApplication]delegate]).aryFileRequestArray count]; i++) {
								if ([[[ary objectAtIndex:indexPath.row
									   ] valueForKey:@"fileUrl"] isEqualToString:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication]delegate]).aryFileRequestArray objectAtIndex:i]]) {
									isAvailable = YES;
								}
							}
                            // cut here
                            
							if (!isAvailable) {
								[((MobileJabberAppDelegate*)[[UIApplication sharedApplication]delegate]).aryFileRequestArray addObject:[[ary objectAtIndex:indexPath.row] valueForKey:@"fileUrl"]];
								
								CustomURLConnection *connection = [[CustomURLConnection alloc] initWithUrl:[[ary objectAtIndex:indexPath.row] valueForKey:@"fileUrl"]
                                    FileName:[NSString stringWithFormat:@"%@", fileName]
									NotificationName:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS];
							}
						}
						// if (imageData != nil) {
                        if (exists) {
							UIImageView *objImage = [[UIImageView alloc] initWithFrame:CGRectMake(450-46-60, 10, 60, 60)];
                            // NSLog (@"%@", filePath);
                            UIImage *timg = [[UIImage alloc] initWithContentsOfFile:filePath];
                            [objImage setImage:timg];
							// [objImage setImage:[UIImage imageWithData:imageData]];
							[cell addSubview:objImage];
                            [objImage release];
                            [timg release];
							[activityInd removeFromSuperview];
							UIButton *btnShowImage = [UIButton buttonWithType:UIButtonTypeCustom];
							[btnShowImage setTag:indexPath.row];
							[btnShowImage setFrame:objImage.frame];
							[btnShowImage addTarget:self action:@selector(btnShowImageTapped:) forControlEvents:UIControlEventTouchUpInside];
							[cell addSubview:btnShowImage];
							
							lblMessageDescription.text = [[ary objectAtIndex:indexPath.row
														   ] valueForKey:@"body"];
                            cell.tag = 2;
						}
					}
				}

				[activityInd release];
				[cell addSubview:lblMessageDescription];
				[lblMessageDescription release];
			}
		}		
	}
	isFirstMessage = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
		if([((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages containsObject:[ary objectAtIndex:indexPath.row]
			]){
			[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages removeObject:[ary objectAtIndex:indexPath.row]
			 ];
		}
		[ary removeObjectAtIndex:indexPath.row];
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserConversation removeObjectAtIndex:indexPath.row
		 ];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade
		 ];
    }
}


-(void)dealloc{
	[super dealloc];
}

- (void)btnGroupFileAcceptTapped:(UIButton*)sender {
	NSDictionary *dict = [ary objectAtIndex:[sender tag]];
	
	NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
	[message addAttributeWithName:@"type" stringValue:@"groupchat"];
	[message addAttributeWithName:@"to" stringValue:[[[[dict valueForKey:@"from"] description] componentsSeparatedByString:@"/"] objectAtIndex:0]];
	[message addAttributeWithName:@"from" stringValue:[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID]
														 description] componentsSeparatedByString:@"@"] objectAtIndex:0]];
	
	NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
	NSXMLElement *type = [NSXMLElement elementWithName:@"type" stringValue:GROUP_FILE_SENDING_TEXT];
	NSXMLElement *sequece = [NSXMLElement elementWithName:@"seq"];
	NSXMLElement *fileSentDate = [NSXMLElement elementWithName:@"Date"];
	NSXMLElement *fileId = [NSXMLElement elementWithName:@"UniqueId"];
	NSXMLElement *action = [NSXMLElement elementWithName:@"action"];
	[sequece setStringValue:[dict objectForKey:@"seq"]];
	
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
	[body addChild:type];
	[message addChild:fileSentDate];
	[message addChild:body];
	
	//Send Message
	int indx = 0;
	for (NSDictionary *dictFile in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileRecvList) {
		if ([[dictFile objectForKey:@"fileId"] isEqualToString:[dict objectForKey:@"UniqueId"]]) {
			NSMutableDictionary *dictTemp = [NSMutableDictionary dictionaryWithDictionary:dictFile];
			[dictTemp setObject:@"Accept" forKey:@"RecvStatus"];
			[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileRecvList replaceObjectAtIndex:indx withObject:dictTemp]; 
			break;
		}
		indx++;
	}
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:message];
	
	
}

- (void)btnGroupFileRejectTapped:(UIButton*)sender {
	NSDictionary *dict = [ary objectAtIndex:[sender tag]];
	
	NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
	[message addAttributeWithName:@"type" stringValue:@"groupchat"];
	[message addAttributeWithName:@"to" stringValue:[[[[dict valueForKey:@"from"] description] componentsSeparatedByString:@"/"] objectAtIndex:0]];
	[message addAttributeWithName:@"from" stringValue:[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID]
														 description] componentsSeparatedByString:@"@"] objectAtIndex:0]];
	
	NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
	NSXMLElement *type = [NSXMLElement elementWithName:@"type" stringValue:GROUP_FILE_SENDING_TEXT];
	NSXMLElement *sequece = [NSXMLElement elementWithName:@"seq"];
	NSXMLElement *fileSentDate = [NSXMLElement elementWithName:@"Date"];
	NSXMLElement *fileId = [NSXMLElement elementWithName:@"UniqueId"];
	NSXMLElement *action = [NSXMLElement elementWithName:@"action"];
	[sequece setStringValue:[dict objectForKey:@"seq"]];
	
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateFormat:@"dd-MMM-yyyy hh:mm"];
	NSString* localDateString = [formatter stringFromDate:[NSDate date]];
	[formatter release];
	[fileSentDate setStringValue:localDateString];
	
	[fileId setStringValue:[dict objectForKey:@"UniqueId"]];
	
	[action setStringValue:@"Reject"];
	[body addChild:sequece];			
	[body addChild:fileId];
	[body addChild:action];
	[body addChild:type];
	[message addChild:fileSentDate];
	[message addChild:body];
	
	//Send Message
	int indx = 0;
	for (NSDictionary *dictFile in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileRecvList) {
		if ([[dictFile objectForKey:@"fileId"] isEqualToString:[dict objectForKey:@"seq"]]) {
			NSMutableDictionary *dictTemp = [NSDictionary dictionaryWithDictionary:dictFile];
			[dictTemp setObject:@"Reject" forKey:@"RecvStatus"];
			[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryGroupFileRecvList replaceObjectAtIndex:indx withObject:dictTemp]; 
			break;
		}
		indx++;
	}
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:message];
	
	
}

- (void)btnFileAcceptTapped:(UIButton*)sender {
	NSDictionary *dict = [ary objectAtIndex:sender.tag];
	
	NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
	[message addAttributeWithName:@"type" stringValue:FILE_SENDING_TEXT];
	[message addAttributeWithName:@"to" stringValue:[[dict valueForKey:@"from"] description]];
	[message addAttributeWithName:@"from" stringValue:[[dict valueForKey:@"to"] description]];
	
	NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
	NSXMLElement *sequece = [NSXMLElement elementWithName:@"seq"];
	NSXMLElement *fileSentDate = [NSXMLElement elementWithName:@"Date"];
	NSXMLElement *fileId = [NSXMLElement elementWithName:@"UniqueId"];
	NSXMLElement *action = [NSXMLElement elementWithName:@"action"];
	[sequece setStringValue:[dict objectForKey:@"seq"]];
	
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
	[message addChild:fileSentDate];
	[message addChild:body];
	
	//Send Message
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:message];
	
	NSMutableDictionary * dictSendMessage = [[NSMutableDictionary alloc] init];
	[dictSendMessage setValue:[message attributeStringValueForName:@"to"] forKey:@"to"];
	[dictSendMessage setValue:[message attributeStringValueForName:@"from"] forKey:@"from"];	
	[dictSendMessage setObject:@"File transfer started" forKey:@"body"];
	[dictSendMessage setValue:localDateString forKey:@"Date"];
	[dictSendMessage setValue:FILE_SENDING_TEXT forKey:@"type"];
	[dictSendMessage setValue:[[[message elementForName:@"body"] elementForName:@"UniqueId"] stringValue] forKey:@"UniqueId"];
	[dictSendMessage setValue:[[[message elementForName:@"body"] elementForName:@"seq"] stringValue] forKey:@"seq"];
	[dictSendMessage setValue:[[[message elementForName:@"body"] elementForName:@"action"] stringValue] forKey:@"action"];
	NSInteger ind = 0;
	BOOL isReplace = NO;
	for (NSMutableDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages) {
		if ([[dict objectForKey:@"UniqueId"] isEqualToString:[dictSendMessage objectForKey:@"UniqueId"]]) {
			
			[dict setObject:[dictSendMessage valueForKey:@"seq"] forKey:@"seq"];
			[dict setObject:[dictSendMessage valueForKey:@"action"] forKey:@"action"];
			[dict setObject:[dictSendMessage valueForKey:@"body"] forKey:@"body"];
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
	
}

- (void)btnFileRejectTapped:(UIButton*)sender {
	NSDictionary *dict = [ary objectAtIndex:[sender tag]];
	
	NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
	[message addAttributeWithName:@"type" stringValue:FILE_SENDING_TEXT];
	[message addAttributeWithName:@"to" stringValue:[[dict valueForKey:@"from"] description]];
	[message addAttributeWithName:@"from" stringValue:[[dict valueForKey:@"to"] description]];
	
	NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
	NSXMLElement *sequece = [NSXMLElement elementWithName:@"seq"];
	NSXMLElement *fileSentDate = [NSXMLElement elementWithName:@"Date"];
	NSXMLElement *fileId = [NSXMLElement elementWithName:@"UniqueId"];
	NSXMLElement *action = [NSXMLElement elementWithName:@"action"];
	[sequece setStringValue:[dict objectForKey:@"seq"]];
	
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateFormat:@"dd-MMM-yyyy hh:mm"];
	NSString* localDateString = [formatter stringFromDate:[NSDate date]];
	[formatter release];
	[fileSentDate setStringValue:localDateString];
	
	[fileId setStringValue:[dict objectForKey:@"UniqueId"]];
	
	[action setStringValue:@"Reject"];
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
	NSInteger ind = 0;
	BOOL isReplace = NO;
	for (NSMutableDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages) {
		if ([[dict objectForKey:@"UniqueId"] isEqualToString:[dictSendMessage objectForKey:@"UniqueId"]]) {
			
			[dict setObject:[dictSendMessage valueForKey:@"seq"] forKey:@"seq"];
			[dict setObject:[dictSendMessage valueForKey:@"action"] forKey:@"action"];
			[dict setObject:[dictSendMessage valueForKey:@"body"] forKey:@"body"];
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
	
}

- (void)btnShowImageTapped:(UIButton*)sender {
	NSDictionary *dict = [ary objectAtIndex:sender.tag];
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SHOW_TRANSFERED_IMAGE object:[dict objectForKey:@"UniqueId"]];
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
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	//NSLog(@"%@",[connection description]);
	//NSString *fileName = [[[[[NSString stringWithContentsOfURL:connection.request.url] componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."] objectAtIndex:0];
//	[responseData writeToFile:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:
//							   [NSString stringWithFormat:@"%@.png", fileName]] atomically:YES];
//	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS object:nil];	
//	
	
}



@end
