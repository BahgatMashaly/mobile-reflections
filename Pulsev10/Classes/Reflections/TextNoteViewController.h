//
//  TextNoteViewController.h
//  MobileReflections
//
//  Created by SonNT on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ColorPickerViewController.h"
#import "FontPickerViewController.h"
#import "SizeViewController.h"

@interface TextNoteViewController : UIViewController <UIPopoverControllerDelegate, ColorPickerViewControllerDelegate, FontPickerViewControllerDelegate, SizeViewControllerDelegate>
{
	IBOutlet UIImageView                    *imgTextBG;
	IBOutlet UIImageView                    *imgResize;
	IBOutlet UITextView                     *txtContent;
	IBOutlet UIToolbar                      *toolbar;

	CGPoint touchStart;
	BOOL isResizing;
	
	UIPopoverController                     *aPopover;
    
    UITextView                              *m_TextViewInit;
}

@property (nonatomic, retain) UITextView *txtContent;

- (id)initWithTextView:(UITextView *)textView ;

- (IBAction)clickDelete:(id)sender;
- (IBAction)clickDone:(id)sender;
- (IBAction)clickColor:(id)sender;
- (IBAction)clickFont:(id)sender;
- (IBAction)clickFontSize:(id)sender;

- (void)fixPosition;

@end
