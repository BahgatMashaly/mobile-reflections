//
//  TblActiveChatListDelegagte.m
//  MobileJabber
//
//  Created by Shivang Vyas on 7/2/11.
//  Copyright 2011 company. All rights reserved.
//

#import "TblActiveChatListDelegagte.h"


@implementation TblActiveChatListDelegagte
-(id) initWithArray:(NSMutableArray*)aryActiveChatUsers{
	if (self=[super init]) {
		ary = [[NSMutableArray alloc]initWithArray:aryActiveChatUsers];			
	}
	return self;
}

-(void)dealloc{
	[super dealloc];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	/*[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SHOW_CHAT_WINDOW object:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:indexPath.row]
	 ];*/
	
	
	NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:indexPath.row] objectForKey:@"user"], @"user",
							  @"0", @"chatBadge", [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:indexPath.row] objectForKey:@"type"], @"type", nil];
	
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers replaceObjectAtIndex:indexPath.row withObject:tempDict];
	//NSLog(@"%@", [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers description]);
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SHOW_CHAT_WINDOW object:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:indexPath.row] ];
	 
	 UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	 for (UIView *vw in [cell subviews]) {
		 if ([vw class] == [CustomBadge class]) {
			 [vw removeFromSuperview];			   
		}
	 }
	if ([[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"chat"]) {
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).chatActUser = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:indexPath.row] objectForKey:@"user"];	  
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictChatActGroup = nil;
	} 
	else {
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictChatActGroup = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:indexPath.row] objectForKey:@"user"];	  
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).chatActUser = nil;
	} 
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 60.0;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{	
	
}

@end
