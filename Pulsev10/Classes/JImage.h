//
//  JImage.h
//  ModelAgency
//
//  Created by Triforce consultancy on 21/01/11.
//  Copyright 2011 Triforce consultancy . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JImage : UIImageView 
{	
    NSURLConnection *connection;
    NSMutableData* data;
    UIActivityIndicatorView *ai;
	NSString *imageType;
}

-(void)initWithImageAtURL:(NSURL*)url;	         
-(void)initWithImageAtURL:(NSURL*)url withType:(NSString *) imgType;	         
-(void) addNoImage;

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) UIActivityIndicatorView *ai;

@end

