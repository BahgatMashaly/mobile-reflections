//
//  URLConnectionDelegate.h
//  MobileJabber
//
//  Created by Shivang Vyas on 7/7/11.
//  Copyright 2011 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLConnectionDelegate : NSObject  {
	NSMutableData * webdata;
	NSXMLParser * xmlparser;
	NSString * strNotificationName;
}
- (id)initWIthNotification:(NSString*) strNotfName;

@end
