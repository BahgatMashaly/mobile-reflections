//
//  UserOptionPopoverViewController.h
//  MobileJabber
//
//  Created by jigar shah on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class UserPopOverTableViewDatasource;
@class UserPopOverTableViewDelegate;
#import <UIKit/UIKit.h>
#import "UserPopOverTableViewDelegate.h"
#import "UserPopOverTableViewDatasource.h"

@interface UserOptionPopoverViewController : UIViewController {
	IBOutlet UITableView *tblView;
	IBOutlet UITableViewCell *tbcCustomCell;
	NSMutableArray *aryFields;
	UserPopOverTableViewDatasource *objDatasource;
	UserPopOverTableViewDelegate *objDelegate;
}
@property (nonatomic, retain)IBOutlet UITableViewCell *tbcCustomCell;

@end
