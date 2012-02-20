//
//  FontPickerViewController.h
//  MobileReflections
//
//  Created by SonNT on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FontPickerViewControllerDelegate <NSObject>
@optional
- (void)didSelectFont:(NSString *)fontName;
@end

@interface FontPickerViewController : UITableViewController
{
	id<FontPickerViewControllerDelegate> myDelegate;
}

@property (assign)id<FontPickerViewControllerDelegate> myDelegate;

@end
