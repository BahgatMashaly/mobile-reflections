//
//  VMImagePickerController.m
//  Makeup
//
//  Created by MinhPB on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VMImagePickerController.h"


@implementation VMImagePickerController
@synthesize selectedImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    selectedImage = (UIImage*) [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    selectedImage = (UIImage*) [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
    [picker.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void) dealloc{
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.selectedImage = nil;
}

@end
