//
//  EventListDataSource.m
//  MobileJabber
//
//  Created by shivang vyas on 06/07/11.
//  Copyright 2011 Matrix. All rights reserved.
//

#import "EventListDataSource.h"


@implementation EventListDataSource
-(id) initWithArray:(NSMutableArray*)aryEventList{
	if (self=[super init]) {
		ary = [[NSMutableArray alloc]initWithArray:aryEventList];			
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
	NSString *CellIdentifier = [NSString stringWithFormat:@"(%i)(%i)",indexPath.section,indexPath.row];
	TblEventCell * cell = (TblEventCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = nil; // temporary
    if (cell == nil) {
        cell = [[[TblEventCell alloc] initWithFrame:CGRectMake(0,0,277,80) reuseIdentifier:CellIdentifier] 
				autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor clearColor];
		
		if([[ary objectAtIndex:indexPath.row] valueForKey:@"eventdate"]!=nil){
			if(![[[[ary objectAtIndex:indexPath.row] valueForKey:@"eventdate"] description] isEqualToString:@"<null>"]){
				cell.lblEventDate.text = [[[[[ary objectAtIndex:indexPath.row] valueForKey:@"eventdate"] uppercaseString] componentsSeparatedByString:@"T"] objectAtIndex:0
										  ];
				
			}
		}
		
		if([[ary objectAtIndex:indexPath.row] valueForKey:@"eventname"]!=nil){
			if(![[[[ary objectAtIndex:indexPath.row] valueForKey:@"eventname"] description] isEqualToString:@"<null>"]){
				cell.lblEventSubject.text = [[ary objectAtIndex:indexPath.row] valueForKey:@"eventname"
										  ];
				
			}
		}
		
		if([[ary objectAtIndex:indexPath.row] valueForKey:@"eventduration"]!=nil){
			if(![[[[ary objectAtIndex:indexPath.row] valueForKey:@"eventduration"] description] isEqualToString:@"<null>"]){
				cell.lblEventTime.text = [[ary objectAtIndex:indexPath.row] valueForKey:@"eventduration"
											 ];
				
			}
		}
		
		
		
	}
	
    return cell;
	
}



-(void)dealloc{
	[super dealloc];
}


@end
