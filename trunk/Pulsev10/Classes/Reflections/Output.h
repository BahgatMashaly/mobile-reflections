//
//  Output.h
//  MobileReflections
//
//  Created by SonNT on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Output : NSObject
{
	NSMutableArray *arrReflectionList;
	NSMutableArray *arrReflectionContent;
	NSMutableArray *arrCommentList;
}

@property (nonatomic, retain) NSMutableArray *arrReflectionList;
@property (nonatomic, retain) NSMutableArray *arrReflectionContent;
@property (nonatomic, retain) NSMutableArray *arrCommentList;

@end