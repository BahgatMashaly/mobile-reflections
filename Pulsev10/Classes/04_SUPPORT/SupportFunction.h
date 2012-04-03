/*
 * $URL: https://kidbaw@subversion.assembla.com/svn/mmobiledev/trunk/SwypeKeyboard/JSC_SWYPE/04_SUPPORT/SupportFunction.h $
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

#import <Foundation/Foundation.h>
#import "Define.h"

@interface SupportFunction : NSObject
+ (BOOL)deviceIsIPad;
+ (int)getDeviceHeight;
+ (int)getDeviceWidth;
@end
