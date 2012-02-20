//
//  URLRequestHandler.h
//  MobileJabber
//
//  Created by Shivang Vyas on 6/16/11.
//  Copyright 2011 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParserHandler.h"


@interface URLRequestHandler : NSURLConnection {
	NSMutableData * webData;
	XMLParserHandler *ObjXMLParserHandler;
	NSXMLParser *xmlParser;
	NSString *strNotificationName;
}
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate NotificationName:(NSString*)strNotificationName;
@end
