//
//  WebServiceConnection.m
//  PIMagazine
//
//  Created by jigar shah on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomURLConnection.h"

@implementation CustomURLConnection
@synthesize WebSeviceFor;

#pragma mark -
#pragma mark Init Method

- (id)initWithUrl:(NSString*)urlString FileName:(NSString*)strFileName NotificationName:(NSString*)strNotificationName {
    // NSLog(@"Getting url");
	NSMutableURLRequest *request;
	fileName = [strFileName retain];
	// fileURL = [urlString retain];

    NSString *urls = @"";
    if (CONNECTION_MODE == 0) {
        urls = [NSString stringWithFormat:@"http://%@%@%@", ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strServerLocation, URL_FILETRANSFER_LOCATION, urlString];            
    } else {
        urls = [NSString stringWithFormat:@"%@%@%@",HTTPS_WEB_SERVER,URL_FILETRANSFER_LOCATION, urlString];
    }
    
    urls = [urls stringByReplacingOccurrencesOfString:@".." withString:@""];
    urls = [urls stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    
    fileURL = [urls retain];
	NotificationName = strNotificationName;
	//request = [[NSMutableURLRequest alloc] initWithURL: 
	//		   [NSURL URLWithString:urlString]];
	request = [[NSMutableURLRequest alloc] initWithURL: 
			   [NSURL URLWithString:urls]];
	responseData = [[NSMutableData data] retain];	
	[super initWithRequest:request delegate:self];
	[request release];
	return self;
}

-(void) dealloc
{
	[responseData release];
	[super dealloc];
}

#pragma mark -
#pragma mark delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationName object:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    @try {
        int fileType = 0;
        
        NSString *fext = [[fileName componentsSeparatedByString:@"."] lastObject];
        // NSLog(@"%@", fileName);
        if ([[fext lowercaseString] isEqualToString:@"mov"]) 
            fileType = 1;

        
        if (fileType == 0) {
            // NSLog(@"Got url - saving to photo album"); 
            UIImage *image = [[UIImage imageWithData:responseData] retain];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            // NSLog(@"Got url - writing to local storage");
            [responseData writeToFile:
             [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:fileName] atomically:YES];
            [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryFileRequestArray removeObject:fileURL];
            //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            // [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName object:nil];	
            // [responseData release];
        } else {
            // NSLog(@"Got url - saving video"); 
            NSString * filepath = [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:fileName];
            
            [responseData writeToFile:filepath atomically:YES];
            /*
             MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
             UIImage *thumbnail = [[moviePlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame] retain];
             NSData *imgData = UIImagePNGRepresentation(thumbnail);
             */
            // [imgData writeToFile:[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", strUniqueFileId]] atomically:YES];        
            // [imgData release];
            //[moviePlayer release];
            //[thumbnail release];
            
            UISaveVideoAtPathToSavedPhotosAlbum(filepath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            // NSLog(@"Got url - writing to local storage");
            //[responseData writeToFile:
             //[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).strFilePath stringByAppendingPathComponent:fileName] atomically:YES];
            [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryFileRequestArray removeObject:fileURL];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName object:nil];	
            //[responseString release];
            
        }
    }
    @catch (NSException *ex) {
        NSLog (@"Exception on saving image");
    }
}

-(void) video:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo:(void *)contextInfo {
    [image release];
}

-(void) image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo:(void *)contextInfo {
    [image release];
    image = nil;
    [responseData release];
    responseData = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName object:nil];	
}

/*
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
		//if ([trustedHosts containsObject:challenge.protectionSpace.host])
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

*/
@end
