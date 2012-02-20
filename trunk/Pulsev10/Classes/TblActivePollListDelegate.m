//
//  TblActivePollListDelegate.m
//  MobileJabber
//
//  Created by MAC BOOK on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TblActivePollListDelegate.h"

@implementation TblActivePollListDelegate

-(id) initWithArray:(NSMutableArray*)aryActivePoll{
	if (self=[super init]) 
	{
		ary = [[NSMutableArray alloc]initWithArray:aryActivePoll];			
	}
	return self;
}

-(void)dealloc
{
	[super dealloc];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// NSLog(@"@@@@@@@@@@@@@@@@@@@@@ %@ ",[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryPollMessages objectAtIndex:indexPath.row]);
	
	NSMutableDictionary *temp = (NSMutableDictionary *) ( [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryPollMessages objectAtIndex:indexPath.row]);
	// UITableViewCell * cell= [tableView cellForRowAtIndexPath:indexPath];
	// UILabel * lbl = [cell.subviews objectAtIndex:6];
	// [temp setObject:lbl.text forKey:@"time"];
    
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SHOW_POLL_WINDOW object:temp];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 60.0;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{	
	
}

@end
