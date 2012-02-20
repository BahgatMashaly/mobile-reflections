//
//  Output.m
//  MobileReflections
//
//  Created by SonNT on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Output.h"


@implementation Output
@synthesize arrReflectionList, arrReflectionContent, arrCommentList;

- (id)init
{
    self = [super init];
    if (self)
	{
        // Initialization code here.
		self.arrReflectionList = [[NSMutableArray alloc] init];
		self.arrReflectionContent = [[NSMutableArray alloc] init];
		self.arrCommentList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
