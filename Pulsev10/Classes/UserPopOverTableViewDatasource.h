//
//  UserPopOverTableViewDatasource.h
//  MobileJabber
//
//  Created by jigar shah on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class UserOptionPopoverViewController;
#import <Foundation/Foundation.h>
#import "UserOptionPopoverViewController.h"

@interface UserPopOverTableViewDatasource : NSObject <UITableViewDataSource>{
	NSArray *aryFields;
	UserOptionPopoverViewController *objParentView;
}

- (id)initWithArray:(NSArray*)ary parent:(id)objParent;

@end
