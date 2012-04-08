//
//  ReflectionViewController.m
//  MobileReflections
//
//  Created by SonNT on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReflectionViewController.h"
#import "Define.h"

@implementation ReflectionViewController

#pragma mark - Calendar view delegate

- (NSDate *)createDate:(int)aDay month:(int)aMonth year:(int)aYear
{
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setDay:aDay];
	[components setMonth:aMonth];
	[components setYear:aYear];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	return [gregorian dateFromComponents:components];
}

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

	selectedDate = [[calendarView getDateOfCalendarInfo] retain];
	NSLog(@"selected date : %@", selectedDate);

    CGRect f = clip.frame;

	if (isMonthView == YES)
	{
		f.size.height = 30;
		clip.frame = f;
		[clip setClipsToBounds:YES];
	}
	else
	{
		NSInteger weeks = [calendarView selectedMonthNumberOfWeeks];

		CGFloat adjustment;
		switch (weeks)
		{
			case 4:
				//adjustment = (92/321)*360+30;
				adjustment = 140;
				break;
			case 5:
				//adjustment = (46/321)*360;
				adjustment = 90;
				break;
			case 6:
				adjustment = 45;
				break;
			default:
				adjustment = 0;
				break;
		}
		
		f.size.height = 360 - adjustment;
		clip.frame = f;
		[clip setClipsToBounds:YES];
	}
/*
	CGFloat x = 0;
	CGFloat y = 44 + f.size.height;
	CGFloat width = lblTable.frame.size.width;
	CGFloat height = 644 - f.size.height;
	[lblTable setFrame:CGRectMake(x, y, width, height)];
	[tblReflectionList setFrame:CGRectMake(x+1, y+1, width-2, height-2)];
	[self.view bringSubviewToFront:tblReflectionList];

	tile = nil;
*/
}

#pragma mark - Button Events

- (IBAction)clickBtnCalendar:(id)sender
{
	if (aPopover) [aPopover dismissPopoverAnimated:NO];
	
	CalendarViewController *vc = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
	
	aPopover = [[UIPopoverController alloc] initWithContentViewController:vc];
	[aPopover setPopoverContentSize:vc.view.frame.size];
	[aPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];

	if (selectedDate) [vc createCalendarWithDate:selectedDate];
	else [vc createCalendar];

	[vc release];
}

- (IBAction)clickCommentList:(id)sender
{
	if (reflection_id > 0)
	{
		CommentViewController *vc = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
		[self presentModalViewController:vc animated:YES];
		[vc setReflectionID:reflection_id];
		[vc release];
	}
	else [common alertChooseReflection];
}

- (void)clickEdit:(UIButton *)btnEdit
{
	int tag = [btnEdit tag];
	NSLog(@"btnEdit at : %d", tag);
}

- (void)clickAddNew
{
	CreateReflectionViewController *vc = [[CreateReflectionViewController alloc] initWithNibName:@"CreateReflectionViewController" bundle:nil];
	[self presentModalViewController:vc animated:NO];
	[vc release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[selectedDate release];
	[calendarView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)createCalendar
{
	calendarView = [[KLCalendarView alloc] initWithFrame:CGRectMake(0, 0, 320, 360) delegate:self];
	[viewCalendar addSubview:calendarView];
	
	UIView *clip = calendarView.superview;
    CGRect f = clip.frame;
	f.size.height = 30;
	clip.frame = f;
	[clip setClipsToBounds:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	appDelegate = (MobileJabberAppDelegate *)[[UIApplication sharedApplication] delegate];
	isMonthView = YES;
	selectedDate = [[NSDate alloc] init];
	NSLog(@"selected date : %@", selectedDate);
	[self createCalendar];
	//NSLog(@"%@ - %@", [appDelegate strUserName], [appDelegate encUserStr]);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (appDelegate.strFullName != nil && ![appDelegate.strFullName isEqualToString:@""])
	{
		lblUserName.text = appDelegate.strFullName;
	}
	else
	{
		lblUserName.text = [[[[appDelegate.xmppStream myJID] bare] componentsSeparatedByString:@"@"] objectAtIndex:0];
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(setUserFullName:) 
												 name:NSNOTIFICATION_SET_USER_FULL_NAME 
											   object:nil];
	
    /*
	 [[NSNotificationCenter defaultCenter] addObserver:self 
	 selector:@selector(SetUserAvtarImage:) 
	 name:NSNOTIFICATION_USER_AVTAR 
	 object:nil];
     */
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(UpdateEventList:) 
												 name:NSNOTIFICATION_SHOW_EVENTS 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(LogOut:) 
												 name:NOTIFICATION_LOGOUT 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(ChangeTheme:) 
												 name:NSNOTIFICATION_CHANGE_APPLICATION_THEME 
											   object:nil];
	
	
	NSMutableDictionary * dictTheme = [[NSMutableDictionary alloc] initWithContentsOfFile:appDelegate.strPath];
	
	if([[dictTheme valueForKey:@"ThemeNumber"] isEqualToString:@"1"])
	{
		appDelegate.ThemeNumber = 1;
		imvBackgroundImage.image = [UIImage imageNamed:@"wood-floor-wallpapers_6855_1280x800.jpg"];
    }
    else if([[dictTheme valueForKey:@"ThemeNumber"] isEqualToString:@"2"])
	{
		appDelegate.ThemeNumber = 2;
		imvBackgroundImage.image = [UIImage imageNamed:@"theme2.jpg"];
	}else
	{
		appDelegate.ThemeNumber = 3;		
		imvBackgroundImage.image = [UIImage imageNamed:@"theme3.jpg"];
	}
	[dictTheme release];
	
    [self setUserFullName:nil];
	[self.view addSubview:appDelegate.menuToolBar];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:NO];
	[tblReflectionList reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Edit Reflection View Controller Protocol

- (void)reloadReflectionListAtIndex:(NSIndexPath *)indexPath {
    [tblReflectionList reloadData];
}

#pragma mark -
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{        
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0, 320, 44)] autorelease]; // x,y,width,height
	
	UIImageView *imgBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"b_01.png"]];
	[imgBG setFrame:[headerView frame]];
	[headerView addSubview:imgBG];
	
    UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];    
    reportButton.frame = CGRectMake(280, 7, 30.0, 30.0); // x,y,width,height
	[reportButton setImage:[UIImage imageNamed:@"b_03.png"] forState:UIControlStateNormal];
    [reportButton addTarget:self 
                     action:@selector(clickAddNew)
           forControlEvents:UIControlEventTouchUpInside];        
	
    [headerView addSubview:reportButton];
    return headerView;    
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Reflections List";
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[appDelegate objOutput] arrReflectionList] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ReflectionCell *cell = (ReflectionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
		cell = [[[ReflectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	//save to arrReflectionList : id, title, image, private, date

	NSArray *item = [[[appDelegate objOutput] arrReflectionList] objectAtIndex:[indexPath row]];
    
	NSString *strDate = [item objectAtIndex:4];
	NSString *aDay = [strDate substringToIndex:3];
	NSString *aDate = [strDate substringToIndex:[strDate length]-6];
	aDate = [aDate substringFromIndex:[aDate length]-2];

	//NSLog(@"strDate : %@", strDate);
	//NSLog(@"aDay : %@", aDay);
	//NSLog(@"aDate : %@", aDate);
	
	[cell.lblDay setText:aDay];
	[cell.lblDate setText:aDate];
	[cell.lblTitle setText:[item objectAtIndex:1]];
	[cell.lblCommentsRating setText:[NSString stringWithFormat:@"%@ %@", @"0 comments.", @"Not rating."]];
	
	UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnEdit.frame = CGRectMake(280, 12, 29.0, 28.0); // x,y,width,height
	[btnEdit setTag:[[item objectAtIndex:0] intValue]];
	[btnEdit setImage:[UIImage imageNamed:@"b_02.png"] forState:UIControlStateNormal];
    [btnEdit addTarget:self 
                action:@selector(clickEdit:)
      forControlEvents:UIControlEventTouchUpInside];
	[cell addSubview:btnEdit];
    
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *item = [[[appDelegate objOutput] arrReflectionList] objectAtIndex:[indexPath row]];
    
//	reflection_id = [[item objectAtIndex:0] intValue];
//	//NSLog(@"imgPath : %@", [item objectAtIndex:2]);
//	
	[lblTitleOfReflection setText:[item objectAtIndex:ENUM_INDEX_REFLECTION_DATA_TITILE]];
	[lblDateOfReflection setText:[item objectAtIndex:ENUM_INDEX_REFLECTION_DATA_DATE]];
    
//	[imgContent setImage:[UIImage imageWithContentsOfFile:[item objectAtIndex:2]]];
//	//[imgContent setImage:[UIImage imageWithContentsOfFile:[item objectAtIndex:2]] forState:UIControlStateNormal];
    
    // MinhPB 2012/04/04
    RELEASE_SAFE(m_EditVC);
    m_EditVC = [[EditReflectionViewController alloc] initWithFrame:imgContent.frame andArrayData:[item objectAtIndex:ENUM_INDEX_REFLECTION_DATA_COMPONENTS] andTitle:[item objectAtIndex:ENUM_INDEX_REFLECTION_DATA_TITILE] andDelegate:self atIndex:indexPath];
    [self.view addSubview:m_EditVC.view];
}

#pragma mark -
#pragma mark Custom or IBAction Methods

- (void)setUserFullName:(id)sender
{
	if (appDelegate.strFullName != nil && 
		![appDelegate.strFullName isEqualToString:@""])
	{
		
		lblUserName.text = appDelegate.strFullName;
	}
	else
	{
		lblUserName.text = [[[[appDelegate.xmppStream myJID] bare] componentsSeparatedByString:@"@"] objectAtIndex:0];
	}
	imvUserProfile.image = [appDelegate getSelfImage];				
}

- (IBAction)BtnViewUserProfileTabbed:(id)sender
{
	[appDelegate ShowUserProfile:sender info:nil];
}

- (IBAction)BtnThemesTabbed:(id)sender
{
	[appDelegate BtnThemesTabbed:sender];
}

- (IBAction)BtnSettingTabbed:(id)sender
{
	[appDelegate BtnSettingTabbed:sender];
}

- (IBAction)BtnMenuTabbed:(id)sender
{
	[appDelegate btnNameBarTapped:sender];
}

-(void)SetUserAvtarImage:(id)sender
{
	if([sender object]!=nil && [[sender object] length] >0)
	{
		imvUserProfile.image = [UIImage imageWithData:[sender object]];
	}
	else
	{
		imvUserProfile.image = [UIImage imageNamed:@"no_Img.jpg"];
	}
}

- (void)GetUserProfileImage
{
	imvUserProfile.image = [appDelegate getSelfImage];
}

- (void)ChangeTheme:(id)sender
{
	if([[sender object] isEqualToString:@"1"])
	{
		imvBackgroundImage.image = [UIImage imageNamed:@"wood-floor-wallpapers_6855_1280x800.jpg"];
	}
	else if([[sender object] isEqualToString:@"2"])
	{
		imvBackgroundImage.image = [UIImage imageNamed:@"theme2.jpg"];
	}
	else if([[sender object] isEqualToString:@"3"])
	{
		imvBackgroundImage.image = [UIImage imageNamed:@"theme3.jpg"];
	}
}

- (void)LogOut:(id)sender
{
	[appDelegate.ObjPopoverController_Menu dismissPopoverAnimated:YES];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end