//
//  VMCameraController.h
//  Makeup
//
//  Created by MinhPB on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "VMImagePickerController.h"
#import "BackToTopDelegate.h"
#import "VMAfterShootViewController.h"

@interface VMCameraController : UIImagePickerController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,VMCameraManagerDelegate, BackToTopDelegate>
{
    UIViewController<BackToTopDelegate> *m_Delegate;
	UIView *viewCustom;
	UIView *viewCustomOverlay;
	UIButton *btnSwitch;

}
- (void)loadCustomLayout;
- (void)loadCustomLayoutLandscape;
- (void)createSwitchButton;
@property (nonatomic, assign)UIViewController<BackToTopDelegate> *m_Delegate;

//- (void) setFlagScreen:(int) i;
//- (void) setFlagBluetooth:(BOOL)flag;
- (void) initCamera;
/////////////////////
@end
