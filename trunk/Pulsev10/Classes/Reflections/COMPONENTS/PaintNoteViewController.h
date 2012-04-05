//
//  PaintNoteViewController.h
//  MobileReflections
//
//  Created by SonNT on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ColorPickerViewController.h"

@protocol PaintNoteViewControllerDelegate <NSObject>
@optional
- (void)deletePaintview;
@end

@interface PaintNoteViewController : UIViewController <UIPopoverControllerDelegate, ColorPickerViewControllerDelegate>
{
	id<PaintNoteViewControllerDelegate>                 myDelegate;

	IBOutlet UILabel                                    *lblStroke;
	IBOutlet UISlider                                   *sliderStroke;
	IBOutlet UITextField                                *txtStrokeSize;
	IBOutlet UIToolbar                                  *toolbar;
	IBOutlet UIImageView                                *imgDrawingboard;
	IBOutlet UIImageView                                *imgEraser;
	
	CGPoint                                             previousPoint2;
	CGPoint                                             previousPoint1;
	CGPoint                                             currentPoint;
	
	UIColor                                             *color;
	int                                                 strokeSize;
	
	BOOL                                                eraser;
	BOOL                                                highlighter;
	
	UIPopoverController                                 *aPopover;
    UIImageView                                         *m_ImageViewInit;
}

@property (assign)id<PaintNoteViewControllerDelegate> myDelegate;
- (id)initWithImageView:(UIImageView *)imageView;
- (UIImageView *)getImageViewDrawing;

- (IBAction)clickPen:(id)sender;
- (IBAction)clickHighlight:(id)sender;
- (IBAction)clickEraser:(id)sender;
- (IBAction)clickColor:(id)sender;
- (IBAction)clickDelete:(id)sender;
- (IBAction)clickDone:(id)sender;
- (IBAction)sliderStrokeChanged:(id)sender;

- (CGPoint)midPoint:(CGPoint)p1 point:(CGPoint)p2;
- (void)showTools;
- (void)hideTools;
- (void)setStrokeSize;

@end
