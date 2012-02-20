//
//  TblContactListDelegate.h
//  MobileJabber
//
//  Created by Shivang Vyas on 6/27/11.
//  Copyright 2011 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTHeaderView.h"

@interface TblContactListDelegate : NSObject <UITableViewDelegate>{
	NSMutableArray * ary;
	NSMutableArray * aryContactHeader; 
	GTHeaderView * hView;
	UITableView * tbl;
}
-(id) initWithArray:(NSMutableArray*)aryContact Table:(UITableView*)tblView;
//- (void)toggle:(NSString*)isExpanded:(NSInteger)section;
- (void)generateHeaderViews;
@end
