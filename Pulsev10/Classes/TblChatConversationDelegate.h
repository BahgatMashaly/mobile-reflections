//
//  TblChatConversationDelegate.h
//  MobileJabber
//
//  Created by Shivang Vyas on 7/2/11.
//  Copyright 2011 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPUserCoreDataStorage.h"

@interface TblChatConversationDelegate : NSObject <UITableViewDelegate> {
	NSMutableArray *ary;
	XMPPUserCoreDataStorage * ChatUser;
}
@property (nonatomic,retain) XMPPUserCoreDataStorage * ChatUser;
@end
