//
//  LoadingAlert.m
//  CustomAlertView
//
//  Created by Triforce consultancy on 27/01/11.
//  Copyright 2011 Triforce consultancy . All rights reserved.
//

#import "LoadingAlert.h"

UIAlertView *LoadAlert;
@implementation LoadingAlert
+(void)ShowLoadingAlert{

		if(LoadAlert!=nil && [LoadAlert retainCount]>0){
			[LoadAlert removeFromSuperview];
			[LoadAlert release];
			LoadAlert = nil;
		}
		LoadAlert  = [[UIAlertView alloc]initWithTitle:@"Loading" 
										   message:@"please wait..." 
										  delegate:nil 
								 cancelButtonTitle:nil 
								 otherButtonTitles:nil];
		UIActivityIndicatorView *Indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(115,60,50,50)];
		[Indicator startAnimating];
		[Indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[LoadAlert addSubview:Indicator];
		[Indicator release];
		[LoadAlert show];
}

+(void)HideLoadingAlert{
	[LoadAlert dismissWithClickedButtonIndex:0 animated:YES];
}

@end
