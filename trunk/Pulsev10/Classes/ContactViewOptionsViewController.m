    //
//  ContactViewOptionsViewController.m
//  MobileJabber
//
//  Created by Shivang Vyas on 6/20/11.
//  Copyright 2011 company. All rights reserved.
//

#import "ContactViewOptionsViewController.h"


@implementation ContactViewOptionsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	aryContactviewOptions = [NSArray arrayWithObjects:@"Online",nil];
	
	ObjTblContactViewOptionsDelegate = [[TblContactViewOptionsDelegate alloc] initWithArray:aryContactviewOptions
										];
	
	TblContactViewOption.delegate = ObjTblContactViewOptionsDelegate;
	
	ObjTblContactViewOptionsDataSource = [[TblContactViewOptionsDataSource alloc] initWithArray:aryContactviewOptions
										  ];
	
	TblContactViewOption.dataSource = ObjTblContactViewOptionsDataSource;
	
	[TblContactViewOption reloadData];
	
	
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)dealloc {
    [super dealloc];
}



@end
