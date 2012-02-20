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
	IBOutlet UIImageView *imgTextBG;
	IBOutlet UIImageView *imgResize;
	IBOutlet UITextView *txtContent;
	IBOutlet UIToolbar *toolbar;
	
	NSString *strContent;
	UIColor *fontColor;
	NSString *fontName;
	CGFloat fontSize;

	CGPoint touchStart;
	BOOL isResizing;
	
	UIPopoverController *aPopover;
}

@property (nonatomic, retain) NSString *strContent;
@property (nonatomic, retain) UIColor *fontColor;
@property (nonatomic, retain) NSString *fontName;
@property CGFloat fontSize;

- (IBAction)clickDelete:(id)sender;
- (IBAction)clickDone:(id)sender;
- (IBAction)clickColor:(id)sender;
- (IBAction)clickFont:(id)sender;
- (IBAction)clickFontSize:(id)sender;

- (void)fixPosition;

@end
