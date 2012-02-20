//
//  common.h
//  FinePhotoShare
//
//  Created by SonNT on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface common : NSObject

+ (void)alertChooseReflection;
+ (void)alertCameraNotSupport;
+ (void)alertCommentNotFound;
+ (void)alertCommentPosted;
+ (void)loadHTMLContent:(NSString *)data webView:(UIWebView *)webView;
+ (int)findMax:(NSArray *)arrData;

@end