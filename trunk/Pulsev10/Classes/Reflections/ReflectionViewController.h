//
//  ReflectionViewController.h
//  MobileReflections
//
//  Created by SonNT on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MobileJabberAppDelegate.h"
#import "CalendarViewController.h"
#import "CreateReflectionViewController.h"
#import "CommentViewController.h"

#import "KLCalendarView.h"
#import "CheckmarkTile.h"

#import "ReflectionCell.h"

@interface ReflectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, KLCalendarViewDelegate>
{
	MobileJabberAppDelegate *appDelegate;

	IBOutlet UISegmentedControl *segSelection;
	IBOutlet UIView *viewCalendar;
	IBOutlet UITableView *tblReflectionList;
	
	IBOutlet UILabel *lblTitleOfReflection;
	IBOutlet UILabel *lblDateOfReflection;
	IBOutlet UIImageView *imgContent;
	IBOutlet UIImageView *imvBackgroundImage;
	
	IBOutlet UIImageView * imvUserProfile;
	IBOutlet UILabel * lblUserName;
	
	int reflection_id;
	
	NSDate *selectedDate;
	KLCalendarView *calendarView;
	BOOL isMonthView;
	
	UIPopoverController *aPopover;
}

- (IBAction)clickBtnCalendar:(id)sender;

- (void)setUserFullName:(id)sender;
- (void)GetUserProfileImage;
- (IBAction)BtnMenuTabbed:(id)sender;
- (IBAction)BtnThemesTabbed:(id)sender;
- (IBAction)BtnSettingTabbed:(id)sender;
- (IBAction)BtnViewUserProfileTabbed:(id)sender;

@end
