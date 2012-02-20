//
//  TblActiveChatListDataSource.m
//  MobileJabber
//
//  Created by Shivang Vyas on 7/2/11.
//  Copyright 2011 company. All rights reserved.
//

#import "TblActiveChatListDataSource.h"


@implementation TblActiveChatListDataSource
@synthesize isCollapsed;

-(id) initWithArray:(NSMutableArray*)aryActiveChatUsers{
	if (self=[super init]) 
    {
		ary = [[NSMutableArray alloc]initWithArray:aryActiveChatUsers];			
	}
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.isCollapsed) 
    {
        return 0;
    }
    return [ary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = [NSString stringWithFormat:@"(%i)(%i)",indexPath.section,indexPath.row];
	TblActiveChatListCell * cell = (TblActiveChatListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = nil;
    if (cell == nil) {
        cell = [[[TblActiveChatListCell alloc] initWithFrame:CGRectMake(0,0,310,100) reuseIdentifier:CellIdentifier] 
				autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor clearColor];
		
		if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"chat"]) {
			cell.lblContactName.text=((XMPPUserCoreDataStorage*)[[ary objectAtIndex:indexPath.row] objectForKey:@"user"]).displayName;
			if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).chatActUser == ((XMPPUserCoreDataStorage*)[[ary objectAtIndex:indexPath.row] objectForKey:@"user"])) {
				NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:indexPath.row] objectForKey:@"user"], @"user",
										  @"0", @"chatBadge", [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:indexPath.row] objectForKey:@"type"], @"type", nil];
				
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers replaceObjectAtIndex:indexPath.row withObject:tempDict];
			}
			else if ([[[ary objectAtIndex:indexPath.row ] objectForKey:@"chatBadge"] intValue] > 0) {
				CustomBadge *cstBadge = [CustomBadge customBadgeWithString:[[ary objectAtIndex:indexPath.row ] objectForKey:@"chatBadge"]];
				[cstBadge setFrame:CGRectMake(cell.lblContactName.frame.origin.x + cell.lblContactName.frame.size.width, cell.frame.origin.y, 20, 20)];
				[cell addSubview:cstBadge];
			}
			
			XMPPUserCoreDataStorage *user = (XMPPUserCoreDataStorage*)[[ary objectAtIndex:indexPath.row
																		] objectForKey:@"user"];
            cell.imvContact.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getUserImage:user.jidStr];	
			NSString *strJid = [[user.jidStr componentsSeparatedByString:@"/"]
								objectAtIndex:0];
			for(int i=0;i<[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages count];i++)
			{
				if(
				   ([[[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages objectAtIndex:i] valueForKey:@"from"] description]
					   componentsSeparatedByString:@"/"] objectAtIndex:0]
					 isEqualToString:strJid]) ||
				   ([[[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages objectAtIndex:i] valueForKey:@"to"] description]
					   componentsSeparatedByString:@"/"] objectAtIndex:0]
					 isEqualToString:strJid])
				   )
				{
					// Date = "14-Sep-2011 05:03";
					NSString *strLastMessageDate = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages objectAtIndex:i] objectForKey:@"Date"];
					//NSLog(@"%@",[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages objectAtIndex:i] description]);					
                    /*
					NSArray *aryDate = [strLastMessageDate componentsSeparatedByString:@" "];
					NSDateFormatter *dtFormatter = [[[NSDateFormatter alloc] init] autorelease];
					[dtFormatter setDateFormat:@"dd-MMM-yyyy HH:mm"];
					NSDate *dtLastDate = [dtFormatter dateFromString:[aryDate objectAtIndex:0]];
                     */
					// NSArray *aryDate = [strLastMessageDate componentsSeparatedByString:@" "];
					NSDateFormatter *dtFormatter = [[[NSDateFormatter alloc] init] autorelease];
					[dtFormatter setDateFormat:@"dd-MMM-yyyy HH:mm"];
					NSDate *dtLastDate = [dtFormatter dateFromString:strLastMessageDate];
					// NSArray *aryDate = [dtLastDate componentsSeparatedByString:@" "];
					
					NSDateFormatter *dtDateToStr = [[[NSDateFormatter alloc] init] autorelease];
					[dtDateToStr setDateFormat:@"dd MMM HH:mm"];
					NSString *strMyDate = [dtDateToStr stringFromDate:dtLastDate];
					NSArray *aryFinalLastDate = [strMyDate componentsSeparatedByString:@" "];
					
					
					
					NSString *strDate = [NSString stringWithFormat:@"%@%@ %@",[aryFinalLastDate objectAtIndex:0], [self ordinalSuffixFromInt:[[aryFinalLastDate objectAtIndex:0] intValue]] , [aryFinalLastDate objectAtIndex:1]];
					//switch ([[aryFinalLastDate objectAtIndex:0] intValue]) {
//						case 1:
//							strDate = [NSString stringWithFormat:@"%@st %@", [aryFinalLastDate objectAtIndex:0], [aryFinalLastDate objectAtIndex:1]];
//							break;
//						case 2:
//							strDate = [NSString stringWithFormat:@"%@nd %@", [aryFinalLastDate objectAtIndex:0], [aryFinalLastDate objectAtIndex:1]];
//							break;
//						case 3:
//							strDate = [NSString stringWithFormat:@"%@rd %@", [aryFinalLastDate objectAtIndex:0], [aryFinalLastDate objectAtIndex:1]];
//							break;
//						default:
//							strDate = [NSString stringWithFormat:@"%@th %@", [aryFinalLastDate objectAtIndex:0], [aryFinalLastDate objectAtIndex:1]];
//							break;
//					}
					NSString *strLastMessageText = [NSString stringWithFormat:@"Last Message %@ at %@", strDate, [aryFinalLastDate objectAtIndex:2]];
					cell.lblLastMessageText.text = strLastMessageText;
				}
			}
		}
		
		else {
			if ([[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictChatActGroup objectForKey:@"groupName"] isEqualToString:[[[ary objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"groupName"]]) {
				NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:indexPath.row] objectForKey:@"user"], @"user",
										  @"0", @"chatBadge", [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:indexPath.row] objectForKey:@"type"], @"type", nil];
				
				[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers replaceObjectAtIndex:indexPath.row withObject:tempDict];
			}
			else if ([[[ary objectAtIndex:indexPath.row ] objectForKey:@"chatBadge"] intValue] > 0) {
				CustomBadge *cstBadge = [CustomBadge customBadgeWithString:[[ary objectAtIndex:indexPath.row ] objectForKey:@"chatBadge"]
										 ];
				
				[cstBadge setFrame:CGRectMake(cell.lblContactName.frame.origin.x + cell.lblContactName.frame.size.width, cell.frame.origin.y, 20, 20)];
				[cell addSubview:cstBadge];
				
				//			UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(cell.lblContactName.frame.origin.x + cell.lblContactName.frame.size.width, cell.frame.origin.y - 5, 20, 20)];
				//			[lbl setBackgroundColor:[UIColor redColor]];
				//			[lbl setTextColor:[UIColor whiteColor]];
				//			[lbl setText:[[ary objectAtIndex:indexPath.row ] objectForKey:@"chatBadge"]];
				//			[lbl setTag:101];
				//			[cell addSubview:lbl];
			}
			
			/*
			 XMPPUserCoreDataStorage *user = (XMPPUserCoreDataStorage*)[ary objectAtIndex:indexPath.row
			 ];
			 */
			NSArray *aryUsers = [[[ary objectAtIndex:indexPath.row
								   ] objectForKey:@"user"] objectForKey:@"GroupUsers"];
			CGFloat x = 15, y = 15;
			NSString *strDisplayName = [[[ary objectAtIndex:indexPath.row
										  ] objectForKey:@"user"] objectForKey:@"GroupName"];//@"";
            @try {
                UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 36, 36)];
                // Rakesh needs instructorimage
                UIImage * uimg = INSTRUCTOR_IMAGE;
                [imv setImage:uimg];
                // [[imv setImage:INSTRUCTOR_IMAGE] ];
                [cell addSubview:imv];
            } 
            @catch (NSException *exc) {
                
            }
            

            /*
			for (XMPPUserCoreDataStorage *user in aryUsers) {
				//strDisplayName = [NSString stringWithFormat:@"%@ %@,", strDisplayName, user.displayName];
				if ([aryUsers count] <= 5 || i >= [aryUsers count]-5) {
                    // Patch code - Rakesh
                    @try {
                        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 36, 36)];
                        [imv setImage:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getUserImage:user.jidStr]];
                        [cell addSubview:imv];
                        x += 1;
                        y += 1;

                        // Old commented out codes
                        // NSData *photoData = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) xmppvCardAvatarModule] photoDataForJID:user.jid];
					
                        // if (photoData != nil) {
                        //    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 36, 36)];
                        //    [imv setImage:[UIImage imageWithData:photoData]];
                        //    [cell addSubview:imv];
                        //    x += 1;
                        //    y += 1;
                        // }else {	
						//
                        // }
                         
                    }
                    @catch (NSException *error) {
                    }
				}
				i++;
				
			}		
             */
			cell.lblContactName.text = strDisplayName;
		}			
	}
	
    return cell;
	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
		[ary removeObjectAtIndex:indexPath.row];
		if ([[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:indexPath.row] objectForKey:@"user"] == ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).chatActUser ||
			 [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:indexPath.row] objectForKey:@"user"] == ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictChatActGroup) {
			((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).chatActUser = nil;
			((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictChatActGroup = nil;
		}
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers removeObjectAtIndex:indexPath.row
		 ];
		[[NSNotificationCenter defaultCenter]postNotificationName:NSNOTIFICATION_SHOW_CHAT_WINDOW object:nil];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade
		 ];
		//NSLog(@"ary: %@",ary);
		//NSLog(@"global array: %@",((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers);
		[tableView reloadData];
    }
}


- (NSString *)ordinalSuffixFromInt:(int)number {
    NSArray *cSfx = [NSArray arrayWithObjects:@"th", @"st", @"nd", @"rd", @"th", @"th", @"th", @"th", @"th", @"th", nil];
    NSString *suffix = @"th";
	
    number = abs(number % 100);
    if ((number < 10) || (number > 19)) {
        suffix = [cSfx objectAtIndex:number % 10];
    }
    return suffix;
}


-(void)dealloc{
	[super dealloc];
}



@end
