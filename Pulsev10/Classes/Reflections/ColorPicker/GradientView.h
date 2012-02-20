//
//  GradientView.h
//  MobileReflections
//
//  Created by SonNT on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientView : UIView
{
	CGGradientRef gradient;
	CGColorRef color;
}

@property (readwrite) CGColorRef color;
- (void)setupGradient;

@end
