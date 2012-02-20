//
//  VMAfterShootViewController.m
//  Makeup
//
//  Created by MinhPB on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VMAfterShootViewController.h"
#import "FaceResizeViewController.h"
#import "MakeupAppDelegate.h"
#import "VMCameraController.h"

@implementation VMAfterShootViewController
@synthesize imageDisplay;
@synthesize m_Delegate, m_FlagScreen, btnOK;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
//    [imageDisplay release];
    [btnOK release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.imageDisplay = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)clickCancel:(id)sender
{
    [self dismissModalViewControllerAnimated:NO];
    [m_Delegate clickCancel];
    
}

/////////////////////////////////////////////////
//Added from Old File
- (void)backToTop {
    [self dismissModalViewControllerAnimated:NO];
    [m_Delegate backToTop];
}

- (void) setFlagScreen:(int) i{
	m_FlagScreen = i;
}

- (IBAction)clickOK:(id)sender
{
	switch (m_FlagScreen) {
		case 1:
			[self dismissModalViewControllerAnimated:NO];
			[m_Delegate clickOK:[imageDisplay image]];
			break;
		case 2:
			[self faceDetect];
            btnOK.enabled = FALSE;
			break;
	}
}

- (void)hideProgressIndicator {

    NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:face_rect.origin.x forKey:@"FACE_X"];
    NSLog(@"x_detect = %f",face_rect.origin.x);
    
    [defaults setFloat:face_rect.size.width forKey:@"FACE_W"];
    NSLog(@"width_detect = %f",face_rect.size.width);
    if(face_rect.size.height > 0)
    {
        face_rect.origin.y = face_rect.origin.y - face_rect.size.height/10;
        [defaults setFloat:face_rect.origin.y forKey:@"FACE_Y"];
        NSLog(@"y_detect = %f",face_rect.origin.y);
        
        face_rect.size.height = face_rect.size.height + face_rect.size.height/5;
        [defaults setFloat:face_rect.size.height forKey:@"FACE_H"];
        NSLog(@"height_detect = %f",face_rect.size.height);
    }
    else
    {
        [defaults setFloat:face_rect.origin.y forKey:@"FACE_Y"];
        NSLog(@"y_detect = %f",face_rect.origin.y);
        
        [defaults setFloat:face_rect.size.height forKey:@"FACE_H"];
        NSLog(@"height_detect = %f",face_rect.size.height);
    }
    
    btnOK.enabled = TRUE;
    
    FaceResizeViewController *faceResize_vc = [[FaceResizeViewController alloc] initWithNibName:@"FaceResizeViewController" bundle:nil];
	[faceResize_vc setImage:[imageDisplay image]];
    faceResize_vc.myDelegate = self;
    [self presentModalViewController:faceResize_vc animated:NO];
	[faceResize_vc release];
}

- (void)faceDetect{
	cvSetErrMode(CV_ErrModeParent);
    // The hud will dispable all input on the view
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    // Add HUD to screen
    [self.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"処理中";
	
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(opencvFaceDetect:) onTarget:self withObject:nil animated:NO];
}

// NOTE you SHOULD cvReleaseImage() for the return value when end of the code.
- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image {
	CGImageRef imageRef = image.CGImage;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	IplImage *iplimage = cvCreateImage(cvSize(image.size.width, image.size.height), IPL_DEPTH_8U, 4);
	CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height,
													iplimage->depth, iplimage->widthStep,
													colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
	CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
	CGContextRelease(contextRef);
	CGColorSpaceRelease(colorSpace);
	
	IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
	cvCvtColor(iplimage, ret, CV_RGBA2BGR);
	cvReleaseImage(&iplimage);
	
	return ret;
}

// NOTE You should convert color mode as RGB before passing to this function
- (UIImage *)UIImageFromIplImage:(IplImage *)image {
	NSLog(@"IplImage (%d, %d) %d bits by %d channels, %d bytes/row %s", image->width, image->height, image->depth, image->nChannels, image->widthStep, image->channelSeq);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
	CGImageRef imageRef = CGImageCreate(image->width, image->height,
										image->depth, image->depth * image->nChannels, image->widthStep,
										colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
										provider, NULL, false, kCGRenderingIntentDefault);
	UIImage *ret = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorSpace);
	return ret;
}


- (UIImage *)resizeImage:(UIImage *)image2 toSize:(CGSize)newSize
{
    
    
	if (UIGraphicsBeginImageContextWithOptions != NULL) UIGraphicsBeginImageContextWithOptions(CGSizeMake(768, 1024), NO, 0.0);
	else UIGraphicsBeginImageContext(CGSizeMake(768, 1024));
	
    float deltaX =0;
	float deltaY =0;
	
	if(newSize.width < 768){
		deltaX = (768 -newSize.width)/2;
	}
	
	if(newSize.height < 1024){
		deltaY = (1024 -newSize.height)/2;
	}
	[image2 drawInRect:CGRectMake(deltaX,deltaY,newSize.width,newSize.height)];
    
    
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (void) opencvFaceDetect:(UIImage *)overlayImage  {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if(imageDisplay.image) {
		cvSetErrMode(CV_ErrModeParent);
		
        
        float xScale, yScale, newWidth, newHeight;
        xScale = 768/imageDisplay.image.size.width;
        yScale = 1024/imageDisplay.image.size.height;
        float newScale = MIN(xScale, yScale);
        newWidth = imageDisplay.image.size.width*newScale;
        newHeight = imageDisplay.image.size.height*newScale;
        
        CGSize size = CGSizeMake(newWidth, newHeight);
        UIImage *bgImage = [self resizeImage:imageDisplay.image toSize:size];
        NSLog(@"width = %f",bgImage.size.width);
        NSLog(@"height = %f",bgImage.size.height);
        
        
        
		IplImage *image = [self CreateIplImageFromUIImage:bgImage];
		
		// Scaling down
		IplImage *small_image = cvCreateImage(cvSize(image->width/2,image->height/2), IPL_DEPTH_8U, 3);
		cvPyrDown(image, small_image, CV_GAUSSIAN_5x5);
		int scale = 2;
		
		// Load XML
		NSString *path = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_default" ofType:@"xml"];
		CvHaarClassifierCascade* cascade = (CvHaarClassifierCascade*)cvLoad([path cStringUsingEncoding:NSASCIIStringEncoding], NULL, NULL, NULL);
		CvMemStorage* storage = cvCreateMemStorage(0);
		
		// Detect faces and draw rectangle on them
        //Old OpenCV
        //		CvSeq* faces = cvHaarDetectObjects(small_image, cascade, storage, 1.2f, 2, CV_HAAR_DO_CANNY_PRUNING, cvSize(20, 20));
        //		cvReleaseImage(&small_image);
		//Add by Minh
        CvSeq* faces = cvHaarDetectObjects(small_image, cascade, storage, 1.2f, 2, CV_HAAR_DO_CANNY_PRUNING, cvSize(0, 0), cvSize(20, 20));
		cvReleaseImage(&small_image);
        
		// Create canvas to show the results
		CGImageRef imageRef = bgImage.CGImage;
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef contextRef = CGBitmapContextCreate(NULL, bgImage.size.width, bgImage.size.height,
														8, bgImage.size.width * 4,
														colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
		CGContextDrawImage(contextRef, CGRectMake(0, 0, bgImage.size.width, bgImage.size.height), imageRef);
		
		CGContextSetLineWidth(contextRef, 4);
		CGContextSetRGBStrokeColor(contextRef, 0.0, 0.0, 1.0, 0.5);
		
		// Draw results on the iamge
		for(int i = 0; i < faces->total; i++) {
			NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
			
			// Calc the rect of faces
			CvRect cvrect = *(CvRect*)cvGetSeqElem(faces, i);
			face_rect = CGContextConvertRectToDeviceSpace(contextRef, CGRectMake(cvrect.x * scale, cvrect.y * scale, cvrect.width * scale, cvrect.height * scale));
			
			if(overlayImage) {
				CGContextDrawImage(contextRef, face_rect, overlayImage.CGImage);
			} else {
				CGContextStrokeRect(contextRef, face_rect);
			}
			
			[pool release];
		}
		
		//		bgImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(contextRef)];
		CGContextRelease(contextRef);
		CGColorSpaceRelease(colorSpace);
		cvReleaseMemStorage(&storage);
		cvReleaseHaarClassifierCascade(&cascade);
		
	}
	[pool release];
}
//////////////////////

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
    [self hideProgressIndicator];
}

@end

