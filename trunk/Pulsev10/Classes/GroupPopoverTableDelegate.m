//
//  GroupPopoverTableDelegate.m
//  MobileJabber
//
//  Created by jigar shah on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupPopoverTableDelegate.h"


@implementation GroupPopoverTableDelegate
- (id)initWithArray:(NSArray*)ary {
	if ([super init]) {
		aryFields = [[NSArray alloc] initWithArray:ary];
	}
	return self;
}

-(void)dealloc{
	[super dealloc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_GROUP_OPTION_SELECTED object:[aryFields objectAtIndex:indexPath.row]];
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{	
	
}

@end
