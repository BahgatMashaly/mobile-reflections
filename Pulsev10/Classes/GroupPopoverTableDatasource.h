//
//  GroupPopoverTableDatasource.h
//  MobileJabber
//
//  Created by jigar shah on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class GroupOptionPopoverViewController;
#import <Foundation/Foundation.h>
#import "GroupOptionPopoverViewController.h"

@interface GroupPopoverTableDatasource : NSObject <UITableViewDataSource> {
	NSArray *aryFields;
	GroupOptionPopoverViewController *objParentView;
}

- (id)initWithArray:(NSArray*)ary parent:(id)objParent;
@end
