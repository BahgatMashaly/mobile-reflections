//
//  TextNoteView.m
//  MobileReflections
//
//  Created by SonNT on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TextNoteView.h"
#define kResizeThumbSize 32

@implementation TextNoteView

- (CGRect)setBtnDeleteFrame
{
	int x = self.frame.size.width - (3 * (kResizeThumbSize + 1));
	int y = self.frame.size.height - kResizeThumbSize - 1;
	CGRect frame = CGRectMake(x, y, kResizeThumbSize, kResizeThumbSize);
	
	return frame;
}

- (CGRect)setBtnOKFrame
{
	int x = self.frame.size.width - (2 * (kResizeThumbSize + 1));
	int y = self.frame.size.height - kResizeThumbSize - 1;
	CGRect frame = CGRectMake(x, y, kResizeThumbSize, kResizeThumbSize);
	
	return frame;
}

- (CGRect)setLblBackgroundFrame
{
	int viewWidth = self.frame.size.width;
	int viewHeight = kResizeThumbSize + 2;
	int y = self.frame.size.height - kResizeThumbSize - 2;
	CGRect frame = CGRectMake(0, y, viewWidth, viewHeight);
	
	return frame;
}

- (CGRect)setTxtContentFrame
{
	int viewWidth = self.frame.size.width - 2;
	int viewHeight = self.frame.size.height - kResizeThumbSize;
	CGRect frame = CGRectMake(1, 1, viewWidth, viewHeight);

	return frame;
}

- (CGRect)setScalableFrame
{
	int x = self.frame.size.width - kResizeThumbSize - 1;
	int y = self.frame.size.height - kResizeThumbSize - 1;
	CGRect frame = CGRectMake(x, y, kResizeThumbSize, kResizeThumbSize);
	
	return frame;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		[self setBackgroundColor:[UIColor clearColor]];
		
		lblBackground = [[UILabel alloc] initWithFrame:[self setLblBackgroundFrame]];
		[lblBackground setBackgroundColor:[UIColor grayColor]];
		[self addSubview:lblBackground];
		
		btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnDelete setImage:[UIImage imageNamed:@"icon_delete_32.png"] forState:UIControlStateNormal];
		[btnDelete setFrame:[self setBtnDeleteFrame]];
		[btnDelete addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btnDelete];
		
		btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnOK setImage:[UIImage imageNamed:@"icon_check_32.png"] forState:UIControlStateNormal];
		[btnOK setFrame:[self setBtnOKFrame]];
		[btnOK addTarget:self action:@selector(clickOK:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btnOK];

		imgScalable = [[UIImageView alloc] initWithFrame:[self setScalableFrame]];
		[imgScalable setImage:[UIImage imageNamed:@"icon_scalable.png"]];
		[self addSubview:imgScalable];
		
		txtContent = [[UITextView alloc] initWithFrame:[self setTxtContentFrame]];
		[txtContent setBackgroundColor:[UIColor clearColor]];
		[txtContent setFont:[UIFont fontWithName:@"Verdana" size:14]];
		[txtContent becomeFirstResponder];
		[self addSubview:txtContent];
	}
	return self;
}

- (void)clickDelete:(id)sender
{
	[self removeFromSuperview];
}

- (void)clickOK:(id)sender
{
	[lblBackground setHidden:YES];
	[btnDelete setHidden:YES];
	[btnOK setHidden:YES];
	[imgScalable setHidden:YES];
	
	[self setUserInteractionEnabled:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	touchStart = [[touches anyObject] locationInView:self];
	isResizing = (self.bounds.size.width - touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize);
	
	if (isResizing)
	{
		touchStart = CGPointMake(touchStart.x - self.bounds.size.width, touchStart.y - self.bounds.size.height);
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [[touches anyObject] locationInView:self];
	
	if (isResizing)
	{
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, touchPoint.x - touchStart.x, touchPoint.y - touchStart.y);
		[lblBackground setFrame:[self setLblBackgroundFrame]];
		[btnDelete setFrame:[self setBtnDeleteFrame]];
		[btnOK setFrame:[self setBtnOKFrame]];
		[imgScalable setFrame:[self setScalableFrame]];
		[txtContent setFrame:[self setTxtContentFrame]];
	}
	else
	{
		self.center = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
								  self.center.y + touchPoint.y - touchStart.y);
	}
	
	// Uncomment to force boundary checks
	CGAffineTransform concat;
	if (self.frame.origin.x < 0)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(-self.frame.origin.x, 0.0f));
		self.transform = concat;
	}
	
	if (self.frame.origin.y < 0)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(0.0f, -self.frame.origin.y));
		self.transform = concat;
	}
	
	float dx = (self.frame.origin.x + self.frame.size.width) - self.superview.frame.size.width;
	if (dx > 0.0f)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(-dx, 0.0f));
		self.transform = concat;
	}
	
	float dy = (self.frame.origin.y + self.frame.size.height) - self.superview.frame.size.height;
	if (dy > 0.0f)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(0.0f, -dy));
		self.transform = concat;
	}
}

@end
