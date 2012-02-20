//
//  EventListDataSource.h
//  MobileJabber
//
//  Created by shivang vyas on 06/07/11.
//  Copyright 2011 Matrix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TblEventCell.h"

@interface EventListDataSource : NSObject <UITableViewDataSource>{
	NSMutableArray *ary;
}

@end
