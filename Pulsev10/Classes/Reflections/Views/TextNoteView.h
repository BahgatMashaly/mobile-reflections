//
//  TextNoteView.h
//  MobileReflections
//
//  Created by SonNT on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextNoteView : UIView
{
	UITextView *txtContent;

	UILabel *lblBackground;
	UIImageView *imgScalable;
	UIButton *btnOK;
	UIButton *btnDelete;
	
	CGPoint touchStart;
	BOOL isResizing;
}

@end
