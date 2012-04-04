//
//  EditReflectionViewController.m
//  MobileJabber
//
//  Created by Phan Ba Minh on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditReflectionViewController.h"
#import "Define.h"

@implementation EditReflectionViewController

- (id)initWithFrame:(CGRect)rect andArrayData:(NSMutableArray *)array {
    self = [super init];
    if (self) {
        // Custom initialization
        appDelegate = (MobileJabberAppDelegate *)[[UIApplication sharedApplication] delegate];
        viewIndex = 1000;
        
        m_RectFrame = rect;
        
        m_ArrayOldComponents = [array retain];
        m_ArrayNewComponents = [NSMutableArray new];
    }
    return self;
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    [self.view removeFromSuperview];
}

- (UIImage *)renderToSave
{
	UIGraphicsBeginImageContext(viewFreeEditor.frame.size);
	[viewFreeEditor.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return [newImage retain];
}

- (void)hideToolbars
{
	for (UIView *view in viewFreeEditor.subviews)
	{
		if ([view tag] > 1000)
		{
			if ([view tag] < 2000)
			{
				for (UIView *sub in view.subviews)
				{
					if ([sub isKindOfClass:[UIToolbar class]] == TRUE || [sub isKindOfClass:[UIImageView class]] == TRUE)
					{
						[sub setHidden:YES];
					}
				}
			}
			if ([view tag] > 2000 && [view tag] < 4000)
			{
				for (UIView *sub in view.subviews)
				{
					if ([sub isKindOfClass:[UIToolbar class]] == TRUE || ([sub isKindOfClass:[UIImageView class]] == TRUE && [sub tag] == -1))
					{
						[sub setHidden:YES];
					}
				}
			}
		}
	}
	
	if (paintnote_vc)
	{
		[paintnote_vc hideTools];
	}
}

- (void)saveObjectContent:(int)aReflection_id
{

}

- (void)editReflection:(int)aReflectionID
{
	isEditing = YES;
	
}

- (IBAction)clickSave:(id)sender
{

}

- (void)browsePhotoAlbum:(id)sender
{
	if (aPopover) [aPopover dismissPopoverAnimated:NO];
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
	aPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
	[aPopover setPopoverContentSize:picker.view.frame.size];
	[picker release];
	[aPopover setDelegate:self];
	[aPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	//[aPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
}

- (IBAction)clickText:(id)sender
{
	viewIndex = viewIndex + 1;
	CGRect frame = FRAME_REFLECTION_TEXT_NOTE;
    
	TextNoteViewController *vc = [[TextNoteViewController alloc] initWithNibName:@"TextNoteViewController" bundle:nil];
	[vc.view setFrame:frame];
	[vc.view setTag:viewIndex];
	[viewFreeEditor addSubview:vc.view];
	[vc.view release];
}

- (IBAction)clickPostIt:(id)sender
{
	viewIndex = viewIndex + 1;
	int vIndex = viewIndex + 4000;
	
	PostItViewController *vc = [[PostItViewController alloc] initWithNibName:@"PostItViewController" bundle:nil];
	[vc.view setTag:vIndex];
	[viewFreeEditor addSubview:vc.view];
    
    [m_ArrayNewComponents addObject:vc];
    
	[vc.view release];
}

- (IBAction)clickVoiceImport:(id)sender
{
	sourceType = 3;
}

- (IBAction)clickVideoImport:(id)sender
{
	sourceType = 2;
}

- (IBAction)clickChangeBackground:(id)sender
{
	sourceType = 4;
	[self browsePhotoAlbum:sender];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2)
	{
		CGPoint pos = [[touches anyObject] locationInView:self.view];
		
		int xOri = viewFreeEditor.frame.origin.x;
		int yOri = viewFreeEditor.frame.origin.y;
		int xPos = viewFreeEditor.frame.origin.x + viewFreeEditor.frame.size.width;
		int yPos = viewFreeEditor.frame.origin.y + viewFreeEditor.frame.size.height;
		int x = pos.x;
		int y = pos.y;
		
		if (x < xPos && y < yPos && x > xOri && y > yOri)
		{
			viewIndex = viewIndex + 1;
			CGRect frame = CGRectMake(x - 20, y - 90, 400, 300);
			
			TextNoteViewController *vc = [[TextNoteViewController alloc] initWithNibName:@"TextNoteViewController" bundle:nil];
			[vc.view setFrame:frame];
			[vc.view setTag:viewIndex];
			[viewFreeEditor addSubview:vc.view];
			[vc fixPosition];
			[vc.view release];
		}
	}
}

- (IBAction)clickImage:(id)sender
{
	sourceType = 0;
	[self browsePhotoAlbum:sender];
}

- (IBAction)clickCamera:(id)sender
{
	sourceType = 1;
    
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        picker.allowsEditing = NO;
		picker.delegate = self;
		
		[self presentModalViewController:picker animated:YES];
        [picker release];
	}
	else [common alertCameraNotSupport];
}

- (void)deletePaintview
{
	[paintnote_vc.view removeFromSuperview];
	[paintnote_vc release];
	paintnote_vc = nil;
}

- (IBAction)clickPen:(id)sender
{
	if (!paintnote_vc)
	{
		paintnote_vc = [[PaintNoteViewController alloc] initWithNibName:@"PaintNoteViewController" bundle:nil];
		[paintnote_vc setMyDelegate:self];
		[viewFreeEditor addSubview:paintnote_vc.view];
	}
	else
	{
		[viewFreeEditor bringSubviewToFront:paintnote_vc.view];
		[paintnote_vc showTools];
	}
}

- (IBAction)clickClearAll:(id)sender
{
	[self deletePaintview];
	
	for (UIView *view in viewFreeEditor.subviews)
	{
		if ([view tag] > 1000)
		{
			[view removeFromSuperview];
			viewIndex = viewIndex - 1;
		}
	}
}

- (IBAction)clickPrivate:(id)sender
{
	isPrivate =!isPrivate;
	if (isPrivate)
	{
		[btnPrivate setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateNormal];
		[btnPrivate setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlEventTouchUpInside];
	}
	else
	{
		[btnPrivate setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
		[btnPrivate setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlEventTouchUpInside];
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)dealloc
{
	if (paintnote_vc) [self deletePaintview];
    
    RELEASE_SAFE(m_ArrayOldComponents);
    RELEASE_SAFE(m_ArrayNewComponents);
    
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (UIViewController *mem in m_ArrayOldComponents) {
        NSLog(@"mem: %@", [[mem class] description]);
        LOG_RETAIN_COUNT(mem);
        
        if ([[[mem class] description] isEqualToString:[ARRAY_STRING_COMPONENTS objectAtIndex:ENUM_INDEX_REFLECTION_DATA_COMPONENTS_MEMBER_PAINT_NOTE]]) {
            [viewFreeEditor addSubview:mem.view];
        }
        else if ([[[mem class] description] isEqualToString:[ARRAY_STRING_COMPONENTS objectAtIndex:ENUM_INDEX_REFLECTION_DATA_COMPONENTS_MEMBER_POST_IT]]) {
            viewIndex = viewIndex + 1;
            int vIndex = viewIndex + 4000;
            
            PostItViewController *postItVC = [[PostItViewController alloc] initWithText:[(PostItViewController *)mem getText]];
            [postItVC.view setTag:vIndex];
            postItVC.view.frame = mem.view.frame;
            [viewFreeEditor addSubview:postItVC.view];
            
            [m_ArrayNewComponents addObject:postItVC];
            
            [viewFreeEditor addSubview:postItVC.view];
            RELEASE_SAFE(postItVC);
        }
        else if ([[[mem class] description] isEqualToString:[ARRAY_STRING_COMPONENTS objectAtIndex:ENUM_INDEX_REFLECTION_DATA_COMPONENTS_MEMBER_TEXT_NOTE]]) {
            viewIndex = viewIndex + 1;
            TextNoteViewController *tempVC = (TextNoteViewController *)mem;
            TextNoteViewController *textNoteVC = [[TextNoteViewController alloc] initWithTextView:tempVC.txtContent];
            [textNoteVC.view setFrame:mem.view.frame];
            [textNoteVC.view setTag:viewIndex];
            
            [m_ArrayNewComponents addObject:textNoteVC];
            
            [viewFreeEditor addSubview:textNoteVC.view];
            RELEASE_SAFE(textNoteVC);
        }
        else { 
            [viewFreeEditor addSubview:mem.view];
        }
    }
    
    self.view.frame = m_RectFrame;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)addPhotoNoteVC:(int)vIndex imgSource:(UIImage *)imgSource
{
	PhotoNoteViewController *vc = [[PhotoNoteViewController alloc] initWithNibName:@"PhotoNoteViewController" bundle:nil];
	[vc.view setTag:vIndex];
	[viewFreeEditor addSubview:vc.view];
	[vc setSource:imgSource];
	[vc.view release];
}

- (void)deleteBackground
{
	for (UIView *view in viewFreeEditor.subviews)
	{
		if ([view tag] > 4000)
		{
			[view removeFromSuperview];
			viewIndex = viewIndex - 1;
		}
	}
}

- (void)addBackground:(int)vIndex imgSource:(UIImage *)imgSource
{
	[self deleteBackground];
    
	UIImageView *img = [[UIImageView alloc] initWithImage:imgSource];
	[img setTag:vIndex];
	[img setFrame:[viewFreeEditor bounds]];
	[viewFreeEditor addSubview:img];
	[viewFreeEditor sendSubviewToBack:img];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//sourceType : 0=PhotoAlbum, 1=Camera, 2=video, 3=voice, 4=background
	viewIndex = viewIndex + 1;
	int vIndex = 0;
	
	if (sourceType == 0 || sourceType == 1)
	{
		vIndex = viewIndex + 1000;
		[self addPhotoNoteVC:vIndex imgSource:[info objectForKey:UIImagePickerControllerOriginalImage]];
	}
	else if(sourceType == 4)
	{
		vIndex = viewIndex + (1000 * 4);
		[self addBackground:vIndex imgSource:[info objectForKey:UIImagePickerControllerOriginalImage]];
	}
	else if(sourceType == 2)
	{
		
	}
	
	[aPopover dismissPopoverAnimated:NO];
}

@end
