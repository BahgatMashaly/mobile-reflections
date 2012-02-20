//
//  HomeViewController.h
//  MobileJabber
//
//  Created by Shivang Vyas on 6/20/11.
//  Copyright 2011 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewController.h"
#import "EventListDelegate.h"
#import "EventListDataSource.h"
#import "URLConnectionDelegate.h"
#import "ContactListViewController.h"

@interface HomeViewController : UIViewController <contactListViewdelegate,UISearchBarDelegate,UIPopoverControllerDelegate, NSFetchedResultsControllerDelegate>{
	UIPopoverController *ObjPopoverController_ContactListViewOptions;
	BOOL IsNotificationShowed;
	IBOutlet UIImageView * imvBackgroundImage;
	ChatViewController * ObjChatViewController;
	EventListDelegate * ObjEventListDelegate;
	EventListDataSource * ObjEventListDataSource;
	IBOutlet UITableView * TblEvent;
	URLConnectionDelegate * ObjURLConnectionDelegate;
	IBOutlet UIImageView * imvUserProfile;
	IBOutlet UILabel * lblUserName;
	ContactListViewController * ObjContactListViewController;
	NSInteger groupIndexPathSection;

}
@property (nonatomic,retain) UIImageView * imvBackgroundImage;

-(IBAction)BtnNotificationsTabbed:(id)sender;
-(void)UpdateEventList:(id)sender;
-(void)reinit;
-(IBAction)BtnEditWeatherTabbed:(id)sender;
-(void)GetWeatherFromLocation:(NSString*)strLocation;
-(IBAction)BtnAddEventTabbed:(id)sender;
-(void)AddEventIQSent:(id)sender;
-(void)GetUserProfileImage;
-(IBAction)BtnMenuTabbed:(id)sender;
-(IBAction)BtnThemesTabbed:(id)sender;
-(IBAction)BtnSettingTabbed:(id)sender;
-(IBAction)BtnViewUserProfileTabbed:(id)sender;


@end
