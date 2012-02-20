//
//  ColorPickerViewController.m
//  MobileReflections
//
//  Created by SonNT on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ColorPickerViewController.h"

#define kBrightnessGradientPlacent CGRectMake(10, 434, 300, 40)
#define kColorWindowFrame CGRectMake(66, 10, 188, 44)
#define kHueSatFrame CGRectMake(11, 170, 298, 257)

#define kHueSatImage @"colormap.png"
#define kInitialBrightness 0.5

#define kBrightnessEpsilon 0.05
#define kHueEpsilon 0.005
#define kSatEpsilon 0.005

#define kAnimationDuration 0.6

#define kMatrixWidth 298.0
#define kMatrixHeight 257.0

#define kXAxisOffset 11.0
#define kYAxisOffset 170.0

#define kBrightBarYCenter 451

@implementation ColorPickerViewController
@synthesize myDelegate;

- (IBAction)clickDone:(id)sender
{
	[myDelegate setSelectedColor:[UIColor colorWithHue:currentHue saturation:currentSaturation brightness:currentBrightness alpha:1.0]];
}

- (NSString *)hexStringFromColor:(CGColorRef)theColor
{
	const CGFloat *c = CGColorGetComponents(theColor);  
	CGFloat r, g, b;  
	r = c[0];  
	g = c[1];  
	b = c[2];  
	
	// Fix range if needed
	if (r < 0.0f) r = 0.0f;
	if (g < 0.0f) g = 0.0f;
	if (b < 0.0f) b = 0.0f;
	
	if (r > 1.0f) r = 1.0f;
	if (g > 1.0f) g = 1.0f;
	if (b > 1.0f) b = 1.0f;
	
	// Convert to hex string between 0x00 and 0xFF  
	return [NSString stringWithFormat:@"#%02X%02X%02X",	(int)(r * 255), (int)(g * 255), (int)(b * 255)];
}  

- (void)getStringForHSL:(float)hue saturation:(float)sat brightness:(float)bright
{
	[Hcoords setText:[NSString stringWithFormat:@"%d",(int)(hue*255)]];
	[Scoords setText:[NSString stringWithFormat:@"%d",(int)(sat*255)]];
	[Lcoords setText:[NSString stringWithFormat:@"%d",(int)(bright*255)]];
}

- (void)getStringForRGB:(CGColorRef)theColor
{
	const CGFloat *c = CGColorGetComponents(theColor);
	CGFloat r, g, b;
	r = c[0];
	g = c[1];
	b = c[2];
	
	[Rcoords setText:[NSString stringWithFormat:@"%d",(int)(r*255)]];
	[Gcoords setText:[NSString stringWithFormat:@"%d",(int)(g*255)]];
	[Bcoords setText:[NSString stringWithFormat:@"%d",(int)(b*255)]];
}

- (void)updateHueSatWithMovement:(CGPoint)position
{
	currentHue = (position.x - kXAxisOffset) / kMatrixWidth;
	currentSaturation = 1.0 - (position.y - kYAxisOffset) / kMatrixHeight;
	
	UIColor *forGradient = [UIColor colorWithHue:currentHue 
									  saturation:currentSaturation 
									  brightness: kInitialBrightness 
										   alpha:1.0];
	
	[gradientView setColor:[forGradient CGColor]];
	[gradientView setupGradient];
	[gradientView setNeedsDisplay];
	
	currentColor  = [UIColor colorWithHue:currentHue 
							   saturation:currentSaturation 
							   brightness:currentBrightness
									alpha:1.0];
	
	[viewPreview setBackgroundColor:currentColor];
	[Hex setText:[self hexStringFromColor:[currentColor CGColor]]]; 
	[self getStringForRGB:[currentColor CGColor]];
	[self getStringForHSL:currentHue saturation:currentSaturation brightness:currentBrightness];
}

- (void)updateBrightnessWithMovement:(CGPoint)position
{
	currentBrightness = 1.0 - (position.x / gradientView.frame.size.width) + kBrightnessEpsilon;
	
	UIColor *forColorView  = [UIColor colorWithHue:currentHue 
										saturation:currentSaturation 
										brightness:currentBrightness
											 alpha:1.0];
	
	[viewPreview setBackgroundColor:forColorView];
	[Hex setText:[self hexStringFromColor:[forColorView CGColor]]]; 
	[self getStringForRGB:[forColorView CGColor]];
	[self getStringForHSL:currentHue saturation:currentSaturation brightness:currentBrightness];
}

#pragma mark - Touch Functions

// Scales down the view and moves it to the new position. 
- (void)animateView:(UIImageView *)theView toPosition:(CGPoint)thePosition
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:kAnimationDuration];
	
	// Set the center to the final postion
	theView.center = thePosition;
	
	// Set the transform back to the identity, thus undoing the previous scaling effect.
	theView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];	
}

-(void) dispatchTouchEvent:(CGPoint)position
{
	if (CGRectContainsPoint(colorMatrixFrame, position))
	{
		[self animateView:imgCrossHairs toPosition:position];
		[self updateHueSatWithMovement:position];
	}
	else if (CGRectContainsPoint(gradientView.frame, position))
	{
		CGPoint newPos = CGPointMake(position.x, kBrightBarYCenter);
		[self animateView:imgBrightnessBar toPosition:newPos];
		[self updateBrightnessWithMovement:position];
	}
	else
	{
		//		printf("X Of the touch in grad view is : %f\n",position.x);
		//		printf("Y Of the touch in grad view is : %f\n",position.y);
	}
}

// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches)
	{
		[self dispatchTouchEvent:[touch locationInView:self.view]];
	}
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches)
	{
		[self dispatchTouchEvent:[touch locationInView:self.view]];
	}
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
        // Custom initialization
		gradientView = [[GradientView alloc] initWithFrame:kBrightnessGradientPlacent];
		[gradientView setColor:[[UIColor yellowColor] CGColor]];
		[self.view addSubview:gradientView];
		[self.view sendSubviewToBack:gradientView];
		[self.view setMultipleTouchEnabled:YES];

		colorMatrixFrame = kHueSatFrame;
		UIImageView *hueSatImage = [[UIImageView alloc] initWithFrame:colorMatrixFrame];
		[hueSatImage setImage:[UIImage imageNamed:kHueSatImage]];
		[self.view addSubview:hueSatImage];
		[self.view sendSubviewToBack:hueSatImage];
		[hueSatImage release];
		
		currentBrightness = kInitialBrightness;
		currentColor = [[UIColor alloc] init];
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
	CGFloat x = currentBrightness * gradientView.frame.size.width;
	imgBrightnessBar.center = CGPointMake(x, kBrightBarYCenter);
	
	[gradientView setupGradient];
	[gradientView setNeedsDisplay];
	[Hex setFont:[UIFont fontWithName:@"helvetica" size:16]];
	[self.view sendSubviewToBack:viewPreview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
