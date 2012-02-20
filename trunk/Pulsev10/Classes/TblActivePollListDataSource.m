//
//  TblActivePollListDataSource.m
//  MobileJabber
//
//  Created by MAC BOOK on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TblActivePollListDataSource.h"

@implementation TblActivePollListDataSource
-(id) initWithArray:(NSMutableArray*)aryPollList
{
	if (self=[super init]) 
	{
		ary = [[NSMutableArray alloc]initWithArray:aryPollList];
		pollsLocal = ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).polls;
        pollsLocal = [[NSMutableArray alloc] init];
		setTimer = NO;
	}
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	table = [tableView retain];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [ary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// NSLog(@"Loading Table");
	NSString *CellIdentifier = [NSString stringWithFormat:@"(%i)(%i)",indexPath.section,indexPath.row];
	TblActivePollListCell * cell = (TblActivePollListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = nil;
	
    if (cell == nil) 
	{
		// NSLog(@"New Cell");
        cell = [[[TblActivePollListCell alloc] initWithFrame:CGRectMake(0,0,310,100) reuseIdentifier:CellIdentifier] 
				autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor clearColor];
	}
	
	XMPPJID *usR = [[ary objectAtIndex:indexPath.row] objectForKey:@"user"];
    if (usR == nil) {

    } else {
        /*
        NSData *photoData = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) xmppvCardAvatarModule] photoDataForJID:usR];
	
        if (photoData != nil) 
        {
            cell.imvContact.image = [UIImage imageWithData:photoData];			
        }
         */
        cell.imvContact.image = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getUserImage:[usR user]];			
    }
	
	cell.lblQuestion.text = [[ary objectAtIndex:indexPath.row] valueForKey:@"QUESTION"];
    NSInteger pollType = [[[ary objectAtIndex:indexPath.row] valueForKey:@"type"] integerValue];
    NSString *type = @"Open Ended";
    if (pollType == 1) 
        type = @"Multiple Choice";
    else if (pollType == 2) 
        type = @"True / False";
    else if (pollType == 3)
        type = @"Likert Scale";
    
	cell.lblType.text = type;
    return cell;	
}

-(void)counter :(id)timer
{
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{	
	
}

-(void)dealloc{
    [pollsLocal release];
    pollsLocal = nil;
	[super dealloc];
}
@end
