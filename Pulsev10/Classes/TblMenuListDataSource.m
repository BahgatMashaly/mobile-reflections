//
//  TblMenuListDataSource.m
//  MobileJabber
//
//  Created by Shivang Vyas on 7/21/11.
//  Copyright 2011 company. All rights reserved.
//

#import "TblMenuListDataSource.h"


@implementation TblMenuListDataSource
-(id) initWithArray:(NSMutableArray*)aryMenuList{
	if (self=[super init]) {
		ary = [aryMenuList retain];			
	}
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [ary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = [NSString stringWithFormat:@"%i",indexPath.row];
	
	UITableViewCell * cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,295,50) reuseIdentifier:CellIdentifier] 
				autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor whiteColor];
		UILabel *lblMenu = [[UILabel alloc] initWithFrame:CGRectMake(55, cell.frame.size.height/2 - 13, cell.frame.size.width - 65, 30)];
		[lblMenu setText:[[ary objectAtIndex:indexPath.row] objectForKey:@"value"]];
		[lblMenu setFont:[UIFont boldSystemFontOfSize:16]];
		[cell addSubview:lblMenu];
		
		UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, cell.frame.size.height/2 - 13, 30, 30)];
		imgView.image = [UIImage imageNamed:[[ary objectAtIndex:indexPath.row] objectForKey:@"icon"]];
		[cell addSubview:imgView];
	}
	
    return cell;
	
}



-(void)dealloc{
	[ary release];
	[super dealloc];
}

@end
