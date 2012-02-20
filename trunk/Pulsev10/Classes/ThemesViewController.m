    //
//  ThemesViewController.m
//  MobileJabber
//
//  Created by Shivang Vyas on 6/29/11.
//  Copyright 2011 company. All rights reserved.
//

#import "ThemesViewController.h"


@implementation ThemesViewController

#pragma mark -
#pragma mark IBAction or Custom Methods
- (void)viewDidLoad {
    [super viewDidLoad];

	aryThemes = [[NSArray alloc] 
					initWithObjects:@"Default",@"3G Army",@"BMTC", nil
					];
	
	ObjTblThemeDelegate = [[TblThemeDelegate alloc] initWithArray:aryThemes];
	TblThemes.delegate = ObjTblThemeDelegate;
	
	ObjTblThemeDataSource = [[TblThemeDataSource alloc] initWithArray:aryThemes];
 	TblThemes.dataSource = ObjTblThemeDataSource;
	
	[TblThemes reloadData];
	
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
