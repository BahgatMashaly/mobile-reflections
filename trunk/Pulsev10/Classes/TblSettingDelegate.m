//
//  TblSettingDelegate.m
//  MobileJabber
//
//  Created by Mac Pro 1 on 20/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TblSettingDelegate.h"

@implementation TblSettingDelegate
-(id) initWithArray:(NSMutableArray*)aryActiveChatUsers{
	if (self=[super init]) {
		ary = [[NSMutableArray alloc]initWithArray:aryActiveChatUsers];			
	}
	return self;
}

-(void)dealloc{
	[ary release];
	[super dealloc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).ObjPopoverController_Themes dismissPopoverAnimated:YES];
	
	if(indexPath.row == 0){
        [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) showSettings];
	}else if(indexPath.row == 1){
        [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) changePassword];
	}else if(indexPath.row == 2){
        [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) showHelpPage];
	}
	
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{	
	
}

@end
