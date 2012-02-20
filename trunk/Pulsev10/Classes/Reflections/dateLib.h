//
//  dateLib.h
//  MobileReflections
//
//  Created by SonNT on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dateLib : NSObject

+ (NSString *)getMonthNameFromDate:(NSDate *)aDate;
+ (NSDate *)setDateToComponents:(int)aDay month:(int)aMonth year:(int)aYear;
+ (BOOL)isDateOfMonth:(NSDate *)aDate ofMonth:(int)aMonth;
+ (NSRange)getNumberOfDaysInMonth:(int)aMonth year:(int)aYear;

@end
