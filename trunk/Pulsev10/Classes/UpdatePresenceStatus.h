//
//  UpdatePresenceStatus.h
//  MobileJabber
//
//  Created by Shivang Vyas on 11/11/11.
//  Copyright 2011 company. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UpdatePresenceStatus : UIViewController {
	IBOutlet UITextField *txtUpdateText;
	NSMutableArray *aryStatus;
	IBOutlet UITableView *tblView;
	NSInteger selectedIndx;
	MobileJabberAppDelegate *appDelegate;
}
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnUpdateTapped:(id)sender;

@end
