//
//  TblMenuListDelegate.m
//  MobileJabber
//
//  Created by Shivang Vyas on 7/21/11.
//  Copyright 2011 company. All rights reserved.
//

#import "TblMenuListDelegate.h"


@implementation TblMenuListDelegate
-(id) initWithArray:(NSMutableArray*)aryMenuList{
	if (self=[super init]) {
		ary = [aryMenuList retain];			
	}
	return self;
}

-(void)dealloc{
	[ary release];
	[super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	//0-Home, 1-chat, 2-Resources, 3-Reflections, 4-Learning Center, 5-Settings, 6-Logout
    int rowidx = indexPath.row;
    // if (ISDEVELOPMENT == 0 && rowidx > 1) 
    //    rowidx += 2;
    if (ISDEVELOPMENT == 0 && rowidx > 1) {
        rowidx += 4;
    } else if (ISDEVELOPMENT == 1) {
        if (rowidx == 4) 
            rowidx = 9;
        if (rowidx == 5) 
            rowidx = 7;
        if (rowidx == 6)
            rowidx = 8;
        if (rowidx == 3) 
            rowidx = 4;
    }
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SELECTED_MENU_ITEM 
														object:[NSString stringWithFormat:@"%i",rowidx]
	 ];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50.0;
}

@end
