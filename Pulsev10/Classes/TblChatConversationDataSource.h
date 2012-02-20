//
//  TblChatConversationDataSource.h
//  MobileJabber
//
//  Created by Shivang Vyas on 7/2/11.
//  Copyright 2011 company. All rights reserved.
//

#import "CustomURLConnection.h"
#import <Foundation/Foundation.h>
#import "TblChatConversationCell.h"
#import "XMPPUserCoreDataStorage.h"

@interface TblChatConversationDataSource : NSObject <UITableViewDataSource>{
	NSMutableArray *ary;
	XMPPUserCoreDataStorage * ChatUser;
	NSMutableData *responseData;
	NSMutableArray *aryRequest;
	BOOL isSelfMessage;
	BOOL isFirstMessage;
	NSString *strLastUserName;
}
@property(nonatomic,retain) XMPPUserCoreDataStorage * ChatUser;
@end
