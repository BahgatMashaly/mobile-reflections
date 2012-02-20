//
//  objText.m
//  MobileJabber
//
//  Created by Nguyen Thanh Son on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "objText.h"

@implementation objText
@synthesize objRect, objTag, objContent, fontColor, fontName, fontSize;

- (id)initWithFrame:(CGRect)aRect content:(NSString *)aContent tag:(CGFloat)aTag fontColor:(UIColor *)aColor fontName:(NSString *)aFont fontSize:(CGFloat)aFontSize
{
    self = [super init];
    if (self)
	{
        // Initialization code here.
		self.objRect = aRect;
		self.objTag = aTag;
		self.objContent = aContent;
		
		self.fontColor = aColor;
		self.fontName = aFont;
		self.fontSize = aFontSize;
    }
    
    return self;
}

- (void)setObjectFrame:(CGRect)aRect
{
	self.objRect = aRect;
}

- (void)setObjectTag:(CGFloat)aTag
{
	self.objTag = aTag;
}

- (void)dealloc
{
	[objContent release];
	[fontColor release];
	[fontName release];

	[super dealloc];
}

@end