//
//  EventListDelegate.m
//  MobileJabber
//
//  Created by shivang vyas on 06/07/11.
//  Copyright 2011 Matrix. All rights reserved.
//

#import "EventListDelegate.h"


@implementation EventListDelegate
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
	return 80.0;
}
 


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{	
	
}
@end
