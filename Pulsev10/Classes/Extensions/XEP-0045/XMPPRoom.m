#import "XMPPRoom.h"

#import "XMPPMessage+XEP0045.h"
#import "XMPPStream.h"
#import "XMPPJID.h"

@interface XMPPRoom ()
- (void)sendInstantRoomConfig;
@end

static NSString *const XMPPMUCNamespaceName = @"http://jabber.org/protocol/muc";
static NSString *const XMPPMUCUserNamespaceName = @"http://jabber.org/protocol/muc#user";
static NSString *const XMPPMUCOwnerNamespaceName = @"http://jabber.org/protocol/muc#owner";

@implementation XMPPRoom
@synthesize stream;
@synthesize roomName, nickName, subject;
@synthesize isJoined;
@synthesize occupants;

/////////////////////////////////////////////////
#pragma mark Constructor Methods
/////////////////////////////////////////////////

- (id)init
{
	NSAssert(NO, @"Do not alloc XMPPRoom. Use -initWithStream:roomName:");
	return nil;
}

// initializes a room for given room name and for nick name.
// Provide Room Name as [name]@conference.[yourhostname] as Input.
- (id)initWithStream:(XMPPStream *)aStream roomName:(NSString *)name nickName:(NSString *)nickname
{
	if((self = [super init]))
	{
		stream = [aStream retain];
		roomName = [name retain];
		nickName = [nickname retain];
		[stream addDelegate:self];
		occupants = [NSMutableDictionary new];
		// NSLog(@"[XMPPRoom] initWithStream:roomName:%@ nick:%@",roomName,nickName);
	}
	return self;
}

/////////////////////////////////////////////////
#pragma mark Properties
/////////////////////////////////////////////////

- (XMPPStream *)stream {
	return stream;
}

- (NSString *)roomName {
	return roomName;
}

- (NSString *)nickname {
	return nickName;
}

- (NSString *)subject {
	return subject;
}

- (BOOL)isJoined {
	return isJoined;
}

- (NSMutableDictionary *)occupants {
	return occupants;
}

- (NSString *)invitedUser {
	return invitedUser;
}

- (void)setInvitedUser:(NSString *)ainvitedUser {
	if (invitedUser) [invitedUser release];
	invitedUser = [ainvitedUser retain];
}

/////////////////////////////////////////////////
#pragma mark Class Accessors
/////////////////////////////////////////////////

- (void)setDelegate:(id)aDelegate
{
	delegate = aDelegate; // weak
}

- (id)delegate
{
	return delegate;
}

/////////////////////////////////////////////////
#pragma mark Room Methods
/////////////////////////////////////////////////
// Creates a temporary Chat Room at Server.
- (void)createOrJoinRoom {
	if ([stream isConnected]) {
//		<presence
//		from='crone1@shakespeare.lit/desktop'
//		to='darkcave@chat.shakespeare.lit/firstwitch'>
//			<x xmlns='http://jabber.org/protocol/muc'/>
//		</presence>
		
		NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
		//[presence addAttributeWithName:@"from" stringValue:[[stream myJID]full]];
		NSString *strFrom = [NSString stringWithFormat:@"%@@%@", [[[[stream myJID]bare] componentsSeparatedByString:@"@"] objectAtIndex:0],
							 [[roomName componentsSeparatedByString:@"@"] objectAtIndex:1]];
		[presence addAttributeWithName:@"from" stringValue:strFrom];//[[stream myJID]bare]];
		[presence addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@/%@", roomName, nickName]];
		NSXMLElement *xelement = [NSXMLElement elementWithName:@"x" xmlns:XMPPMUCNamespaceName];
		[presence addChild:xelement];
		
		XMPPPresence * pres = [XMPPPresence presenceFromElement:presence];
		[stream sendElement:pres];

		[self additionalRequestWithRoomCreation];
	}
}

// Created By Kapil
- (void)additionalRequestWithRoomCreation {
	//<iq type="set" 
	//	from="victor@conference.mqcommunicator" 
	//	to="class-ocs1#24263202#room@conference.mqcommunicator">
	//	<query xmlns="http://jabber.org/protocol/muc#owner">
	//		<x type="submit" xmlns="jabber:x:data" />
	//	</query>
	//</iq>
	NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
	[iq addAttributeWithName:@"type" stringValue:@"set"];
	NSString *strFrom = [NSString stringWithFormat:@"%@@%@", [[[[stream myJID]bare] componentsSeparatedByString:@"@"] objectAtIndex:0],
						 [[roomName componentsSeparatedByString:@"@"] objectAtIndex:1]];
	[iq addAttributeWithName:@"from" stringValue:strFrom];
	 //[[stream myJID]bare]];
	[iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@", roomName]];
	
	NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
	[query addAttributeWithName:@"xmlns" stringValue:XMPPMUCOwnerNamespaceName];
	
	NSXMLElement *xelement = [NSXMLElement elementWithName:@"x"];
	[xelement addAttributeWithName:@"type" stringValue:@"submit"];
	[xelement addAttributeWithName:@"xmlns" stringValue:@"jabber:x:data"];
	[query addChild:xelement];
	[iq addChild:query];
	[stream sendElement:iq];

}

// Config room
- (void)sendConfigRoomInstance {
	//<iq id="create2" type="set" 
	//	from="victor@conference.mqcommunicator"
	//	to="class-ocs1#24263202#room@conference.mqcommunicator">
	NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
	[iq addAttributeWithName:@"from" stringValue:[[stream myJID] bare]];
	[iq addAttributeWithName:@"to" stringValue:roomName];
	[iq addAttributeWithName:@"type" stringValue:@"set"];
	//	<query xmlns="http://jabber.org/protocol/muc#owner">
	NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
	[query addAttributeWithName:@"xmlns" stringValue:XMPPMUCOwnerNamespaceName];
	//		<x type="submit" xmlns="jabber:x:data">
	NSXMLElement *xelement = [NSXMLElement elementWithName:@"x"];
	[xelement addAttributeWithName:@"type" stringValue:@"submit"];
	[xelement addAttributeWithName:@"xmlns" stringValue:@"jabber:x:data"];	
	//			<field var="muc#roomconfig_maxusers" label="" type="list-single">
	NSXMLElement *field_MaxUser = [NSXMLElement elementWithName:@"field"];
	[field_MaxUser addAttributeWithName:@"var" stringValue:@"muc#roomconfig_maxusers"];
	[field_MaxUser addAttributeWithName:@"label" stringValue:@""];
	[field_MaxUser addAttributeWithName:@"type" stringValue:@"list-single"];
	//				<value>0</value><desc></desc>

	NSXMLElement *value_MaxUser = [NSXMLElement elementWithName:@"value" stringValue:@"0"];
	NSXMLElement *desc_MaxUser = [NSXMLElement elementWithName:@"desc" stringValue:@""];
	
	[field_MaxUser addChild:value_MaxUser];
	[field_MaxUser addChild:desc_MaxUser];
	[xelement addChild:field_MaxUser];
	//			</field>
	//			<field var="privacy" label="" type="boolean">
	//				<value>1</value><desc></desc>
	//			</field>
	NSXMLElement *field_Privacy = [NSXMLElement elementWithName:@"field"];
	[field_Privacy addAttributeWithName:@"var" stringValue:@"privacy"];
	[field_Privacy addAttributeWithName:@"label" stringValue:@""];
	[field_Privacy addAttributeWithName:@"type" stringValue:@"boolean"];
	
	NSXMLElement *value_Privacy = [NSXMLElement elementWithName:@"value" stringValue:@"1"];
	NSXMLElement *desc_Privacy = [NSXMLElement elementWithName:@"desc" stringValue:@""];
	
	[field_Privacy addChild:value_Privacy];
	[field_Privacy addChild:desc_Privacy];
	 
	[xelement addChild:field_Privacy];
	
	
	//			<field var="muc#owner_publicroom" label="" type="boolean">
	//				<value>1</value><desc></desc>
	//			</field>
	NSXMLElement *field_publicroom = [NSXMLElement elementWithName:@"field"];
	[field_publicroom addAttributeWithName:@"var" stringValue:@"muc#owner_publicroom"];
	[field_publicroom addAttributeWithName:@"label" stringValue:@""];
	[field_publicroom addAttributeWithName:@"type" stringValue:@"boolean"];
	
	NSXMLElement *value_publicroom = [NSXMLElement elementWithName:@"value" stringValue:@"1"];
	NSXMLElement *desc_publicroom = [NSXMLElement elementWithName:@"desc" stringValue:@""];
	
	[field_publicroom addChild:value_publicroom];
	[field_publicroom addChild:desc_publicroom];
	
	[xelement addChild:field_publicroom];
	//			<field var="muc#owner_persistentroom" label="" type="boolean">
	//				<value>0</value><desc></desc>
	//			</field>
	NSXMLElement *field_persistentroom = [NSXMLElement elementWithName:@"field"];
	[field_persistentroom addAttributeWithName:@"var" stringValue:@"muc#owner_persistentroom"];
	[field_persistentroom addAttributeWithName:@"label" stringValue:@""];
	[field_persistentroom addAttributeWithName:@"type" stringValue:@"boolean"];

	NSXMLElement *value_persistentroom = [NSXMLElement elementWithName:@"value" stringValue:@"0"];
	NSXMLElement *desc_persistentroom = [NSXMLElement elementWithName:@"desc" stringValue:@""];
	
	[field_persistentroom addChild:value_persistentroom];
	[field_persistentroom addChild:desc_persistentroom];
	
	[xelement addChild:field_persistentroom];
	//			<field var="legacy" label="" type="boolean">
	//				<value>1</value><desc></desc>
	//			</field>
	NSXMLElement *field_legacy = [NSXMLElement elementWithName:@"field"];
	[field_legacy addAttributeWithName:@"var" stringValue:@"legacy"];
	[field_legacy addAttributeWithName:@"label" stringValue:@""];
	[field_legacy addAttributeWithName:@"type" stringValue:@"boolean"];
	
	NSXMLElement *value_legacy = [NSXMLElement elementWithName:@"value" stringValue:@"1"];
	NSXMLElement *desc_legacy = [NSXMLElement elementWithName:@"desc" stringValue:@""];
		
	[field_legacy addChild:value_legacy];
	[field_legacy addChild:desc_legacy];
	
	[xelement addChild:field_legacy];
	//			<field var="muc#owner_moderatedroom" label="" type="boolean">
	//				<value>0</value><desc></desc>
	//			</field>
	NSXMLElement *field_moderatedroomy = [NSXMLElement elementWithName:@"field"];
	[field_moderatedroomy addAttributeWithName:@"var" stringValue:@"muc#owner_moderatedroom"];
	[field_moderatedroomy addAttributeWithName:@"label" stringValue:@""];
	[field_moderatedroomy addAttributeWithName:@"type" stringValue:@"boolean"];
	
	NSXMLElement *value_moderatedroomy = [NSXMLElement elementWithName:@"value" stringValue:@"0"];
	NSXMLElement *desc_moderatedroomy = [NSXMLElement elementWithName:@"desc" stringValue:@""];
	
	[field_moderatedroomy addChild:value_moderatedroomy];
	[field_moderatedroomy addChild:desc_moderatedroomy];
	
	[xelement addChild:field_moderatedroomy];
	//			<field var="defaulttype" label="" type="boolean">
	//				<value>0</value><desc></desc>
	//			</field>
	NSXMLElement *field_defaulttype = [NSXMLElement elementWithName:@"field"];
	[field_defaulttype addAttributeWithName:@"var" stringValue:@"defaulttype"];
	[field_defaulttype addAttributeWithName:@"label" stringValue:@""];
	[field_defaulttype addAttributeWithName:@"type" stringValue:@"boolean"];
	
	NSXMLElement *value_defaulttype = [NSXMLElement elementWithName:@"value" stringValue:@"0"];
	NSXMLElement *desc_defaulttype = [NSXMLElement elementWithName:@"desc" stringValue:@""];
	
	[field_defaulttype addChild:value_defaulttype];
	[field_defaulttype addChild:desc_defaulttype];
	
	[xelement addChild:field_defaulttype];
	//			<field var="privmsg" label="" type="boolean">
	//				<value>0</value><desc></desc>
	//			</field>
	NSXMLElement *field_privmsg = [NSXMLElement elementWithName:@"field"];
	[field_privmsg addAttributeWithName:@"var" stringValue:@"privmsg"];
	[field_privmsg addAttributeWithName:@"label" stringValue:@""];
	[field_privmsg addAttributeWithName:@"type" stringValue:@"boolean"];
	
	NSXMLElement *value_privmsg = [NSXMLElement elementWithName:@"value" stringValue:@"0"];
	NSXMLElement *desc_privmsg = [NSXMLElement elementWithName:@"desc" stringValue:@""];
	
	[field_privmsg addChild:value_privmsg];
	[field_privmsg addChild:desc_privmsg];
	
	[xelement addChild:field_privmsg];
	//			<field var="muc#owner_inviteonly" label="" type="boolean">
	//				<value>0</value><desc></desc>
	//			</field>
	NSXMLElement *field_inviteonly = [NSXMLElement elementWithName:@"field"];
	[field_inviteonly addAttributeWithName:@"var" stringValue:@"muc#owner_inviteonly"];
	[field_inviteonly addAttributeWithName:@"label" stringValue:@""];
	[field_inviteonly addAttributeWithName:@"type" stringValue:@"boolean"];
	
	NSXMLElement *value_inviteonly = [NSXMLElement elementWithName:@"value" stringValue:@"0"];
	NSXMLElement *desc_inviteonly = [NSXMLElement elementWithName:@"desc" stringValue:@""];

	[field_inviteonly addChild:value_inviteonly];
	[field_inviteonly addChild:desc_inviteonly];
	
	[xelement addChild:field_inviteonly];
	//			<field var="muc#owner_allowinvites" label="" type="boolean">
	//				<value>1</value><desc></desc>
	//			</field>
	NSXMLElement *field_allowinvites = [NSXMLElement elementWithName:@"field"];
	[field_allowinvites addAttributeWithName:@"var" stringValue:@"muc#owner_allowinvites"];
	[field_allowinvites addAttributeWithName:@"label" stringValue:@""];
	[field_allowinvites addAttributeWithName:@"type" stringValue:@"boolean"];
	
	NSXMLElement *value_allowinvites = [NSXMLElement elementWithName:@"value" stringValue:@"1"];
	NSXMLElement *desc_allowinvites = [NSXMLElement elementWithName:@"desc" stringValue:@""];

	[field_allowinvites addChild:value_allowinvites];
	[field_allowinvites addChild:desc_allowinvites];
	
	[xelement addChild:field_allowinvites];
	//			<field var="muc#owner_passwordprotectedroom" label="" type="boolean">
	//				<value>1</value><desc></desc>
	//			</field>
	NSXMLElement *field_passwordprotectedroom = [NSXMLElement elementWithName:@"field"];
	[field_passwordprotectedroom addAttributeWithName:@"var" stringValue:@"muc#owner_passwordprotectedroom"];
	[field_passwordprotectedroom addAttributeWithName:@"label" stringValue:@""];
	[field_passwordprotectedroom addAttributeWithName:@"type" stringValue:@"boolean"];
	
	NSXMLElement *value_passwordprotectedroom = [NSXMLElement elementWithName:@"value" stringValue:@"1"];
	NSXMLElement *desc_passwordprotectedroom = [NSXMLElement elementWithName:@"desc" stringValue:@""];
	
	[field_passwordprotectedroom addChild:value_passwordprotectedroom];
	[field_passwordprotectedroom addChild:desc_passwordprotectedroom];
	
	[xelement addChild:field_passwordprotectedroom];
	
	//			<field var="muc#owner_roomsecret" label="" type="text-private">
	//				<value>mqcommunicator</value><desc></desc>
	//			</field>
	NSXMLElement *field_roomsecret = [NSXMLElement elementWithName:@"field"];
	[field_roomsecret addAttributeWithName:@"var" stringValue:@"muc#owner_roomsecret"];
	[field_roomsecret addAttributeWithName:@"label" stringValue:@""];
	[field_roomsecret addAttributeWithName:@"type" stringValue:@"text-private"];
	
	NSXMLElement *value_roomsecret = [NSXMLElement elementWithName:@"value" stringValue:@"mqcommunicator"];
	NSXMLElement *desc_roomsecret = [NSXMLElement elementWithName:@"desc" stringValue:@""];

	[field_roomsecret addChild:value_roomsecret];
	[field_roomsecret addChild:desc_roomsecret];
	
	[xelement addChild:field_roomsecret];
	//			<field var="muc#owner_whois" label="" type="list-single">
	//				<value>Admins</value><desc></desc>
	//			</field>
	NSXMLElement *field_whois = [NSXMLElement elementWithName:@"field"];
	[field_whois addAttributeWithName:@"var" stringValue:@"muc#owner_whois"];
	[field_whois addAttributeWithName:@"label" stringValue:@""];
	[field_whois addAttributeWithName:@"type" stringValue:@"list-single"];
	
	NSXMLElement *value_whois = [NSXMLElement elementWithName:@"value" stringValue:@"Admins"];
	NSXMLElement *desc_whois = [NSXMLElement elementWithName:@"desc" stringValue:@""];

	[field_whois addChild:value_whois];
	[field_whois addChild:desc_whois];
	
	[xelement addChild:field_whois];
	//			<field var="muc#owner_enablelogging" label="" type="boolean">
	//				<value>1</value><desc></desc>
	//			</field>
	NSXMLElement *field_enablelogging = [NSXMLElement elementWithName:@"field"];
	[field_enablelogging addAttributeWithName:@"var" stringValue:@"muc#owner_enablelogging"];
	[field_enablelogging addAttributeWithName:@"label" stringValue:@""];
	[field_enablelogging addAttributeWithName:@"type" stringValue:@"boolean"];
	
	NSXMLElement *value_enablelogging = [NSXMLElement elementWithName:@"value" stringValue:@"1"];
	NSXMLElement *desc_enablelogging = [NSXMLElement elementWithName:@"desc" stringValue:@""];
 
	[field_enablelogging addChild:value_enablelogging];
	[field_enablelogging addChild:desc_enablelogging];
	
	[xelement addChild:field_enablelogging];
	//			<field var="logformat" label="" type="list-single">
	//				<value>text</value><desc>
	//			</field>
	NSXMLElement *field_logformat = [NSXMLElement elementWithName:@"field"];
	[field_logformat addAttributeWithName:@"var" stringValue:@"logformat"];
	[field_logformat addAttributeWithName:@"label" stringValue:@""];
	[field_logformat addAttributeWithName:@"type" stringValue:@"boolean"];
	
	NSXMLElement *value_logformat = [NSXMLElement elementWithName:@"value" stringValue:@"text"];
	NSXMLElement *desc_logformat = [NSXMLElement elementWithName:@"desc" stringValue:@""];
		
	[field_logformat addChild:value_logformat];
	[field_logformat addChild:desc_logformat];
	
	[xelement addChild:field_logformat];
	//		</x>
	[query addChild:xelement];
	//	</query>
	[iq addChild:query];
	//</iq>
	[stream sendElement:iq];
}

- (void)sendInstantRoomConfig {
//	<iq from='crone1@shakespeare.lit/desktop'
//    id='create1'
//    to='darkcave@chat.shakespeare.lit'
//    type='set'>
//	<query xmlns='http://jabber.org/protocol/muc#owner'>
//    <x xmlns='jabber:x:data' type='submit'/>
//	</query>
//	</iq>
	// NSLog(@"[XMPPRoom] sendInstantRoomConfig:");
	NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
	[iq addAttributeWithName:@"id" stringValue:[NSString stringWithFormat:@"inroom-cr%@",roomName]];
	[iq addAttributeWithName:@"to" stringValue:roomName];
	[iq addAttributeWithName:@"type" stringValue:@"set"];
	NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:XMPPMUCOwnerNamespaceName];
	NSXMLElement *xelem = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
	[xelem addAttributeWithName:@"type" stringValue:@"submit"];
	[query addChild:xelem];
	[iq addChild:query];
	[stream sendElement:iq]; 
}
// Joins the room by sending presence with nickname.
- (void)joinRoom {
	if ([stream isConnected]) {
		
//		<presence
//		from='hag66@shakespeare.lit/pda'
//		to='darkcave@chat.shakespeare.lit/thirdwitch'/>
		
		// NSLog(@"[XMPPRoom] joinRoom: %@", roomName);
		NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
		[presence addAttributeWithName:@"from" stringValue:[[stream myJID]full]];
		[presence addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@/%@", roomName, nickName]];
		[stream sendElement:presence];
	}
}
// Leaves the chat room by sending presence as unavailable.
- (void)leaveRoom {
	if ([stream isConnected]) {
		// NSLog(@"[XMPPRoom] leaveRoom: %@", roomName);
//		<presence
//		from='hag66@shakespeare.lit/pda'
//		to='darkcave@chat.shakespeare.lit/thirdwitch'
//		type='unavailable'/>
		
		NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
		[presence addAttributeWithName:@"from" stringValue:[[stream myJID]full]];
		[presence addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@/%@", roomName, nickName]];
		[presence addAttributeWithName:@"type" stringValue:@"unavailable"];
		[stream sendElement:presence];
		isJoined = NO;
	}
}
// Changes the nickname for room by joining room again with new nick.
- (void)chageNickForRoom:(NSString *)name {
	// NSLog(@"[XMPPRoom] changeNick: %@", roomName);
	if (nickName) [nickName release];
	nickName = [name retain];
	[self joinRoom];
}
/////////////////////////////////////////////////
#pragma mark RoomInvite Methods
/////////////////////////////////////////////////
// Invites a user to room with Message.
- (void)inviteUser:(XMPPJID *)jid message:(NSString *)message {
	// NSLog(@"[XMPPRoom] inviteUser:");
	// Default Implementation
/*
 
 //	<message
//    from='crone1@shakespeare.lit/desktop'
//    to='darkcave@chat.shakespeare.lit'>
//		<x xmlns='http://jabber.org/protocol/muc#user'>
//			<invite to='hecate@shakespeare.lit'>
//				<reason>
//					Hey Hecate, this is the place for all good witches!
//				</reason>
//			</invite>
//		</x>
//	</message>
	
	if ([stream isConnected]) {
		NSXMLElement *imessage = [NSXMLElement elementWithName:@"message"];
		[imessage addAttributeWithName:@"from" stringValue:[[stream myJID]full]];
		[imessage addAttributeWithName:@"to" stringValue:roomName];
		
		NSXMLElement *xelem = [NSXMLElement elementWithName:@"x" xmlns:XMPPMUCUserNamespaceName];
		
		NSXMLElement *invite = [NSXMLElement elementWithName:@"invite"];
		[invite addAttributeWithName:@"to" stringValue:[jid full]];
		NSXMLElement *reason = [NSXMLElement elementWithName:@"reason"];
		[reason setStringValue:message];
		[invite addChild:reason];
		
		[xelem addChild:invite];
		
		[imessage addChild:xelem];
		
		[stream sendElement:imessage];
	}*/
	
	// Our Implementation
//<iq id="JN_24" type="get" to="benny@mqcommunicator/Messenger">
//	<query xmlns="chat:iq:invite">
//		class-ocs1#24263202#room@conference.mqcommunicator
//	</query>
//	</iq>
	
	NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
	[iq addAttributeWithName:@"type" stringValue:@"get"];
	[iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@/Messenger", jid]];
	
	NSXMLElement *query = [NSXMLElement elementWithName:@"query" stringValue:roomName];
	[query addAttributeWithName:@"xmlns" stringValue:@"chat:iq:invite"];
	[iq addChild:query];
	[stream sendElement:iq];				   
}

- (void)acceptInvitation {
	// NSLog(@"[XMPPRoom] acceptInvitation:");
	// just need to send presence to room to accept it. we are done.
	[self joinRoom];
}

- (void)rejectInvitation {
	// NSLog(@"[XMPPRoom] rejectInvitation:");
//	<message
//    from='hecate@shakespeare.lit/broom'
//    to='darkcave@chat.shakespeare.lit'>
//		<x xmlns='http://jabber.org/protocol/muc#user'>
//			<decline to='crone1@shakespeare.lit'>
//				<reason>
//					Sorry, I'm too busy right now.
//				</reason>
//			</decline>
//		</x>
//	</message>
	
	if ([stream isConnected]) {
		NSXMLElement *imessage = [NSXMLElement elementWithName:@"message"];
		[imessage addAttributeWithName:@"from" stringValue:[[stream myJID]full]];
		[imessage addAttributeWithName:@"to" stringValue:roomName];
		
		NSXMLElement *xelem = [NSXMLElement elementWithName:@"x" xmlns:XMPPMUCUserNamespaceName];
		
		NSXMLElement *decline = [NSXMLElement elementWithName:@"decline"];
		[decline addAttributeWithName:@"to" stringValue:invitedUser];
		NSXMLElement *reason = [NSXMLElement elementWithName:@"reason"];
		[reason setStringValue:@"Sorry Dear, I can not join right now."];
		[decline addChild:reason];
		
		[xelem addChild:decline];
		
		[imessage addChild:xelem];
	}
}
/////////////////////////////////////////////////
#pragma mark Message Methods
/////////////////////////////////////////////////

- (void)sendMessage:(NSString *)msg {
	if (!(msg.length > 0)) return;
//	<message
//    from='wiccarocks@shakespeare.lit/laptop'
//    to='darkcave@chat.shakespeare.lit/firstwitch'
//    type='groupchat'>
//		<body>I'll give thee a wind.</body>
//	</message>
	if ([stream isConnected]) {
		NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
		[body setStringValue:msg];
		
		NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
		[message addAttributeWithName:@"to" stringValue:roomName];
		[message addAttributeWithName:@"type" stringValue:@"groupchat"];
		[message addChild:body];
		
		[stream sendElement:message];
	}
}

/////////////////////////////////////////////////
#pragma mark XMPPStreamDelegate Methods
/////////////////////////////////////////////////

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
	// NSLog(@"[XMPPRoom] xmppStream:didReceiveIQ:");
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender willSendPresence:(XMPPPresence *)presence{

}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
	NSArray *roomNick = [[presence fromStr] componentsSeparatedByString:@"/"];
	NSString *aroomname = [roomNick objectAtIndex:0];
	NSString *anick = [roomNick objectAtIndex:1];
	if (![aroomname isEqualToString:roomName]) return;
	// NSLog(@"[XMPPRoom] didReceivePresence: ROOM: %@", aroomname);
	NSXMLElement *priorityElement = [presence elementForName:@"priority"];
	NSXMLElement *xmucElement = [presence elementForName:@"x" xmlns:XMPPMUCUserNamespaceName];
	NSXMLElement *xmucItemElement = [xmucElement elementForName:@"item"];
	NSString *jid = [xmucItemElement attributeStringValueForName:@"jid"];
	NSString *role = [xmucItemElement attributeStringValueForName:@"role"];
	NSString *newnick = [xmucItemElement attributeStringValueForName:@"nick"];
	if (priorityElement)
	// NSLog(@"[XMPPRoom] didReceivePresence: priority:%@",[priorityElement stringValue]);
	// NSLog(@"[XMPPRoom] didReceivePresence: nick:%@ role:%@ newnick:%@ jid:%@", anick, role, newnick, jid);
	
	if (newnick) {
		isJoined = YES; // we are joined, getting presence for room
		// Handle nick Change having "nick" in <item> element.
		[occupants removeObjectForKey:anick];
		// add new room occupant
		XMPPRoomOccupant *aoccupant = [[XMPPRoomOccupant alloc] init];
		[aoccupant setNick:newnick];
		[aoccupant setRole:role];
		if (jid) [aoccupant setJid:[XMPPJID jidWithString:jid]];
		[occupants setObject:aoccupant forKey:newnick]; [aoccupant release];
		// oh its a change. let's notify delegate now..
		if ([delegate respondsToSelector:@selector(xmppRoom:didChangeOccupants:)])
			[delegate xmppRoom:self didChangeOccupants:occupants];	
		return;
	} else if (anick) {
		// Handle room leaving if with presence type "unavailable"
		// for my Nick name.
		if ([[presence type] isEqualToString:@"unavailable"] && [anick isEqualToString:nickName]) {
			// we got presence from our nick to us about leaving. Notify Delegate.
			[occupants removeAllObjects];
			isJoined = NO; // we left the room.
			if ([delegate respondsToSelector:@selector(xmppRoom:didLeave:)])
				[delegate xmppRoom:self didLeave:YES];
			// notify delegate about my leave as well. why not we can join back if we want.
			if ([delegate respondsToSelector:@selector(xmppRoom:didChangeOccupants:)])
				[delegate xmppRoom:self didChangeOccupants:occupants];
		} else if ([[presence type] isEqualToString:@"unavailable"]) {
			isJoined = YES; // we are joined, getting presence for room
			// this is about some one else leaving the Room. let's remove him
			[occupants removeObjectForKey:anick];
			if ([delegate respondsToSelector:@selector(xmppRoom:didChangeOccupants:)])
				[delegate xmppRoom:self didChangeOccupants:occupants];
		} else { 
			// this is about some sort of available presence. i don't mind even if they are busy.
			// if the user is there. no need to notify. let's check that.
			XMPPRoomOccupant *aoccupant = nil;
			aoccupant = (XMPPRoomOccupant *)[occupants objectForKey:anick];
			if (aoccupant) return;
			aoccupant = [[XMPPRoomOccupant alloc] init];
			[aoccupant setNick:anick];
			[aoccupant setRole:role];
			if (jid) [aoccupant setJid:[XMPPJID jidWithString:jid]];
			[occupants setObject:aoccupant forKey:anick]; [aoccupant release];
			// let's notify delegate now..
			if ([delegate respondsToSelector:@selector(xmppRoom:didChangeOccupants:)])
				[delegate xmppRoom:self didChangeOccupants:occupants];
		}

	}
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
	// check if its group chat. and make sure that's for this Room as well..

	if ([message isGroupChatMessageWithBody]) {
		NSArray *roomNick = [[message fromStr] componentsSeparatedByString:@"/"];
		NSString *aroomname = [roomNick objectAtIndex:0];
		if (![aroomname isEqualToString:roomName]) return;
		NSString *anick = nil;
		// get nick name and message body if available for room message.
		if(roomNick.count > 1) anick = [roomNick objectAtIndex:1];
		NSString *body = [[message elementForName:@"body"] stringValue];
		// this is a message from group.
		if (roomNick.count == 1) {
			// This room is locked from entry until configuration is confirmed.
			if ([body isEqualToString:@"This room is locked from entry until configuration is confirmed."]) {
				// NSLog(@"[XMPPRoom] This room is locked from entry until configuration is confirmed.");
				
				return;
			}
			// This room is now unlocked.
			if ([body isEqualToString:@"This room is now unlocked."]) {
				// NSLog(@"[XMPPRoom] This room is now unlocked.");
				[self sendConfigRoomInstance];
				// notify delegate about room creation success.
				if ([delegate respondsToSelector:@selector(xmppRoom:didEnter:)])
					[delegate xmppRoom:self didEnter:YES];
				return;
			}
		}
		// NSLog(@"[XMPPRoom] didReceiveMessage: room:%@ nick:%@ body:%@", aroomname, anick, body);
		// let's notify delegate now..
		if ([delegate respondsToSelector:@selector(xmppRoom:didReceiveMessage:fromNick:)])
			[delegate xmppRoom:self didReceiveMessage:body fromNick:anick];
	}
}

/////////////////////////////////////////////////
#pragma mark Destructor Methods
/////////////////////////////////////////////////

- (void) dealloc
{
	if (isJoined)
	{
		[self leaveRoom];
	}
	[stream removeDelegate:self];
	
	[roomName release]; roomName = nil;
	[nickName release]; nickName = nil;
	[subject release]; subject = nil;
	[invitedUser release]; invitedUser = nil;
	[occupants release]; occupants = nil;
	[stream release]; stream = nil;
	[super dealloc];
}



@end
