//
//  ProfileIQParser.m
//  MobileJabber
//
//  Created by shivang vyas on 05/08/11.
//  Copyright 2011 Matrix. All rights reserved.
//

#import "ProfileIQParser.h"


@implementation ProfileIQParser
- (id)initWithData:(NSData *)data NotificationName:(NSString*)NotificationName{
	if(self = [super initWithData:data]){
		if(strNotificationName!=nil && [strNotificationName retainCount]>0){
			[strNotificationName release];
			strNotificationName = nil;
		}
		strNotificationName = [[NSString alloc] initWithString:NotificationName];
		IsPhotoTagStarted = NO;
		super.delegate = self;
		[super parse];
		return self;
	}
	return nil;
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
	/*
     <iq to="student1@mqcommunicator/Messenger" from="services.mqcommunicator" type="result">
        <query xmlns="services:iq:getuserbyid">
            <result type="dataset">
                <NewDataSet>
                    <Table_x0020_0>
                        <userid>student1</userid>
                        <role>student</role>
                        <fullname>Student 1</fullname>
                        <email>stu1@mqspectreum.com</email>
                        <ntlogin/><handphone/><phone/><dob/><gender/><website/><businessphone/><unit/>
                    </Table_x0020_0>
                </NewDataSet>
            </result>
        </query>
     </iq>
     */
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName attributes: (NSDictionary *)attributeDict{
	//if([elementName isEqualToString:@"iq"]){
	if ([elementName isEqualToString:@"iq"]) {
        strToJID = [attributeDict objectForKey:@"to"];
    }
    if([elementName isEqualToString:@"NewDataSet"]){
		dictIQ = [[NSMutableDictionary alloc] init];
		[dictIQ addEntriesFromDictionary:attributeDict];
	}
	/*if([elementName isEqualToString:@"vCard"]){
		dictVcard = [[NSMutableDictionary alloc] init];
		[dictVcard addEntriesFromDictionary:attributeDict];
	}*/
	
	/*if([elementName isEqualToString:@"N"]){
		dictN = [[NSMutableDictionary alloc] init];
	}
	
	if([elementName isEqualToString:@"EMAIL"]){
		dictEmail = [[NSMutableDictionary alloc] init];
	}
	if([elementName isEqualToString:@"PHOTO"]){
		IsPhotoTagStarted = YES;
		dictPhoto = [[NSMutableDictionary alloc] init];
	}
	if ([elementName isEqualToString:@"TEL"]) {
		dictTel = [[NSMutableDictionary alloc] init];
	}
	*/
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
	/*if([elementName isEqualToString:@"FN"] || 
	   [elementName isEqualToString:@"NICKNAME"] ||
	   [elementName isEqualToString:@"URL"] ||
	   [elementName isEqualToString:@"BDAY"] ||
	   [elementName isEqualToString:@"TITLE"] ||
	   [elementName isEqualToString:@"ROLE"] ||
	   [elementName isEqualToString:@"JABBERID"] ||
	   [elementName isEqualToString:@"DESC"] ||
	   [elementName isEqualToString:@"ADR"] || 
	   [elementName isEqualToString:@"GENDER"] ||
	   [elementName isEqualToString:@"APPOINTMENT"]
	   
	   ){
		[dictVcard setValue:strTemp forKey:elementName];
	}
	if([elementName isEqualToString:@"FAMILY"] ||
	   [elementName isEqualToString:@"GIVEN"] ||
	   [elementName isEqualToString:@"MIDDLE"] 
	   ){
		[dictN setValue:strTemp forKey:elementName];
	}
	if([elementName isEqualToString:@"N"]){
		[dictVcard setValue:dictN forKey:elementName];
		[dictN release];
	}
	if([elementName isEqualToString:@"INTERNET"] ||
	   [elementName isEqualToString:@"PREF"] ||
	   [elementName isEqualToString:@"USERID"] ){
		[dictEmail setValue:strTemp forKey:elementName];
	}
	if ([elementName isEqualToString:@"WORK"] ||
		[elementName isEqualToString:@"VOICE"]) {
		[dictTel setValue:strTemp forKey:elementName];
	}
	if ([elementName isEqualToString:@"TEL"]) {
		[dictVcard setValue:dictTel forKey:elementName];
	}
	if([elementName isEqualToString:@"TYPE"] ||
	   [elementName isEqualToString:@"BINVAL"]){
		if(IsPhotoTagStarted){
			[dictPhoto setValue:strTemp forKey:elementName];
		}
	}
	
	if([elementName  isEqualToString:@"PHOTO"]){
		[dictVcard setValue:dictPhoto forKey:elementName];
		[dictPhoto release];
		IsPhotoTagStarted = NO;
	}
	 if([elementName isEqualToString:@"EMAIL"]){
	 [dictVcard setValue:dictEmail forKey:elementName];
	 [dictEmail release];
	 }
	 
	*/
	if ([elementName isEqualToString:@"fullname"] ||
		[elementName isEqualToString:@"email"] ||
		[elementName isEqualToString:@"handphone"] ||
		[elementName isEqualToString:@"phone"] ||
		[elementName isEqualToString:@"aboutme"] ||
		[elementName isEqualToString:@"dob"] ||
		[elementName isEqualToString:@"gender"] ||
		[elementName isEqualToString:@"website"] ||
		[elementName isEqualToString:@"businessphone"] ||
		[elementName isEqualToString:@"address"] ||
		[elementName isEqualToString:@"appointment"] ||
		[elementName isEqualToString:@"unit"] ||
		[elementName isEqualToString:@"ntlogin"] ||
		[elementName isEqualToString:@"userid"] ||
		[elementName isEqualToString:@"role"]) {
		[dictIQ setValue:strTemp forKey:elementName];
	}
   
    
	/*if([elementName isEqualToString:@"vCard"]){
		[dictIQ setValue:dictVcard forKey:@"vCard"];
		[dictVcard release];
	}*/
}


- (void)parserDidEndDocument:(NSXMLParser *)parser{
	//NSLog(@"profile info: %@",[dictIQ description]
	//	  );
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:dictIQ
								  ];
    
    if ([[[[[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).xmppStream myJID] bare] componentsSeparatedByString:@"@"
           ] objectAtIndex:0] isEqualToString:[dictIQ objectForKey:@"userid"]]) {
        ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFullName = [dictIQ objectForKey:@"fullname"];
        ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strSelfEmail = [dictIQ objectForKey:@"email"]; 
		((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strSelfRole = [dictIQ objectForKey:@"role"]; 
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SET_USER_FULL_NAME object:nil];
    }
    BOOL isAvailable = NO;
    for (NSDictionary *dict in ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactEmail) {
        if ([[dict objectForKey:@"jid"] isEqualToString:[dictIQ objectForKey:@"userid"]]) {
            isAvailable = YES;
            break;
        }
    }
    if (!isAvailable) {
        [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactEmail addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:[dictIQ objectForKey:@"userid"], @"jid", [dictIQ objectForKey:@"email"], @"email", nil]];
    }
           

	[dictIQ release];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:strNotificationName 
														object:dict];
}

@end
