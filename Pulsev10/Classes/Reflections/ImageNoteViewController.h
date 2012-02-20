//
//  ImageNoteViewController.h
//  MobileReflections
//
//  Created by SonNT on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "common.h"

@interface DragView : UIImageView
{
	CGPoint startLocation;
	CGSize originalSize;
	CGAffineTransform originalTransform;
    CFMutableDictionaryRef touchBeginPoints;
}
@end

@interface ImageNoteViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
{
	IBOutlet UIToolbar *toolbar;
	UIPopoverController *aPopover;
	DragView *dragger;

	UIImage *source;
	int sourceType;	//0=PhotoAlbum, 1=Camera
}

- (IBAction)clickChangePicture:(id)sender;
- (IBAction)clickResetPicture:(id)sender;
- (IBAction)clickDelete:(id)sender;
- (IBAction)clickDone:(id)sender;

- (void)setSource:(UIImage *)img;
- (void)createDragger;

@end
