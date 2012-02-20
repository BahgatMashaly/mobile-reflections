//
//  objText.h
//  MobileJabber
//
//  Created by Nguyen Thanh Son on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface objText : NSObject
{
	CGRect objRect;
	CGFloat objTag;
	NSString *objContent;
	
	UIColor *fontColor;
	NSString *fontName;
	CGFloat fontSize;
}

@property CGRect objRect;
@property CGFloat objTag;
@property (nonatomic, retain) NSString *objContent;

@property (nonatomic, retain) UIColor *fontColor;
@property (nonatomic, retain) NSString *fontName;
@property CGFloat fontSize;

- (id)initWithFrame:(CGRect)aRect content:(NSString *)aContent tag:(CGFloat)aTag fontColor:(UIColor *)aColor fontName:(NSString *)aFont fontSize:(CGFloat)aFontSize;

@end
