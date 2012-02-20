//
//  XMPPStreamHandler.h
//  MobileJabber
//
//  Created by Shivang Vyas on 6/20/11.
//  Copyright 2011 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RosterIQParser.h"
#import "UserRolesIQParser.h"
#import "FileTransfer.h"
#import "ProfileIQParser.h"

@interface XMPPStreamHandler : NSObject {
	RosterIQParser * ObjRosterIQParser;
	UserRolesIQParser * ObjUserRolesIQParser;
	BOOL isOpen;
	FileTransfer * ObjFileTransfer;
	ProfileIQParser * ObjProfileIQParser;
	NSMutableData *responseData;
}

- (void)sendFileUrl:(NSString*)strFileId;

@end
