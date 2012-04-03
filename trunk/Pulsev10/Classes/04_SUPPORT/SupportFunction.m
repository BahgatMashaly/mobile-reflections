/*
 * $URL: https://kidbaw@subversion.assembla.com/svn/mmobiledev/trunk/SwypeKeyboard/JSC_SWYPE/04_SUPPORT/SupportFunction.m $
 * $Author: kidbaw $
 * $Revision: 59 $
 * $Date: 2012-03-23 22:44:48 +0700 (Fri, 23 Mar 2012) $
 *
 * ====================================================================
 *
 * Copyright (C) 2012 by MMobileDev.com
 *
 * Minh Nguyen PROPRIETARY/CONFIDENTIAL PROPERTIES. Use is subject to license terms.
 * You CANNOT use this software unless you receive a written permission from MMobileDev.com
 */

#import "SupportFunction.h"

@implementation SupportFunction

typedef enum {
	libUserInterfaceIdiomUnknown = -1,
    libUserInterfaceIdiomPhone,
    libUserInterfaceIdiomPad,
} libUserInterfaceIdiom;

static libUserInterfaceIdiom g_interfaceIdiom = libUserInterfaceIdiomUnknown;
+ (BOOL)deviceIsIPad
{
	if ( g_interfaceIdiom == libUserInterfaceIdiomUnknown ) {
		switch ( UI_USER_INTERFACE_IDIOM() ) {
			case UIUserInterfaceIdiomPhone:
				g_interfaceIdiom = libUserInterfaceIdiomPhone;
				break;
				
			case UIUserInterfaceIdiomPad:
				g_interfaceIdiom = libUserInterfaceIdiomPad;
				break;
		}
	}
	
	return (g_interfaceIdiom == libUserInterfaceIdiomPad);
}

+ (int)getDeviceHeight
{
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        if (IS_IPAD) {
            return WIDTH_IPAD;
        }
        else
            return WIDTH_IPHONE;
    }
    else {
        if (IS_IPAD) {
            return HEIGHT_IPAD;
        }
        else
            return HEIGHT_IPHONE;
    }
}

+ (int)getDeviceWidth
{
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        if (IS_IPAD) {
            return HEIGHT_IPAD;
        }
        else
            return HEIGHT_IPHONE;
    }
    else {
        if (IS_IPAD) {
            return WIDTH_IPAD;
        }
        else
            return WIDTH_IPHONE;
    }
}

@end
