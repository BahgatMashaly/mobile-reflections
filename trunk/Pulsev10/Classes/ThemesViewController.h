//
//  ThemesViewController.h
//  MobileJabber
//
//  Created by Shivang Vyas on 6/29/11.
//  Copyright 2011 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TblThemeDelegate.h"
#import "TblThemeDataSource.h"

@interface ThemesViewController : UIViewController {
	IBOutlet UITableView * TblThemes;
	NSArray * aryThemes;
	TblThemeDelegate * ObjTblThemeDelegate;
	TblThemeDataSource * ObjTblThemeDataSource;
}
-(IBAction)BtnBackTabbed:(id)sender;
@end
