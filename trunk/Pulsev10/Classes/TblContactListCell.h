//
//  TblContactListCell.h
//  MobileJabber
//
//  Created by Shivang Vyas on 6/27/11.
//  Copyright 2011 company. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TblContactListCell : UITableViewCell {
	UIImageView *imvBackground;
	UIImageView *imvContactBackground;
	UIImageView *imvContact;
	UIImageView *imvStatus;
	UIImageView *imvRole;
	UILabel *lblContactName;
	UILabel *lblContactMoodMessage;
	UIImageView * imvDivider;
	UIImageView * imgLogo;
	UIButton *btnLogo;
    NSString *userid;
    NSString *role;
    int status;
}
@property (nonatomic,retain) UIImageView * imvContact;
@property (nonatomic,retain) UILabel * lblContactName;
@property (nonatomic,retain) UILabel * lblContactMoodMessage;
@property (nonatomic,retain) UIImageView * imvRole;
@property (nonatomic,retain) UIButton *btnLogo;
@property (nonatomic,retain) NSString *role;
@property (nonatomic,retain) NSString *userid;
@property (nonatomic) int status;

@end
