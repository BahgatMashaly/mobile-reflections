//
//  EditReflectionViewController.h
//  MobileJabber
//
//  Created by Phan Ba Minh on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MobileJabberAppDelegate.h"
#import "common.h"

#import "PaintNoteViewController.h"
#import "TextNoteViewController.h"
#import "PostItViewController.h"
#import "ImageNoteViewController.h"
#import "PhotoNoteViewController.h"

#import "objText.h"

@interface EditReflectionViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, PaintNoteViewControllerDelegate>
{
	MobileJabberAppDelegate             *appDelegate;
	IBOutlet UIView                     *viewFreeEditor;
	IBOutlet UITextField                *txtTitle;
	IBOutlet UIButton                   *btnPrivate;
    
	BOOL                                isPrivate;
	int                                 viewIndex;
	int                                 sourceType;	//0=PhotoAlbum, 1=Camera, 2=video, 3=voice, 4=background
	
	UIPopoverController                 *aPopover;
	PaintNoteViewController             *paintnote_vc;
    
    NSMutableArray                      *m_ArrayOldComponents;
    NSMutableArray                      *m_ArrayNewComponents;
    CGRect                              m_RectFrame;
    
	BOOL                                isEditing;
}
- (id)initWithFrame:(CGRect)rect andArrayData:(NSMutableArray *)array;
- (void)loadViewWithOldArray;

- (IBAction)clickPrivate:(id)sender;
- (IBAction)clickSave:(id)sender;
- (IBAction)clickText:(id)sender;
- (IBAction)clickPostIt:(id)sender;
- (IBAction)clickImage:(id)sender;
- (IBAction)clickCamera:(id)sender;
- (IBAction)clickPen:(id)sender;
- (IBAction)clickVoiceImport:(id)sender;
- (IBAction)clickVideoImport:(id)sender;
- (IBAction)clickChangeBackground:(id)sender;
- (IBAction)clickClearAll:(id)sender;

- (void)editReflection:(int)aReflectionID;

@end