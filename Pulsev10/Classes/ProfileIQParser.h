//
//  ProfileIQParser.h
//  MobileJabber
//
//  Created by shivang vyas on 05/08/11.
//  Copyright 2011 Matrix. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProfileIQParser : NSXMLParser <NSXMLParserDelegate> {
	NSString *strNotificationName;
	NSString * strTemp; 
	NSMutableDictionary * dictIQ;
	NSMutableDictionary * dictVcard;
	NSMutableDictionary * dictN;
	NSMutableDictionary * dictEmail;
	NSMutableDictionary * dictPhoto;
	NSMutableDictionary * dictTel;
    NSString *strToJID;
	BOOL IsPhotoTagStarted;
    NSString *strUserID;
}
- (id)initWithData:(NSData *)data NotificationName:(NSString*)NotificationName;
@end
