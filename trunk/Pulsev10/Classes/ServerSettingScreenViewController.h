//
//  ServerSettingScreenViewController.h
//  MobileJabber
//
//  Created by Shivang Vyas on 8/8/11.
//  Copyright 2011 company. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ServerSettingScreenViewController : UIViewController <UITextFieldDelegate>{
	IBOutlet UITableView *tblView;
	IBOutlet UITableViewCell *tbcCustomCell;
	NSMutableArray *aryServerSetting;
}
- (IBAction)btnDoneTapped;

@end
