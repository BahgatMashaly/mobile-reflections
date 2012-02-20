//
//  TblContactListDataSource.m
//  MobileJabber
//
//  Created by Shivang Vyas on 6/27/11.
//  Copyright 2011 company. All rights reserved.
//

#import "TblContactListDataSource.h"
#import "TblContactListCell.h"

@implementation TblContactListDataSource
-(id) initWithArray:(NSMutableArray*)aryUser Table:(UITableView*)tblView{
	if (self=[super init]) {
		ary = [[NSMutableArray alloc]initWithArray:aryUser];
		tbl = [tblView retain]; 
		
		[self generateHeaderViews];		
	}
	return self;
}

-(void)generateHeaderViews{
	
	aryContactHeader = [[NSMutableArray alloc]init];
	for(int i=0;i<[ary count];i++)
	{
		hView = [GTHeaderView headerViewWithTitle:[[ary objectAtIndex:i] valueForKey:@"GroupName"] section:i Expanded:@"YES"];
		//[hView.btnShowHideAnimation addTarget:self action:@selector(toggleSectionForSection:) forControlEvents:UIControlEventTouchUpInside];
		[aryContactHeader addObject:hView];
	}
}

/*-(void)toggleSectionForSection:(id)sender
{
	GTHeaderView *tmp=[aryContactHeader objectAtIndex:[sender tag]];
	[self toggle:tmp.Rowstatus:[sender tag]];
}*/

/*- (NSArray*)indexPathsInSection:(NSInteger)section 
{
	NSMutableArray *paths = [NSMutableArray array];
	NSInteger row;	
	for ( row = 0; row < [[[ary objectAtIndex:section] valueForKey:@"GroupUsers"] count]; row++ ) {
		[paths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
	}
	return [NSArray arrayWithArray:paths];
}
*/

/*- (void)toggle:(NSString*)isExpanded:(NSInteger)section 
{
	GTHeaderView *tmp;
	tmp=[aryContactHeader objectAtIndex:section];
	if([tmp.Rowstatus isEqualToString:@"NO"])
		tmp.Rowstatus=@"YES";
	else
		tmp.Rowstatus=@"NO";
	NSArray *paths = [self indexPathsInSection:section];
	BOOL isExpand=[tmp.Rowstatus isEqualToString:@"YES"];
	if (!isExpand)
		[tbl deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
	else
		[tbl insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
}*/



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [ary count];
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int count;
	//NSLog(@"%@", [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactListExpandValue description]);
	if ([[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactListExpandValue objectAtIndex:section] isEqualToString:@"YES"]) {
		return 0;
	}
	count = [[[ary objectAtIndex:section] valueForKey:@"GroupUsers"] count];
	
	GTHeaderView *tmp=[aryContactHeader objectAtIndex:section];
	return [[tmp Rowstatus]isEqualToString:@"YES"]? count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	 NSString *CellIdentifier = [NSString stringWithFormat:@"(%i)(%i)",indexPath.section,indexPath.row];
	
	TblContactListCell * cell = (TblContactListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[TblContactListCell alloc] initWithFrame:CGRectMake(0,0,275,60) reuseIdentifier:CellIdentifier] 
				autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor orangeColor];
		
		XMPPUserCoreDataStorage *user = (XMPPUserCoreDataStorage*)[[[ary objectAtIndex:indexPath.section] valueForKey:@"GroupUsers"] objectAtIndex:indexPath.row];
        
        cell.role = [self FindUserRole:[[user.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0]];
        
      /*  if ([cell.role isEqualToString:@"Teacher"] || [cell.role isEqualToString:@"Instructor"]) {
			cell.imvContact.image = INSTRUCTOR_IMAGE;            
        } else {
			cell.imvContact.image = STUDENT_IMAGE;                        
        }*/
        
        if ([cell.role isEqualToString:@"Teacher"] || [cell.role isEqualToString:@"Instructor"]) {
            cell.imvContact.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getUserImage:user.jidStr];	
			// cell.imvContact.image = INSTRUCTOR_IMAGE;            
        } else {
            cell.imvContact.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getUserImage:user.jidStr];	
			// cell.imvContact.image = STUDENT_IMAGE;                        
        }
        
		cell.lblContactName.text = user.displayName;
		cell.lblContactMoodMessage.text = user.primaryResource.status;
		[cell.btnLogo addTarget:self action:@selector(btnLogoTapped:) forControlEvents:UIControlEventTouchUpInside];
		[cell.btnLogo setTag:indexPath.row];
		[cell.btnLogo setTitle:[NSString stringWithFormat:@"%d", indexPath.section] forState:UIControlStateNormal];
        
        cell.status = [user.sectionNum intValue];
		if([user.sectionNum intValue]== 0){
			// Indicating status color (Green Color) for online users
			cbgStatus = [CustomBadge customBadgeWithString:@""
                                           withStringColor:[UIColor whiteColor] 
                                            withInsetColor:[UIColor greenColor] 
                                            withBadgeFrame:YES 
                                       withBadgeFrameColor:[UIColor greenColor] 
                                                 withScale:1.5 
                                               withShining:YES];
            
			cbgStatus.frame = CGRectMake(8,8,10,10);
			[cell addSubview:cbgStatus];
			[cell.lblContactMoodMessage setText:@"Available"];
			[cell.lblContactMoodMessage setTextColor:[UIColor greenColor]];
		}
		else if([user.sectionNum intValue]== 1) {
			// Indicating status color (Orange Color) for away users			
			cbgStatus = [CustomBadge customBadgeWithString:@""
										   withStringColor:[UIColor whiteColor] 
											withInsetColor:[UIColor orangeColor] 
											withBadgeFrame:YES 
									   withBadgeFrameColor:[UIColor orangeColor] 
												 withScale:1.5 
											   withShining:YES];
			
			cbgStatus.frame = CGRectMake(8,8,10,10);
			[cell addSubview:cbgStatus];
			[cell.lblContactMoodMessage setText:@"Away"];
			[cell.lblContactMoodMessage setTextColor:[UIColor orangeColor]];
			
		}
		else if([user.sectionNum intValue] == 3){
			// Indicating status color (Gray Color) for offline users			
			cbgStatus = [CustomBadge customBadgeWithString:@""
										   withStringColor:[UIColor whiteColor] 
											withInsetColor:[UIColor lightGrayColor] 
											withBadgeFrame:YES 
									   withBadgeFrameColor:[UIColor lightGrayColor] 
												 withScale:1.5 
											   withShining:YES];
            
			
			cbgStatus.frame = CGRectMake(8,8,10,10);
			[cell addSubview:cbgStatus];
			[cell.lblContactMoodMessage setText:@"Offline"];
			[cell.lblContactMoodMessage setTextColor:[UIColor grayColor]];
		}
		else if([user.sectionNum intValue] == 2){
			// Indicating status color (Red Color) for offline users			
			
			cbgStatus = [CustomBadge customBadgeWithString:@""
                                           withStringColor:[UIColor whiteColor] 
                                            withInsetColor:[UIColor redColor] 
                                            withBadgeFrame:YES 
                                       withBadgeFrameColor:[UIColor redColor] 
                                                 withScale:1.5 
                                               withShining:YES];
			
			cbgStatus.frame = CGRectMake(8,8,10,10);
			[cell addSubview:cbgStatus];
			[cell.lblContactMoodMessage setText:@"Busy"];
			[cell.lblContactMoodMessage setTextColor:[UIColor redColor]];
			
		}
        
    }
    else {
        XMPPUserCoreDataStorage *user = (XMPPUserCoreDataStorage*)[[[ary objectAtIndex:indexPath.section] valueForKey:@"GroupUsers"] objectAtIndex:indexPath.row];
        
        if (![cell.role isEqualToString:[self FindUserRole:[[user.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0]]]) {
            cell.role = [self FindUserRole:[[user.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0]];
          
            /*if ([cell.role isEqualToString:@"Teacher"] || [cell.role isEqualToString:@"Instructor"]) {
                cell.imvContact.image = INSTRUCTOR_IMAGE;            
            } else {
                cell.imvContact.image = STUDENT_IMAGE;                        
            }*/
        
            
            if ([cell.role isEqualToString:@"Teacher"] || [cell.role isEqualToString:@"Instructor"]) {
                cell.imvContact.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getUserImage:user.jidStr];	
                // cell.imvContact.image = INSTRUCTOR_IMAGE;            
            } else {
                cell.imvContact.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getUserImage:user.jidStr];	
                // cell.imvContact.image = STUDENT_IMAGE;                        
            }
        }
        
		cell.lblContactName.text = user.displayName;
		// cell.lblContactMoodMessage.text = user.primaryResource.status;
        [cell.btnLogo removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents]; 
		[cell.btnLogo addTarget:self action:@selector(btnLogoTapped:) forControlEvents:UIControlEventTouchUpInside];
		[cell.btnLogo setTag:indexPath.row];
		[cell.btnLogo setTitle:[NSString stringWithFormat:@"%d", indexPath.section] forState:UIControlStateNormal];
        
        if ([user.sectionNum intValue] != cell.status) {
            for (UIView *subview in cell.subviews)
            {
                if([subview isKindOfClass:[CustomBadge class]])
                {
                    [subview removeFromSuperview];
                }
            }
            cell.status = [user.sectionNum intValue];
        
            if([user.sectionNum intValue]== 0){
                // Indicating status color (Green Color) for online users
                cbgStatus = [CustomBadge customBadgeWithString:@""
                                           withStringColor:[UIColor whiteColor] 
                                            withInsetColor:[UIColor greenColor] 
                                            withBadgeFrame:YES 
                                       withBadgeFrameColor:[UIColor greenColor] 
                                                 withScale:1.5 
                                               withShining:YES];
            
                cbgStatus.frame = CGRectMake(8,8,10,10);
                [cell addSubview:cbgStatus];
                [cell.lblContactMoodMessage setText:@"Available"];
                [cell.lblContactMoodMessage setTextColor:[UIColor greenColor]];
		}else if([user.sectionNum intValue]== 1) {
			// Indicating status color (Orange Color) for away users			
			cbgStatus = [CustomBadge customBadgeWithString:@""
										   withStringColor:[UIColor whiteColor] 
											withInsetColor:[UIColor orangeColor] 
											withBadgeFrame:YES 
									   withBadgeFrameColor:[UIColor orangeColor] 
												 withScale:1.5 
											   withShining:YES];
			
			cbgStatus.frame = CGRectMake(8,8,10,10);
			[cell addSubview:cbgStatus];
			[cell.lblContactMoodMessage setText:@"Away"];
			[cell.lblContactMoodMessage setTextColor:[UIColor orangeColor]];
			
		}else if([user.sectionNum intValue] == 3){
			// Indicating status color (Gray Color) for offline users			
			cbgStatus = [CustomBadge customBadgeWithString:@""
										   withStringColor:[UIColor whiteColor] 
											withInsetColor:[UIColor lightGrayColor] 
											withBadgeFrame:YES 
									   withBadgeFrameColor:[UIColor lightGrayColor] 
												 withScale:1.5 
											   withShining:YES];
            
			
			cbgStatus.frame = CGRectMake(8,8,10,10);
			[cell addSubview:cbgStatus];
			[cell.lblContactMoodMessage setText:@"Offline"];
			[cell.lblContactMoodMessage setTextColor:[UIColor grayColor]];
		}
		else if([user.sectionNum intValue] == 2){
			// Indicating status color (Red Color) for offline users			
			
			cbgStatus = [CustomBadge customBadgeWithString:@""
                                           withStringColor:[UIColor whiteColor] 
                                            withInsetColor:[UIColor redColor] 
                                            withBadgeFrame:YES 
                                       withBadgeFrameColor:[UIColor redColor] 
                                                 withScale:1.5 
                                               withShining:YES];
			
			cbgStatus.frame = CGRectMake(8,8,10,10);
			[cell addSubview:cbgStatus];
			[cell.lblContactMoodMessage setText:@"Busy"];
			[cell.lblContactMoodMessage setTextColor:[UIColor redColor]];
			
		}
        }
    }
    
    /*
	cell=nil; // temperary...!
    if (cell == nil) {
        cell = [[[TblContactListCell alloc] initWithFrame:CGRectMake(0,0,275,60) reuseIdentifier:CellIdentifier] 
				autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor orangeColor];
		
		XMPPUserCoreDataStorage *user = (XMPPUserCoreDataStorage*)[[[ary objectAtIndex:indexPath.section] valueForKey:@"GroupUsers"] objectAtIndex:indexPath.row
																   ];        
        NSString * role = [self FindUserRole:[[user.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0]];
        
        if ([role isEqualToString:@"Teacher"] || [role isEqualToString:@"Instructor"]) {
			cell.imvContact.image = INSTRUCTOR_IMAGE;            
        } else {
			cell.imvContact.image = STUDENT_IMAGE;                        
        }
        
		cell.lblContactName.text = user.displayName;		
		cell.lblContactMoodMessage.text = user.primaryResource.status;
		[cell.btnLogo addTarget:self action:@selector(btnLogoTapped:) forControlEvents:UIControlEventTouchUpInside];
		[cell.btnLogo setTag:indexPath.row];
		[cell.btnLogo setTitle:[NSString stringWithFormat:@"%d", indexPath.section] forState:UIControlStateNormal];
        
		if([user.sectionNum intValue]== 0){
			// Indicating status color (Green Color) for online users
			cbgStatus = [CustomBadge customBadgeWithString:@""
									   withStringColor:[UIColor whiteColor] 
										withInsetColor:[UIColor greenColor] 
										withBadgeFrame:YES 
								   withBadgeFrameColor:[UIColor greenColor] 
											 withScale:1.5 
										   withShining:YES];
		
			cbgStatus.frame = CGRectMake(8,8,10,10);
			[cell addSubview:cbgStatus];
			[cell.lblContactMoodMessage setText:@"Available"];
			[cell.lblContactMoodMessage setTextColor:[UIColor greenColor]];
		}else if([user.sectionNum intValue]== 1) {
			// Indicating status color (Orange Color) for away users			
			cbgStatus = [CustomBadge customBadgeWithString:@""
										   withStringColor:[UIColor whiteColor] 
											withInsetColor:[UIColor orangeColor] 
											withBadgeFrame:YES 
									   withBadgeFrameColor:[UIColor orangeColor] 
												 withScale:1.5 
											   withShining:YES];
			
			cbgStatus.frame = CGRectMake(8,8,10,10);
			[cell addSubview:cbgStatus];
			[cell.lblContactMoodMessage setText:@"Away"];
			[cell.lblContactMoodMessage setTextColor:[UIColor orangeColor]];
			
		}else if([user.sectionNum intValue] == 3){
			// Indicating status color (Gray Color) for offline users			
			cbgStatus = [CustomBadge customBadgeWithString:@""
										   withStringColor:[UIColor whiteColor] 
											withInsetColor:[UIColor lightGrayColor] 
											withBadgeFrame:YES 
									   withBadgeFrameColor:[UIColor lightGrayColor] 
												 withScale:1.5 
											   withShining:YES];

			
			cbgStatus.frame = CGRectMake(8,8,10,10);
			[cell addSubview:cbgStatus];
			[cell.lblContactMoodMessage setText:@"Offline"];
			[cell.lblContactMoodMessage setTextColor:[UIColor grayColor]];
		}
		else if([user.sectionNum intValue] == 2){
			// Indicating status color (Red Color) for offline users			
			
			cbgStatus = [CustomBadge customBadgeWithString:@""
													   withStringColor:[UIColor whiteColor] 
														withInsetColor:[UIColor redColor] 
														withBadgeFrame:YES 
												   withBadgeFrameColor:[UIColor redColor] 
															 withScale:1.5 
														   withShining:YES];
			
			cbgStatus.frame = CGRectMake(8,8,10,10);
			[cell addSubview:cbgStatus];
			[cell.lblContactMoodMessage setText:@"Busy"];
			[cell.lblContactMoodMessage setTextColor:[UIColor redColor]];
			
		}
	}
     */
    
	
    return cell;
	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
//		[ary removeObjectAtIndex:indexPath.row];
//		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//						 withRowAnimation:UITableViewRowAnimationFade];
		
		
		/* Uptil now all groups users are coming from server side, so as per requirement don't allow to delete it, so
		   just display proper message...! don't remove them.
		*/
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" 
														 message:@"Permission denied. Not Allowed to delete." 
														delegate:nil 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
}


-(void)dealloc{
	[super dealloc];
}


-(NSString*)FindUserRole:(NSString*)UserId{
/*
 - Returns user role based on user jid (Jabber ID)
 - User role can be teacher or student. 
 */
	for(int i=0;i<[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserRoles count];i++)
	{
		if([[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserRoles objectAtIndex:i] valueForKey:@"userid"] isEqualToString:UserId]
		   ){
			return [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserRoles objectAtIndex:i] valueForKey:@"role"];		
		}
	}
	return nil;	
}


- (void)btnLogoTapped:(UIButton*)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SHOW_USER_OPTIONS object:sender];
}


@end
