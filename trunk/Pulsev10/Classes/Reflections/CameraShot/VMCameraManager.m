//
//  VMCameraManager.m
//  Makeup
//
//  Created by MinhPB on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VMCameraManager.h"
#import "define.h"

@implementation VMCameraManager
@synthesize m_Delegate, m_FlagScreen, m_Bluetooth;
#define cameraIsAvailable [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]

- (void)clickShot:(UIImage *)image
{
	if (m_Bluetooth == YES)
	{
		[self clickOK:image];
	}
	else
	{
		VMAfterShootViewController *afterShootVC = [VMAfterShootViewController new];
		afterShootVC.m_FlagScreen = m_FlagScreen;
		afterShootVC.m_Delegate = self;
		[self presentModalViewController:afterShootVC animated:NO];
		afterShootVC.imageDisplay.image = image;
		[afterShootVC release]; 
	}
}
- (void)clickBack
{
    [self dismissModalViewControllerAnimated:NO];
}

- (void)clickCancel
{
    [self presentCameraController];
}

- (void)clickOK:(UIImage *)image
{
	if (image)
	{
		[self dismissModalViewControllerAnimated:NO];
		[m_Delegate clickOK:image];
	}
}

- (void)backToTop
{
    [self dismissModalViewControllerAnimated:NO];
    [m_Delegate backToTop];
}

- (void)presentCameraController
{
    if (cameraIsAvailable) {
        VMCameraController *vm_camera = [VMCameraController new];
        vm_camera.m_Delegate = self;
        [self presentModalViewController:vm_camera animated:YES];
        [vm_camera release];
    }
	else
	{
        [self dismissModalViewControllerAnimated:NO];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:CAMERA_NOT_SUPPORTED
													   delegate:m_Delegate
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void)dealloc
{
    [super dealloc];
}

//Added from Old File
- (void) setFlagScreen:(int) i
{
    self.m_FlagScreen = i;
}

- (void) setFlagBluetooth:(BOOL)flag
{
	self.m_Bluetooth = flag;
}
/////////////////////

@end
