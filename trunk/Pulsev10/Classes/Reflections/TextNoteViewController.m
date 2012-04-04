//
//  TextNoteViewController.m
//  MobileReflections
//
//  Created by SonNT on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TextNoteViewController.h"
#import "Define.h"

#define kResizeThumbSize 24
#define minWidth 350
#define minHeight 60

@implementation TextNoteViewController
@synthesize strContent, fontColor, fontName, fontSize;

- (void)setSelectedColor:(UIColor *)selectedColor
{
	[txtContent setTextColor:[selectedColor retain]];
	[aPopover dismissPopoverAnimated:YES];
}

- (void)didSelectFont:(NSString *)aFontName
{
	[txtContent setFont:[UIFont fontWithName:aFontName size:[txtContent.font pointSize]]];
	[aPopover dismissPopoverAnimated:YES];
}

- (void)didSelectSize:(CGFloat)sizeValue
{
	[txtContent setFont:[UIFont fontWithName:[txtContent.font fontName] size:sizeValue]];
	[aPopover dismissPopoverAnimated:YES];
}

- (void)setContentFrame
{
	CGRect frame;
	CGFloat viewWidth = self.view.frame.size.width;
	CGFloat viewHeight = self.view.frame.size.height;
	int x, y;
	
	frame = CGRectMake(0, viewHeight - 44, viewWidth, 44);
	[toolbar setFrame:frame];
	[imgTextBG setFrame:[self.view bounds]];

	x = viewWidth - kResizeThumbSize - 1;
	y = viewHeight - kResizeThumbSize - 1;
	frame = CGRectMake(x, y, kResizeThumbSize, kResizeThumbSize);
	[imgResize setFrame:frame];
	
	viewHeight = self.view.frame.size.height - (2 + kResizeThumbSize);
	y = 1;
	
	x = 1;
	frame = CGRectMake(x, y, viewWidth, viewHeight);
	[txtContent setFrame:frame];
}

- (void)showTools
{
	[toolbar setHidden:NO];
	[imgTextBG setHidden:NO];
	[imgResize setHidden:NO];
	[self setContentFrame];
	[txtContent setUserInteractionEnabled:YES];
}

- (void)hideTools
{
	[toolbar setHidden:YES];
	[txtContent setUserInteractionEnabled:NO];
}

- (void)showHideToolbar
{
	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: 0.75];
	
	if ([toolbar alpha] == 0.0) [toolbar setAlpha:1.0];
	else [toolbar setAlpha:0.0];
	
	[UIView commitAnimations];
	
	if ([toolbar alpha] == 0.0) [self hideTools];
	else [self showTools];
}

- (IBAction)clickDelete:(id)sender
{
	[self.view removeFromSuperview];
}

- (void)hideToolToSave
{
	[self hideTools];
}

- (IBAction)clickDone:(id)sender
{
	[self hideTools];

	[imgTextBG setHidden:YES];
	[imgResize setHidden:YES];
	
	strContent = [NSString stringWithString:[txtContent text]];
	fontColor = [txtContent textColor];
	fontName = [NSString stringWithString:[txtContent.font fontName]];
	fontSize = [txtContent.font pointSize];
}

- (IBAction)clickColor:(id)sender
{
	if (aPopover) [aPopover dismissPopoverAnimated:NO];
	
	ColorPickerViewController *vc = [[ColorPickerViewController alloc] initWithNibName:@"ColorPickerViewController" bundle:nil];
	[vc setMyDelegate:self];
	
	aPopover = [[UIPopoverController alloc] initWithContentViewController:vc];
	[aPopover setPopoverContentSize:vc.view.frame.size];
	[vc release];
	
	[aPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)clickFont:(id)sender
{
	if (aPopover) [aPopover dismissPopoverAnimated:NO];
	
	FontPickerViewController *vc = [[FontPickerViewController alloc] initWithNibName:@"FontPickerViewController" bundle:nil];
	[vc setMyDelegate:self];
	
	aPopover = [[UIPopoverController alloc] initWithContentViewController:vc];
	[aPopover setPopoverContentSize:vc.view.frame.size];
	[vc release];
	
	[aPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)clickFontSize:(id)sender
{
	if (aPopover) [aPopover dismissPopoverAnimated:NO];
	
	SizeViewController *vc = [[SizeViewController alloc] initWithNibName:@"SizeViewController" bundle:nil];
	[vc setMyDelegate:self];
	
	aPopover = [[UIPopoverController alloc] initWithContentViewController:vc];
	[aPopover setPopoverContentSize:vc.view.frame.size];
	[aPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

	[vc setSliderValue:[txtContent.font pointSize] minValue:10.0 maxValue:42.0];
	[vc release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	touchStart = [[touches anyObject] locationInView:self.view];
	isResizing = (self.view.bounds.size.width - touchStart.x < kResizeThumbSize && self.view.bounds.size.height - touchStart.y < kResizeThumbSize);
	
	if (isResizing)
	{
		touchStart = CGPointMake(touchStart.x - self.view.bounds.size.width, touchStart.y - self.view.bounds.size.height);
	}
}

- (void)fixPosition
{
	CGAffineTransform concat;
	if (self.view.frame.origin.x < 0)
	{
		concat = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeTranslation(-self.view.frame.origin.x, 0.0f));
		self.view.transform = concat;
	}
	
	if (self.view.frame.origin.y < 0)
	{
		concat = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeTranslation(0.0f, -self.view.frame.origin.y));
		self.view.transform = concat;
	}
	
	float dx = (self.view.frame.origin.x + self.view.frame.size.width) - self.view.superview.frame.size.width;
	if (dx > 0.0f)
	{
		concat = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeTranslation(-dx, 0.0f));
		self.view.transform = concat;
	}
	
	float dy = (self.view.frame.origin.y + self.view.frame.size.height) - self.view.superview.frame.size.height;
	if (dy > 0.0f)
	{
		concat = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeTranslation(0.0f, -dy));
		self.view.transform = concat;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
	
	if (isResizing)
	{
		CGFloat width = touchPoint.x - touchStart.x;
		CGFloat height = touchPoint.y - touchStart.y;
		
		if (width >= minWidth && height >= minHeight)
		{
			self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, width, height);
			[self setContentFrame];
		}
	}
	else
	{
		self.view.center = CGPointMake(self.view.center.x + touchPoint.x - touchStart.x, self.view.center.y + touchPoint.y - touchStart.y);
	}
	
	// Uncomment to force boundary checks
	[self fixPosition];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 1)
	{
		//[self hideTools];
		[self showHideToolbar];
	}/*
	else if ([touch tapCount] == 2)
	{
		
	}*/
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self fixPosition];
	[self setContentFrame];
	[txtContent becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	RELEASE_SAFE(strContent);
	RELEASE_SAFE(fontColor);
	RELEASE_SAFE(fontName);
	RELEASE_SAFE(aPopover);
    RELEASE_SAFE(imgTextBG);
    RELEASE_SAFE(imgResize);
    RELEASE_SAFE(txtContent);
    RELEASE_SAFE(toolbar);
    
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

@end
