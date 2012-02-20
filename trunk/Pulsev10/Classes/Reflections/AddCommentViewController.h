//
//  AddCommentViewController.h
//  MobileJabber
//
//  Created by Nguyen Thanh Son on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobileJabberAppDelegate.h"
#import "common.h"

@interface AddCommentViewController : UIViewController
{
	MobileJabberAppDelegate *appDelegate;

	IBOutlet UITextField *txtCommentTitle;
	IBOutlet UITextView *txtCommentContent;

	int reflection_id;
}

- (IBAction)clickCancel:(id)sender;
- (IBAction)clickResetComment:(id)sender;
- (IBAction)clickPostComment:(id)sender;
- (void)setReflectionID:(int)aValue;

@end
