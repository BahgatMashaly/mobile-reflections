//
//  URLRequestHandler.m
//  MobileJabber
//
//  Created by Shivang Vyas on 6/16/11.
//  Copyright 2011 company. All rights reserved.
//

#import "URLRequestHandler.h"


@implementation URLRequestHandler

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate NotificationName:(NSString*)NotificationName{
	if(self = [super initWithRequest:request delegate:self]){
		webData = [[NSMutableData data] retain];
		strNotificationName = NotificationName;
		return self;
	}
	return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[webData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[connection release];
	[webData release];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[webData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	// NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	// NSLog(@"%@",theXML);
	
	ObjXMLParserHandler = [[XMLParserHandler alloc] initWithData:webData NotificationName:strNotificationName];
	
	
	[[NSRunLoop currentRunLoop] run];
	
	[connection release];
	[webData release];
	

}

@end
