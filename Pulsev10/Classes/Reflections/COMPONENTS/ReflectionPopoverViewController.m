//
//  ReflectionPopoverViewController.m
//  MobileJabber
//
//  Created by Phan Ba Minh on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReflectionPopoverViewController.h"
#import "Define.h"

@implementation ReflectionPopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_ArrayData = [NSMutableArray new];
    }
    return self;
}

- (id)initWithData:(NSMutableArray *)arrayData andDelegate:(id)delegate {
    self = [super init];
    if (self) {
        if (arrayData) {
            m_ArrayData = [arrayData retain];
        }
        m_Delegate = delegate;
        
        if (m_ArrayData) {
            self.view.frame = FRAME(0, 0, self.view.frame.size.width, ([m_ArrayData count] == 0 ? 1 : ([m_ArrayData count] > 5 ? 5 : 5)) * HEIGHT_REFLECTION_POPOVER_CELL);
        }
    }
    return self;
}

- (void)dealloc {
    RELEASE_SAFE(m_ArrayData);
    [super dealloc];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View Protocol

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([m_Delegate respondsToSelector:@selector(didSelectReflectionPopoeverCellOfArray:atIndex:)]) {
        [m_Delegate didSelectReflectionPopoeverCellOfArray:m_ArrayData atIndex:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HEIGHT_REFLECTION_POPOVER_CELL;
}

#pragma mark - Table View DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_ArrayData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        // Show disclosure only if this view is related to showing nearby places, thus allowing
        // the user to check-in.
        
    }
    return cell;
}

@end
