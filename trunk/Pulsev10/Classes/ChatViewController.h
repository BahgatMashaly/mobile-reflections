//
//  ChatViewController.h
//  MobileJabber
//
//  Created by Shivang Vyas on 6/30/11.
//  Copyright 2011 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TblContactListDataSource.h"
#import "TblContactListDelegate.h"
#import "ContactViewOptionsViewController.h"
#import "TblActiveChatListDataSource.h"
#import "TblActiveChatListDelegagte.h"

#import "TblActivePollListDataSource.h"
#import "TblActivePollListDelegate.h"

#import "ChatWindowViewController.h"

#import "GroupOptionPopoverViewController.h"
@interface ChatViewController : UIViewController <UITextFieldDelegate,UIPopoverControllerDelegate,UISearchBarDelegate,UIPopoverControllerDelegate, NSFetchedResultsControllerDelegate>{
	IBOutlet UIImageView *imvBackground;
	TblContactListDataSource *ObjTblContactListDataSource;
	TblContactListDelegate *ObjTblContactListDelegate;
	IBOutlet UITableView * TblContactList;
	BOOL IsContactEditable;
	BOOL IsActiveChatEditable;
	
	BOOL IsNotificationShowed;
	ContactViewOptionsViewController * ObjContactViewOptionsViewController;
	UIPopoverController * ObjPopoverController_ContactListViewOptions;
	IBOutlet UITableView * tblActiveChatList;
	TblActiveChatListDataSource * ObjTblActiveChatListDataSource;
	TblActiveChatListDelegagte * ObjTblActiveChatListDelegagte;
	ChatWindowViewController * ObjChatWindowViewController;
	IBOutlet UITextField * txtMyStatus;
	IBOutlet UISearchBar * ObjSearchBar;
	
	IBOutlet UIImageView * imvUserProfile;
	IBOutlet UILabel * lblUserName;
	UIView *viewFileDisplay;
    BOOL IsCollapsed;
	
	IBOutlet UITableView * tblActivePollList;
	TblActivePollListDataSource * ObjTblActivePollListDataSource;
	TblActivePollListDelegate * ObjTblActivePollListDelegate;
	
	UIPopoverController *ObjPopoverController_GroupOptionListView;
	NSInteger groupIndexPathSection;

}


-(IBAction)BtnEditContactsTabbed:(id)sender;
-(IBAction)BtnEditActiveChatsTabbed:(id)sender;
-(IBAction)BtnShowContactViewOptionsTabbed:(id)sender;
-(IBAction)BtnAddNewUserTabbed:(id)sender;
-(void)removePollWindow:(id)sender;
-(void)UpdateActiveChatList:(id)sender;
-(void)UpdateActivePollList:(id)sender;
-(void)UpdateContactList:(id)sender;
-(IBAction)BtnUpdateStatusTabbed:(id)sender;

-(IBAction)BtnUserNameTabbed:(id)sender;
-(IBAction)BtnThemesTabbed:(id)sender;
-(IBAction)BtnSettingTabbed:(id)sender;

-(void)ShowChatWindowWithoutNotification:(id)sender;
-(IBAction)BtnViewUserProfileTabbed:(id)sender;
-(IBAction)BtnCollapseActiveChat:(id)sender;

@end
