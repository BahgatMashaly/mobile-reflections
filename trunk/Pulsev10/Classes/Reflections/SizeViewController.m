//
//  SizeViewController.m
//  MobileReflections
//
//  Created by SonNT on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SizeViewController.h"

@implementation SizeViewController
@synthesize myDelegate;

- (void)setSliderValue:(CGFloat)current minValue:(CGFloat)min maxValue:(CGFloat)max
{
	[sliderSize setMinimumValue:min];
	[sliderSize setMaximumValue:max];
	[sliderSize setValue:current];
	
	[txtSize setText:[NSString stringWithFormat:@"%.0f", [sliderSize value]]];
}

- (IBAction)sliderChanged:(id)sender
{
	[txtSize setText:[NSString stringWithFormat:@"%.0f", [sliderSize value]]];
}

- (IBAction)clickDone:(id)sender
{
	[myDelegate didSelectSize:[sliderSize value]];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
	return YES;
}

@end
