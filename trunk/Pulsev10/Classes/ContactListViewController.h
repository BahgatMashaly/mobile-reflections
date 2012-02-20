//
//  ContactListViewController.h
//  MobileJabber
//
//  Created by Shivang Vyas on 7/25/11.
//  Copyright 2011 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TblContactListDelegate.h"
#import "TblContactListDataSource.h"
#import "ContactListViewController.h"
#import "ContactViewOptionsViewController.h"
#import "UserOptionPopoverViewController.h"
#import "GroupOptionPopoverViewController.h"
#import "XMPPUserCoreDataStorage.h"

@protocol contactListViewdelegate;

@interface ContactListViewController : UIViewController  <UIPopoverControllerDelegate, MFMailComposeViewControllerDelegate>{
	TblContactListDelegate * ObjTblContactListDelegate;
	TblContactListDataSource * ObjTblContactListDataSource;
	IBOutlet UITableView * TblContactList;
	BOOL IsContactEditable;
	ContactViewOptionsViewController * ObjContactViewOptionsViewController;
	UIPopoverController * ObjPopoverController_ContactListViewOptions;
	UIPopoverController *ObjPopoverController_UserOptionListView;
	UIPopoverController *ObjPopoverController_GroupOptionListView;
	NSInteger userIndexPathSection;
	NSInteger userIndexPathRow;
	NSInteger groupIndexPathSection;
	id<contactListViewdelegate> del;
    
    IBOutlet UIButton *BtnAddContact;
    
}
@property(nonatomic,retain) id<contactListViewdelegate> del;
-(IBAction)BtnEditContactsTabbed:(id)sender;
-(void)FilterContacts:(UISearchBar*)searchBar;
-(void)GroupByRosters:(NSMutableDictionary*)dictRosterList;
-(IBAction)BtnShowContactViewOptionsTabbed:(id)sender;
-(IBAction)BtnAddNewUserTabbed:(id)sender;
-(IBAction)BtnEditContactsTabbed:(id)sender;
-(void)UpdateContactList:(id)sender;

@end

@protocol contactListViewdelegate
-(void)showview:(NSString *)viewName;
@end
