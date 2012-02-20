//
//  RosterIQParser.m
//  MobileJabber
//
//  Created by Shivang Vyas on 6/25/11.
//  Copyright 2011 company. All rights reserved.
//

#import "RosterIQParser.h"


@implementation RosterIQParser
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

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName attributes: (NSDictionary *)attributeDict
{
	if([elementName isEqualToString:@"iq"]){
		if(dictIQ !=nil && [dictIQ  retainCount]>0){
			[dictIQ release];
			dictIQ = nil;
		}
		dictIQ = [[NSMutableDictionary alloc] init];		
		[dictIQ addEntriesFromDictionary:attributeDict];	
	}
	
	if([elementName isEqualToString:@"query"]){
		dictQuery = [[NSMutableDictionary alloc] init];
		[dictQuery addEntriesFromDictionary:attributeDict];
		aryItem = [[NSMutableArray alloc] init];
	}
	
	if([elementName isEqualToString:@"item"]){
		dictItem = [[NSMutableDictionary alloc] init];
		[dictItem addEntriesFromDictionary:attributeDict];
	}
	if([elementName isEqualToString:@"group"]){
		dictGroup = [[NSMutableDictionary alloc] init];
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
	if([elementName isEqualToString:@"group"])
    {
		NSMutableDictionary * newdict = [[dictItem mutableCopy] retain];
		[dictGroup setValue:strTemp forKey:elementName];
		[dictItem setValue:dictGroup forKey:@"Groups"];
		[dictGroup release];
		[aryItem addObject:dictItem];
		[dictItem release];         
        dictItem = newdict; 
	}
	if([elementName isEqualToString:@"item"]){
        /*
		[dictItem setValue:dictGroup forKey:@"Groups"];
		[dictGroup release];
		[aryItem addObject:dictItem];
         */
	}
	if([elementName isEqualToString:@"query"]){
		[dictQuery setValue:aryItem forKey:@"Items"];
		[aryItem release];
	}
	if([elementName isEqualToString:@"iq"]){
		[dictIQ setValue:dictQuery forKey:@"Query"];
		[dictQuery release];
	}
}


- (void)parserDidEndDocument:(NSXMLParser *)parser{
	//NSLog(@"dictRoster: %@",[dictIQ description]);
    // Rakesh commented out - calling getuserbyid is expensive operation
    [self getProfile:[[[dictIQ objectForKey:@"to"] componentsSeparatedByString:@"@"] objectAtIndex:0]];
	if(((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictRoster!=nil && [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictRoster retainCount]>0){
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictRoster release];
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictRoster = nil;
	}
	
	((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).dictRoster = [[NSMutableDictionary alloc] 
																						   initWithDictionary:dictIQ
																						   ];
	//[dictIQ release];
    /*
	for (NSDictionary *dict in [[dictIQ objectForKey:@"Query"] objectForKey:@"Items"]) {      
         NSString *strUserJid = [[[dict objectForKey:@"jid"] componentsSeparatedByString:@"@"] objectAtIndex:0];
        [self getProfile:strUserJid];       
    }
     */
   
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CONTACTS object:nil];
	// [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOW_CONTACTLIST object:nil];
	
}

- (void)getProfile:(NSString*)strUserJid {
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addAttributeWithName:@"to" stringValue:@"services.mqcommunicator"];
    
    NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
    [query addAttributeWithName:@"xmlns" stringValue:@"services:iq:getuserbyid"];
   
    NSXMLElement *userid = [NSXMLElement elementWithName:@"userid"];
    
    //[iq addAttributeWithName:@"to" stringValue:strUserJid];
    [userid setStringValue:strUserJid];
    [query addChild:userid];
    
    [iq addChild:query];
    
    
    [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream sendElement:iq
     ];
    

}
@end
