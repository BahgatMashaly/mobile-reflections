//
//  TblThemeDelegate.m
//  MobileJabber
//
//  Created by shivang vyas on 22/07/11.
//  Copyright 2011 Matrix. All rights reserved.
//

#import "TblThemeDelegate.h"


@implementation TblThemeDelegate
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
		NSMutableDictionary * dictApplicationSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath];		
		[dictApplicationSettings setValue:@"1" forKey:@"ThemeNumber"];
		[dictApplicationSettings writeToFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath atomically:YES];//?NSLog(@"Success"):NSLog(@"Failure");
		[dictApplicationSettings release];
		[[NSNotificationCenter defaultCenter] postNotificationName:	NSNOTIFICATION_CHANGE_APPLICATION_THEME object:@"1"
		 ];
	}else if(indexPath.row == 1){
		NSMutableDictionary * dictApplicationSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath];		
		[dictApplicationSettings setValue:@"2" forKey:@"ThemeNumber"];
		[dictApplicationSettings writeToFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath atomically:YES];//?NSLog(@"Success"):NSLog(@"Failure");
		[dictApplicationSettings release];
		[[NSNotificationCenter defaultCenter] postNotificationName:	NSNOTIFICATION_CHANGE_APPLICATION_THEME object:@"2"
		 ];
		
	}else if(indexPath.row == 2){
		NSMutableDictionary * dictApplicationSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath];		
		[dictApplicationSettings setValue:@"3" forKey:@"ThemeNumber"];
		[dictApplicationSettings writeToFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath atomically:YES];//?NSLog(@"Success"):NSLog(@"Failure");
		[dictApplicationSettings release];
		[[NSNotificationCenter defaultCenter] postNotificationName:	NSNOTIFICATION_CHANGE_APPLICATION_THEME object:@"3"
		 ];
		
	}
	
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{	
	
}

@end
