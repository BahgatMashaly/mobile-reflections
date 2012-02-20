//
//  TblChatConversationDelegate.m
//  MobileJabber
//
//  Created by Shivang Vyas on 7/2/11.
//  Copyright 2011 company. All rights reserved.
//

#import "TblChatConversationDelegate.h"


@implementation TblChatConversationDelegate
@synthesize ChatUser;

-(id) initWithArray:(NSMutableArray*)aryContact{
	if (self=[super init]) {
		ary = [[NSMutableArray alloc]initWithArray:aryContact];			
	}
	return self;
}

-(void)dealloc{
	[super dealloc];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"chat"] ) {
		CGSize MessageSize = [[[ary objectAtIndex:indexPath.row] valueForKey:@"body"] 
							  sizeWithFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE]
							  constrainedToSize:CGSizeMake(450,MAXFLOAT) 
							  lineBreakMode:UILineBreakModeWordWrap];
		return MAX(MessageSize.height + (2*20.0) ,70.0) + 10.0 ;
	}
	else if ([[[ary objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"groupChat"] ) {
		CGSize MessageSize = [[[ary objectAtIndex:indexPath.row] valueForKey:@"body"] 
							  sizeWithFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE]
							  constrainedToSize:CGSizeMake(450,MAXFLOAT) 
							  lineBreakMode:UILineBreakModeWordWrap];
		return MAX(MessageSize.height + (2*20.0) ,70.0) + 10.0 ;
	}
	else {
		if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"seq"] isEqualToString:@"0"]) {
			if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"sender"] isEqualToString:
				 [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] 
				   componentsSeparatedByString:@"@"] objectAtIndex:0]]
				) {
				return 70;
			}
			if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"groupFileSending"]) {
				if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"Action"] isEqualToString:@""] ||
					[[ary objectAtIndex:indexPath.row] objectForKey:@"Action"] == nil) {
					
					return 110.0;
				}
			}
			else {
				if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] isEqualToString:@""] ||
					[[ary objectAtIndex:indexPath.row] objectForKey:@"action"] == nil) {
					
					return 110.0;
				}
			}

			
		}
	}

	return 70.0;	
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
