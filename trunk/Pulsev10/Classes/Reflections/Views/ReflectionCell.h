//
//  ReflectionCell.h
//  MobileReflections
//
//  Created by SonNT on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReflectionCell : UITableViewCell
{
	UILabel *lblDay;
	UILabel *lblDate;
	UILabel *lblTitle;
	UILabel *lblCommentsRating;
}

@property (nonatomic, retain) UILabel *lblDay;
@property (nonatomic, retain) UILabel *lblDate;
@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) UILabel *lblCommentsRating;

@end
