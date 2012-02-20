//
//  XMLParserHandler.h
//  MobileJabber
//
//  Created by Shivang Vyas on 6/16/11.
//  Copyright 2011 company. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XMLParserHandler : NSXMLParser <NSXMLParserDelegate> {
	NSMutableDictionary * dictElement;
	NSString *strTemp;
	NSString *strNotificationName;
}

- (id)initWithData:(NSData *)data NotificationName:(NSString*)NotificationName;

@end
