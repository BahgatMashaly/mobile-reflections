//
//  BackgroundNoteViewController.h
//  MobileJabber
//
//  Created by Phan Ba Minh on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundNoteViewController : UIViewController {
    UIImage                             *m_ImageInit;
    IBOutlet UIImageView                *m_ImageViewBackground;
}
- (id)initWithImage:(UIImage *)image;
- (UIImage *)getImageInit;
@end
