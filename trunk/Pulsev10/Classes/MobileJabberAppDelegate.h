//
//  MobileJabberAppDelegate.h
//  MobileJabber
//
//  Created by Shivang Vyas on 6/16/11.
//  Copyright 2011 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPPMessage.h"
#import "XMPPStreamHandler.h"
#import "XMPPRosterHandler.h"

#import "XMPP.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPUserCoreDataStorage.h"
#import "XMPPResourceCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "MenuViewController.h"
#import "ThemesViewController.h"
#import "SettingsPopupViewController.h"
#import "ChatViewController.h"
#import "FileTransfer.h"
#import "EditContactPopOverView.h"
#import "UpdatePresenceStatus.h"

#import "SqliteHandler.h"

#import <sqlite3.h>

/* Reflection - 04Dec2011 */
#import "Output.h"
/* Reflection - 04Dec2011 */

@class XMPPStream;
@class XMPPRoster;
@class XMPPRosterCoreDataStorage;
@class XMPPvCardAvatarModule;
@class XMPPvCardTempModule;
@class EditContactPopOverView;
@class SqliteHandler;
@class UpdatePresenceStatus;

@interface MobileJabberAppDelegate : NSObject <UIPopoverControllerDelegate,UIApplicationDelegate, UIAlertViewDelegate, NSFetchedResultsControllerDelegate> {
    
    UIWindow * window;
	
    UINavigationController * navHome;
	UINavigationController * navChat;
	UINavigationController * navSettings;
	UINavigationController * navLearningCenter;
	UINavigationController * navReflections;
	
	XMPPStream *xmppStream;
	XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
	XMPPvCardAvatarModule *_xmppvCardAvatarModule;
	XMPPvCardTempModule *_xmppvCardTempModule;

	
	NSString *password;
    NSString *encUserStr;
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	NSString *strUserName;
	NSString *strPassword;
	NSString *strHostName;
	int PortNumber;
	XMPPStreamHandler *ObjXMPPStreamHandler;
	XMPPRosterHandler *ObjXMPPRosterHandler;
	
	int NavigationBarType; // 0 - for login screen, 1 - for Home & Chat screen.
	
	NSMutableArray * aryBuddyRequests;
	NSMutableDictionary * dictRoster;
	NSMutableArray * aryContactLists;
	NSFetchedResultsController * fetchedResultsController;
	
	NSMutableArray * aryUserRoles;
	MenuViewController * ObjMenuViewController;
	UIPopoverController * ObjPopoverController_Menu;
	
	EditContactPopOverView *ObjEditContactList;
	UIPopoverController * ObjPopoverController_EditContactList;
	
	ThemesViewController * ObjThemesViewController;
    SettingsPopupViewController * ObjSettingPopupViewController;
	UIPopoverController * ObjPopoverController_Themes;
		
	UpdatePresenceStatus *objUpdatePresenceStatus;
	UIPopoverController *ObjPopoverController_UpdateStatus;
	
	int ThemeNumber;
	NSString * strPath;
	NSMutableArray * aryActiveUsers;
	NSMutableArray * aryConversationMessages;
	NSMutableArray * aryUserConversation;
	NSMutableArray * aryPollMessages;
	
		
	FileTransfer * ObjFileTransfer;
	BOOL IsAutoLoginEnabled;
	NSString * strStatusMessage;
	BOOL IsLogMessageEnabled;
	NSString * strServerLocation;
	int ServerPort;
	BOOL IsSASLEnabled;
	BOOL IsTLSEnabled;
	
	BOOL IsShowChatWindow;
	XMPPUserCoreDataStorage *chatActUser;
	NSMutableDictionary *dictChatActGroup;
	BOOL isFileSendingSelected;
	NSString *strFilePath;
    UIViewController *pollController;
//	NSMutableArray *aryUserOption;
//	NSMutableArray *aryGroupOption;
	NSMutableArray *aryContactEmail;
	NSMutableArray *aryContactListExpandValue;
	BOOL isLoggedIn;
	NSMutableData *responseData;
    NSString *strFullName;
    NSString *strSelfEmail;
	NSString *strSelfRole;
    NSMutableArray *aryFileRequestArray;
	BOOL isShowOnlineSelected;
	NSMutableArray *aryOwnedGroupChat;
	NSMutableArray * polls;
	BOOL isChatWindowUp;
	
	sqlite3 *database;
	NSString *strDatabasePath;
	SqliteHandler *objSqliteHandler;
	NSMutableArray *aryGroupFileSendingList;
	NSMutableArray *aryGroupFileRecvList;
    
    NSMutableDictionary *dictPollUserList;
    NSString *pollWindowName;
    int pollReportId;
	
	UIPopoverController *ObjPopoverController_GroupOptionListView;
	NSInteger groupIndexPathSection;

    UINavigationController * navResourceGallery;    
    NSMutableArray *aryAlbumListExpandValue;
    NSMutableArray *aryResourceListExpandValue;
    
    NSDate *lastPresenceDate;
    int refreshAuto;
    bool refreshStart;
    bool hasmoreContacts;
    NSTimer *timerContactList;
    
    int hardLogout;
    int showHelp;
	NSString *strEmoziPath;
	NSInteger statusSelectedIndx;
	IBOutlet UITabBar *menuToolBar;
	NSInteger globalChatMessageCount;
	
	IBOutlet UIButton *btnChatCount;
	
	/* Reflection - 04Dec2011 */
	Output *objOutput;
	/* Reflection - 04Dec2011 */
}

/* Reflection - 04Dec2011 */
@property (nonatomic, retain) Output *objOutput;
/* Reflection - 04Dec2011 */

@property (nonatomic,readwrite) BOOL IsTLSEnabled;
@property (nonatomic,readwrite) BOOL IsSASLEnabled;
@property (nonatomic,readwrite) int ServerPort;
@property (nonatomic,retain) NSString * strServerLocation;
@property (nonatomic,readwrite) BOOL IsLogMessageEnabled;
@property (nonatomic,retain) NSString * strStatusMessage;
@property (nonatomic,readwrite) BOOL IsAutoLoginEnabled;
@property (nonatomic,retain) FileTransfer * ObjFileTransfer;
@property (nonatomic,retain) NSMutableArray * aryUserConversation;
@property (nonatomic,retain) NSMutableArray * aryConversationMessages;
@property (nonatomic,retain) NSMutableArray * aryPollMessages;
@property (nonatomic,retain) NSMutableArray * polls;

@property (nonatomic,retain) NSMutableArray * aryActiveUsers;
@property (nonatomic,retain) NSMutableDictionary *dictChatActGroup;

@property (nonatomic,retain) NSMutableDictionary *dictPollUserList;
@property (nonatomic, assign) NSString *pollWindowName;
@property (nonatomic, assign) int pollReportId;
@property (nonatomic, assign) NSInteger globalChatMessageCount;

@property (nonatomic,retain) NSString * strPath;
@property (nonatomic,readwrite) int ThemeNumber;
@property (nonatomic, retain) NSString *strEmoziPath;

@property (nonatomic,retain) UIPopoverController * ObjPopoverController_Menu;
@property (nonatomic,retain) UIPopoverController * ObjPopoverController_Themes;

@property (nonatomic,retain) NSMutableArray * aryUserRoles;

@property (nonatomic,retain) NSMutableDictionary * dictRoster;
@property (nonatomic,retain) NSMutableArray * aryContactLists;
@property (nonatomic, retain) NSMutableArray * aryBuddyRequests;
@property (nonatomic, retain) UIViewController *pollController;
@property (nonatomic, retain) NSMutableArray *aryContactEmail;
@property (nonatomic, readwrite) int NavigationBarType;
@property (nonatomic, readwrite) NSInteger statusSelectedIndx;
@property (nonatomic, retain) UIView * viwNavigationBar;

@property (nonatomic, readwrite) BOOL allowSelfSignedCertificates;
@property (nonatomic, readwrite) BOOL allowSSLHostNameMismatch;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBar *menuToolBar;

@property (nonatomic, retain) IBOutlet UINavigationController * navHome;
@property (nonatomic, retain) IBOutlet UINavigationController * navChat;
@property (nonatomic, retain) IBOutlet UINavigationController * navSettings;
@property (nonatomic, retain) IBOutlet UINavigationController * navLearningCenter;
@property (nonatomic, retain) IBOutlet UINavigationController * navReflections;

@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, readonly) XMPPvCardTempModule *xmppvCardTempModule;

@property (nonatomic, retain) NSString *strUserName;
@property (nonatomic, retain) NSString *strPassword;
@property (nonatomic, retain) NSString *strHostName;
@property (nonatomic, retain) NSString *strFilePath;
@property (nonatomic, retain) NSString *strFullName;
@property (nonatomic, retain) NSString *strSelfEmail;
@property (nonatomic, retain) NSString *strSelfRole;
@property (nonatomic, retain) NSString *encUserStr;
@property (nonatomic, readwrite) int PortNumber;
@property (nonatomic, assign) BOOL IsShowChatWindow;
@property (nonatomic, retain) XMPPUserCoreDataStorage *chatActUser;
@property (nonatomic, assign) BOOL isFileSendingSelected;
@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, assign) BOOL isShowOnlineSelected;

@property (nonatomic, retain) NSMutableArray *aryContactListExpandValue;
@property (nonatomic, retain) NSMutableArray *aryFileRequestArray;
@property (nonatomic, retain) NSMutableArray *aryOwnedGroupChat;
@property (nonatomic, assign) BOOL isChatWindowUp;
@property (nonatomic, retain) NSMutableArray *aryGroupFileSendingList;
@property (nonatomic, retain) NSMutableArray *aryGroupFileRecvList;

@property (nonatomic, retain) SqliteHandler *objSqliteHandler;

@property (nonatomic) sqlite3 *database;

@property (nonatomic, retain) IBOutlet UINavigationController * navResourceGallery;     ////
@property (nonatomic, retain) NSMutableArray *aryAlbumListExpandValue;
@property (nonatomic, retain) NSMutableArray *aryResourceListExpandValue;

@property (nonatomic) int hardLogout;
@property (nonatomic) int showHelp;

- (NSString *) getDBPathForDB;///


-(void)BtnCloseApplicationMenuTabbed:(id)sender;
-(void)BtnApplicationMenuTabbed:(id)sender;
-(void)RequestUserProfileWithJid:(NSString*)strJID;
-(void)InitializeChattingwithHostName:(NSString*)HostName PortNum:(int)PortNum UserName:(NSString*)UserName Password:(NSString*)Password;
- (void)disconnect;
- (void)goOffline;;
-(BOOL)IsValidEmailAddress:(NSString*)strEmail;
- (NSMutableArray *)fetchedResultsController;
- (void)goOnline;
- (void)resetFirstTimeLogin;
-(void)BtnApplicationMenuTabbed:(id)sender;
-(void)BtnThemesTabbed:(id)sender;
-(void)BtnSettingTabbed:(id)sender;
-(BOOL)IsFoundInActiveUserList:(NSString*)strUserId;
- (NSMutableArray *)fetchedUserwithJid:(NSString*)strJID;
-(void)GetMessagesForUserWithJid:(NSString*)strJid;
-(void)GetEventsWithUserId:(NSString*)strUserId;
-(void)GetPollsWithUserId:(NSString*)strUserId;
-(BOOL)IsSilenced;
- (BOOL) validatePortNumber: (NSString *) strPortNumber;
- (BOOL) validateIP: (NSString *) strIPAddress;
-(BOOL)IsJIDFoundInContactList:(NSString*)strJID;
//-(void)ShowUserProfile:(id)sender;
-(void)ShowUserProfile:(id)sender info:(NSDictionary*)dict;
-(void)BtnCloseProfileTabbed:(id)sender;
-(void)LogoutUser;
-(void)GetMessagesForUserWithGroupName:(NSString*)groupName;
- (void)ShowToogleContactList:(id)sender;
- (void)dismissToogleContactProfile;
- (NSString *) getEncryptedUser;
-(BOOL) isInstructor;
-(UIImage *) getUserImage:(NSString *)userid;
-(UIImage *) getSelfImage;
-(NSString*)findUserRole:(NSString*)UserId;


- (void)copyFilesToDocumentDirIfNotAlreadyExist;
- (void)openDatabase;
- (void)btnNameBarTapped:(id)sender;
-(IBAction)BtnMenuItemTabbedAtMenuBar:(id)sender;
- (void)updateGlobalChatBadgeOnMenuBar;
- (void)logout;
-(void)changePassword;
-(void)showHelpPage;
-(void)showSettings;
@end

