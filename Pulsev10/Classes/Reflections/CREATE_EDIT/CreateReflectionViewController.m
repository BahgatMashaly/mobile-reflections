//
//  CreateReflectionViewController.m
//  MobileReflections
//
//  Created by SonNT on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateReflectionViewController.h"
#import "Define.h"
#import "BackgroundNoteViewController.h"

@implementation CreateReflectionViewController

- (UIImage *)renderToSave
{
	UIGraphicsBeginImageContext(viewFreeEditor.frame.size);
	[viewFreeEditor.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return [newImage retain];
}

- (IBAction)clickCancel:(id)sender
{
	[self dismissModalViewControllerAnimated:NO];
}

- (IBAction)clickSave:(id)sender
{
	UIImage *img = [self renderToSave];
	
	//save image to docDir
	NSString *imagePath = @"";
	if ([img isKindOfClass:[UIImage class]])
	{
		NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		imagePath = [NSString stringWithFormat:@"%@/img_%@.png",docDir, [NSDate date]];
		
		NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(img)];
		[data1 writeToFile:imagePath atomically:YES];
		//NSLog(@"image path : %@", imagePath);
	}
	
	//save to arrReflectionList : id, title, image, private, date, user_id
	NSDate *date = [NSDate date];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"EEEE MMMM d, YYYY"]; //example : Saturday November 22, 2008
	NSString *aDate = [dateFormat stringFromDate:date];  
	[dateFormat release];

	int max = [common findMax:[[appDelegate objOutput] arrReflectionList]] + 1;
	NSArray *arrObject = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:max], [txtTitle text], imagePath, [NSNumber numberWithBool:isPrivate], aDate, [appDelegate strUserName], [NSMutableArray arrayWithArray:m_ArrayComponents], nil];
	[[[appDelegate objOutput] arrReflectionList] addObject:arrObject];
	

	[self dismissModalViewControllerAnimated:NO];
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
	CGRect frame = FRAME_REFLECTION_TEXT_NOTE;

	TextNoteViewController *vc = [TextNoteViewController new];
	[vc.view setFrame:frame];
	[viewFreeEditor addSubview:vc.view];
    
    [m_ArrayComponents addObject:vc];
    
	RELEASE_SAFE(vc);
}

- (IBAction)clickPostIt:(id)sender
{
	PostItViewController *vc = [PostItViewController new];
	[viewFreeEditor addSubview:vc.view];
    
    [m_ArrayComponents addObject:vc];

	RELEASE_SAFE(vc);
}

- (IBAction)clickVoiceImport:(id)sender
{
	sourceType = 3;
    if (aPopover) [aPopover dismissPopoverAnimated:NO];
	
	m_ReflectionPopoverVC = [[ReflectionPopoverViewController alloc] initWithData:[NSMutableArray array] andDelegate:self];
	
	aPopover = [[UIPopoverController alloc] initWithContentViewController:m_ReflectionPopoverVC];
	[aPopover setPopoverContentSize:m_ReflectionPopoverVC.view.frame.size];
    RELEASE_SAFE(m_ReflectionPopoverVC);
    
	[aPopover setDelegate:self];
	[aPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)clickVideoImport:(id)sender
{
	sourceType = 2;
    if (aPopover) [aPopover dismissPopoverAnimated:NO];
	
	m_ReflectionPopoverVC = [[ReflectionPopoverViewController alloc] initWithData:[NSMutableArray array] andDelegate:self];
	
	aPopover = [[UIPopoverController alloc] initWithContentViewController:m_ReflectionPopoverVC];
	[aPopover setPopoverContentSize:m_ReflectionPopoverVC.view.frame.size];
    RELEASE_SAFE(m_ReflectionPopoverVC);
    
	[aPopover setDelegate:self];
	[aPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
			CGRect frame = CGRectMake(x - 20, y - 90, 400, 300);
			
			TextNoteViewController *vc = [TextNoteViewController new];
			[vc.view setFrame:frame];
			[viewFreeEditor addSubview:vc.view];
			[vc fixPosition];
            
            [m_ArrayComponents addObject:vc];
            
            RELEASE_SAFE(vc);
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
		paintnote_vc = [PaintNoteViewController new];
		[paintnote_vc setMyDelegate:self];
		[viewFreeEditor addSubview:paintnote_vc.view];
        
        [m_ArrayComponents addObject:paintnote_vc];
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
		[view removeFromSuperview];
	}
    
    [m_ArrayComponents removeAllObjects];
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
        m_ArrayComponents = [NSMutableArray new];
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
    
    [m_ArrayComponents removeAllObjects];
    RELEASE_SAFE(m_ArrayComponents);
    
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	appDelegate = (MobileJabberAppDelegate *)[[UIApplication sharedApplication] delegate];
    [txtTitle becomeFirstResponder];
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

- (void)deleteBackground
{
	for (UIViewController *viewController in m_ArrayComponents)
	{
        if ([[viewController.class description] isEqualToString:[ARRAY_STRING_COMPONENTS objectAtIndex:ENUM_INDEX_REFLECTION_DATA_COMPONENTS_MEMBER_BACKGROUND_NOTE]]) {
            [viewController.view removeFromSuperview];
        }
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//sourceType : 0=PhotoAlbum, 1=Camera, 2=video, 3=voice, 4=background
	if (sourceType == 0 || sourceType == 1)
	{
        PhotoNoteViewController *photoNoteVC = [PhotoNoteViewController new];
        [viewFreeEditor addSubview:photoNoteVC.view];
        [photoNoteVC setSource:[info objectForKey:UIImagePickerControllerOriginalImage]];
        
        [m_ArrayComponents addObject:photoNoteVC];
        
        RELEASE_SAFE(photoNoteVC);
	}
	else if(sourceType == 4)
	{
        [self deleteBackground];
        
        BackgroundNoteViewController *bgNoteVC = [[BackgroundNoteViewController alloc] initWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        [viewFreeEditor addSubview:bgNoteVC.view];
        [viewFreeEditor sendSubviewToBack:bgNoteVC.view];
        
        [m_ArrayComponents addObject:bgNoteVC];
        
        RELEASE_SAFE(bgNoteVC)
	}
	else if(sourceType == 2)
	{
		
	}
	
	[aPopover dismissPopoverAnimated:NO];
}

#pragma mark - Reflection Popover View Controller Protocol

- (void)didSelectReflectionPopoeverCellOfArray:(NSMutableArray *)arrayData atIndex:(NSIndexPath *)indexPath {
    
}

@end
