//
//  TKADownloadDialog.m
//
//  Created by Kiril Antonov on 11/9/10.
//
//  Copyright (c) 2010 Kiril Antonov
// ================================================================================
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
// 
// ================================================================================

#import "TKADownloadDialog.h"


@implementation TKADownloadDialog
UIAlertView* DownloadDialog;

@synthesize       Request;
@synthesize       Response;
@synthesize       Username;
@synthesize       Password;
@synthesize       LastError;
@synthesize       LastErrorText;
@synthesize       LastErrorDescription;

UIProgressView*             ProgressBar;
UIActivityIndicatorView*    ActivityBar;

BOOL						InDownloading;
NSInteger					ErrorCount;
CGFloat						ProgressStep;
NSInteger					DownloadType;
NSInteger					DownloadSize;
NSInteger					CurrentSize;
NSString*					DownloadFileName; 
NSFileHandle*				DownloadFile;
NSMutableData*				DownloadData;
NSURLConnection*			Download;


- (void) WaitForConnectionDownload{
	NSDate*               LoopUntil;
	//****************************************************************************
	LoopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
	while ((InDownloading) && ([[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate:LoopUntil]))
	{
		LoopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
	}
	//****************************************************************************
}

//***************************************************************************
//  
//                     UIAlertView Delegate
//
//***************************************************************************
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex==0) 
	{
		if (InDownloading)
		{
			NSError* Error = nil;
			[Download cancel];	
			if (DownloadType==1)
			{
				if (DownloadFile)
				{
					[DownloadFile closeFile];
					[DownloadFile release];
				}
				[[NSFileManager defaultManager] removeItemAtPath:DownloadFileName error:&Error];
			}
			if (DownloadType==2)
			{
				[DownloadData setLength:0];
			}
			//********************************************************************************************************
			[self performSelector:@selector(OnDownloadComplete) withObject:nil afterDelay:0.0];	
		}
	}
}

-(void) PresentDownloadDialog{
	NSString* FileName;
	if (DownloadType==1)
	{
		FileName = [DownloadFileName lastPathComponent];
	}
	else 
	{
	 	FileName = [Response suggestedFilename];
	}

	
	DownloadDialog = [[UIAlertView alloc] initWithTitle:@"Downloading ..."
												message:[NSString stringWithFormat:@"\n \n%@", FileName]
											   delegate:self
									  cancelButtonTitle:@"Cancel"
									  otherButtonTitles:nil];
	
	
    ProgressBar = [[UIProgressView alloc] initWithFrame: CGRectMake(30.0, 58.0, 223.0, 25.0)];
	ProgressBar.progressViewStyle          =  UIProgressViewStyleBar;
	[DownloadDialog addSubview:ProgressBar];
	[ProgressBar release];
	ActivityBar = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(123.0, 45.0, 37.0, 37.0)];
	ActivityBar.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[DownloadDialog addSubview:ActivityBar];
	[ActivityBar release];
	// Enable for IPhone
	// CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0, 80.0);
	// [LoginView setTransform:transform];
	
	[DownloadDialog show];
	[DownloadDialog release];
}

#pragma mark -
#pragma mark HTTP download engine delegate NSURLConnection Delegate

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
	return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
	if ([challenge previousFailureCount] == 0) 
	{
		[[challenge sender] useCredential:[NSURLCredential credentialWithUser:Username password:Password persistence:NSURLCredentialPersistenceForSession] forAuthenticationChallenge:challenge];
	} else 
	{
		[[challenge sender] cancelAuthenticationChallenge:challenge]; 
	}
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection{
	return YES;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
	return nil;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	DownloadSize = [response expectedContentLength];
	CurrentSize  = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	NSData*         TempData;
	CGFloat         Progress;
	//**********************************************************************
	if (DownloadType==1)
	{
		if (DownloadFile == nil)
		{		  
			TempData = [NSData data];
			if ([[NSFileManager defaultManager] createFileAtPath:DownloadFileName contents:TempData attributes:nil])
			{
				DownloadFile  = [[NSFileHandle fileHandleForWritingAtPath:DownloadFileName] retain];
			}
		}
	}
    //**********************************************************************
	if (DownloadType==1)
	{
		@try 
		{
			[DownloadFile writeData:data];
			[DownloadFile synchronizeFile];
		}
		@catch (NSException * e) 
		{
			ErrorCount++;
			self.LastError            = nil;
			self.LastErrorText        = [e name];
			self.LastErrorDescription = [e reason];
		}
		@finally {}
	}
	//**********************************************************************
	if (DownloadType==2) 
	{
		@try 
		{
			[DownloadData appendData:data];
		}
		@catch (NSException * e) 
		{
			ErrorCount++;
			self.LastError            = nil;
			self.LastErrorText        = [e name];
			self.LastErrorDescription = [e reason];
		}
		@finally {}
	}
	//**********************************************************************
	CurrentSize += [data length];
	if (DownloadSize > 0)
	{
		Progress = (1/(CGFloat)DownloadSize)*(CGFloat)CurrentSize;
		if (Progress > 1.0) Progress=1.0;
		[ProgressBar setProgress:Progress];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	CGFloat        Progress  = 1.0;
	NSError*       Error     = nil;
	//**********************************************************************
	if (DownloadType==1)
	{
		[DownloadFile closeFile];
		if (ErrorCount > 0) 
		{
			[[NSFileManager defaultManager] removeItemAtPath:DownloadFileName error:&Error];
		}
	}
	if (DownloadType==2)
	{
		if (ErrorCount > 0) 
		{
			[DownloadData setLength:0];
	    }
	}
	if (DownloadSize > 0)
	{
		[ProgressBar setProgress:Progress];
	}
	//**********************************************************************
	[self performSelector:@selector(OnDownloadComplete) withObject:nil afterDelay:0.0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSError*       Error = nil;
	self.LastError       = error;
	//********************************************************************************************************	
	ErrorCount++;
	if (DownloadType==1)
	{
		[DownloadFile closeFile];
		[[NSFileManager defaultManager] removeItemAtPath:DownloadFileName error:&Error];
	}
	if (DownloadType==2)
	{
		[DownloadData setLength:0];
	}
	//********************************************************************************************************
	[self performSelector:@selector(OnDownloadComplete) withObject:nil afterDelay:0.0];
}



- (void) OnDownloadComplete{
	InDownloading = NO;
}


- (BOOL) DoDownload{
	NSMutableURLRequest* DownloadRequest;
	BOOL Result = NO;
	if (Request) 
	{
		if (Response) 
		{
			[self PresentDownloadDialog];
			[ProgressBar setProgress:0.0];
			if ([Response expectedContentLength] > 0)
			{
				ProgressStep = 1/[Response expectedContentLength];
				ProgressBar.hidden = NO;
				ActivityBar.hidden = YES;
			}
			else 
			{
				ProgressStep       = 0;
				ProgressBar.hidden = YES;
				ActivityBar.hidden = NO;
				[ActivityBar startAnimating];
			}
			DownloadRequest           = [Request mutableCopy];
			self.LastError            = nil;
			self.LastErrorText        = nil;
			self.LastErrorDescription = nil;
			ErrorCount     = 0;
			InDownloading  = YES;
			DownloadFile   = nil;
			Download       = [[NSURLConnection alloc] initWithRequest:DownloadRequest delegate:self];
			[self WaitForConnectionDownload];
			[Download release];
			Result             = (ErrorCount == 0);
			ProgressBar.hidden = YES;
			ActivityBar.hidden = YES;
			[ActivityBar stopAnimating];
			[DownloadRequest release];
			[DownloadDialog dismissWithClickedButtonIndex:0 animated:YES];
		}
	}
	return Result;
}

- (BOOL) DownloadToFile:(NSString *)FileName{
	BOOL Result        = NO;
	DownloadType       = 1;
	DownloadFileName   = FileName;
	Result             = [self DoDownload];
	return Result;
}

- (BOOL) DownloadToMemory:(NSMutableData *)Data{
	BOOL Result      = NO;
	DownloadType     = 2;
	DownloadData     = Data;
	Result           = [self DoDownload];
	return Result;
}

-(id)init{
	if (self = [super init])
	{		
		Request               = nil;
		Response              = nil;
		Username              = nil;
		Password              = nil;
		LastError             = nil;
		LastErrorText		  = @"";
		LastErrorDescription  = @"";
		return self;
	}
	else 
	{
		return nil;
	}
}

- (void)dealloc
{
	self.Request			   = nil;
	self.Response		       = nil;
	self.Username			   = nil;
	self.Password			   = nil;
	self.LastError             = nil;
	self.LastErrorText		   = nil;
	self.LastErrorDescription  = nil;
	[super dealloc];
}

@end
