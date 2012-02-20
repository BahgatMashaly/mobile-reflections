//
//  TblContactListCell.m
//  MobileJabber
//
//  Created by Shivang Vyas on 6/27/11.
//  Copyright 2011 company. All rights reserved.
//

#import "TblContactListCell.h"


@implementation TblContactListCell
@synthesize imvContact;
@synthesize lblContactName;
@synthesize lblContactMoodMessage;
@synthesize imvRole;
@synthesize btnLogo;
@synthesize userid, role;
@synthesize status;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		imvBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,275,60)];
		[imvBackground setContentMode:UIViewContentModeScaleToFill];
		[imvBackground setImage:[UIImage imageNamed:@"bgnew.png"]];
        imvBackground.opaque = NO;
        imvBackground.alpha = 1;
        imvBackground.backgroundColor = UIColor.clearColor;
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

		/*
		lblContactName = [[UILabel alloc] initWithFrame:CGRectMake(100,12,100,25)];
		lblContactName.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE-4];
		lblContactName.textColor = [UIColor whiteColor];
		lblContactName.backgroundColor = [UIColor clearColor];
		[self addSubview:lblContactName];
         
         lblContactMoodMessage = [[UILabel alloc] initWithFrame:CGRectMake(75,12+22, 150, 25)];
         lblContactMoodMessage.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE-6];
         lblContactMoodMessage.textColor = [UIColor whiteColor];
         lblContactMoodMessage.backgroundColor = [UIColor clearColor];
         [self addSubview:lblContactMoodMessage];
         */
		
		lblContactName = [[UILabel alloc] initWithFrame:CGRectMake(65,8,170,25)];
		lblContactName.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE-4];
		lblContactName.textColor = [UIColor whiteColor];
		lblContactName.backgroundColor = [UIColor clearColor];
		[self addSubview:lblContactName];


		lblContactMoodMessage = [[UILabel alloc] initWithFrame:CGRectMake(65,8+22, 170, 25)];
		lblContactMoodMessage.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE-6];
		lblContactMoodMessage.textColor = [UIColor whiteColor];
		lblContactMoodMessage.backgroundColor = [UIColor clearColor];
		[self addSubview:lblContactMoodMessage];

		
		imvRole = [[UIImageView alloc] initWithFrame:CGRectMake(75, 12, 25, 25)];
		imvRole.contentMode = UIViewContentModeScaleToFill;
		// [self addSubview:imvRole];
		
		imvDivider = [[UIImageView alloc] initWithFrame:
					  CGRectMake(0,57,275,3)];
		imvDivider.image = [UIImage imageNamed:@"divider.png"];
		[self addSubview:imvDivider];
		[imvDivider release];
		
////////// ADDED By KAPIL ON 4-AUG ///////////
		
		btnLogo = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnLogo setFrame:CGRectMake(230,15,30,30)];
		[btnLogo setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
		//[btnLogo addTarget:self action:@selector(btnLogoTapped:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btnLogo];
		
////////// END ADDED By KAPIL ON 4-AUG ///////////
		
////////// COMMENTED By KAPIL ON 4-AUG OO SHIVANG'S CODE ///////////	
		
		/*imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(230,15,30,30)];
		imgLogo.image = [UIImage imageNamed:@"logo.png"];
		[self addSubview:imgLogo];
		[imgLogo release];*/
		
////////// END COMMENTED By KAPIL ON 4-AUG OO SHIVANG'S CODE ///////////			
		
    }
    return self;
}

- (void)btnLogoTapped:(UIButton*)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SHOW_USER_OPTIONS object:sender];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)dealloc {
    [super dealloc];
}


@end
