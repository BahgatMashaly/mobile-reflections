//
//  GroupOptionPopoverViewController.h
//  MobileJabber
//
//  Created by jigar shah on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class GroupPopoverTableDelegate;
@class GroupPopoverTableDatasource;

#import <UIKit/UIKit.h>
#import "GroupPopoverTableDatasource.h"
#import "GroupPopoverTableDelegate.h"

@interface GroupOptionPopoverViewController : UIViewController {

	IBOutlet UITableView *tblOptionView;
	IBOutlet UITableViewCell *tbcCustomCell;
	NSMutableArray *aryFields;
	GroupPopoverTableDatasource *objDatasource;
	GroupPopoverTableDelegate *objDelegate;
}
@property (nonatomic, retain)IBOutlet UITableViewCell *tbcCustomCell;


@end
