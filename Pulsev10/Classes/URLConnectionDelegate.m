//
//  URLConnectionDelegate.m
//  MobileJabber
//
//  Created by Shivang Vyas on 7/7/11.
//  Copyright 2011 company. All rights reserved.
//

#import "URLConnectionDelegate.h"


@implementation URLConnectionDelegate
- (id)initWIthNotification:(NSString*) strNotfName{
	if(self = [super init]){
		webdata = [[NSMutableData alloc] init];
		strNotificationName = [[NSString alloc] initWithString:strNotfName];
		return self;
	}
	return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[webdata setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[webdata appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[webdata release];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
}

@end
