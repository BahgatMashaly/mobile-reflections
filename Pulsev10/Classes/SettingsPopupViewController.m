//
//  SettingsPopupViewController.m
//  MobileJabber
//
//  Created by Mac Pro 1 on 20/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsPopupViewController.h"

@implementation SettingsPopupViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];    
	aryThemes = [[NSArray alloc] 
                 initWithObjects:@"Configuration",@"Change Password",@"Help", nil
                 ];
	
	ObjTblSettingDelegate = [[TblSettingDelegate alloc] initWithArray:aryThemes];
	TblSettings.delegate = ObjTblSettingDelegate;
	
	ObjTblSettingDataSource = [[TblSettingDataSource alloc] initWithArray:aryThemes];
 	TblSettings.dataSource = ObjTblSettingDataSource;
	
	[TblSettings reloadData];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark IBAction or Custom Methods
-(IBAction)BtnBackTabbed:(id)sender{
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_CLOSE_THEME object:nil];
	
}


@end
