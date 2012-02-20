//
//  VMCameraManager.h
//  Makeup
//
//  Created by MinhPB on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMCameraController.h"

@interface VMCameraManager : UIViewController <VMCameraManagerDelegate>  {
   //Added from Old File
    //UIViewController<BackToTopDelegate> *m_Delegate;
    int m_FlagScreen;
	BOOL m_Bluetooth;
}
- (void)presentCameraController;
//Added from Old File
//@property (nonatomic, assign)UIViewController<BackToTopDelegate> *m_Delegate;
@property int m_FlagScreen;
@property BOOL m_Bluetooth;
- (void) setFlagScreen:(int) i;
- (void) setFlagBluetooth:(BOOL)flag;
/////////////////////

@end
