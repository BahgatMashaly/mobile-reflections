//
//  MenuViewController.h
//  MobileJabber
//
//  Created by Shivang Vyas on 6/29/11.
//  Copyright 2011 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TblMenuListDelegate.h"
#import "TblMenuListDataSource.h"


@interface MenuViewController : UIViewController {
	NSMutableArray * aryMenuItems;
	IBOutlet UITableView * tblMenuList;
	TblMenuListDelegate * ObjTblMenuListDelegate;
	TblMenuListDataSource * ObjTblMenuListDataSource;
}

-(IBAction)BtnHomeTabbed:(id)sender;
-(IBAction)BtnChatTabbed:(id)sender;
-(IBAction)BtnReflectionTabbed:(id)sender;
-(IBAction)BtnResourcesTabbed:(id)sender;
-(IBAction)BtnLogoutTabbed:(id)sender;
-(IBAction)BtnBackTabbed:(id)sender;
@end
