//
//  TblActiveChatListCell.m
//  MobileJabber
//
//  Created by Shivang Vyas on 7/2/11.
//  Copyright 2011 company. All rights reserved.
//

#import "TblActiveChatListCell.h"


@implementation TblActiveChatListCell
@synthesize imvContact;
@synthesize lblContactName, lblLastMessageText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
		
		lblContactName = [[UILabel alloc] initWithFrame:CGRectMake(60,12,180,25)];
		lblContactName.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE-4];
		lblContactName.textColor = [UIColor whiteColor];
		lblContactName.backgroundColor = [UIColor clearColor];
		[self addSubview:lblContactName];
		
		lblLastMessageText = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, self.frame.size.width - 80, 21)];
		[lblLastMessageText setBackgroundColor:[UIColor clearColor]];
		[lblLastMessageText setFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE-5]];
		[lblLastMessageText setTextColor:[UIColor orangeColor]];
		[self addSubview:lblLastMessageText];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)dealloc {
	[imvContact release];
	[lblContactName release];
    [super dealloc];
}


@end
