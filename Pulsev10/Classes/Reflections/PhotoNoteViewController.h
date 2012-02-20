//
//  PhotoNoteViewController.h
//  MobileJabber
//
//  Created by Nguyen Thanh Son on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "common.h"

@interface PhotoNoteViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UIGestureRecognizerDelegate>
{
	IBOutlet UIToolbar *toolbar;
	IBOutlet UIImageView *imgResize;
	IBOutlet UIImageView *imgPhoto;

	UIPopoverController *aPopover;
	UIImage *source;
	int sourceType;	//0=PhotoAlbum, 1=Camera
	
	CGPoint touchStart;
	BOOL isResizing;
}

- (IBAction)clickChangePicture:(id)sender;
- (IBAction)clickDelete:(id)sender;
- (IBAction)clickDone:(id)sender;

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer;

- (void)setSource:(UIImage *)img;

@end
