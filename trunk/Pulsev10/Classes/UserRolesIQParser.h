//
//  UserRolesIQParser.h
//  MobileJabber
//
//  Created by Shivang Vyas on 6/28/11.
//  Copyright 2011 company. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserRolesIQParser : NSXMLParser <NSXMLParserDelegate> {
	NSString *strNotificationName;
	NSMutableArray * aryUserRoles;
	NSMutableDictionary * dictRoles;
	NSString * strTemp;
}
- (id)initWithData:(NSData *)data NotificationName:(NSString*)NotificationName;
@end
