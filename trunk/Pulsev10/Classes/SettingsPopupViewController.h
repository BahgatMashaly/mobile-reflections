//
//  SettingsPopupViewController.h
//  MobileJabber
//
//  Created by Mac Pro 1 on 20/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TblSettingDelegate.h"
#import "TblSettingDataSource.h"

@interface SettingsPopupViewController : UIViewController{
	IBOutlet UITableView * TblSettings;
	NSArray * aryThemes;
	TblSettingDelegate * ObjTblSettingDelegate;
	TblSettingDataSource * ObjTblSettingDataSource;
}
-(IBAction)BtnBackTabbed:(id)sender;

@end
