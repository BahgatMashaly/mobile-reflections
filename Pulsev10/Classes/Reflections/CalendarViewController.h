//
//  CalendarViewController.h
//  MobileJabber
//
//  Created by SonNT on 12/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLCalendarView.h"
#import "CheckmarkTile.h"

@interface CalendarViewController : UIViewController <KLCalendarViewDelegate>
{
	KLCalendarView *calendarView;
}

- (void)createCalendar;
- (void)createCalendarWithDate:(NSDate *)aDate;

@end
