//
//  CommentCell.m
//  MobileJabber
//
//  Created by SonNT on 12/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell
@synthesize imgUserPicture, lblDate, lblTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self)
	{
		// Initialization code
		imgUserPicture = [[UIImageView alloc] init];
		[imgUserPicture setContentMode:UIViewContentModeScaleToFill];
		[self.contentView addSubview:imgUserPicture];
		
		lblTitle = [[UILabel alloc] init];
		[lblTitle setTextAlignment:UITextAlignmentLeft];
		[lblTitle setFont:[UIFont boldSystemFontOfSize:14]];
		[self.contentView addSubview:lblTitle];
		
		lblDate = [[UILabel alloc] init];
		[lblDate setTextAlignment:UITextAlignmentLeft];
		[lblDate setFont:[UIFont systemFontOfSize:12]];
		[self.contentView addSubview:lblDate];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	CGFloat x = contentRect.origin.x;
	
	[imgUserPicture setFrame:CGRectMake(x, 0, 50, 50)];
	[lblTitle setFrame:CGRectMake(x + 60, 0, 240, 25)];
	[lblDate setFrame:CGRectMake(x + 60, 26, 240, 25)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

@end
