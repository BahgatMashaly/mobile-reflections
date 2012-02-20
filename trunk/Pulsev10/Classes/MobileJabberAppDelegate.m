//
//  MobileJabberAppDelegate.m
//  MobileJabber
//
//  Created by Shivang Vyas on 6/16/11.
//  Copyright 2011 company. All rights reserved.
//

#import "MobileJabberAppDelegate.h"
#import "XMPP.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorageController.h"
#import "XMPPvCardTempModule.h"
#import "XMPPResourceCoreDataStorage.h"
#import "XMPPResource.h"
#import "XMPPUser.h"
#import <CFNetwork/CFNetwork.h>
#import "XMPPRoster.h"
#import "HomeViewController.h"
#import "StringEncryption.h"
#import "SettingsPopupViewController.h"

static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};


#pragma mark -
#pragma mark UINavigationBar Category
@interface UIAlertView (CustomAlertView)
- (void)setUILabel:(UILabel *)tempLabel withMaxFrame:(CGRect)maxFrame withText:(NSString *)theText;
- (void)willPresentAlertView:(UIAlertView *)alertView;
@end

@implementation UIAlertView (CustomAlertView)
- (void)willPresentAlertView:(UIAlertView *)alertView {
	
	// add a new label and configure it to replace the title
	UILabel *tempTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,20,350, 20)];
	tempTitle.backgroundColor = [UIColor clearColor];
	tempTitle.textColor = [UIColor whiteColor];
	tempTitle.textAlignment = UITextAlignmentCenter;
	tempTitle.numberOfLines = 1;
	tempTitle.font = [UIFont boldSystemFontOfSize:18];
	tempTitle.text = alertView.title;
	alertView.title = @"";
	[alertView addSubview:tempTitle];
	[tempTitle release];
	
	// add another label to use as message 
	UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 350, 200)];
	tempLabel.backgroundColor = [UIColor clearColor];
	tempLabel.textColor = [UIColor whiteColor];
	tempLabel.textAlignment = UITextAlignmentCenter;
	tempLabel.numberOfLines = 20;
	tempLabel.text = alertView.message;
	[alertView addSubview:tempLabel];
	
	// method used to resize the height of a label depending on the text height
	[self setUILabel:tempLabel withMaxFrame:CGRectMake(10,50, 350, 300) withText:alertView.message];
	alertView.message = @"";
	
	// set the frame of the alert view and center it
	alertView.frame = CGRectMake(alertView.frame.origin.x - (370 - alertView.frame.size.width)/2 , 
								 alertView.frame.origin.y, 
								 370, 
								 tempLabel.frame.size.height + 120);
	
	
	// iterate through the subviews in order to find the button and resize it
	for(UIView *view in alertView.subviews)
	{
		if([[view class] isSubclassOfClass:[UIControl class]])
		{
			view.frame = CGRectMake   (view.frame.origin.x+2,
									   tempLabel.frame.origin.y + tempLabel.frame.size.height + 10,
									   370 - view.frame.origin.x *2-4,
									   view.frame.size.height);
		}
	}
	
	[tempLabel release];
	
}

- (void)setUILabel:(UILabel *)tempLabel withMaxFrame:(CGRect)maxFrame withText:(NSString *)theText{
    CGSize stringSize = [theText sizeWithFont:tempLabel.font constrainedToSize:maxFrame.size lineBreakMode:tempLabel.lineBreakMode];
    tempLabel.frame = CGRectMake(tempLabel.frame.origin.x, 
								 tempLabel.frame.origin.y, 
								 tempLabel.frame.size.width, 
								 stringSize.height
								 );
}


@end

@implementation UIToolbar (CustomImage)
- (void)drawRect:(CGRect)rect{
		UIImage *image = [UIImage imageNamed:@"main.png"];
		[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end


@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect{
	if(((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).NavigationBarType == 0){
		//navigation bar for login page
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).viwNavigationBar removeFromSuperview];
		UIImage *image = [UIImage imageNamed:@"main.png"];
		[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	}else if(((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).NavigationBarType == 1
			 ){
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).viwNavigationBar.frame = CGRectMake(0.0,0.0, 1024.0, 44.0);
		[self addSubview: ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).viwNavigationBar];
		
	}

}
 @end




#pragma mark -
#pragma mark UIImage Category

@implementation UIImage (ResizeImage)
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
	UIGraphicsBeginImageContext( newSize );
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}
@end



@implementation MobileJabberAppDelegate

@synthesize window;
@synthesize navHome;
@synthesize navChat;
@synthesize navSettings;
@synthesize navLearningCenter;
@synthesize navReflections;

@synthesize database;
@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardAvatarModule = _xmppvCardAvatarModule;
@synthesize xmppvCardTempModule = _xmppvCardTempModule;

@synthesize strUserName, strSelfRole;
@synthesize strPassword;
@synthesize strHostName;
@synthesize encUserStr;
@synthesize PortNumber;
@synthesize polls;

@synthesize allowSelfSignedCertificates;
@synthesize allowSSLHostNameMismatch;

@synthesize viwNavigationBar;

@synthesize NavigationBarType;
@synthesize aryBuddyRequests, aryGroupFileRecvList;

@synthesize dictRoster;
@synthesize aryContactLists, dictChatActGroup, aryContactListExpandValue;
@synthesize dictPollUserList;
@synthesize pollWindowName;
@synthesize pollReportId;

@synthesize aryUserRoles, aryGroupFileSendingList;;
@synthesize ObjPopoverController_Menu;
@synthesize ObjPopoverController_Themes;

@synthesize ThemeNumber;
@synthesize strPath;
@synthesize aryActiveUsers;
@synthesize aryConversationMessages, aryOwnedGroupChat;
@synthesize aryPollMessages;
@synthesize aryUserConversation, aryContactEmail, aryFileRequestArray;
@synthesize ObjFileTransfer;
@synthesize IsAutoLoginEnabled, isLoggedIn,isShowOnlineSelected, isChatWindowUp;
@synthesize strStatusMessage, strFullName, strSelfEmail;
@synthesize IsTLSEnabled,IsSASLEnabled,ServerPort,strServerLocation,IsLogMessageEnabled, IsShowChatWindow, isFileSendingSelected;
@synthesize chatActUser;
@synthesize pollController;
@synthesize strFilePath;
@synthesize objSqliteHandler;

@synthesize navResourceGallery; ////
@synthesize aryAlbumListExpandValue,aryResourceListExpandValue;

@synthesize hardLogout, menuToolBar;
@synthesize showHelp, strEmoziPath, statusSelectedIndx, globalChatMessageCount;

/* Reflection - 04Dec2011 */
@synthesize objOutput;
/* Reflection - 04Dec2011 */

#pragma mark -
#pragma mark Database
- (NSString *) getDBPathForDB {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSLog(@"DBPath : %@", documentsDirectoryPath);
	return [documentsDirectoryPath stringByAppendingPathComponent:@"ResourceGallery.sqlite"];
}

- (void) copyDBIfNeeded {
	NSString *dbPath = [self getDBPathForDB];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL exists = [fileManager fileExistsAtPath:dbPath];
	if (!exists) {
		NSError *error;
        NSLog(@"copying db");
        
		NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"ResourceGallery" ofType:@"sqlite"];
		exists = [fileManager copyItemAtPath:defaultPath toPath:dbPath error:&error];
		if (!exists) {
			NSAssert1(0, @"Failure because of db unavailable: %@", [error localizedDescription]);
		}
	}
}

//@synthesize aryUserOption, aryGroupOption;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	/* Reflection - 04Dec2011 */
	//[[UIApplication sharedApplication] setStatusBarHidden:YES];
	objOutput = [[Output alloc] init];
	/* Reflection - 04Dec2011 */
	
    [self copyDBIfNeeded];
	self.statusSelectedIndx = -1;
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	
	//POLL NOTIFICATION
    /*
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(updateActivePolls:) 
												 name:NSNOTIFICATION_UPDATE_ACTIVEPOLL 
											   object:nil];
     */
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(btnCloseUpdateStatusTapped:)
												 name:NSNOTIFICATION_CLOSE_UPDATE_STATUS
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(BtnCloseProfileTabbed:) 
												 name:NSNOTIFICATION_CLOSE_PROFILE 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(BtnCloseApplicationMenuTabbed:) 
												 name:NSNOTIFICATION_CLOSE_MENU 
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(BtnMenuItemTabbed:) 
												 name:NSNOTIFICATION_SELECTED_MENU_ITEM 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(GoToChatViewFromUserOption:) 
												 name:NSNOTIFICATION_CHAT_FROM_USER_OPTION 
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(BtnCloseApplicationThemesTabbed:) 
												 name:NSNOTIFICATION_CLOSE_THEME 
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(GoToChatViewWithFileTransferFromUserOption:) 
												 name:NSNOTIFICATION_FILE_SENDING_FROM_USER_OPTION 
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(GoToChatViewFromGroupOption:) 
												 name:NSNOTIFICATION_GROUP_CHAT_FROM_GROUP_OPTION 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(GoToFileTransferViewFromGroupOption:) 
												 name:NSNOTIFICATION_GROUP_FILE_FROM_GROUP_OPTION 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(EditProfileInfoSucceed:) 
												 name:NSSNOTIFICATION_EDIT_PROFILE_SUCCEED
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(GoToPollViewFromGroupOption:) 
												 name:NSNOTIFICATION_POLL_FROM_GROUP_OPTION 
											   object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(GoToAssessmentViewFromGroupOption:) 
												 name:NSNOTIFICATION_ASSESSMENT_FROM_GROUP_OPTION 
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(GoToProgressTrackFromGroupOption:) 
												 name:NSNOTIFICATION_PROGRESSTRACK_FROM_GROUP_OPTION 
											   object:nil];
    // Override point for customization after application launch.
	self.strHostName = HOSTNAME;
	self.PortNumber = PORTNUMBER;
	
	self.NavigationBarType = 0;
	//================================Getting AutoLogin plist file path, copy file if it doesnt exists ============================	
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1=Create a list of paths.
	NSString *documentsDirectory = [paths objectAtIndex:0]; //2=Get a path to your documents directory from the list.
	self.strPath = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"MobileJabber.plist"]
					]; //3=Create a full file path.
	self.strFilePath = [documentsDirectory stringByAppendingPathComponent:@"files"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	self.strEmoziPath = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"EmotIconConfig.plist"]
						 ];
	if (![fileManager fileExistsAtPath:self.strEmoziPath]) {
		NSString *strBundleEmoziPath = [[NSBundle mainBundle] pathForResource:@"EmotIconConfig" ofType:@"plist"];
		[fileManager copyItemAtPath:strBundleEmoziPath toPath: self.strEmoziPath error:nil];
	}
	if (![fileManager fileExistsAtPath: self.strPath]) //4=Check if file exists.
	{
		NSString *bundle = [[NSBundle mainBundle] pathForResource:@"MobileJabber" ofType:@"plist"]; //5=Get a path to your plist created before in bundle directory (by Xcode).
		//NSLog(@"%@",bundle);
		
		if([fileManager copyItemAtPath:bundle toPath: self.strPath error:&error]){
			NSLog(@"file copied successfully !");
			//	Now set all default values for application settings for first time launch this application....!
			
			NSMutableDictionary * dictDefaultSettings = [[NSMutableDictionary alloc] init];
			[dictDefaultSettings setValue:@"3" forKey:@"ThemeNumber"];
			[dictDefaultSettings setValue:@"NO" forKey:@"IsAutoLoginEnabled"];
			[dictDefaultSettings setValue:@"" forKey:@"UserName"];
			[dictDefaultSettings setValue:@"" forKey:@"Password"];
			[dictDefaultSettings setValue:@"" forKey:@"status"];
			[dictDefaultSettings setValue:@"NO" forKey:@"LogMessage"];
            if (CONNECTION_MODE == 1 && COMPANY == 1) {
                [dictDefaultSettings setValue:COMPANY1_SERVER forKey:@"ServerLocation"];
            } else {
                [dictDefaultSettings setValue:HOSTNAME forKey:@"ServerLocation"];
            }
			[dictDefaultSettings setValue:[NSString stringWithFormat:@"%d", PORTNUMBER] forKey:@"ServerPort"];
			[dictDefaultSettings setValue:@"NO" forKey:@"SASL"];
			[dictDefaultSettings setValue:@"NO" forKey:@"TLS"];
			[dictDefaultSettings writeToFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath atomically:YES]?NSLog(@"Success"):NSLog(@"Failure");
			[dictDefaultSettings release];
			// 
			[[NSFileManager defaultManager] createDirectoryAtPath:self.strFilePath
									  withIntermediateDirectories:YES attributes:nil error:nil];
		}
	}	
	
	NSString *directory = [NSString stringWithFormat:@"%@/",self.strFilePath];
	
	for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil]) {
		[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", directory, file] error:nil];
		
	}
	
	[self copyFilesToDocumentDirIfNotAlreadyExist];
	[self openDatabase];
	self.objSqliteHandler = [[SqliteHandler alloc] init];
	
	//[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/",self.strFilePath] error:nil];
	//================Getting last saved application theme....==================
	
	
	NSMutableDictionary * dictLastSavedSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:self.strPath];
	self.ThemeNumber = [[dictLastSavedSettings valueForKey:@"ThemeNumber"] intValue];
	self.IsAutoLoginEnabled = [[dictLastSavedSettings valueForKey:@"IsAutoLoginEnabled"] boolValue];
	self.strUserName = [dictLastSavedSettings valueForKey:@"UserName"];
	self.strPassword = [dictLastSavedSettings valueForKey:@"Password"];	
 	self.strStatusMessage = [dictLastSavedSettings valueForKey:@"status"];
	self.IsLogMessageEnabled = [[dictLastSavedSettings valueForKey:@"LogMessage"] boolValue];
	self.strServerLocation = [dictLastSavedSettings valueForKey:@"ServerLocation"];
	self.ServerPort = [[dictLastSavedSettings valueForKey:@"ServerPort"] intValue];
	self.IsSASLEnabled = [[dictLastSavedSettings valueForKey:@"SASL"] boolValue];
	self.IsTLSEnabled = [[dictLastSavedSettings valueForKey:@"TLS"] boolValue];

	[dictLastSavedSettings release];

    // Here we revert any customisations made
    if (CONNECTION_MODE == 1 && COMPANY == 1) {
        self.strServerLocation = COMPANY1_SERVER;
    }
    self.window.rootViewController = self.navHome;
	//self.window.rootViewController = self.navReflections;
	
    [self.window makeKeyAndVisible];
	[self.menuToolBar setFrame:CGRectMake(0, 688, 1024, 60)];
	
	aryContactLists = [[NSMutableArray alloc] init];
	aryActiveUsers = [[NSMutableArray alloc] init];
	aryPollMessages = [[NSMutableArray alloc] init];
	polls = [[NSMutableArray alloc] init];
	
	NSMutableDictionary * dictEmojiSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"../../Library/Preferences/"] stringByAppendingPathComponent:@"com.apple.Preferences.plist"]];	
	
	if(![[dictEmojiSettings valueForKey:@"KeyboardEmojiEverywhere"] boolValue]){		
		[dictEmojiSettings setObject:[NSNumber numberWithBool:TRUE] forKey:@"KeyboardEmojiEverywhere"];
        [dictEmojiSettings writeToFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"../../Library/Preferences/"] stringByAppendingPathComponent:@"com.apple.Preferences.plist"] atomically:NO]?NSLog(@"success"):NSLog(@"fail");
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" 
                        message:@"To use emoticons in your messages, you'll need to turn on the Japanese Emoji keyboard.\n\nGo to \"Settings\" ➔ \"General\" ➔ \"Keyboard\" ➔ \"International Keyboards\" ➔ \"Japanese\" ➔ Turn \"Emoji\" to ON." 
                        delegate:nil 
                        cancelButtonTitle:@"OK" 
                        otherButtonTitles:nil];
		[alert show];
		[alert release];

        /*
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Message" 
														 message:@"Enable Emoji Keyboard from Settings Menu." 
														delegate:nil 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil];
		[alert show];
		[alert release];
         */
	}
	
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"gallery"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	// [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];	
	// [[UIDevice currentDevice] setOrientation:UIDeviceOrientationLandscapeRight];
    
    self.hardLogout = 0;
    self.showHelp = 0;
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	sqlite3_close(self.database);
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}






#pragma mark ------
#pragma mark POLL (updateActivePolls)


- (void)updateActivePolls:(NSNotification*)notification
{
	
	//<iq id="" type="get" to="victor@mqcommunicator/Messenger" from="devika@mqcommunicator/Messenger">
	//	<query xmlns="poll:iq:receive">
	//	<id>88</id>
	//	</query>
	//	</iq>
		
	XMPPIQ *iqID = [notification object];

	// NSLog(@"--------------------------------------------------  %@ ",iqID);
			
	NSString *  temp = [[iqID childElement]  stringValue];
			
				
	NSXMLElement *iq = [NSXMLElement elementWithName:@"presence"];
	[iq addAttributeWithName:@"id" stringValue:@"JN_22"];
	[iq addAttributeWithName:@"to" stringValue:@"victor@mqcommunicator/Messenger"];
	[iq addAttributeWithName:@"from" stringValue:@"devika@mqcommunicator/Messenger"];
	
	
	NSXMLElement *query = [NSXMLElement elementWithName:@"query" ];
	[query addAttributeWithName:@"xmlns" stringValue:@"poll:iq:receive"];
	[query setStringValue:temp];
	
	[iq addChild:query];
	
	//Send Message
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:iq];
	
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
	/* Reflection - 04Dec2011 */
	[objOutput release];
	/* Reflection - 04Dec2011 */
	 
	[strServerLocation release];
	//[strStatusMessage release];
	[ObjFileTransfer release];
	[strStatusMessage release];
	[strPath release];
	[aryUserConversation release];
	[aryPollMessages release];
	[aryConversationMessages release];
	[aryActiveUsers release];
	[ObjPopoverController_Themes release];
	[ObjPopoverController_Menu release];
	[aryBuddyRequests release];
	[viwNavigationBar release];
	
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	
	[xmppStream disconnect];
	[_xmppvCardAvatarModule release];
	[_xmppvCardTempModule release];
	[xmppStream release];
	[xmppRoster release];
	[aryContactLists release];
    
    if (aryContactListExpandValue != nil) {
        [aryContactListExpandValue release];
        aryContactListExpandValue = nil;
    }
    	
	[navHome release];
	[navChat release];
	[navSettings release];
	
	[window release];
	[aryUserRoles release];
	[aryActiveUsers release];
	[polls release];
    [navResourceGallery release];
    [aryAlbumListExpandValue release];
    [aryResourceListExpandValue release];
    
    [dictPollUserList release];
	
    [navReflections release];
	[super dealloc];
}

#pragma mark -
#pragma mark Custom Methods


-(void)BtnCloseProfileTabbed:(id)sender{
}

-(void)BtnMenuItemTabbed:(id)sender{
	// NSLog(@"%@",[sender description]);
	/*	0-Home, 1-chat, 2-Resources, 
		3-Reflections, 4-Learning Center, 
		5-Settings, 6- Change Password 7-Logout
	*/
	[ObjPopoverController_Menu dismissPopoverAnimated:YES];
	self.isChatWindowUp = NO;
	if([[sender object] isEqualToString:@"0"]){
        if(!(self.window.rootViewController == self.navHome))
        {
            [self.window setRootViewController:self.navHome];
        }
	}else if([[sender object] isEqualToString:@"1"]){		
		self.isChatWindowUp = YES;
        if(!(self.window.rootViewController == self.navChat))
        {
            [self.window setRootViewController:nil];
            [self.window setRootViewController:self.navChat];
        }
	}else if([[sender object] isEqualToString:@"3"]){
        if (self.navReflections == self.navReflections)
		{
			[self.window setRootViewController:self.navReflections];
        }
	}else if([[sender object] isEqualToString:@"4"]){
        if(!(self.window.rootViewController == self.navLearningCenter))
        {
            self.showHelp = 0;
            self.window.rootViewController = self.navLearningCenter;			
        }
	}else if([[sender object] isEqualToString:@"5"]){
        if(!(self.window.rootViewController == self.navSettings))
        {
            self.window.rootViewController = self.navSettings;
        }
	}else if([[sender object] isEqualToString:@"6"]){
        UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"Change Password" message:@"Password must be 8 characters, contain an upper case, lower case and a numeric digit\n\n" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                
        /*
        UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,40,260,75)];
        passwordLabel.font = [UIFont systemFontOfSize:16];
        passwordLabel.textColor = [UIColor whiteColor];
        passwordLabel.backgroundColor = [UIColor clearColor];
        passwordLabel.shadowColor = [UIColor blackColor];
        passwordLabel.shadowOffset = CGSizeMake(0,-1);
        passwordLabel.textAlignment = UITextAlignmentCenter;
        passwordLabel.text = @"Passwords must be 8 characters, contain an upper case, lower case and a numeric digit";
        [passwordAlert addSubview:passwordLabel];
         */
        
        //UIImageView *passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"passwordfield" ofType:@"png"]]];
        //passwordImage.frame = CGRectMake(11,79,262,31);
        //[passwordAlert addSubview:passwordImage];
        
        UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(16,113,252,25)];
        // passwordField.font = [UIFont systemFontOfSize:18];
        // passwordField.backgroundColor = [UIColor whiteColor];
        passwordField.borderStyle = UITextBorderStyleRoundedRect;
        passwordField.secureTextEntry = YES;
        passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
        passwordField.tag = 3;
        //passwordField.delegate = self;
        [passwordField becomeFirstResponder];
        [passwordAlert addSubview:passwordField];
        
        [passwordAlert setTransform:CGAffineTransformMakeTranslation(0,109)];
        [passwordAlert show];
        // NSString *str = passwordField.text;
        // [self changePassword:str];
        [passwordAlert release];
        // [passwordField release];
        // [passwordImage release];
        // [passwordLabel release];        
        // Popup to show password changer
	}else if([[sender object] isEqualToString:@"7"]){
        if(!(self.window.rootViewController == self.navLearningCenter))
        {
            self.showHelp = 1;
            self.window.rootViewController = self.navLearningCenter;			
        }
	}else if([[sender object] isEqualToString:@"9"]){
        if(!(self.window.rootViewController == self.navLearningCenter))
        {
            self.showHelp = 2;
            self.window.rootViewController = self.navLearningCenter;			
        }
	}else if([[sender object] isEqualToString:@"8"]){
        [self logout];
	}
    else if([[sender object] isEqualToString:@"2"]){      
        //[self.navResourceGallery popToRootViewControllerAnimated:NO];
        //[self.navResourceGallery popViewControllerAnimated:YES];
        //[self.window setRootViewController:nil];
        BOOL isFirstTime =  [[NSUserDefaults standardUserDefaults] boolForKey:@"gallery"];
        if (isFirstTime) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"gallery"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self.window setRootViewController:self.navResourceGallery];
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        UITextField *passField = (UITextField *)[actionSheet viewWithTag:3]; 
        NSString * str = passField.text;
        
        BOOL isValid = YES;
        if ([str isEqualToString:@""]) return;
        
        if ([str length] < 8) {
            UIAlertView *alert = [[UIAlertView alloc] 
                                  initWithTitle:@"Password Change" 
                                  message:@"Please enter a password which is more than 8 characters, and contains an alphabet, a numeric and a special character." 
                                  delegate:self 
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];        
            return;
        }
        
        int failed = 0;
        NSRegularExpression *regex = [[[NSRegularExpression alloc]
                                       initWithPattern:@"[a-z]" options:0 error:NULL] autorelease];
        // Assuming you have some NSString `myString`.
        NSUInteger *matches = [regex numberOfMatchesInString:str options:0
                                                       range:NSMakeRange(0, [str length])];
        
        if (matches == 0) {
            failed++;
        }
        
        NSRegularExpression *regex2 = [[[NSRegularExpression alloc]
                                       initWithPattern:@"[A-Z]" options:0 error:NULL] autorelease];
        // Assuming you have some NSString `myString`.
        NSUInteger *matches2 = [regex2 numberOfMatchesInString:str options:0
                                                       range:NSMakeRange(0, [str length])];
        
        if (matches2 == 0) {
            failed++;
        }
        
        NSRegularExpression *regex3 = [[[NSRegularExpression alloc]
                                        initWithPattern:@"[0-9]" options:0 error:NULL] autorelease];
        // Assuming you have some NSString `myString`.
        NSUInteger *matches3 = [regex3 numberOfMatchesInString:str options:0
                                                        range:NSMakeRange(0, [str length])];
        
        if (matches3 == 0) {
            failed++;
        }
        
        
        NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"];        

        if( [[str stringByTrimmingCharactersInSet:stringSet] isEqualToString:@""]){    
            failed++;
            
        }
        
        if (failed > 1) {
            UIAlertView *alert = [[UIAlertView alloc] 
                                  initWithTitle:@"Password Change" 
                                  message:@"Please enter a password which is more than 8 characters, and contains an alphabet, a numeric and a special character." 
                                  delegate:self 
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];        
            return;
            
        }
            
        
        
        [self changePassword:str];
        ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPassword = str;
        encUserStr = @"";

        /*
        UIAlertView *alert = [[UIAlertView alloc] 
                                         initWithTitle:@"Password Change" 
                                         message:@"Your password has been updated." 
                                         delegate:self 
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
        [alert show];
        [alert release];        
         */

    }
    else
    {
        // NSLog(@"cancel");
    }
}

/*
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSString *str = textField.text;
    [self changePassword:str];
    [textField resignFirstResponder];
    return YES;
}
 */


- (NSString *) base64StringFromData: (NSData *)data length: (int)length {
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length]; 
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0; 
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0) 
            break;        
        for (i = 0; i < 3; i++) { 
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1: 
                ctcopy = 2; 
                break;
            case 2: 
                ctcopy = 3; 
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }     
    return result;
}

-(void) SendPasswordUpdateRequest {
	NSXMLElement * iq = [NSXMLElement elementWithName:@"iq"];
	[iq addAttributeWithName:@"type" stringValue:@"get"];
	[iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"services.%@",SERVERNAME]];
	
	NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"services:iq:mustchangepassword"];
	NSXMLElement * xpassword = [NSXMLElement elementWithName:@"userid" stringValue:encUserStr];
	// [query addChild:jid];
	[query addChild:xpassword];	
	[iq addChild:query];
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:iq];
}


-(void) changePassword:(NSString*)Password {
    
    NSString *username = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strUserName componentsSeparatedByString:@"@"] objectAtIndex:0];
    
    NSString *passkey = [NSString stringWithFormat:@"%@|%@",
                         username,Password];
    NSString *passkey2 = [passkey AES256EncryptWithKey:@"iPadPulse00000000000000000000000"];
    	
	NSXMLElement * iq = [NSXMLElement elementWithName:@"iq"];
	[iq addAttributeWithName:@"type" stringValue:@"get"];
	[iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"services.%@",SERVERNAME]];
	
	NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"services:iq:updateuserpassword"];
	
	// NSXMLElement * jid = [NSXMLElement elementWithName:@"userid" stringValue:username];
	NSXMLElement * xpassword = [NSXMLElement elementWithName:@"password" stringValue:passkey2];
	// [query addChild:jid];
	[query addChild:xpassword];	
	[iq addChild:query];
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:iq];
}

-(void)InitializeChattingwithHostName:(NSString*)HostName PortNum:(int)PortNum UserName:(NSString*)UserName Password:(NSString*)Password{
	
	NSString * tempHostName = [HostName retain];
	NSString * tempUserName = [UserName retain];
	NSString * tempPassword = [Password retain];
	
	// You may need to alter these settings depending on the server you're connecting to
	NSMutableDictionary * dictApplicationSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPath];
    
	if([[dictApplicationSettings valueForKey:@"SASL"] boolValue]){
		allowSelfSignedCertificates = YES;
	}else {
		allowSelfSignedCertificates = NO;
	}
	
	if([[dictApplicationSettings valueForKey:@"TLS"] boolValue]){
		allowSSLHostNameMismatch = YES;
	}else {
		allowSSLHostNameMismatch = NO;
	}
	
	[dictApplicationSettings release];
	
	xmppStream = [[XMPPStream alloc] init];
	
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];		
	
	xmppRoster = [[XMPPRoster alloc] initWithStream:xmppStream rosterStorage:xmppRosterStorage];
	

	
	ObjXMPPRosterHandler = [[XMPPRosterHandler alloc] init];
	[xmppRoster addDelegate:ObjXMPPRosterHandler];
	[xmppRoster setAutoRoster:YES];

	ObjXMPPStreamHandler = [[XMPPStreamHandler alloc] init];
	[xmppStream addDelegate:ObjXMPPStreamHandler];	

	
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//	[xmppStream setHostName:@"talk.google.com"];//talk.l.google.com
	//	 [xmppStream setHostName:@"talk.google.com"];	
	//	[xmppStream setHostName:@"192.168.1.32"];
	[xmppStream setHostName:tempHostName];
	
	//	 [xmppStream setHostPort:5222];
	[xmppStream setHostPort:PortNum];
    	
	// Replace me with the proper JID and password
	//	[xmppStream setMyJID:[XMPPJID jidWithString:@"kdesai"]];
	//	 [xmppStream setMyJID:[XMPPJID jidWithString:@"shivangvyas2008@gmail.com"]];
	[xmppStream setMyJID:[XMPPJID jidWithString:tempUserName]];
	//	NSLog(@"%@",[[XMPPJID jidWithString:tempUserName] description]);
	//	 password = @"";16*7
	password = [[NSString alloc] initWithString:tempPassword];

	_xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithStream:xmppStream 
															   storage:[XMPPvCardCoreDataStorageController sharedXMPPvCardCoreDataStorageController]];
	_xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardTempModule];
	

	
	// Uncomment me when the proper information has been entered above.
	NSError *error = nil;
	if (![xmppStream connect:&error])
	{
		NSLog(@"Error connecting: %@", error);
	}
	
	[tempHostName release];
	[tempUserName release];
	[tempPassword release];
}

-(void)LogoutUser{
	self.isLoggedIn = NO;
	[self disconnect];
}

- (void)disconnect {
    self.encUserStr = @"";
    
    // This is to reset the automatic login
    timerContactList = nil;
    refreshAuto = 0;
    lastPresenceDate = nil;
    refreshStart = NO;
    
	[xmppStream removeDelegate:ObjXMPPStreamHandler];
	[xmppRoster removeDelegate:ObjXMPPRosterHandler];
	
	[xmppStream disconnect];
	[xmppStream release];
	[xmppRoster release];
	
	xmppStream = nil;
	[xmppStream disconnect];
}

#pragma mark-
#pragma mark Custom Methods

- (void)btnNameBarTapped:(id)sender {
	
	objUpdatePresenceStatus = [[UpdatePresenceStatus alloc] initWithNibName:@"UpdatePresenceStatus" bundle:nil];
	if(ObjPopoverController_UpdateStatus!=nil && [ObjPopoverController_UpdateStatus retainCount]>0)
	{
		[ObjPopoverController_UpdateStatus release];
		ObjPopoverController_UpdateStatus = nil;
	}
	ObjPopoverController_UpdateStatus = [[UIPopoverController alloc] initWithContentViewController:objUpdatePresenceStatus];
	ObjPopoverController_UpdateStatus.delegate = self;
	ObjPopoverController_UpdateStatus.popoverContentSize = CGSizeMake(320,310);
	
	CGRect popoverRect = [self.window convertRect:[sender frame] fromView:[sender superview]];
	
	[ObjPopoverController_UpdateStatus presentPopoverFromRect:popoverRect 
											   inView:self.window 
							 permittedArrowDirections:UIPopoverArrowDirectionUp
											 animated:YES];
	
	[objUpdatePresenceStatus release];
	
	
}

- (void)btnCloseUpdateStatusTapped:(id)sender {
	[ObjPopoverController_UpdateStatus dismissPopoverAnimated:YES];
}

- (void)ShowToogleContactList:(id)sender {
	ObjEditContactList = [[EditContactPopOverView alloc] initWithNibName:@"EditContactPopOverView" bundle:nil];
	if (ObjPopoverController_EditContactList != nil && [ObjPopoverController_EditContactList retainCount] > 0) {
		[ObjPopoverController_EditContactList release];
		ObjPopoverController_EditContactList = nil;
	}
	ObjPopoverController_EditContactList = [[UIPopoverController alloc] initWithContentViewController:ObjEditContactList];
	[ObjPopoverController_EditContactList setDelegate:self];
	ObjPopoverController_EditContactList.popoverContentSize = CGSizeMake(320,127);
	CGRect popoverRect = [self.window convertRect:[sender frame] fromView:[sender superview]];
	
	[ObjPopoverController_EditContactList presentPopoverFromRect:popoverRect 
												  inView:self.window 
								permittedArrowDirections:UIPopoverArrowDirectionAny
												animated:YES];
	
	[ObjEditContactList release];	
}

- (void)dismissToogleContactProfile {
	[ObjPopoverController_EditContactList dismissPopoverAnimated:YES];
}


//-(void)ShowUserProfile:(id)sender
-(void)ShowUserProfile:(id)sender info:(NSDictionary*)dict{
}


-(BOOL)IsJIDFoundInContactList:(NSString*)strJID{
	for(int i=0;i< [[[self.dictRoster valueForKey:@"Query"] valueForKey:@"Items"] count];i++){
		if([[[[[self.dictRoster valueForKey:@"Query"] valueForKey:@"Items"] objectAtIndex:i] valueForKey:@"jid"
			 ] isEqualToString:strJID]){
			return YES;
		}
	}
	
	return NO;
}


- (BOOL) validateIP: (NSString *) strIPAddress {
    NSString * txtIPRegex = @"^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$";
    NSPredicate * txtIPTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", txtIPRegex];	
    return [txtIPTest evaluateWithObject:strIPAddress];
}

- (BOOL) validatePortNumber: (NSString *) strPortNumber{
    NSString *txtPortNumRegex = @"^\\d\\d*$";
    NSPredicate *txtPortNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", txtPortNumRegex];	
    if([txtPortNumberTest evaluateWithObject:strPortNumber]){
		if([strPortNumber intValue]>0){
			return YES;
		}		
	}
	return NO;
}


-(void)GetEventsWithUserId:(NSString*)strUserId{
	/***********Sample Input***********
	 <iq id="1" 
		type="get" 
		to="services.mqcommunicator">
		<query xmlns="services:iq:getevents">
			<jid>
				victor
			</jid>
			<limit>
				3
			</limit>
		</query>
	 </iq>
	 
	 **********************************/
	
	NSXMLElement * iq = [NSXMLElement elementWithName:@"iq"];
	[iq addAttributeWithName:@"id" stringValue:@"1"];	
	[iq addAttributeWithName:@"type" stringValue:@"get"];
	[iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"services.%@",SERVERNAME
												]
	 ];
	
	NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"services:iq:getevents"];
	
    NSXMLElement * jid = [NSXMLElement elementWithName:@"jid" stringValue:
                          [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getEncryptedUser]];
	// NSXMLElement * jid = [NSXMLElement elementWithName:@"jid" stringValue:strUserId];
	[query addChild:jid];
	
	NSXMLElement * limit = [NSXMLElement elementWithName:@"limit" stringValue:@"100"];
	[query addChild:limit];
	
	[iq addChild:query];
	
	// NSLog(@"%@",[iq description]);
	
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:iq];
	
}

-(void)GetPollsWithUserId:(NSString*)strUserId{
	/***********Sample Input***********
	 <iq id="1" 
     type="get" 
     to="assessment.mqcommunicator">
     <query xmlns="assessment:iq:getopenofflinepolls">
     <userid>
     victor
     </userid>
     </query>
	 </iq>
	 
	 **********************************/
	
	NSXMLElement * iq = [NSXMLElement elementWithName:@"iq"];
	[iq addAttributeWithName:@"type" stringValue:@"get"];
	[iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"assessment.%@",SERVERNAME]];
	
	NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"assessment:iq:getopenofflinepolls"];
	
    NSXMLElement * jid = [NSXMLElement elementWithName:@"userid" stringValue:
                             [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getEncryptedUser]];
	// NSXMLElement * jid = [NSXMLElement elementWithName:@"userid" stringValue:strUserId];
	[query addChild:jid];
	
	[iq addChild:query];
	
	// NSLog(@"%@",[iq description]);
	
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:iq];
}


-(void)GetMessagesForUserWithJid:(NSString*)strJid{
	[aryUserConversation removeAllObjects];
	
	// NSLog(@"aryConversationMessages: %@",[aryConversationMessages description]);
	
	for(int i=0;i<[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages count];i++)
	{
		if(
		   ([[[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages objectAtIndex:i] valueForKey:@"from"] description]
			   componentsSeparatedByString:@"/"] objectAtIndex:0]
			 isEqualToString:strJid]) ||
		   ([[[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages objectAtIndex:i] valueForKey:@"to"] description]
			   componentsSeparatedByString:@"/"] objectAtIndex:0]
			 isEqualToString:strJid])
		   )
		{
			[aryUserConversation addObject:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages objectAtIndex:i]
			 ];
		}
	}
}

-(void)GetMessagesForUserWithGroupName:(NSString*)groupName{
	[aryUserConversation removeAllObjects];
	
	// NSLog(@"aryConversationMessages: %@",[aryConversationMessages description]);
	
	for(int i=0;i<[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages count];i++)
	{
		if(
		   ([[[[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages objectAtIndex:i] valueForKey:@"from"] description]
			   componentsSeparatedByString:@"#"] objectAtIndex:0] lowercaseString]
			 isEqualToString:[groupName lowercaseString]]) ||
		   ([[[[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages objectAtIndex:i] valueForKey:@"to"] description]
			   componentsSeparatedByString:@"#"] objectAtIndex:0] lowercaseString]
			 isEqualToString:[groupName lowercaseString]])
		   )
		{
			[aryUserConversation addObject:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryConversationMessages objectAtIndex:i]
			 ];
		}
	}
}

-(BOOL)IsFoundInActiveUserList:(NSString*)strUserId{
	
	for(int i=0; i< [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers count];i++){
		//NSString *strJid = [[((XMPPUserCoreDataStorage*)[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:i]).jidStr componentsSeparatedByString:@"@"] objectAtIndex:0];
		if ([[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:i] objectForKey:@"user"] class] == [XMPPUserCoreDataStorage class]) {
			NSString *strJid = [[((XMPPUserCoreDataStorage*)[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers objectAtIndex:i] objectForKey:@"user"]).jidStr componentsSeparatedByString:@"@"] objectAtIndex:0];
			if([strJid isEqualToString:strUserId]
			   ){
				return YES;
			}	
		}
	}
	return NO;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    // Rakesh Bad
    // Create a timer to update in 1 second
    // NSLog (@"controllerChanged");
    if (refreshAuto == 100) {
        // NSLog (@"AutoRefresh");
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CONTACTS object:nil];
        return;
    }
    if (lastPresenceDate == nil) {
        lastPresenceDate = [[NSDate date] retain];
    }
    double seconds = 0 - [lastPresenceDate timeIntervalSinceNow];
    NSLog (@"Seconds : %f", seconds);
    if (seconds > 15 && timerContactList == nil) {
        // NSLog (@"RefreshAuto");
        refreshAuto = 100;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CONTACTS object:nil];
        return;
    } else {
        [lastPresenceDate release];
        lastPresenceDate = nil;
        lastPresenceDate = [[NSDate date] retain];        
    }
    if (timerContactList != nil) {
        hasmoreContacts = YES;        
    }
    if (timerContactList == nil) {        
        hasmoreContacts = NO;
        // NSLog (@"Using Timer");
        if (!refreshStart) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CONTACTS object:nil];        
        }
        else {
            timerContactList = [[NSTimer timerWithTimeInterval:3
											      target:self 
											    selector:@selector(doContactRefresh:)
											    userInfo:nil
											     repeats:NO] retain];
            [[NSRunLoop currentRunLoop] addTimer:timerContactList forMode:NSDefaultRunLoopMode];
        }
        refreshStart = YES;                
	} 
}

- (void)doContactRefresh:(NSTimer *)timer
{
	[timerContactList invalidate];
	timerContactList = nil;
    if (hasmoreContacts) {
        hasmoreContacts = NO;
        timerContactList = [[NSTimer timerWithTimeInterval:1
                                                    target:self 
                                                  selector:@selector(doContactRefresh:)
                                                  userInfo:nil
                                                   repeats:NO] retain];
        [[NSRunLoop currentRunLoop] addTimer:timerContactList forMode:NSDefaultRunLoopMode];        
        return;
    }
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CONTACTS object:nil];
}

- (NSMutableArray *)fetchedResultsController{
	// NSLog(@"%@",[self xmppRosterStorage]);
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorage"
											  inManagedObjectContext:[[self xmppRosterStorage] managedObjectContext]
								   ];
	
	//NSDictionary *dictt = [entity propertiesByName];
//	NSAttributeDescription *sectionNum = [dictt objectForKey:@"sectionNum"];
//	[sectionNum setDefaultValue:@"3"];
//	[entity setProperties:[NSArray arrayWithObject:sectionNum]];
//	
	NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
	NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
	NSArray * sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];

//	NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"%K = %i",@"sectionNum",2];

	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	[fetchRequest setEntity:entity];
//	[fetchRequest setPredicate:predicate1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[fetchRequest setFetchBatchSize:10];
	
	if(fetchedResultsController!=nil && [fetchedResultsController retainCount]>0){
		[fetchedResultsController release];
		fetchedResultsController = nil;
	}
	
	fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																   managedObjectContext:[[self xmppRosterStorage] managedObjectContext]
																	 sectionNameKeyPath:@"sectionNum"
																			  cacheName:nil];
	
	// NSLog(@"fetched objects count: %i",[[fetchedResultsController fetchedObjects] count]);
	
	[fetchedResultsController setDelegate:self];
	
	[sd1 release];
	[sd2 release];
	[fetchRequest release];
	
	NSError *error = nil;
	
	if(![fetchedResultsController performFetch:&error]){
		NSLog(@"Error performing fetch: %@", error);
	}

	if([[fetchedResultsController fetchedObjects] count] >0){
		NSLog(@"%@",[((XMPPUserCoreDataStorage*)[[fetchedResultsController fetchedObjects] objectAtIndex:0]).jid description]);
	}
	
//	NSLog(@"contact users: %@",[NSMutableArray arrayWithArray: 
//								[[NSSet setWithArray:[fetchedResultsController fetchedObjects]] allObjects]
//								]);
	NSMutableArray * aryGroups = [[NSMutableArray alloc] init];
	
	for(int i=0;i< [[fetchedResultsController fetchedObjects] count];i++){
		for(int j = 0; j <
		[[((XMPPUserCoreDataStorage*)[[fetchedResultsController fetchedObjects] objectAtIndex:
									  i]).groups allObjects] count]; j++){
			NSString * GroupName = [((XMPPGroupCoreDataStorage*)[[((XMPPUserCoreDataStorage*)[[fetchedResultsController fetchedObjects] objectAtIndex:
											  i]).groups allObjects] objectAtIndex:j
																]) name];
			
			BOOL IsGroupFound = NO;
			for(int k=0;k<[aryGroups count];k++){
				if([GroupName isEqualToString:[aryGroups objectAtIndex:k]]){
					IsGroupFound = YES;
				}
			}
			
			if(!IsGroupFound){
				[aryGroups addObject:GroupName];				
			}
		}
	}
	
	//NSLog(@"aryGroups: %@",[aryGroups description]);
	NSMutableArray * aryResult = [[NSMutableArray alloc] init];
	
	//now we have a groups, now collect roster group wise.....!
	for(int i=0;i<[aryGroups count];i++){
		NSMutableArray * aryGroupUsers = [[NSMutableArray alloc] init];
			for(int j=0;j< [[fetchedResultsController fetchedObjects] count];j++){
				for(int k=0;k<
				[[((XMPPUserCoreDataStorage*)[[fetchedResultsController fetchedObjects] objectAtIndex:j
											  ]
				   ).groups allObjects] count]; k++){
					if([
						[((XMPPGroupCoreDataStorage*)[[((XMPPUserCoreDataStorage*)[[fetchedResultsController fetchedObjects] objectAtIndex:j]
					   ).groups allObjects] objectAtIndex:k]) name] isEqualToString:
						[aryGroups objectAtIndex:i]
						]){
						[aryGroupUsers addObject:((XMPPUserCoreDataStorage*)[[fetchedResultsController fetchedObjects] objectAtIndex:j
																			 ]
												  )];
					} //end of if
				}
			}
		NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
		[dict setValue:[aryGroups objectAtIndex:i] forKey:@"GroupName"];
		[dict setValue:aryGroupUsers forKey:@"GroupUsers"];
		[aryResult addObject:dict];
		[dict release];
		[aryGroupUsers release];
	}
	
	[aryGroups release];
	//NSLog(@"aryResult: %@",[aryResult description]);
	NSMutableArray * aryTemp = [NSMutableArray arrayWithArray:aryResult];
	[aryResult release];
	
	return aryTemp;
	
}

- (NSString *)getEncryptedUser 
{
    if (encUserStr == nil || [encUserStr isEqualToString:@""]) {
        if (ISENCRYPTED == 1) {
            NSString *username = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strUserName componentsSeparatedByString:@"@"] objectAtIndex:0];
            NSString *passwd = ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strPassword;
    
            NSString *passkey = [NSString stringWithFormat:@"%@|%@",
                         username,passwd];
            encUserStr = [[passkey AES256EncryptWithKey:@"iPadPulse00000000000000000000000"] retain];
        } else {
            NSString *username = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strUserName componentsSeparatedByString:@"@"] objectAtIndex:0];
            encUserStr = [username retain];
        }
    }
    return encUserStr;
}

-(void)RequestUserProfileWithJid:(NSString*)strJID{
	/****************** Request for User Proflile data ********************
	 <iq from='stpeter@jabber.org/roundabout'
	 id='v1'
	 type='get'>
	 <vCard xmlns='vcard-temp'/>
	 </iq>	 
	 ***********************************************************************/
	NSXMLElement * iq = [NSXMLElement elementWithName:@"iq"];
	[iq addAttributeWithName:@"from" stringValue:strJID];
	[iq addAttributeWithName:@"type" stringValue:@"get"];	
	[iq addAttributeWithName:@"id" stringValue:@"v1"];	
	
	
	 NSXMLElement * vCard = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
	 [iq addChild: vCard];
	 
	 [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:iq];

}

- (NSMutableArray *)fetchedUserwithJid:(NSString*)strJID{
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease]; 
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorage"
											  inManagedObjectContext:[[self xmppRosterStorage] managedObjectContext]
								   ];

	[request setEntity:entity]; 
	
	[request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@",@"jidStr",strJID]];
	NSError *error = nil; 
	
	
	NSMutableArray * array;
	//do{
		array = [NSMutableArray arrayWithArray: [[[self xmppRosterStorage] managedObjectContext] 
												 executeFetchRequest:request error:&error]
							 ];
	//}while ([array count]==0);
	
	
	if(array!=nil){
		return array;
	}else {
		return nil;
	}
}

-(BOOL) isInstructor {
    if ([self.strSelfRole isEqualToString:@"Instructor"] || [self.strSelfRole isEqualToString:@"Teacher"]) {
        return true;
    }
    return false;
}
/*
-(UIImage *) getUserImage:(NSString *)userid {
    NSString *role = [self findUserRole:userid];
    NSLog(@"role:%@",role);
    if ([role isEqualToString:@"Teacher"] || [role isEqualToString:@"Instructor"]) {
        return INSTRUCTOR_IMAGE;            
    } else {
        return STUDENT_IMAGE;                        
    }    
    
    /////
     NSData *photoData = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) xmppvCardAvatarModule] photoDataForJID:ChatUser.jid];
     if(photoData!=nil){
        if([photoData length] >0){
            userImage.image = [UIImage imageWithData:photoData];
        }else {
     
        }
     
     } else {
     
     }////////
     
}

-(UIImage *) getSelfImage {
    if ([self isInstructor]) 
        return INSTRUCTOR_IMAGE;
    return STUDENT_IMAGE;
}*/



-(UIImage *) getUserImage:(NSString *)userid {
    if (USERDEFINEDIMAGES == 0) {
        NSString *role = [self findUserRole:userid];
        if ([role isEqualToString:@"Teacher"] || [role isEqualToString:@"Instructor"]) {
            return INSTRUCTOR_IMAGE;            
        } else {
            return STUDENT_IMAGE;                        
        }
    } else {
        XMPPJID *jid = [XMPPJID jidWithString:userid];
        NSData *photoData = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) xmppvCardAvatarModule] photoDataForJID:jid];
        if(photoData!=nil){
            if([photoData length] >0) {
                return [UIImage imageWithData:photoData];
            }
        }
        // If nothing then
        NSString *role = [self findUserRole:userid];
        if ([role isEqualToString:@"Teacher"] || [role isEqualToString:@"Instructor"]) {
            return INSTRUCTOR_IMAGE;            
        } else {
            return STUDENT_IMAGE;                        
        }
    }
}

-(UIImage *) getSelfImage {
    if (USERDEFINEDIMAGES == 0) {
        if ([self isInstructor]) 
            return INSTRUCTOR_IMAGE;
        return STUDENT_IMAGE;
    } else {
        XMPPJID *jid = [XMPPJID jidWithString:[self strUserName]];
        NSData *photoData = [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) xmppvCardAvatarModule] photoDataForJID:jid];
        if(photoData!=nil){
            if([photoData length] >0) {
                return [UIImage imageWithData:photoData];
            }
        }
        if ([self isInstructor]) 
            return INSTRUCTOR_IMAGE;
        return STUDENT_IMAGE;
    }
}

-(NSString*)findUserRole:(NSString*)UserId {
    NSString *strJid = [[UserId componentsSeparatedByString:@"@"]
                        objectAtIndex:0];

	for(int i=0;i<[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserRoles count];i++)
	{
		if([[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserRoles objectAtIndex:i] valueForKey:@"userid"] isEqualToString:strJid]
		   ){
			return [[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserRoles objectAtIndex:i] valueForKey:@"role"];		
		}
	}
	return nil;	
}

-(void)goOnlineWithPresence:(NSXMLElement *)presence{
	[[self xmppStream] sendElement:presence];
}

- (void)goOnline{
	aryConversationMessages = [[NSMutableArray alloc] init];
	aryUserConversation = [[NSMutableArray alloc] init];

	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	// [presence addAttributeWithName:@"type" stringValue:@"available"];
	
	NSXMLElement *show = [NSXMLElement elementWithName:@"show" 
											 stringValue:@"online"];
	NSXMLElement *status = [NSXMLElement elementWithName:@"status" 
											 stringValue:self.strStatusMessage];
	NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" 
											 stringValue:@"24"];

	//NSXMLElement *status = [NSXMLElement elementWithName:@"status" 
//											 stringValue:@"testing"];
	
	[presence addChild:show];	
	[presence addChild:status];	
	[presence addChild:priority];	
	[[self xmppStream] sendElement:presence];
	
	NSArray *arySentMsgs = [self selectChatHistoryOfUser];
	for (NSDictionary *dict in arySentMsgs) {
		NSMutableDictionary *dictChatMsg = [NSMutableDictionary dictionaryWithDictionary:dict];
		[dictChatMsg setObject:[dict objectForKey:@"toUser"] forKey:@"to"];
		[dictChatMsg setObject:[dict objectForKey:@"fromUser"] forKey:@"from"];
		[dictChatMsg removeObjectForKey:@"toUser"];
		[dictChatMsg removeObjectForKey:@"fromUser"];
		[self.aryConversationMessages addObject:dictChatMsg];
	}
    
	self.aryGroupFileSendingList = [[NSMutableArray alloc] init];
	self.aryGroupFileRecvList = [[NSMutableArray alloc] init];
	
		
}

- (void)GoToChatViewFromUserOption:(NSNotification*)sender {
	
	XMPPUserCoreDataStorage *user = (XMPPUserCoreDataStorage*)[sender object];
	NSString *strJid = [[user.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0];
	if (![((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) IsFoundInActiveUserList:strJid]) {
		[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) aryActiveUsers] 
		 addObject:[NSDictionary dictionaryWithObjectsAndKeys:user, @"user", @"0",@"chatBadge", @"chat", @"type", nil]];
		// NSLog(@"%@", [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers description]);
	}	
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) setIsShowChatWindow:YES];
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) setChatActUser:user];
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) setDictChatActGroup:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SELECTED_MENU_ITEM 
														object:@"1"
	 ];
	
	//[self.navigationController pushViewController:ObjChatViewController animated:NO];
	//	[ObjChatViewController ShowChatWindowWithoutNotification:user];
	//[ObjChatViewController release];	
}

- (void)GoToProgressTrackFromGroupOption:(NSNotification*)sender {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SELECTED_MENU_ITEM object:@"9"];
}


- (void)GoToPollViewFromGroupOption:(NSNotification*)sender 
{	
}

- (void)GoToAssessmentViewFromGroupOption:(NSNotification*)sender 
{	
	// XMPPUserCoreDataStorage *user = (XMPPUserCoreDataStorage*)[sender object];
	// NSString *strJid = [[user.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0];
    // [ObjPopoverController_Menu dismissPopoverAnimated:YES];
	// [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) setChatActUser:user];
	// [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) setDictChatActGroup:nil];
}


- (void)GoToChatViewWithFileTransferFromUserOption:(NSNotification*)sender {
	XMPPUserCoreDataStorage *user = (XMPPUserCoreDataStorage*)[sender object];
	NSString *strJid = [[user.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0];
	if (![((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) IsFoundInActiveUserList:strJid]) {
		[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) aryActiveUsers] 
		 addObject:[NSDictionary dictionaryWithObjectsAndKeys:user, @"user", @"0",@"chatBadge", @"chat", @"type", nil]];
	}	
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) setIsShowChatWindow:YES];
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) setChatActUser:user];
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) setDictChatActGroup:nil];
	
	self.isFileSendingSelected = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SELECTED_MENU_ITEM 
														object:@"1"
	 ];
}

- (void)GoToChatViewFromGroupOption:(NSNotification*)sender {

		NSMutableDictionary *dictUserList = [NSMutableDictionary dictionaryWithDictionary:[sender object]];
		//	NSArray *aryUsersInGrop = [dictUserList objectForKey:@"GroupUsers"];
		BOOL isAvailable = NO;
		//... Allow Only one group chat a at a time ...//
		for (id obj in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers) {
			if ([[obj objectForKey:@"user"] class] != [XMPPUserCoreDataStorage class]) {
				if ([[dictUserList objectForKey:@"GroupName"] isEqualToString:[[obj objectForKey:@"user"] objectForKey: @"GroupName"]]) {
					isAvailable = YES;
					break;
				}
			}
		}
    
    // We submit the alert - if teacher
    if (self.strSelfRole != nil && ([self.strSelfRole isEqualToString:@"Teacher"] || 
                                    [self.strSelfRole isEqualToString:@"Instructor"])) {
        
        // Pass stream 
        // Provide Room Name as [name]@conference.[yourhostname]
        
        //NSString *strRoomId = [NSString stringWithFormat:@"%qi", (long)[[NSDate date] timeIntervalSince1970]];
        
        
        /*
         <iq id="1" type="get" to="services.mqcommunicator">
         <query xmlns="services:iq:addalert">
         <jid>victor</jid>
         <alerttype>Status Update</alerttype>
         <alertmsg>Testing Event</alertmsg>
         <currentdatetime>2011-10-14 01:57:50</currentdatetime>
         <alertkey></alertkey>
         <alertkeyvalue></alertkeyvalue>
         </query>
         </iq> 
         */
        NSXMLElement * iq = [NSXMLElement elementWithName:@"iq"];		
        [iq addAttributeWithName:@"type" stringValue:@"get"];	
        [iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"services.%@",SERVERNAME]];
        
        NSXMLElement * query = [NSXMLElement elementWithName:@"query" xmlns:@"services:iq:addalert"];
		NSXMLElement * jid = [NSXMLElement elementWithName:@"jid" stringValue:
							  [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) getEncryptedUser]];
        // NSXMLElement * jid = [NSXMLElement elementWithName:@"jid" stringValue:
        //                      [[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"
        //                        ] objectAtIndex:0]];
        [query addChild: jid];
        
        NSXMLElement * alerttype = [NSXMLElement elementWithName:@"alerttype" stringValue:@"Status Update"];
        [query addChild: alerttype];
        
        NSXMLElement * alertmsg = [NSXMLElement elementWithName:@"alertmsg" stringValue:[NSString stringWithFormat:@"%@%@%@", @"started a group chat for '", [dictUserList objectForKey:@"GroupName"], @"'"]];
        [query addChild: alertmsg];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss'"];    
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
        [dateFormatter release]; 
        dateFormatter = nil;
        NSXMLElement * currentDateTime = [NSXMLElement elementWithName:@"currentdatetime" stringValue:currentTime];
        [query addChild: currentDateTime];    
        
        NSXMLElement * alertkey = [NSXMLElement elementWithName:@"alertkey" stringValue:@""];
        [query addChild: alertkey];
        
        NSXMLElement * alertkeyvalue = [NSXMLElement elementWithName:@"alertkeyvalue" stringValue:@""];
        [query addChild: alertkeyvalue];
        
        [iq addChild:query];
        
        //NSLog(@"%",[iq description]);    
        [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:iq];
    }

    
		//... Allow Multiple instance of group chat ...//
		/*	for (id obj in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryOwnedGroupChat) {
		 if ([[[obj objectForKey:@"groupName"] lowercaseString] isEqualToString:[[dictUserList objectForKey:@"GroupName"] lowercaseString]]) {
		 isAvailable = YES;
		 break;
		 }
		 }*/
		if (!isAvailable) {
			

		
			NSString *strRoomName = [NSString stringWithFormat:@"%@#1#room@conference.%@", [[dictUserList objectForKey:@"GroupName"] lowercaseString], SERVERNAME];
			XMPPRoom *objRoom = [[XMPPRoom alloc] initWithStream:xmppStream roomName:strRoomName nickName:[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"
																											] objectAtIndex:0]];
			[objRoom setDelegate:self];
			[objRoom createOrJoinRoom];	
			[dictUserList setObject:strRoomName forKey:@"roomId"];
			[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) aryActiveUsers] 
			 addObject:[NSDictionary dictionaryWithObjectsAndKeys:dictUserList, @"user", @"0",@"chatBadge", @"groupChat", @"type", nil]];	
			self.dictChatActGroup = [NSMutableDictionary dictionaryWithObjectsAndKeys:dictUserList, @"user",strRoomName, @"roomId",nil];
			self.chatActUser = nil;
		}
		
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) setIsShowChatWindow:YES];
		
		// NSLog(@"%@", [self.aryActiveUsers description]);
		[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SELECTED_MENU_ITEM 
															object:@"1"
		 ];
//	}
	

}

- (void)GoToFileTransferViewFromGroupOption:(NSNotification*)sender {
	//if (self.strSelfRole != nil && ([self.strSelfRole isEqualToString:@"Teacher"] || 
	//		[self.strSelfRole isEqualToString:@"Instructor"])) {
	NSMutableDictionary *dictUserList = [NSMutableDictionary dictionaryWithDictionary:[sender object]];
	//	NSArray *aryUsersInGrop = [dictUserList objectForKey:@"GroupUsers"];
	BOOL isAvailable = NO;
	//... Allow Only one group chat a at a time ...//
	for (id obj in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers) {
		if ([[obj objectForKey:@"user"] class] != [XMPPUserCoreDataStorage class]) {
			if ([[dictUserList objectForKey:@"GroupName"] isEqualToString:[[obj objectForKey:@"user"] objectForKey: @"GroupName"]]) {
				isAvailable = YES;
				break;
			}
		}
	}
	//... Allow Multiple instance of group chat ...//
	/*	for (id obj in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryOwnedGroupChat) {
	 if ([[[obj objectForKey:@"groupName"] lowercaseString] isEqualToString:[[dictUserList objectForKey:@"GroupName"] lowercaseString]]) {
	 isAvailable = YES;
	 break;
	 }
	 }*/
	if (!isAvailable) {
		
		// Pass stream 
		// Provide Room Name as [name]@conference.[yourhostname]
		
		//NSString *strRoomId = [NSString stringWithFormat:@"%qi", (long)[[NSDate date] timeIntervalSince1970]];
		
		NSString *strRoomName = [NSString stringWithFormat:@"%@#1#room@conference.%@", [[dictUserList objectForKey:@"GroupName"] lowercaseString], SERVERNAME];
		XMPPRoom *objRoom = [[XMPPRoom alloc] initWithStream:xmppStream roomName:strRoomName nickName:[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"
																										] objectAtIndex:0]];
		[objRoom setDelegate:self];
		[objRoom createOrJoinRoom];	
		[dictUserList setObject:strRoomName forKey:@"roomId"];
		[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) aryActiveUsers] 
		 addObject:[NSDictionary dictionaryWithObjectsAndKeys:dictUserList, @"user", @"0",@"chatBadge", @"groupChat", @"type", nil]];	
		self.dictChatActGroup = [NSMutableDictionary dictionaryWithObjectsAndKeys:dictUserList, @"user",strRoomName, @"roomId",nil];
		self.chatActUser = nil;
	}
	
	[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]) setIsShowChatWindow:YES];
	
	// NSLog(@"%@", [self.aryActiveUsers description]);
	self.isFileSendingSelected = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SELECTED_MENU_ITEM 
														object:@"1"
	 ];
	//	}
	
	
}

-(void) resetFirstTimeLogin {
    // This is to reset the automatic login
    timerContactList = nil;
    refreshAuto = 0;
    lastPresenceDate = nil;
    refreshStart = NO;    
}

- (void)goOffline{
	[aryConversationMessages release]; aryConversationMessages = nil;
	[aryUserConversation release]; aryUserConversation = nil;
	
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	[presence addAttributeWithName:@"type" stringValue:@"unavailable"];

	NSXMLElement * status = [NSXMLElement elementWithName:@"status" stringValue:@"testing"
							 ];
	[presence addChild:status];
	
	[[self xmppStream] sendElement:presence];
	[self.aryGroupFileRecvList release];
    
	[self.aryGroupFileSendingList release];

    [self.aryPollMessages release];
    [self.aryActiveUsers release];
    [self.aryContactLists release];
    [self.polls release];
    
    if (aryContactListExpandValue != nil) {
        [aryContactListExpandValue release];
        aryContactListExpandValue = nil;
    }
    
    aryContactLists = [[NSMutableArray alloc] init];
	aryActiveUsers = [[NSMutableArray alloc] init];
	aryPollMessages = [[NSMutableArray alloc] init];
	polls = [[NSMutableArray alloc] init];
    [self.menuToolBar removeFromSuperview];
}

-(BOOL)IsValidEmailAddress:(NSString*)strEmail{
	NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
	
	
	NSPredicate *regEmailValidator = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
	return [regEmailValidator evaluateWithObject:strEmail];
}

-(void)BtnApplicationMenuTabbed:(id)sender
{
		ObjMenuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
		if(ObjPopoverController_Menu!=nil && [ObjPopoverController_Menu retainCount]>0)
        {
			[ObjPopoverController_Menu release];
			ObjPopoverController_Menu = nil;
		}
		ObjPopoverController_Menu = [[UIPopoverController alloc] initWithContentViewController:ObjMenuViewController];
		ObjPopoverController_Menu.delegate = self;
        if ( ISDEVELOPMENT == 1) {
            ObjPopoverController_Menu.popoverContentSize = CGSizeMake(320,410);
        } else {
            ObjPopoverController_Menu.popoverContentSize = CGSizeMake(320,320);            
            // ObjPopoverController_Menu.popoverContentSize = CGSizeMake(320,320);            
        }
		CGRect popoverRect = [self.window convertRect:[sender frame] fromView:[sender superview]];
		
		[ObjPopoverController_Menu presentPopoverFromRect:popoverRect 
																	 inView:self.window 
												   permittedArrowDirections:UIPopoverArrowDirectionUp
																   animated:YES];
		
		[ObjMenuViewController release];
}
-(void)BtnCloseApplicationMenuTabbed:(id)sender{
	[ObjPopoverController_Menu dismissPopoverAnimated:YES];
}
-(void)BtnCloseApplicationThemesTabbed:(id)sender{
	[ObjPopoverController_Themes dismissPopoverAnimated:YES];
}

-(void)BtnThemesTabbed:(id)sender{
	ObjThemesViewController = [[ThemesViewController alloc] initWithNibName:@"ThemesViewController" bundle:nil];
	if(ObjPopoverController_Themes!=nil && [ObjPopoverController_Themes retainCount]>0){
		[ObjPopoverController_Themes release];
		ObjPopoverController_Themes = nil;
	}
	
	ObjPopoverController_Themes = [[UIPopoverController alloc] initWithContentViewController:ObjThemesViewController];
	ObjPopoverController_Themes.delegate = self;
	ObjPopoverController_Themes.popoverContentSize = CGSizeMake(287,215);
	CGRect popoverRect = [self.window convertRect:[sender frame] fromView:[sender superview]];
	
	[ObjPopoverController_Themes presentPopoverFromRect:popoverRect 
											   inView:self.window 
							 permittedArrowDirections:UIPopoverArrowDirectionUp
											 animated:YES];
	
	[ObjThemesViewController release];	
}

-(void)BtnSettingTabbed:(id)sender{
    /*
	ObjSettingPopupViewController = [[SettingsPopupViewController alloc] initWithNibName:@"SettingsPopupViewController" bundle:nil];
    NSLog(@"%@", [ObjSettingPopupViewController description]);
     */
    ObjSettingPopupViewController = [[SettingsPopupViewController alloc] initWithNibName:@"SettingsPopupViewController" bundle:nil];
	if(ObjPopoverController_Themes!=nil && [ObjPopoverController_Themes retainCount]>0){
		[ObjPopoverController_Themes release];
		ObjPopoverController_Themes = nil;
	}

	ObjPopoverController_Themes = [[UIPopoverController alloc] initWithContentViewController:ObjSettingPopupViewController];
	ObjPopoverController_Themes.delegate = self;
	ObjPopoverController_Themes.popoverContentSize = CGSizeMake(287,210);
	CGRect popoverRect = [self.window convertRect:[sender frame] fromView:[sender superview]];
	
	[ObjPopoverController_Themes presentPopoverFromRect:popoverRect 
                                                 inView:self.window 
                               permittedArrowDirections:UIPopoverArrowDirectionUp
                                               animated:YES];
	
	[ObjSettingPopupViewController release];	
}


- (void)EditProfileInfoSucceed:(NSNotification*)noti {
}



#pragma mark -
#pragma mark popover delegate Methods
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{	
	return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {

	//if(ObjPopoverController_Profile!=nil && [ObjPopoverController_Profile retainCount]>0){
//		[ObjPopoverController_Profile release];
//		ObjPopoverController_Profile = nil;
//	}
}
#pragma mark -
#pragma mark Audio(checking Sound Status) Methods
-(BOOL)IsSilenced{
#if TARGET_IPHONE_SIMULATOR
	// return NO in simulator. Code causes crashes for some reason.
	return NO;
#endif
	
    CFStringRef state;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
    if(CFStringGetLength(state) > 0)
		return NO;
    else
		return YES;
	
}

- (void)xmppRoom:(XMPPRoom *)room didEnter:(BOOL)enter {
	// NSLog(@"Call Friends Now");
	//[room sendConfigRoomInstance];
	//NSLog(@"%@",[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers description]);
	for (id obj in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryActiveUsers) {
		if ([[obj objectForKey:@"user"] class] != [XMPPUserCoreDataStorage class]) {
			// NSLog(@"%@", [obj description]);
			// NSLog(@"%@", room.roomName);
			if ([[[[obj objectForKey: @"user"]objectForKey:@"GroupName"] lowercaseString] isEqualToString:[[[room roomName] componentsSeparatedByString:@"#"] objectAtIndex:0]]) {
				for (XMPPUserCoreDataStorage *user in [[obj objectForKey: @"user"]objectForKey:@"GroupUsers"]) {
					if ([user.sectionNum intValue] == 0) {
						[room inviteUser:user.jid message:@"Group chat started"];
					}					
				}
			}
		}
	}
}

#pragma mark -
#pragma mark Database Methods


//
/// Copy Database file to document directory
//
- (void)copyFilesToDocumentDirIfNotAlreadyExist {
	NSArray *aryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

	strDatabasePath = [[[aryPath objectAtIndex:0] stringByAppendingPathComponent:@"MobileJabberAppDb.sqlite"] retain];
	if (![[NSFileManager defaultManager] fileExistsAtPath:strDatabasePath]) {
		NSString *strResourceDBPath = [[NSBundle mainBundle] pathForResource:@"MobileJabberAppDb" ofType:@"sqlite"];
		[[NSFileManager defaultManager] copyItemAtPath:strResourceDBPath toPath:strDatabasePath error:nil];
	}
}

//
/// Open Database
//
- (void)openDatabase {
	sqlite3_open([strDatabasePath UTF8String], &self->database);
	//self.database = database;
}


//
/// Customize Dictionary and Call Insert Method from Sqlite Handler
//
- (void)insertChatHistory:(NSDictionary*)dict {	
	NSMutableDictionary *dictChatMessage = [NSMutableDictionary dictionaryWithDictionary:dict];
	[dictChatMessage setObject:[[dict objectForKey:@"to"] description] forKey:@"toUser"];
	[dictChatMessage setObject:[[[[dict objectForKey:@"from"] description] componentsSeparatedByString:@"/"] objectAtIndex:0] forKey:@"fromUser"];
	[dictChatMessage removeObjectForKey:@"to"];
	[dictChatMessage removeObjectForKey:@"from"];
    @try {
        [self.objSqliteHandler insertSingle:dictChatMessage inTable:@"ChatHistory"];
    }
    @catch (NSException *exc) {
        NSLog(@"Exception inserting chat history - %@", [exc description]);
    }
}

- (NSArray*)selectChatHistoryOfUser {
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[self.xmppStream myJID] bare], @"toUser",
						  [[self.xmppStream myJID] bare], @"fromUser", nil];
	NSMutableArray *aryMessages = [self.objSqliteHandler selectWholeRecordFrom:@"ChatHistory" withWhere:dict type:@"or"];
	
	
	NSMutableArray *aryUserMsgList = [[NSMutableArray alloc] init];
	
	for (NSDictionary *dictMsg in aryMessages) {
		
		NSMutableArray *aryTempUserMsg = [[NSMutableArray alloc] init];
		
		NSString *strUserId = @"";
		if ([[dictMsg objectForKey:@"fromUser"] isEqualToString:[[self.xmppStream myJID] bare]]) {
			strUserId = [dictMsg objectForKey:@"toUser"];
			BOOL isAvailble = NO;
			for (NSDictionary *dictUserId in aryUserMsgList) {
				if ([[dictUserId objectForKey:@"userId"] isEqualToString:strUserId]) {
					isAvailble = YES;
				}
			}
			if (!isAvailble) {
				for (int j = 0; j < [aryMessages count]; j++) {
					NSDictionary *dictTempMsg = [aryMessages objectAtIndex:j];
					if ([[dictTempMsg objectForKey:@"fromUser"] isEqualToString:strUserId] || 
						[[dictTempMsg objectForKey:@"toUser"] isEqualToString:strUserId]) {
						[aryTempUserMsg addObject:dictTempMsg];
					}
				}
			}
			else {
				continue;
			}

		}
		else {
			strUserId = [dictMsg objectForKey:@"fromUser"];
			BOOL isAvailble = NO;
			for (NSDictionary *dictUserId in aryUserMsgList) {
				if ([[dictUserId objectForKey:@"userId"] isEqualToString:strUserId]) {
					isAvailble = YES;
				}
			}
			if (!isAvailble) {
				for (int j = 0; j < [aryMessages count]; j++) {
					NSDictionary *dictTempMsg = [aryMessages objectAtIndex:j];
					if ([[dictTempMsg objectForKey:@"fromUser"] isEqualToString:strUserId] || 
						[[dictTempMsg objectForKey:@"toUser"] isEqualToString:strUserId]) {
						[aryTempUserMsg addObject:dictTempMsg];
						
					}
				}
			}
			else {
				continue;
			}

		}
		[aryUserMsgList addObject:[NSDictionary dictionaryWithObjectsAndKeys:strUserId, @"userId",
								   aryTempUserMsg, @"messageList",nil]];
	}
	int ind = 0;
	[aryMessages removeAllObjects];
	for (NSDictionary *dictNew in aryUserMsgList) {
		NSMutableArray *ary = [dictNew objectForKey:@"messageList"];
		if ([ary count] > 20) {
			int diff = [ary count] - 20;
			[ary removeObjectsInRange:NSMakeRange(0, diff)];
		//	[ary removeObjectsFromIndices:0 numIndices:diff-1];
			//NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dictNew];
			//[mDict setObject:ary forKey:@"messageList"];
			//[aryUserMsgList replaceObjectAtIndex:ind withObject:mDict];
			//[aryMessages addObjectsFromArray:ary];
		}
		[aryMessages addObjectsFromArray:ary];

	}

	[objSqliteHandler deleteAllRecordsWhere:dict inTable:@"ChatHistory"];
	[objSqliteHandler insertMultiple:aryMessages inTable:@"ChatHistory"];
	
	return aryMessages;
}
		
-(IBAction)BtnMenuItemTabbedAtMenuBar:(id)sender{
	[ObjPopoverController_Menu dismissPopoverAnimated:YES];
	self.isChatWindowUp = NO;
	if([sender tag] == 0){
        if(!(self.window.rootViewController == self.navHome))
        {
            [self.window setRootViewController:self.navHome];
        }
	}
	else if([sender tag] == 1){		
		self.isChatWindowUp = YES;
        if(!(self.window.rootViewController == self.navChat))
        {
            [self.window setRootViewController:nil];
            [self.window setRootViewController:self.navChat];
        }
	}
	else if([sender tag] == 3){
        if(!(self.window.rootViewController == self.navLearningCenter))
        {
            self.showHelp = 0;
            self.window.rootViewController = self.navLearningCenter;			
        }
	}else if([sender tag] == 4){
        if (self.navReflections == self.navReflections)
		{
			[self.window setRootViewController:self.navReflections];
        }
	}else if([sender tag] == 5) {
	}
    else if([sender tag] == 6) {
	} 
}

- (void)updateGlobalChatBadgeOnMenuBar {
	if (globalChatMessageCount>0) {
		[[self.menuToolBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d", globalChatMessageCount]];
		//btnChatCount.hidden = NO;
//		[btnChatCount setTitle:[NSString stringWithFormat:@"%d", globalChatMessageCount] forState:UIControlStateNormal];
	}
	else {
		[[self.menuToolBar.items objectAtIndex:1] setBadgeValue:nil];
		//btnChatCount.hidden = YES;		
	}	
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	//NSLog(@"%i",item.tag);
	
	[self BtnMenuItemTabbedAtMenuBar:item];
}

-(void)logout {
    self.hardLogout = 1;
    [self.navResourceGallery popToRootViewControllerAnimated:YES];      /////
    [self.navChat popToRootViewControllerAnimated:YES];
    [self.navLearningCenter popToRootViewControllerAnimated:YES];
    [self.navSettings popToRootViewControllerAnimated:YES];
    [self.navHome popToRootViewControllerAnimated:YES];        
    self.window.rootViewController = self.navHome;
    [self.navResourceGallery popViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"gallery"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self LogoutUser];
    [self goOffline];
}

-(void)changePassword {
    UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"Change Password" message:@"Password must be 8 characters, contain an upper case, lower case and a numeric digit\n\n" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    
    UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(16,113,252,25)];
    passwordField.borderStyle = UITextBorderStyleRoundedRect;
    passwordField.secureTextEntry = YES;
    passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
    passwordField.tag = 3;
    //passwordField.delegate = self;
    [passwordField becomeFirstResponder];
    [passwordAlert addSubview:passwordField];
    
    [passwordAlert setTransform:CGAffineTransformMakeTranslation(0,109)];
    [passwordAlert show];
    [passwordAlert release];
}

-(void)showHelpPage {
    if(!(self.window.rootViewController == self.navLearningCenter))
    {
        self.showHelp = 1;
        self.window.rootViewController = self.navLearningCenter;			
    }
}

-(void)showSettings {
    if(!(self.window.rootViewController == self.navSettings))
    {
        self.window.rootViewController = self.navSettings;
    }
}



@end

