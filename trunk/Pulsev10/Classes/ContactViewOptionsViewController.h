//
//  ContactViewOptionsViewController.h
//  MobileJabber
//
//  Created by Shivang Vyas on 6/20/11.
//  Copyright 2011 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TblContactViewOptionsDelegate.h"
#import "TblContactViewOptionsDataSource.h"


@interface ContactViewOptionsViewController : UIViewController {
	IBOutlet UITableView * TblContactViewOption;
	TblContactViewOptionsDelegate * ObjTblContactViewOptionsDelegate;
	TblContactViewOptionsDataSource * ObjTblContactViewOptionsDataSource;
	NSArray * aryContactviewOptions;
}
@end
