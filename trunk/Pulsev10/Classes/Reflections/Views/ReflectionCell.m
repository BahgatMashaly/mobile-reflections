//
//  ReflectionCell.m
//  MobileReflections
//
//  Created by SonNT on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ReflectionCell.h"

@implementation ReflectionCell
@synthesize lblDay, lblDate, lblTitle, lblCommentsRating;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self)
	{
		// Initialization code
		lblDay = [[UILabel alloc] init];
		[lblDay setTextAlignment:UITextAlignmentCenter];
		[lblDay setFont:[UIFont boldSystemFontOfSize:14]];
		[lblDay setTextColor:[UIColor whiteColor]];
		[lblDay setBackgroundColor:[UIColor greenColor]];
		[self.contentView addSubview:lblDay];
		
		lblDate = [[UILabel alloc] init];
		[lblDate setTextAlignment:UITextAlignmentCenter];
		[lblDate setFont:[UIFont boldSystemFontOfSize:18]];
		[lblDate setTextColor:[UIColor whiteColor]];
		[lblDate setBackgroundColor:[UIColor greenColor]];
		[self.contentView addSubview:lblDate];
		
		lblTitle = [[UILabel alloc] init];
		[lblTitle setTextAlignment:UITextAlignmentLeft];
		[lblTitle setFont:[UIFont boldSystemFontOfSize:14]];
		[self.contentView addSubview:lblTitle];
		
		lblCommentsRating = [[UILabel alloc] init];
		[lblCommentsRating setTextAlignment:UITextAlignmentLeft];
		[lblCommentsRating setFont:[UIFont systemFontOfSize:12]];
		[self.contentView addSubview:lblCommentsRating];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	CGFloat x = contentRect.origin.x;
	
	[lblDay setFrame:CGRectMake(x, 0, 50, 25)];
	[lblDate setFrame:CGRectMake(x, 26, 50, 25)];
	[lblTitle setFrame:CGRectMake(x + 60, 0, 260, 25)];
	[lblCommentsRating setFrame:CGRectMake(x + 60, 26, 260, 25)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
