//
//  TblActivePollListCell.m
//  MobileJabber
//
//  Created by MAC BOOK on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TblActivePollListCell.h"


@implementation TblActivePollListCell
@synthesize imvContact;
@synthesize lblType,lblQuestion,lbltimercount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
	{
		imvBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,275,60)];
		[imvBackground setContentMode:UIViewContentModeScaleToFill];
		[imvBackground setImage:[UIImage imageNamed:@"bgnew.png"]];
		[self addSubview:imvBackground];
		[imvBackground release];
		
		imvContactBackground = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,46,46)];
		imvContactBackground.image = [UIImage imageNamed:@"image border 42 x 42.png"];
		imvContactBackground.contentMode = UIViewContentModeScaleToFill;
		[self addSubview:imvContactBackground];
		[imvContactBackground release];
		
		imvContact = [[UIImageView alloc] initWithFrame:CGRectMake(15,15, 36, 36)];
		imvContact.contentMode = UIViewContentModeScaleToFill;
		[self addSubview:imvContact];
		
		lblType = [[UILabel alloc] initWithFrame:CGRectMake(63,8,100,25)];
		lblType.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE-4];
		lblType.textColor = [UIColor whiteColor];
		lblType.backgroundColor = [UIColor clearColor];
		[self addSubview:lblType];
		
		lblQuestion = [[UILabel alloc] initWithFrame:CGRectMake(63,30,140,25)];
		lblQuestion.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE-4];
		lblQuestion.textColor = [UIColor whiteColor];
		lblQuestion.backgroundColor = [UIColor clearColor];
		[self addSubview:lblQuestion];
		
		
		lbltimercount = [[UILabel alloc] initWithFrame:CGRectMake(220,30,50,25)];
		lbltimercount.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE-4];
		lbltimercount.textColor = [UIColor redColor];
		lbltimercount.backgroundColor = [UIColor clearColor];
		[self addSubview:lbltimercount];
				
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	[imvContact release];
	[lblType release];
	[lblQuestion release];
	[lbltimercount release];
    [super dealloc];
}
@end
