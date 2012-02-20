//
//  common.m
//  FinePhotoShare
//
//  Created by SonNT on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "common.h"

@implementation common

+ (void)alertChooseReflection
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
													message:@"Select a reflection that you want to do. Please !!!"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void)alertCameraNotSupport
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
													message:@"Camera is not available."
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void)alertCommentNotFound
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
													message:@"There is not any comment for this reflection."
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void)alertCommentPosted
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
													message:@"Your comment has posted to this reflection successfully."
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void)loadHTMLContent:(NSString *)data webView:(UIWebView *)webView
{
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
		
	NSString *html = [NSString stringWithFormat:@"<html><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><link rel='stylesheet' type='text/css' href='style.css'><body>%@</body></html>", data];
	[webView loadHTMLString:html baseURL:baseURL];
}

+ (int)findMax:(NSArray *)arrData
{
	int max = 0;
	
	if ([arrData count] > 0)
	{
		for (int i=0; i < [arrData count]; i++)
		{
			NSArray *tmp = [arrData objectAtIndex:i];
			if ([[tmp objectAtIndex:0] intValue] > max)
			{
				max = [[tmp objectAtIndex:0] intValue];
			}
		}
	}
	
	return max;
}

@end