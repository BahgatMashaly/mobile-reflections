//
//  ImageNoteView.h
//  MobileReflections
//
//  Created by SonNT on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageNoteView : UIImageView
{
	CGPoint startLocation;
	CGSize originalSize;
	CGAffineTransform originalTransform;
    CFMutableDictionaryRef touchBeginPoints;
	
	UIButton *btnOK;
	UIButton *btnDelete;
}

@end
