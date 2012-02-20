//
//  TblContactViewOptionsDelegate.m
//  MobileJabber
//
//  Created by Shivang Vyas on 7/22/11.
//  Copyright 2011 company. All rights reserved.
//

#import "TblContactViewOptionsDelegate.h"


@implementation TblContactViewOptionsDelegate
-(id) initWithArray:(NSMutableArray*)aryViewOptions{
	if (self=[super init]) {
		ary = [aryViewOptions retain];			
	}
	return self;
}

-(void)dealloc{
	[ary release];
	[super dealloc];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50.0;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{	
	
}

@end
