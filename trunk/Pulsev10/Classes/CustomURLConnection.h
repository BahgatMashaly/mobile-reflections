//
//  WebServiceConnection.h
//  PIMagazine
//
//  Created by jigar shah on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileJabberAppDelegate.h"

@interface CustomURLConnection : NSURLConnection {

	NSMutableData *responseData;
	NSString *NotificationName;
	NSString *fileName;
	NSString *fileURL;
}
@property(nonatomic,readwrite) int WebSeviceFor;

//- (id)initWithJSONKey:(NSString*)strJSONKey JSONValues:(NSDictionary*)dictJSONValues URL:(NSString*)strURL NotificationName:(NSString*)strNotificationName;
- (id)initWithUrl:(NSString*)urlString FileName:(NSString*)strFileName NotificationName:(NSString*)strNotificationName;


@end
