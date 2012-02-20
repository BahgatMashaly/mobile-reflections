//
//  TblActivePollListCell.h
//  MobileJabber
//
//  Created by MAC BOOK on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TblActivePollListCell : UITableViewCell {
	UIImageView *imvBackground;
	UIImageView *imvContactBackground;
	UIImageView *imvContact;
	UILabel * lblType;
	UILabel * lblQuestion;
	UILabel * lbltimercount;
}
@property(nonatomic,retain) UIImageView * imvContact;
@property(nonatomic,retain) UILabel * lblType;
@property(nonatomic,retain) UILabel * lblQuestion;
@property(nonatomic,retain) UILabel * lbltimercount;



@end
