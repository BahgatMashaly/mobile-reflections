//
//  RosterIQParser.h
//  MobileJabber
//
//  Created by Shivang Vyas on 6/25/11.
//  Copyright 2011 company. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RosterIQParser : NSXMLParser <NSXMLParserDelegate> {
	NSMutableDictionary *dictIQ;
	NSString * strNotificationName;
	NSMutableDictionary * dictQuery;
	NSMutableArray * aryItem;
	NSMutableDictionary * dictItem;
	NSMutableDictionary * dictGroup;
	NSString *strTemp;
	
}
- (id)initWithData:(NSData *)data NotificationName:(NSString*)NotificationName;
- (void)getProfile:(NSString*)strUserJid;

@end
