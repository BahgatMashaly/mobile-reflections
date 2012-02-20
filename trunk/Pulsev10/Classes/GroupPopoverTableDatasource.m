//
//  GroupPopoverTableDatasource.m
//  MobileJabber
//
//  Created by jigar shah on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupPopoverTableDatasource.h"


@implementation GroupPopoverTableDatasource
- (id)initWithArray:(NSArray*)ary parent:(id)objParent {
	if ([super init]) {
		aryFields = [[NSArray alloc] initWithArray:ary];
		objParentView = (GroupOptionPopoverViewController*)objParent;
	}
	return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [aryFields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = [NSString stringWithFormat:@"(%i)(%i)",indexPath.section,indexPath.row];
	UITableViewCell * cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = nil;
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"UserOptionCell" owner:objParentView options:nil];
		cell = objParentView.tbcCustomCell;
		//cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,450,100) reuseIdentifier:CellIdentifier] 
		//				autorelease];
		//		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//		cell.backgroundColor = [UIColor clearColor];
		//		cell.textLabel.text = [[ary objectAtIndex:indexPath.row] valueForKey:@"Name"];
		//		cell.textLabel.font = [UIFont fontWithName:BOLD_FONT_NAME size:FONT_SIZE];
		//		cell.textLabel.textColor =[UIColor blackColor];
		//		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	UIImageView *imvIcon = (UIImageView *)[cell viewWithTag:1];
	UILabel *lblField = (UILabel*)[cell viewWithTag:2];
	[imvIcon setImage:[UIImage imageNamed:[[aryFields objectAtIndex:indexPath.row] objectForKey:@"icon"]]];
	lblField.text = [[aryFields objectAtIndex:indexPath.row] objectForKey:@"field"];
    return cell;
	
}


-(void)dealloc{
	[super dealloc];
}


@end
