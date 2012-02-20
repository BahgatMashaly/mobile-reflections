//
//  LoginViewController.h
//  MobileJabber
//
//  Created by Shivang Vyas on 6/16/11.
//  Copyright 2011 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLRequestHandler.h"
#import "HomeViewController.h"
#import "ServerSettingScreenViewController.h"

@interface LoginViewController : UIViewController <UIPopoverControllerDelegate> {
	UIPopoverController * popoverController;
	IBOutlet UIViewController * popoverContent;
	IBOutlet UIView *popoverChangePassword;
	
	//forgot password
	IBOutlet UITextField *txt_f_Username;
	IBOutlet UITextField *txt_f_CurrentPassword;
	IBOutlet UITextField *txt_f_NewPassword;
	IBOutlet UITextField *txt_f_ConfirmPassword;
	
	//login
	IBOutlet UITextField *txtUsername;
	IBOutlet UITextField *txtPassword;
    IBOutlet UIButton *BtnServerSetting;
	
	URLRequestHandler * ObjURLRequestHandler;
	HomeViewController *ObjHomeViewController;
	IBOutlet UIImageView * imvBackground;
	int flag; 
	
	UIPopoverController * ObjPopoverController;
	IBOutlet UIButton * BtnLogMeInAutomatically;
	IBOutlet UIButton * BtnLogInWithOfflineMode;
	BOOL IsBtnLogMeInAutomaticallyTabbed;
	BOOL IsBtnLogInWithOfflineModeTabbed;
	BOOL IsAutoLoginEnabled;
}

-(void)BtnRegisterTabbed:(id)sender;
-(IBAction)BtnDismissTabbed:(id)sender;
-(IBAction)BtnSubmitTabbed:(id)sender;
-(IBAction)BtnLoginTabbed:(id)sender;
-(IBAction)BtnTest:(id)sender;
-(IBAction)BtnSearchTabbed:(id)sender;
-(IBAction)btnEmojiTabbed:(id)sender;
-(IBAction)BtnLoginMeInAutomaticallyTabbed:(id)sender;
-(IBAction)BtnLogInWithOfflineModeTabbed:(id)sender;
- (IBAction)btnPulseLogoTapped:(UIButton*)sender;
-(void) storeUserName;
-(BOOL) checkUserOfflineLoging;


-(void)LoginSuccessful:(id)sender;

@end
