//
//  TblActiveChatListDataSource.h
//  MobileJabber
//
//  Created by Shivang Vyas on 7/2/11.
//  Copyright 2011 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomBadge.h"
#import "TblActiveChatListCell.h"

@interface TblActiveChatListDataSource : NSObject <UITableViewDataSource>{
	NSMutableArray *ary;
	CustomBadge *cbgStatus;
    BOOL isCollapsed;
}
@property (nonatomic, readwrite) BOOL isCollapsed;
@end
