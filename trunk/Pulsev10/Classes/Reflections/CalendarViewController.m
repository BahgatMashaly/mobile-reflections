//
//  CalendarViewController.m
//  MobileJabber
//
//  Created by SonNT on 12/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalendarViewController.h"

@implementation CalendarViewController

#pragma mark - Calendar view delegate

- (void)calendarView:(KLCalendarView *)calendarView tappedTile:(KLTile *)aTile
{
	NSLog(@"Date Selected is %@",[aTile date]);
	[aTile flash];
}

- (KLTile *)calendarView:(KLCalendarView *)calendarView createTileForDate:(KLDate *)date
{
	CheckmarkTile *aTile = [[CheckmarkTile alloc] init];
	return aTile;
}

- (void)didChangeMonths
{
    UIView *clip = calendarView.superview;
    if (!clip) return;
    
    CGRect f = clip.frame;
	
	NSInteger weeks = [calendarView selectedMonthNumberOfWeeks];

	CGFloat adjustment;
	switch (weeks)
	{
		case 4:
			adjustment = 140;
			break;
		case 5:
			adjustment = 90;
			break;
		case 6:
			adjustment = 40;
			break;
		default:
			adjustment = 0;
			break;
	}

	f.size.height = 360 - adjustment;
	clip.frame = f;
	[clip setClipsToBounds:YES];
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

- (void)createCalendarWithDate:(NSDate *)aDate
{
	calendarView = [[KLCalendarView alloc] initWithFrame:CGRectMake(0, -45, 320, 320) delegate:self withDate:aDate];
	[self.view addSubview:calendarView];
}

- (void)createCalendar
{
	calendarView = [[KLCalendarView alloc] initWithFrame:CGRectMake(0, -45, 320, 320) delegate:self];
	[self.view addSubview:calendarView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	[calendarView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

@end
