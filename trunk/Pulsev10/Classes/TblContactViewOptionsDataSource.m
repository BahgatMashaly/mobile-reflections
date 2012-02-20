//
//  TblContactViewOptionsDataSource.m
//  MobileJabber
//
//  Created by Shivang Vyas on 7/22/11.
//  Copyright 2011 company. All rights reserved.
//

#import "TblContactViewOptionsDataSource.h"


@implementation TblContactViewOptionsDataSource
-(id) initWithArray:(NSMutableArray*)aryViewOptions{
	if (self=[super init]) {
		ary = [aryViewOptions retain];	
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
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,310,100) reuseIdentifier:CellIdentifier] 
				autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor clearColor];
		cell.textLabel.text = [ary objectAtIndex:indexPath.row];
	}
	
    return cell;
}

-(void)dealloc{
	[ary release];
	[super dealloc];
}

@end
