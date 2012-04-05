//
//  PaintNoteViewController.m
//  MobileReflections
//
//  Created by SonNT on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PaintNoteViewController.h"
#import "Define.h"

@implementation PaintNoteViewController
@synthesize myDelegate;

- (id)initWithImageView:(UIImageView *)imageView {
    self = [super init];
    if (self) {
        m_ImageViewInit = [imageView retain];
    }
    return self;
}

- (UIImageView *)getImageViewDrawing {
    return imgDrawingboard;
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
	color = [selectedColor retain];
	[aPopover dismissPopoverAnimated:YES];
}

- (IBAction)clickPen:(id)sender
{
	eraser = NO;
	highlighter = NO;
	
	[imgEraser setHidden:YES];
}

- (IBAction)clickHighlight:(id)sender
{
	eraser = NO;
	highlighter = YES;
	[imgEraser setHidden:YES];
	
	color = [UIColor yellowColor];
	[sliderStroke setValue:[sliderStroke maximumValue] / 2];
	[self setStrokeSize];
}

- (IBAction)clickEraser:(id)sender
{
	eraser = YES;
	highlighter = NO;
	
	[imgEraser setHidden:NO];
}

- (IBAction)clickColor:(id)sender
{
	if (aPopover) [aPopover dismissPopoverAnimated:NO];
	
	ColorPickerViewController *vc = [[ColorPickerViewController alloc] initWithNibName:@"ColorPickerViewController" bundle:nil];
	[vc setMyDelegate:self];
	
	aPopover = [[UIPopoverController alloc] initWithContentViewController:vc];
	[aPopover setPopoverContentSize:vc.view.frame.size];
	[vc release];
	
	[aPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (IBAction)clickDelete:(id)sender
{
	[myDelegate deletePaintview];
}

- (IBAction)clickDone:(id)sender
{
	[self hideTools];
}

- (void)setStrokeSize
{
	[txtStrokeSize setText:[NSString stringWithFormat:@"%.0f", [sliderStroke value]]];
	strokeSize = [sliderStroke value];
}

- (IBAction)sliderStrokeChanged:(id)sender
{
	[self setStrokeSize];
}

- (void)showHideToolbar
{
	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: 0.75];
	
	if ([toolbar alpha] == 0.0) [toolbar setAlpha:1.0];
	else [toolbar setAlpha:0.0];
	
	[UIView commitAnimations];
}

- (void)showTools
{
	[toolbar setHidden:NO];
	[lblStroke setHidden:NO];
	[self.view setUserInteractionEnabled:YES];
}

- (void)hideTools
{
	[toolbar setHidden:YES];
	[lblStroke setHidden:YES];
	[self.view setUserInteractionEnabled:NO];
}

-(CGPoint)midPoint:(CGPoint)p1 point:(CGPoint)p2
{
	return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	previousPoint1 = [touch previousLocationInView:self.view];
	previousPoint2 = [touch previousLocationInView:self.view];
	currentPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	previousPoint2 = previousPoint1;
	previousPoint1 = [touch previousLocationInView:self.view];
	currentPoint = [touch locationInView:self.view];
	
	// calculate mid point
	CGPoint mid1 = [self midPoint:previousPoint1 point:previousPoint2]; 
	CGPoint mid2 = [self midPoint:currentPoint point:previousPoint1];
	
	UIGraphicsBeginImageContext(self.view.frame.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[imgDrawingboard.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	
	if(eraser)
	{
		[imgEraser setCenter:currentPoint];

		if ([touch tapCount] == 1)
		{
			CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
			CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
			CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 25.0); // for size
			CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0); //values for R, G, B, and Alpha
		}
	}
	else
	{
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), strokeSize);
		CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [color CGColor]);
		
		if (highlighter) CGContextSetAlpha(UIGraphicsGetCurrentContext(), 0.1f);
	}
	
	CGContextMoveToPoint(context, mid1.x, mid1.y);
	
	// Use QuadCurve is the key
	CGContextAddQuadCurveToPoint(context, previousPoint2.x, previousPoint2.y, mid1.x, mid1.y); 
	CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y); 
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	
	imgDrawingboard.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 1)
	{
		//[self showHideToolbar];
	}
	else if ([touch tapCount] == 2)
	{
		[self showTools];
	}
}

#pragma mark - View lifecycle

- (void)dealloc
{
	RELEASE_SAFE(color);
    RELEASE_SAFE(lblStroke);
	RELEASE_SAFE(sliderStroke);
	RELEASE_SAFE(txtStrokeSize);
	RELEASE_SAFE(toolbar);
	RELEASE_SAFE(imgDrawingboard);
	RELEASE_SAFE(imgEraser);
    RELEASE_SAFE(aPopover);
    RELEASE_SAFE(m_ImageViewInit);
    
	[super dealloc];
}

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

	// Do any additional setup after loading the view from its nib.
    if (m_ImageViewInit) {
        imgDrawingboard.image = m_ImageViewInit.image;
        [self hideTools];
        [self setStrokeSize];
        color = [UIColor blackColor];
        eraser = NO;
        highlighter = NO;
    }
    else {
        [self setStrokeSize];
        color = [UIColor blackColor];
        eraser = NO;
        highlighter = NO;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

@end
