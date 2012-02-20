//
//  TblEventCell.h
//  MobileJabber
//
//  Created by shivang vyas on 06/07/11.
//  Copyright 2011 Matrix. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TblEventCell : UITableViewCell {
	UIImageView * imvEventIcon;
	UIImageView * imvEventChecked;
	UIImageView * imvBackground;
	UIImageView * imvDivider;
	
	UILabel * lblEventDate;
	UILabel * lblEventSubject;
	UILabel * lblEventTime;
	
	
}
@property(nonatomic,retain)	UIImageView * imvEventChecked;
@property(nonatomic,retain)	UILabel * lblEventDate;
@property(nonatomic,retain)	UILabel * lblEventSubject;
@property(nonatomic,retain)	UILabel * lblEventTime;

@end
