//
//  UserRolesIQParser.m
//  MobileJabber
//
//  Created by Shivang Vyas on 6/28/11.
//  Copyright 2011 company. All rights reserved.
//

#import "UserRolesIQParser.h"


@implementation UserRolesIQParser

- (id)initWithData:(NSData *)data NotificationName:(NSString*)NotificationName{
	if(self = [super initWithData:data]){
		if(strNotificationName!=nil && [strNotificationName retainCount]>0){
			[strNotificationName release];
			strNotificationName = nil;
		}
		strNotificationName = [[NSString alloc] initWithString:NotificationName];
		super.delegate = self;
		[super parse];
		return self;
	}
	return nil;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
	
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName attributes: (NSDictionary *)attributeDict{
	if([elementName isEqualToString:@"query"]){
		aryUserRoles = [[NSMutableArray alloc] init];
	}
	if([elementName isEqualToString:@"Table_x0020_0"]){
		dictRoles = [[NSMutableDictionary alloc] init];
	}
	if(strTemp!=nil && [strTemp retainCount]>0){
		[strTemp release];
		strTemp = nil;
	}
	strTemp = [[NSString alloc] initWithString:@""];
	
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	if(strTemp!=nil && [strTemp retainCount]>0){
		[strTemp release];
		strTemp = nil;
	}
	strTemp = [[NSString alloc] initWithString:string];	
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if([elementName isEqualToString:@"groupname"] || [elementName isEqualToString:@"userid"] || [elementName isEqualToString:@"role"] || [elementName isEqualToString:@"owner"]){
		[dictRoles setValue:strTemp forKey:elementName];
	}
	
	if([elementName isEqualToString:@"Table_x0020_0"]){
		[aryUserRoles addObject:dictRoles];
		[dictRoles release];
	}
	
}


- (void)parserDidEndDocument:(NSXMLParser *)parser{
	//NSLog(@"aryUserRoles: %@",[aryUserRoles description]);
	if(((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserRoles !=nil && [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserRoles retainCount]>0){
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserRoles release];
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserRoles = nil;
	}
	
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryUserRoles = [[NSMutableArray alloc] initWithArray:aryUserRoles];
	
	
	[aryUserRoles release];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CONTACTS object:nil];	
	   
}


@end
