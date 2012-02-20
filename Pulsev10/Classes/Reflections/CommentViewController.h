//
//  CommentViewController.h
//  MobileJabber
//
//  Created by SonNT on 12/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobileJabberAppDelegate.h"
#import "AddCommentViewController.h"
#import "common.h"

#import "CommentCell.h"

@interface CommentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	MobileJabberAppDelegate *appDelegate;

	IBOutlet UITextView *txtCommentContent;
	IBOutlet UILabel *lblTitleOfComment;
	IBOutlet UILabel *lblDateOfComment;
	IBOutlet UITableView *tblCommentList;
	
	int reflection_id;
	int comment_id;
	NSMutableArray *arrComment;
}

@property (nonatomic, retain) NSMutableArray *arrComment;

- (IBAction)clickBack:(id)sender;
- (IBAction)clickAdd:(id)sender;
- (IBAction)clickEdit:(id)sender;
- (void)setReflectionID:(int)aValue;

@end
