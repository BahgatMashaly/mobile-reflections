//
//  VMAfterShootViewController.h
//  Makeup
//
//  Created by MinhPB on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/objdetect/objdetect.hpp>
#import "BackToTopDelegate.h"
#import "MBProgressHUD.h"

@interface VMAfterShootViewController : UIViewController<BackToTopDelegate, MBProgressHUDDelegate> {
    IBOutlet UIImageView *imageDisplay;
    
    //Added from Old File
    MBProgressHUD *HUD;
    UIViewController<VMCameraManagerDelegate> *m_Delegate;
    int m_FlagScreen;
    CGRect face_rect;
    IBOutlet UIButton *btnOK;
    //////////////////////
}
@property (nonatomic, assign) UIImageView *imageDisplay;
@property (nonatomic, retain) IBOutlet UIButton *btnOK;
- (IBAction)clickCancel:(id)sender;
//Added from Old File
@property (assign)UIViewController<VMCameraManagerDelegate> *m_Delegate;
@property int m_FlagScreen;
- (void) setFlagScreen:(int) i;
- (IBAction)clickOK:(id)sender;
- (void)hideProgressIndicator;
- (void)faceDetect;
- (void) opencvFaceDetect:(UIImage *)overlayImage;
- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image;
- (UIImage *)UIImageFromIplImage:(IplImage *)image;
- (void) setFlagScreen:(int) i;
//////////////////////

@end
