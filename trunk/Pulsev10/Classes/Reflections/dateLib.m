//
//  dateLib.m
//  MobileReflections
//
//  Created by SonNT on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "dateLib.h"

@implementation dateLib

+ (NSString *)getMonthNameFromDate:(NSDate *)aDate
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat:@"MMMM"];
	
	NSString *dateString = [dateFormatter stringFromDate:aDate];
	
	return dateString;
}

+ (NSDate *)setDateToComponents:(int)aDay month:(int)aMonth year:(int)aYear
{
	NSDateComponents *aComponents = [[[NSDateComponents alloc] init] autorelease];
	
	[aComponents setDay:aDay];
	[aComponents setMonth:aMonth];
	[aComponents setYear:aYear];

	NSCalendar *aGregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDate *date = [aGregorian dateFromComponents:aComponents];
	
	return date;
}

+ (BOOL)isDateOfMonth:(NSDate *)aDate ofMonth:(int)aMonth
{
	NSCalendar *aGregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents *aComponents = [aGregorian components:NSMonthCalendarUnit fromDate:aDate];
	NSInteger month = [aComponents month];

	if (month == aMonth) return YES;
	return NO;
}

+ (NSRange)getNumberOfDaysInMonth:(int)aMonth year:(int)aYear
{
	NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	
	NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
	[components setYear:aYear];
	[components setMonth:aMonth];
	[components setDay:1];

	NSDate *aDate = [calendar dateFromComponents:components];
	NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:aDate];
	
	NSLog(@"%u days in february", range.length);
	return range;
}

@end
