//
//  VMCameraController.m
//  Makeup
//
//  Created by MinhPB on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VMCameraController.h"
#import "FaceResizeViewController.h"
#import "MakeupAppDelegate.h"
#import "define.h"

#define cameraIsAvailable [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]

@implementation VMCameraController
@synthesize m_Delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // self.delegate = self;
        [self initCamera];
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	switch ( toInterfaceOrientation )
	{
		case UIInterfaceOrientationLandscapeRight:
			[viewCustom setHidden:YES];
			[viewCustomOverlay setHidden:NO];
			[btnSwitch setFrame:CGRectMake(20, 104, 60, 31)];
			break;
		case UIInterfaceOrientationLandscapeLeft:
			[viewCustom setHidden:YES];
			[viewCustomOverlay setHidden:NO];
			[btnSwitch setFrame:CGRectMake(20, 104, 60, 31)];
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			[viewCustom setHidden:NO];
			[viewCustomOverlay setHidden:YES];
			[btnSwitch setFrame:CGRectMake(688, 104, 60, 31)];
			break;
		case UIInterfaceOrientationPortrait:
			[viewCustom setHidden:NO];
			[viewCustomOverlay setHidden:YES];
			[btnSwitch setFrame:CGRectMake(688, 104, 60, 31)];
			break;
		default:
			[viewCustom setHidden:NO];
			[viewCustomOverlay setHidden:YES];
			[btnSwitch setFrame:CGRectMake(688, 104, 60, 31)];
			break;
	}
}

- (void) initCamera {

        
        [self createSwitchButton];
        [self loadCustomLayout];
        [self loadCustomLayoutLandscape];
        
        [btnSwitch setHidden:YES];
        [viewCustom setHidden:NO];
        [viewCustomOverlay setHidden:YES];
        
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.showsCameraControls = NO;
        
        [self.cameraOverlayView addSubview:viewCustom];
        [self.cameraOverlayView addSubview:viewCustomOverlay];
        [self.cameraOverlayView addSubview:btnSwitch];
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
            [self setCameraDevice:UIImagePickerControllerCameraDeviceFront];
            [btnSwitch setHidden:NO];
        }
}

-(void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
}


// backToTopDelegate [s]
- (void)backToTop
{
    [self dismissModalViewControllerAnimated:NO];
    [m_Delegate backToTop];
}

//- (void)clickCancel {
//    
//    [self dismissModalViewControllerAnimated:NO];
//    VMCameraController *vm_camera = [VMCameraController new];
//    vm_camera.m_Delegate = m_Delegate;
//    [vm_camera setFlagScreen:m_FlagScreen];
//    [m_Delegate presentModalViewController:vm_camera animated:NO];
//    [vm_camera release];
//}


//- (void)clickOK:(UIImage *)image
//{
//	if (image)
//	{
//		[self dismissModalViewControllerAnimated:NO];
//		[m_Delegate clickOK:image];
//	}
//}

// backToTopDelegate [e]
- (void)clickBack
{
    [self dismissModalViewControllerAnimated:NO];
}

////Added from Old File
//- (void) setFlagScreen:(int) i
//{
//    self.m_FlagScreen = i;
//}
//
//- (void) setFlagBluetooth:(BOOL)flag
//{
//	self.m_Bluetooth = flag;
//}
///////////////////////

- (void)clickSwitch
{
    if (self.cameraDevice == UIImagePickerControllerCameraDeviceFront)
	{
        [self setCameraDevice:UIImagePickerControllerCameraDeviceRear];
    }
    else
    {
        [self setCameraDevice:UIImagePickerControllerCameraDeviceFront];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    UIButton *btnShoot = (UIButton *)[viewCustom viewWithTag:100];
    btnShoot.enabled = TRUE;
    [super viewDidAppear:animated];
}
- (void)clickShoot:(id)sender
{
    [self performSelector:@selector(takePicture) withObject:nil afterDelay:0.5];
}


//- (void)viewWillAppear:(BOOL)animated
//{
//    
//    if (cameraIsAvailable) {
//
//        [self createSwitchButton];
//        [self loadCustomLayout];
//        [self loadCustomLayoutLandscape];
//        
//        [btnSwitch setHidden:YES];
//        [viewCustom setHidden:NO];
//        [viewCustomOverlay setHidden:YES];
//        
//        self.sourceType = UIImagePickerControllerSourceTypeCamera;
//        self.showsCameraControls = NO;
//        
//        [self.cameraOverlayView addSubview:viewCustom];
//        [self.cameraOverlayView addSubview:viewCustomOverlay];
//        [self.cameraOverlayView addSubview:btnSwitch];
//        
//        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
//        {
//            [btnSwitch setHidden:NO];
//            [self setCameraDevice:UIImagePickerControllerCameraDeviceFront];
//        }
//        
//
//    }
//    [super viewWillAppear:animated];
//}

//- (void) viewDidAppear:(BOOL)animated{
//    
//    if (!cameraIsAvailable) {
//          [self dismissModalViewControllerAnimated:NO];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:CAMERA_NOT_SUPPORTED
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//        return;
//    }
//    else
//    {
//        // Create image picker controller
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        
//        // Set source to the camera
//        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
//        
//        // Delegate is self
//        imagePicker.delegate = self;
//        
//        // Allow editing of image ?
//        //imagePicker.allowsImageEditing = NO;
//        
//        // Show image picker
//        [self presentModalViewController:imagePicker animated:YES];	
//    }
//    [super viewDidAppear:animated];
//}


- (void)loadCustomLayout
{
    //config camera
    viewCustom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    
    UIImageView *imageMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_mask_ipad.png"]];
    [viewCustom addSubview:imageMask];
    [imageMask release];
    
    UIImageView *imageTitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_title.png"]];
    [imageTitle setFrame:CGRectMake(0, 0, 768, 96)];
    [viewCustom addSubview:imageTitle];
    [imageTitle release];
    
    UIImageView *imageFooter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lower_bg_bottom.png"]];
    [imageFooter setFrame:CGRectMake(0, 774, 768, 250)];
    [viewCustom addSubview:imageFooter];
    [imageFooter release];
    
    UILabel *labelFooter = [[UILabel alloc] initWithFrame:CGRectMake(0, 814, 768, 55)];
    labelFooter.text = @"撮影するときは口を閉じてください";
    labelFooter.textColor = [UIColor whiteColor];
    [labelFooter setFont:[UIFont boldSystemFontOfSize:28]];
    [labelFooter setBackgroundColor:[UIColor clearColor]];
    labelFooter.textAlignment = UITextAlignmentCenter;
    [viewCustom addSubview:labelFooter];
    [labelFooter release];

    UILabel *lblFooter = [[UILabel alloc] initWithFrame:CGRectMake(0, 869, 768, 55)];
    lblFooter.text = @"眉毛が見える位置まで前髪を上げてください";
    lblFooter.textColor = [UIColor whiteColor];
    [lblFooter setFont:[UIFont boldSystemFontOfSize:28]];
    [lblFooter setBackgroundColor:[UIColor clearColor]];
    lblFooter.textAlignment = UITextAlignmentCenter;
    [viewCustom addSubview:lblFooter];
    [lblFooter release];
    
    UIButton *btn_Back = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 140, 60)];
    [btn_Back setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [btn_Back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [viewCustom addSubview:btn_Back];
    [btn_Back release];
    
    UIButton *btn_Shoot = [[UIButton alloc] initWithFrame:CGRectMake(204, 932, 360, 72)];
    [btn_Shoot setBackgroundImage:[UIImage imageNamed:@"btn_shoot.png"] forState:UIControlStateNormal];
    [btn_Shoot addTarget:self action:@selector(clickShoot:) forControlEvents:UIControlEventTouchUpInside];
    [btn_Shoot setTag:100];
    btn_Shoot.enabled = FALSE;
    [viewCustom  addSubview:btn_Shoot];
    
    [btn_Shoot release];
}

- (void)loadCustomLayoutLandscape
{
    //config camera
    viewCustomOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    
    UIImageView *imageMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_mask_ipad.png"]];
	[imageMask setFrame:CGRectMake(128, 0, 768, 1024)];
    [viewCustomOverlay addSubview:imageMask];
    [imageMask release];
    
    UIImageView *imageTitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_title.png"]];
    [imageTitle setFrame:CGRectMake(0, 0, 1024, 96)];
    [viewCustomOverlay addSubview:imageTitle];
    [imageTitle release];
    
    UIImageView *imageFooter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lower_bg_bottom.png"]];
    [imageFooter setFrame:CGRectMake(0, 518, 1024, 250)];
    [viewCustomOverlay addSubview:imageFooter];
    [imageFooter release];
    
    UILabel *labelFooter = [[UILabel alloc] initWithFrame:CGRectMake(0, 620, 1024, 55)];
    labelFooter.text = @"撮影するときは口を閉じてください";
    labelFooter.textColor = [UIColor whiteColor];
    [labelFooter setFont:[UIFont boldSystemFontOfSize:28]];
    [labelFooter setBackgroundColor:[UIColor clearColor]];
    labelFooter.textAlignment = UITextAlignmentCenter;
    [viewCustomOverlay addSubview:labelFooter];
    [labelFooter release];

	UILabel *lblFooter = [[UILabel alloc] initWithFrame:CGRectMake(0, 620, 1024, 55)];
    lblFooter.text = @"眉毛が見える位置まで前髪を上げてください";
    lblFooter.textColor = [UIColor whiteColor];
    [lblFooter setFont:[UIFont boldSystemFontOfSize:28]];
    [lblFooter setBackgroundColor:[UIColor clearColor]];
    lblFooter.textAlignment = UITextAlignmentCenter;
    [viewCustomOverlay addSubview:lblFooter];
    [lblFooter release];

    UIButton *btn_Back = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 140, 60)];
    [btn_Back setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [btn_Back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [viewCustomOverlay addSubview:btn_Back];
    [btn_Back release];
    
    UIButton *btn_Shoot = [[UIButton alloc] initWithFrame:CGRectMake(332, 676, 360, 72)];
    [btn_Shoot setBackgroundImage:[UIImage imageNamed:@"btn_shoot.png"] forState:UIControlStateNormal];
    [btn_Shoot addTarget:self action:@selector(clickShoot) forControlEvents:UIControlEventTouchUpInside];
    [viewCustomOverlay  addSubview:btn_Shoot]; 
    [btn_Shoot release];
}

- (void)createSwitchButton
{
	CGRect rect = CGRectMake(688, 104, 60, 31);
	btnSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[btnSwitch setFrame:rect];
	[btnSwitch setImage:[UIImage imageNamed:@"icon_switch_camera.png"] forState:UIControlStateNormal];
	[btnSwitch addTarget:self action:@selector(clickSwitch) forControlEvents:UIControlEventTouchUpInside];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//   UIImage *selectedImage = (UIImage*) [info objectForKey:UIImagePickerControllerOriginalImage];
//    //[picker.parentViewController dismissModalViewControllerAnimated:YES];
//    if (m_Bluetooth == YES)
//	{
//		[self clickOK:selectedImage];
//	}
//	else
//	{
//		VMAfterShootViewController *afterShootVC = [VMAfterShootViewController new];
//		afterShootVC.m_FlagScreen = m_FlagScreen;
//		afterShootVC.m_Delegate = self;
//		[self presentModalViewController:afterShootVC animated:NO];
//		afterShootVC.imageDisplay.image = selectedImage;
//		[afterShootVC release]; 
//	}
//    //[picker release];
}


@end
