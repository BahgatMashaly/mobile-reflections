//
//  TblActivePollListDataSource.h
//  MobileJabber
//
//  Created by MAC BOOK on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomBadge.h"
#import "TblActivePollListCell.h"

@interface TblActivePollListDataSource : NSObject <UITableViewDataSource> {
	NSMutableArray *ary, * timers;
	CustomBadge *cbgStatus;
	NSMutableArray * pollsLocal;
	
	UITableView * table;
	BOOL setTimer;
}

-(void)counter :(id)timer;

@end
