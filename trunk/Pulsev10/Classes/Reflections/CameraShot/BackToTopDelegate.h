//
//  BackToTopDelegate.h
//  Makeup
//
//  Created by admin on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Favourite.h"

@protocol BackToTopDelegate <NSObject>

@optional
- (void)backToTop;
- (void)clickOK:(UIImage *)image;
- (void)clickFavouriteOK:(Favourite *)fdata;
- (void)closeMe;
- (void)selectSourceAgain:(int)flag;
@end

@protocol VMCameraManagerDelegate <NSObject>

@optional
- (void)clickCancel;
- (void)clickShot:(UIImage *)image;
- (void)clickBack;
- (void)clickOK:(UIImage *)image;
- (void)backToTop;
@end


