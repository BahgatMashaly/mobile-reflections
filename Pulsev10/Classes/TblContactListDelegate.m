//
//  TblContactListDelegate.m
//  MobileJabber
//
//  Created by Shivang Vyas on 6/27/11.
//  Copyright 2011 company. All rights reserved.
//

#import "TblContactListDelegate.h"


@implementation TblContactListDelegate

-(id) initWithArray:(NSMutableArray*)aryContact Table:(UITableView*)tblView{
	if (self=[super init]) {
		ary = [[NSMutableArray alloc]initWithArray:aryContact];
		tbl = [tblView retain]; 
		[self generateHeaderViews];
	}
	return self;
}

-(void)dealloc{
	[super dealloc];
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
}*/

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
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).isChatWindowUp) {
            //NSLog(@"didSelectRowAtIndexPath");	
            //NSLog(@"contact ary: %@",ary);
            NSString *strJid = [[((XMPPUserCoreDataStorage*)[[[ary objectAtIndex:indexPath.section] valueForKey:@"GroupUsers"] objectAtIndex:indexPath.row
														 ]).jidStr	componentsSeparatedByString:@"@"] objectAtIndex:0];
		
            if(![((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) IsFoundInActiveUserList:strJid]){
                /*[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers addObject:
                 ((XMPPUserCoreDataStorage*)[[[ary objectAtIndex:indexPath.section] valueForKey:@"GroupUsers"] objectAtIndex:indexPath.row
                 ])
                 ];*/
                //NSLog(@"%@", [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers description]);
                [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers addObject:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  ((XMPPUserCoreDataStorage*)[[[ary objectAtIndex:indexPath.section] valueForKey:@"GroupUsers"] objectAtIndex:indexPath.row
										  ]), @"user", @"0", @"chatBadge", @"chat", @"type", nil]
                 ];
                ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).chatActUser = (XMPPUserCoreDataStorage*)[[[ary objectAtIndex:indexPath.section] valueForKey:@"GroupUsers"] objectAtIndex:indexPath.row
																															  ];
                //NSLog(@"%@", [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers description]);
            }
            ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).chatActUser = (XMPPUserCoreDataStorage*)[[[ary objectAtIndex:indexPath.section] valueForKey:@"GroupUsers"] objectAtIndex:indexPath.row];
            [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_UPDATE_ACTIVECHATUSERS object:nil];
            //NSLog(@"%@", [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers description]);
		NSInteger index = 0;
		for (NSDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers) {
			if ([[dict objectForKey:@"type"] isEqualToString:@"chat"]) {
				if ([dict objectForKey:@"user"] == ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).chatActUser) {
					break;
				}
			}
			index++;
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SHOW_CHAT_WINDOW object:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:index] 
		 ];
		
        }
    }
    @catch (NSException* e) {
        // Do nothing
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
/*
	UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 25)];

	UIImageView *imvHeaderBackground = [[UIImageView alloc] initWithFrame:CGRectMake
										(0,0,275,25)];
	imvHeaderBackground.contentMode = UIViewContentModeScaleToFill;
	imvHeaderBackground.image = [UIImage imageNamed:@"widget title.png"];
	
	[viewHeader addSubview:imvHeaderBackground];
	[imvHeaderBackground release];
	
	
	
	UIImageView * imgUpArrow = [[UIImageView alloc] initWithFrame:
								CGRectMake(5,5,15,15)];
	imgUpArrow.image = [UIImage imageNamed:@"arrow up.png"];
	[viewHeader addSubview:imgUpArrow];
	[imgUpArrow release];
	
	
	UIImageView * imvDownArrowBackground = [[UIImageView alloc] initWithFrame:
								  CGRectMake(245,0,25,25)];
	imvDownArrowBackground.contentMode = UIViewContentModeScaleToFill;
	imvDownArrowBackground.image = [UIImage imageNamed:@"bg 2.png"];
	[viewHeader addSubview:imvDownArrowBackground];
	[imvDownArrowBackground release];
	
	UIImageView * imgDownArrow = [[UIImageView alloc] initWithFrame:
								  CGRectMake(250,5,15,15)];
	imgDownArrow.contentMode = UIViewContentModeScaleToFill;
	imgDownArrow.image = [UIImage imageNamed:@"arrow down.png"];
	[viewHeader addSubview:imgDownArrow];
	[imgDownArrow release];
								  
	
	
	UILabel *lblHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake
										(20,0,250,25)];
	lblHeaderTitle.font = [UIFont fontWithName:BOLD_FONT_NAME size:FONT_SIZE-4];
	lblHeaderTitle.textColor = [UIColor whiteColor];
	lblHeaderTitle.backgroundColor = [UIColor clearColor];
	lblHeaderTitle.text = [[ary objectAtIndex:section] valueForKey:@"GroupName"];
	[viewHeader addSubview:lblHeaderTitle];
	[lblHeaderTitle release];
	
	return [viewHeader autorelease];
*/
	//NSLog(@"%@",[[aryContactHeader objectAtIndex:section] description]);
	
	return [aryContactHeader objectAtIndex:section];	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
		return 60.0;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{	
	
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Detemine if it's in editing mode
	// if (self.editing) {
	//        return UITableViewCellEditingStyleDelete;
	//    }
    return UITableViewCellEditingStyleNone;
	
}


@end
