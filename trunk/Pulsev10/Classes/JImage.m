//
//  JImage.m
//  ModelAgency
//
//  Created by Triforce consultancy on 21/01/11.
//  Copyright 2011 Triforce consultancy . All rights reserved.
//

#import "JImage.h"

@implementation JImage
@synthesize ai,connection, data;

-(void)initWithImageAtURL:(NSURL*)url
{
    [self setContentMode:UIViewContentModeScaleAspectFit];
    if (!ai)
	{
        [self setAi:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]];	
        [ai startAnimating];
        [ai setFrame:CGRectMake(27, 13, 20, 20)];
        [self addSubview:ai];
    }
	
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];    
	//[NSURLConnection canHandleRequest:request]?NSLog(@"yes - it can handle the request"):NSLog(@"It can't handle the request");
	if(connection==nil)
	{
	//	NSLog(@"conn nill");
		/*
		if(((ModelAgencyAppDelegate*)[[UIApplication sharedApplication] delegate]).ImageFlag == 0)
		{
			[self setImage:[UIImage imageNamed:@"no-image-available-100.png"]];	
		}
		else 
		{
			[self setImage:[UIImage imageNamed:@"no-image-available-320.png"]];				
		}
		*/ 
		[self setImage:[UIImage imageNamed:@"no-image-available-100.png"]];
	}
}

- (void)connection:(NSURLConnection *)connection1 didReceiveResponse:(NSURLResponse *)response 
{
    if ([response respondsToSelector:@selector(statusCode)])
    {
        int statusCode = [((NSHTTPURLResponse *)response) statusCode];
        if (statusCode == 404){
			//404 Error is there...
			//NSLog(@"Eror is there !");
			/*
			if(((ModelAgencyAppDelegate*)[[UIApplication sharedApplication] delegate]).ImageFlag == 0){
				[self setImage:[UIImage imageNamed:@"no-image-available-100.png"]];	
			}else {
				[self setImage:[UIImage imageNamed:@"no-image-available-320.png"]];				
			}
			*/
			[self setImage:[UIImage imageNamed:@"no-image-available-100.png"]];

			[connection1 cancel];
			[ai removeFromSuperview];
        }
    }
}


- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData
{
    if (data==nil) data = [[NSMutableData alloc] initWithCapacity:2048];
    [data appendData:incrementalData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	/*
	if(((ModelAgencyAppDelegate*)[[UIApplication sharedApplication] delegate]).ImageFlag == 0)
	{
		[self setImage:[UIImage imageNamed:@"no-image-available-100.png"]];	
	}
	else 
	{
		[self setImage:[UIImage imageNamed:@"no-image-available-320.png"]];				
	}
	 */
	[self setImage:[UIImage imageNamed:@"no-image-available-100.png"]];	
	[ai removeFromSuperview];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection 
{
	if([data length]>0)
	{
		[self setImage:[UIImage imageWithData: data]]; 
	}
	else 
	{
		/*
		if(((ModelAgencyAppDelegate*)[[UIApplication sharedApplication] delegate]).ImageFlag == 0)
		{
			[self setImage:[UIImage imageNamed:@"no-image-available-100.png"]];	
		}
		else 
		{
			[self setImage:[UIImage imageNamed:@"no-image-available-320.png"]];				
		}
		 */
	}

    [ai removeFromSuperview];
}

-(void)dealloc{
    [data release];
    [connection release];
    [ai release];
    [super dealloc];
}
@end