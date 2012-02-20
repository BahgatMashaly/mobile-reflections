//
//  TblSettingDataSource.m
//  MobileJabber
//
//  Created by Mac Pro 1 on 20/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TblSettingDataSource.h"

@implementation TblSettingDataSource
-(id) initWithArray:(NSMutableArray*)aryThemes{
	if (self=[super init]) {
		ary = [aryThemes retain];			
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
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,130,50) reuseIdentifier:CellIdentifier] 
				autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = [ary objectAtIndex:indexPath.row];		
    }
	
    return cell;
	
}

-(void)dealloc{
	[ary release];
	[super dealloc];
}

@end
