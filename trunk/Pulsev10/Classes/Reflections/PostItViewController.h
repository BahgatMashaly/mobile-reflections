//
//  PostItViewController.h
//  MobileJabber
//
//  Created by Nguyen Thanh Son on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostItViewController : UIViewController
{
	IBOutlet UIImageView *imgNoteBG;
	IBOutlet UITextView *txtContent;
	
	CGPoint touchStart;
}

@end
