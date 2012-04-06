//
//  BackgroundNoteViewController.m
//  MobileJabber
//
//  Created by Phan Ba Minh on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackgroundNoteViewController.h"
#import "Define.h"

@implementation BackgroundNoteViewController

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        m_ImageInit = [image retain];
    }
    return self;
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

- (void)dealloc {
    RELEASE_SAFE(m_ImageInit);
    RELEASE_SAFE(m_ImageViewBackground);
    
    [super dealloc];
}

- (UIImage *)getImageInit
{
    return m_ImageInit;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    m_ImageViewBackground.image = m_ImageInit;
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
