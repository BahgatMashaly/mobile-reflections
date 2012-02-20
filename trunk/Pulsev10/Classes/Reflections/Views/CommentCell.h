//
//  CommentCell.h
//  MobileJabber
//
//  Created by SonNT on 12/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
{
	UIImageView *imgUserPicture;
	UILabel *lblTitle;
	UILabel *lblDate;
}

@property (nonatomic, retain) UIImageView *imgUserPicture;
@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) UILabel *lblDate;

@end
