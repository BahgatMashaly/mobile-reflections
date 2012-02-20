//
//  VMImagePickerController.h
//  Makeup
//
//  Created by MinhPB on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface VMImagePickerController : UIImagePickerController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImage *selectedImage;
}
@property (nonatomic, assign) UIImage *selectedImage;
@end
