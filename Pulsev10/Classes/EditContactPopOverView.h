//
//  EditContactPopOverView.h
//  MobileJabber
//
//  Created by Shivang Vyas on 9/15/11.
//  Copyright 2011 company. All rights reserved.
//

@class MobileJabberAppDelegate;

#import <UIKit/UIKit.h>
#import "MobileJabberAppDelegate.h"

@interface EditContactPopOverView : UIViewController {
	MobileJabberAppDelegate *appDelegate;
	IBOutlet UILabel *lblTitle;
	IBOutlet UITableView *tblView;
	IBOutlet UITableViewCell *tbcCustomCell;
}
- (IBAction)backButtonTapped:(id)sender;
@end
