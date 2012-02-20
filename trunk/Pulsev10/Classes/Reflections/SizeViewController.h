//
//  SizeViewController.h
//  MobileReflections
//
//  Created by SonNT on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SizeViewControllerDelegate <NSObject>
@optional
- (void)didSelectSize:(CGFloat)sizeValue;
@end

@interface SizeViewController : UIViewController
{
	id<SizeViewControllerDelegate> myDelegate;
	
	IBOutlet UISlider *sliderSize;
	IBOutlet UITextField *txtSize;
}

@property (assign)id<SizeViewControllerDelegate> myDelegate;

- (IBAction)clickDone:(id)sender;
- (IBAction)sliderChanged:(id)sender;
- (void)setSliderValue:(CGFloat)current minValue:(CGFloat)min maxValue:(CGFloat)max;

@end
