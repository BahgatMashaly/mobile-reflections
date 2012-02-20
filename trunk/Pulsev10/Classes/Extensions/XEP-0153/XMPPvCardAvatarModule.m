//
//  XMPPvCardAvatarModule.h
//  XEP-0153 vCard-Based Avatars
//
//  Created by Eric Chamberlain on 3/9/11.
//  Copyright 2011 RF.com. All rights reserved.


// TODO: publish after upload vCard
/*
 * XEP-0153 Section 4.2 rule 1
 *
 * However, a client MUST advertise an image if it has just uploaded the vCard with a new avatar 
 * image. In this case, the client MAY choose not to redownload the vCard to verify its contents.
 */


#ifdef DEBUG_LEVEL
  #undef DEBUG_LEVEL
  #define DEBUG_LEVEL 1
#endif


#import "XMPPvCardAvatarModule.h"

#import "NSDataAdditions.h"
#import "NSXMLElementAdditions.h"
#import "XMPPPresence.h"
#import "XMPPvCardTempModule.h"


NSString *const kXMPPvCardAvatarElement = @"x";
NSString *const kXMPPvCardAvatarNS = @"vcard-temp:x:update";
NSString *const kXMPPvCardAvatarPhotoElement = @"photo";


@implementation XMPPvCardAvatarModule


#pragma mark -
#pragma mark Init/dealloc methods


- (id)initWithvCardTempModule:(XMPPvCardTempModule *)xmppvCardTempModule {
	if ((self = [super initWithStream:xmppvCardTempModule.xmppStream])) {
    _xmppvCardTempModule = [xmppvCardTempModule retain];
    _moduleStorage = (id <XMPPvCardAvatarStorage>)xmppvCardTempModule.moduleStorage;
    
    [_xmppvCardTempModule addDelegate:self];
	}
	return self;
}


- (void)dealloc {
  [_xmppvCardTempModule removeDelegate:self];
  
  [_moduleStorage release];
  _moduleStorage = nil;
  
  [_xmppvCardTempModule release];
  _xmppvCardTempModule = nil;
  
	[super dealloc];
}


#pragma mark - Public instance methods


- (NSData *)photoDataForJID:(XMPPJID *)jid {
	NSLog(@"%@",[jid description]);
	
  NSData *photoData = [_moduleStorage photoDataForJID:jid];

  if (photoData == nil) {
      // Rakesh vcard Modified to use cache
      [_xmppvCardTempModule fetchvCardTempForJID:jid xmppStream:xmppStream useCache:YES];
      // [_xmppvCardTempModule fetchvCardTempForJID:jid xmppStream:xmppStream useCache:NO];
	  
  }

/* 
	NSLog(@"User1:%@",[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID
						  ] description] componentsSeparatedByString:@"@"] objectAtIndex:0]);
	
	NSLog(@"User2: %@",[[[jid description] componentsSeparatedByString:@"@"
						 ] objectAtIndex:0]);
	
	if([[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID
		  ] description] componentsSeparatedByString:@"@"] objectAtIndex:0] isEqualToString:[[[jid description] componentsSeparatedByString:@"@"
																																   ] objectAtIndex:0]
		]){
		if(photoData!=nil){
			if([photoData length]>0){
				((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).imvProfileImage.image = [UIImage imageWithData:photoData];
								[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).navigationController.navigationBar drawRect:((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).navigationController.navigationBar.frame
								 ];
				
			}
		}
		
	}
*/	
	
  return photoData;
}


#pragma mark -
#pragma mark XMPPStreamDelegate methods


- (void)xmppStreamWillConnect:(XMPPStream *)sender {
  /* 
   * XEP-0153 Section 4.2 rule 1
   *
   * A client MUST NOT advertise an avatar image without first downloading the current vCard. 
   * Once it has done this, it MAY advertise an image. 
   */
  [_moduleStorage clearvCardTempForJID:[sender myJID]];
}


- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    // Rakesh vcard use cache
    [_xmppvCardTempModule fetchvCardTempForJID:[sender myJID] xmppStream:sender useCache:YES];
    // [_xmppvCardTempModule fetchvCardTempForJID:[sender myJID] xmppStream:sender useCache:NO];
}


- (void)xmppStream:(XMPPStream *)sender willSendPresence:(XMPPPresence *)presence {  
  // add our photo info to the presence stanza
	BOOL isGroupChat = NO;
	for (NSDictionary *dict in ((MobileJabberAppDelegate*) [[UIApplication sharedApplication] delegate]).aryContactLists) {
		if ([[[dict objectForKey:@"GroupName"] lowercaseString] isEqualToString:[[[[[presence valueForKey:@"to"] description] componentsSeparatedByString:@"#"]objectAtIndex:0] lowercaseString]]) {
			isGroupChat = YES;
		}
	}
	if (!isGroupChat) {
        /*
         Rakesh - commented out - to not send vcard
		NSXMLElement *photoElement = nil;
		NSXMLElement *xElement = [NSXMLElement elementWithName:kXMPPvCardAvatarElement xmlns:kXMPPvCardAvatarNS];
		
		NSString *photoHash = [_moduleStorage photoHashForJID:[sender myJID]];
		
		if (photoHash != nil) {
			photoElement = [NSXMLElement elementWithName:kXMPPvCardAvatarPhotoElement stringValue:photoHash];
		} else {
			photoElement = [NSXMLElement elementWithName:kXMPPvCardAvatarPhotoElement];
		}
		
		[xElement addChild:photoElement];
		[presence addChild:xElement];
         */
		//<presence><status>Hi</status><Latitude></Latitude><Longitude></Longitude></presence>
	}
	
}


- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence  {
  NSXMLElement *xElement = [presence elementForName:kXMPPvCardAvatarElement xmlns:kXMPPvCardAvatarNS];
  
  if (xElement == nil) {
    return;
  }
  
  NSString *photoHash = [[xElement elementForName:kXMPPvCardAvatarPhotoElement] stringValue];
  
  if (photoHash == nil || [photoHash isEqualToString:@""]) {
    return;
  }
  
  XMPPJID *jid = [presence from];
  
  // check the hash
  if (![photoHash isEqualToString:[_moduleStorage photoHashForJID:jid]]) {
      // Rakesh vcard
      [_xmppvCardTempModule fetchvCardTempForJID:jid xmppStream:sender useCache:YES];
      //[_xmppvCardTempModule fetchvCardTempForJID:jid xmppStream:sender useCache:NO];
  }
}


#pragma mark -
#pragma mark XMPPvCardTempModuleDelegate


- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule 
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp 
                     forJID:(XMPPJID *)jid
                 xmppStream:(XMPPStream *)aXmppStream {
  /*
   * XEP-0153 4.1.3                                                                                                                                           
   * If the client subsequently obtains an avatar image (e.g., by updating or retrieving the vCard), 
   * it SHOULD then publish a new <presence/> stanza with character data in the <photo/> element.
   */
	NSLog(@"%@",[[aXmppStream myJID] bareJID]);
	NSLog(@"%@", [aXmppStream description]);
	NSLog(@"%@", vCardTemp.jid);
  if ([jid isEqual:[[aXmppStream myJID] bareJID]] || jid == nil) {
	  
    NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];	  
    [aXmppStream sendElement:presence];
	 
	  [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_USER_AVTAR object:vCardTemp.photo
	   ];
	  
  }
	/*else {
		if (((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactEmail == nil ||
			[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactEmail retainCount] <= 0) {
			((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactEmail = [[NSMutableArray alloc] init];
		}

		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactEmail addObject:
		 [NSDictionary dictionaryWithObjectsAndKeys:vCardTemp.jid, @"jid", vCardTemp.emailAddresses, @"email", nil]];
	}*/

}


#pragma mark -
#pragma mark Getter/setter methods


@synthesize xmppvCardTempModule = _xmppvCardTempModule;


@end
