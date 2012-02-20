//
//  FileTransfer.h
//  MobileJabber
//
//  Created by Shivang Vyas on 7/12/11.
//  Copyright 2011 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPStream.h"
#import "XMPPModule.h"

@interface FileTransfer : XMPPModule <XMPPStreamDelegate> {
	NSString * strSenderJID;
	NSString * strReceiverJID;
	NSString * strFileName;
	double fileSize;
	NSData * dtFileContents;
}

@property(nonatomic,retain) NSString * strSenderJID;
@property(nonatomic,retain) NSString * strReceiverJID;
@property(nonatomic,retain) NSString * strFileName;
@property(nonatomic,readwrite) double fileSize;
@property(nonatomic,retain) NSData * dtFileContents;

//-(id) initWithSenderJID:(NSString*)SenderJID ReceiverJID:(NSString*)ReceiverJID FileName:(NSString*)FileName FileSize:(double)FileSize FileContents:(NSData*) FileContents;
-(id) initWithStream:(XMPPStream*)xmppStream;
-(void) CreateAndSendFileTransferRequest;
@end
