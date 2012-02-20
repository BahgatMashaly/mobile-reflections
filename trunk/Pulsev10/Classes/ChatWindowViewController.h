//
//  ChatWindowViewController.h
//  MobileJabber
//
//  Created by Shivang Vyas on 7/2/11.
//  Copyright 2011 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPUserCoreDataStorage.h"
#import "TblChatConversationDataSource.h"
#import "TblChatConversationDelegate.h"

@interface ChatWindowViewController : UIViewController <UINavigationControllerDelegate,UIPopoverControllerDelegate> {
	IBOutlet UILabel * lblUserName;
	XMPPUserCoreDataStorage * ObjXMPPUserCoreDataStorage;
	NSDictionary *dictGroupChatUser;
	IBOutlet UIView * viwSendMessage;
	IBOutlet UITableView * TblChatConversation;
	IBOutlet UITextField * txtMessage;
	TblChatConversationDataSource * ObjTblChatConversationDataSource;
	TblChatConversationDelegate * ObjTblChatConversationDelegate;
	IBOutlet UIImagePickerController * imgpkctrl_File;
	UIPopoverController * popCtrl_OpenFile;
	IBOutlet UIBarButtonItem * BtnSendFile;
	IBOutlet UIButton *btnFileSend;
	NSOperationQueue * queue;
	BOOL isFileSend;
	NSString *strUniqueFileId;
	int *fileType;
}

@property (nonatomic,retain) XMPPUserCoreDataStorage * ObjXMPPUserCoreDataStorage;
@property (nonatomic, retain) NSDictionary *dictGroupChatUser;

-(void)BtnSendMessageTabbed:(id)sender;
-(void)UpdateUserChat:(id)sender;
-(IBAction)BtnSendFileTabbed:(id)sender;
-(IBAction)BtnCloseTabbed:(id)sender;

@end
