//
//  FileTransfer.m
//  MobileJabber
//
//  Created by Shivang Vyas on 7/12/11.
//  Copyright 2011 company. All rights reserved.
//

#import "FileTransfer.h"


@implementation FileTransfer

@synthesize strSenderJID,strReceiverJID,strFileName,fileSize,dtFileContents;

/*
-(id) initWithSenderJID:(NSString*)SenderJID ReceiverJID:(NSString*)ReceiverJID FileName:(NSString*)FileName FileSize:(double)FileSize FileContents:(NSData*) FileContents{
	if(self=[super init]){
		
		self.strReceiverJID = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@",ReceiverJID]
						];
		self.strSenderJID = [[NSString alloc] initWithString:SenderJID];
		self.strFileName = [[NSString alloc] initWithString:FileName];
		self.fileSize  = FileSize;
		
		self.dtFileContents = [[NSData alloc] initWithData:FileContents];
		return self;
	}
	return nil;	
}
*/

-(id) initWithStream:(XMPPStream*)axmppStream{
	if(self=[super initWithStream:axmppStream]){ 		
		return self;
	}
	return nil;
}

-(void) CreateAndSendFileTransferRequest{
/*
 <iq id="JN_35"	type="get" to="victor@mqcommunicator/Messenger">
	<query xmlns="file:iq:transfer">
		C:\Docs\BusinessCV.doc|54 KB
	</query>
</iq> 
 */

	NSXMLElement * iq = [NSXMLElement elementWithName:@"iq"];		
	[iq addAttributeWithName:@"type" stringValue:@"get"];	
	[iq addAttributeWithName:@"to" stringValue:strReceiverJID];
	
	NSXMLElement * query = [NSXMLElement elementWithName:@"query" 
											 stringValue:[NSString stringWithFormat:
														  @"%@|%0.0f",strFileName,fileSize]
							];
	
	[query setXmlns:@"file:iq:transfer"];
	
	[iq addChild:query];
	
	//NSLog(@"%@",[iq description]);
	
	[super.xmppStream sendElement:iq];
	
	
}

#pragma mark -
#pragma mark XMPPStream delegate Methods
- (void)xmppStreamWillConnect:(XMPPStream *)sender{
	/**
	 * This method is called before the socket connects with the remote host.
	 * 
	 * If developing an iOS app that runs in the background, this is where you would enable background sockets.
	 * For example:
	 * 
	 * CFReadStreamSetProperty([socket getCFReadStream], kCFStreamNetworkServiceType, kCFStreamNetworkServiceTypeVoIP);
	 * CFWriteStreamSetProperty([socket getCFWriteStream], kCFStreamNetworkServiceType, kCFStreamNetworkServiceTypeVoIP);
	 **/	
}

- (void)xmppStream:(XMPPStream *)sender socketWillConnect:(AsyncSocket *)socket{
/**
 * This method is called after a TCP connection has been established with the server,
 * and the opening XML stream negotiation has started.
 **/

}
- (void)xmppStreamDidStartNegotiation:(XMPPStream *)sender{
/**
 * This method is called immediately prior to the stream being secured via TLS/SSL.
 * Note that this delegate may be called even if you do not explicitly invoke the startTLS method.
 * Servers have the option of requiring connections to be secured during the opening process.
 * If this is the case, the XMPPStream will automatically attempt to properly secure the connection.
 * 
 * The possible keys and values for the security settings are well documented.
 * Some possible keys are:
 * - kCFStreamSSLLevel
 * - kCFStreamSSLAllowsExpiredCertificates
 * - kCFStreamSSLAllowsExpiredRoots
 * - kCFStreamSSLAllowsAnyRoot
 * - kCFStreamSSLValidatesCertificateChain
 * - kCFStreamSSLPeerName
 * - kCFStreamSSLCertificates
 * 
 * Please refer to Apple's documentation for associated values, as well as other possible keys.
 * 
 * The dictionary of settings is what will be passed to the startTLS method of ther underlying AsyncSocket.
 * The AsyncSocket header file also contains a discussion of the security consequences of various options.
 * It is recommended reading if you are planning on implementing this method.
 * 
 * The dictionary of settings that are initially passed will be an empty dictionary.
 * If you choose not to implement this method, or simply do not edit the dictionary,
 * then the default settings will be used.
 * That is, the kCFStreamSSLPeerName will be set to the configured host name,
 * and the default security validation checks will be performed.
 * 
 * This means that authentication will fail if the name on the X509 certificate of
 * the server does not match the value of the hostname for the xmpp stream.
 * It will also fail if the certificate is self-signed, or if it is expired, etc.
 * 
 * These settings are most likely the right fit for most production environments,
 * but may need to be tweaked for development or testing,
 * where the development server may be using a self-signed certificate.
 **/

}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings{
/**
 * This method is called after the stream has been secured via SSL/TLS.
 * This method may be called if the server required a secure connection during the opening process,
 * or if the secureConnection: method was manually invoked.
 **/

}

- (void)xmppStreamDidSecure:(XMPPStream *)sender{
/**
 * This method is called after the XML stream has been fully opened.
 * More precisely, this method is called after an opening <xml/> and <stream:stream/> tag have been sent and received,
 * and after the stream features have been received, and any required features have been fullfilled.
 * At this point it's safe to begin communication with the server.
 **/

}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
/**
 * This method is called after registration of a new user has successfully finished.
 * If registration fails for some reason, the xmppStream:didNotRegister: method will be called instead.
 **/

}

- (void)xmppStreamDidRegister:(XMPPStream *)sender{
/**
 * This method is called if registration fails.
 **/	
}


- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
/**
 * This method is called after authentication has successfully finished.
 * If authentication fails for some reason, the xmppStream:didNotAuthenticate: method will be called instead.
 **/

}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
/**
 * This method is called if authentication fails.
 **/

}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
/**
 * These methods are called after their respective XML elements are received on the stream.
 * 
 * In the case of an IQ, the delegate method should return YES if it has or will respond to the given IQ.
 * If the IQ is of type 'get' or 'set', and no delegates respond to the IQ,
 * then xmpp stream will automatically send an error response.
 **/

}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{

}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
/**
 * There are two types of errors: TCP errors and XMPP errors.
 * If a TCP error is encountered (failure to connect, broken connection, etc) a standard NSError object is passed.
 * If an XMPP error is encountered (<stream:error> for example) an NSXMLElement object is passed.
 * 
 * Note that standard errors (<iq type='error'/> for example) are delivered normally,
 * via the other didReceive...: methods.
 **/

}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error{

/**
 * These methods are called before their respective XML elements are sent over the stream.
 * These methods can be used to customize elements on the fly.
 * (E.g. add standard information for custom protocols.)
 **/

}

- (void)xmppStream:(XMPPStream *)sender willSendIQ:(XMPPIQ *)iq{

}

- (void)xmppStream:(XMPPStream *)sender willSendMessage:(XMPPMessage *)message{

}

- (void)xmppStream:(XMPPStream *)sender willSendPresence:(XMPPPresence *)presence{

}

/**
 * These methods are called after their respective XML elements are sent over the stream.
 * These methods may be used to listen for certain events (such as an unavailable presence having been sent),
 * or for general logging purposes. (E.g. a central history logging mechanism).
 **/

- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq{

}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{

}

- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence{

}

/**
 * This method is called for every sendElement:andNotifyMe: method.
 **/
- (void)xmppStream:(XMPPStream *)sender didSendElementWithTag:(UInt16)tag{

}

/**
 * This method is called if the disconnect method is called.
 * It may be used to determine if a disconnection was purposeful, or due to an error.
 **/
- (void)xmppStreamWasToldToDisconnect:(XMPPStream *)sender{
}

/**
 * This method is called after the stream is closed.
 **/
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender{
	
}




@end
