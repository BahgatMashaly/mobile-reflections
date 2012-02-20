//
//  TblActiveChatListCell.h
//  MobileJabber
//
//  Created by Shivang Vyas on 7/2/11.
//  Copyright 2011 company. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TblActiveChatListCell : UITableViewCell {
	UIImageView *imvBackground;
	UIImageView *imvContactBackground;
	UIImageView *imvContact;
	UILabel * lblContactName;
	UILabel *lblLastMessageText;
}
@property(nonatomic,retain) UIImageView * imvContact;
@property(nonatomic,retain) UILabel * lblContactName;
@property(nonatomic,retain) UILabel *lblLastMessageText;

@end
