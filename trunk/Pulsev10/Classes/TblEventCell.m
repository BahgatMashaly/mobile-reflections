//
//  TblEventCell.m
//  MobileJabber
//
//  Created by shivang vyas on 06/07/11.
//  Copyright 2011 Matrix. All rights reserved.
//

#import "TblEventCell.h"


@implementation TblEventCell
@synthesize imvEventChecked;
@synthesize lblEventDate;
@synthesize lblEventSubject;
@synthesize lblEventTime;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		float xStart = 10.0;
		float yStart = 10.0;
		float Height = 20.0;
		float Width = 277.0;
		float IconHeight = 27.0;
		float IconWidth = 27.0;
//		float CheckboxHeight = 16.0;
//		float CheckboxWidth = 16.0;
		
		
		imvBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,Width,80.0)];
		[imvBackground setContentMode:UIViewContentModeScaleToFill];
		[imvBackground setImage:[UIImage imageNamed:@"bgnew.png"]];
		[self addSubview:imvBackground];
		[imvBackground release];

		imvDivider = [[UIImageView alloc] initWithFrame:CGRectMake(0,(80.0-3.0),Width,3.0)];
		[imvDivider setContentMode:UIViewContentModeScaleToFill];
		[imvDivider setImage:[UIImage imageNamed:@"divider.png"]];
		[self addSubview:imvDivider];
		[imvDivider release];
		
		imvEventIcon = [[UIImageView alloc] initWithFrame:CGRectMake(xStart, yStart, IconWidth, IconHeight)
						];
		imvEventIcon.contentMode = UIViewContentModeScaleToFill;
		imvEventIcon.image = [UIImage imageNamed:@"events.png"];
		[self addSubview:imvEventIcon];
		[imvEventIcon release]; imvEventIcon = nil;
	
		lblEventDate = [[UILabel alloc] initWithFrame:CGRectMake(xStart + IconWidth + 20, yStart, Width - (IconWidth + 40), Height)
						];
		lblEventDate.textAlignment = UITextAlignmentLeft;
		lblEventDate.textColor = [UIColor whiteColor];
		lblEventDate.backgroundColor = [UIColor clearColor];
		lblEventDate.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE-4];
		[self addSubview:lblEventDate];
		yStart = yStart + Height;
		
		lblEventSubject = [[UILabel alloc] initWithFrame:CGRectMake(xStart + IconWidth + 20, yStart, Width - (IconWidth + 40), Height)
						   ];
		lblEventSubject.textAlignment = UITextAlignmentLeft;
		lblEventSubject.textColor = [UIColor whiteColor];
		lblEventSubject.backgroundColor = [UIColor clearColor];
		lblEventSubject.font = [UIFont fontWithName:BOLD_FONT_NAME size:FONT_SIZE-4];
		[self addSubview:lblEventSubject];
		yStart = yStart + Height;
		
		lblEventTime = [[UILabel alloc] initWithFrame:CGRectMake(xStart + IconWidth + 20, yStart, Width - (IconWidth + 40), Height)
						   ];
		lblEventTime.textAlignment = UITextAlignmentLeft;
		lblEventTime.textColor = [UIColor grayColor];
		lblEventTime.backgroundColor = [UIColor clearColor];
		lblEventTime.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE-4];
		[self addSubview:lblEventTime];
		yStart = yStart + Height;
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
