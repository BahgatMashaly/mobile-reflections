//
//  XMLParserHandler.m
//  MobileJabber
//
//  Created by Shivang Vyas on 6/16/11.
//  Copyright 2011 company. All rights reserved.
//

#import "XMLParserHandler.h"


@implementation XMLParserHandler

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
	if(dictElement!=nil && [dictElement retainCount]>0){
		[dictElement release];
		dictElement = nil;
	}
		dictElement = [[NSMutableDictionary alloc] init];
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	if(strTemp!=nil && [strTemp retainCount]>0){
		[strTemp release];
		strTemp = nil;
	}
		
	strTemp = [[NSString alloc] initWithString:string];  
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
		[dictElement setValue:strTemp forKey:elementName];
}


- (void)parserDidEndDocument:(NSXMLParser *)parser{
	[[NSNotificationCenter defaultCenter] postNotificationName:strNotificationName object:dictElement];
}

@end
