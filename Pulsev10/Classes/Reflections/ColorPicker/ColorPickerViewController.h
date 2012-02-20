//
//  ColorPickerViewController.h
//  MobileReflections
//
//  Created by SonNT on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientView.h"

@protocol ColorPickerViewControllerDelegate <NSObject>
@optional
- (void)setSelectedColor:(UIColor *)selectedColor;
@end

@interface ColorPickerViewController : UIViewController
{
	id<ColorPickerViewControllerDelegate> myDelegate;

	GradientView *gradientView;
	UIColor *currentColor;
	CGRect colorMatrixFrame;
	
	CGFloat currentBrightness;
	CGFloat currentHue;
	CGFloat currentSaturation;
	
	IBOutlet UIView *viewPreview;
	IBOutlet UIImageView *imgCrossHairs;
	IBOutlet UIImageView *imgBrightnessBar;
	
	IBOutlet UILabel *Hex;
	IBOutlet UILabel *Hcoords;
	IBOutlet UILabel *Scoords;
	IBOutlet UILabel *Lcoords;
	IBOutlet UILabel *Rcoords;
	IBOutlet UILabel *Gcoords;
	IBOutlet UILabel *Bcoords;
}

@property (assign)id<ColorPickerViewControllerDelegate> myDelegate;

- (IBAction)clickDone:(id)sender;

@end
