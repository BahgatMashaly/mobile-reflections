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

- (id)initWithFrame:(CGRect)rect andArrayData:(NSMutableArray *)array andTitle:(NSString *)strTitle andDelegate:(id)delegate atIndex:(NSIndexPath *)indexPath {
    self = [super init];
    if (self) {
        // Custom initialization
        appDelegate = (MobileJabberAppDelegate *)[[UIApplication sharedApplication] delegate];
        m_RectFrame = rect;
        m_IndexPath = [indexPath retain];
        m_Delegate = delegate;
        m_Title = [strTitle retain];
        
        m_ArrayOldComponents = [[NSMutableArray alloc] initWithArray:array];
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

- (void)editReflection:(int)aReflectionID
{
	isEditing = YES;
	
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
    
    self.view.frame = FRAME(0, 0, HEIGHT_IPAD, WIDTH_IPAD - HEIGHT_STATUS_BAR);self.view.frame = FRAME(0, 0, HEIGHT_IPAD, WIDTH_IPAD - HEIGHT_STATUS_BAR);
	NSArray *arrObject = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:max], [txtTitle text], imagePath, [NSNumber numberWithBool:isPrivate], aDate, [appDelegate strUserName], [NSMutableArray arrayWithArray:m_ArrayNewComponents], nil];
    
	[[[appDelegate objOutput] arrReflectionList] replaceObjectAtIndex:m_IndexPath.row withObject:arrObject];
	if ([m_Delegate respondsToSelector:@selector(reloadReflectionListAtIndex:)]) {
        [m_Delegate reloadReflectionListAtIndex:m_IndexPath];
    }

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

- (void)addNewComponentView:(UIView *)view {
    self.view.frame = FRAME(0, 0, HEIGHT_IPAD, WIDTH_IPAD - HEIGHT_STATUS_BAR);
    [viewFreeEditor addSubview:view];
    self.view.frame = m_RectFrame;
}

- (IBAction)clickText:(id)sender
{
	CGRect frame = FRAME_REFLECTION_TEXT_NOTE;
    
	TextNoteViewController *vc = [TextNoteViewController new];
	[vc.view setFrame:frame];
	[self addNewComponentView:vc.view];
    
    [m_ArrayNewComponents addObject:vc];
    
	[vc.view release];
}

- (IBAction)clickPostIt:(id)sender
{
	PostItViewController *vc = [PostItViewController new];
	[self addNewComponentView:vc.view];
    
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
			CGRect frame = CGRectMake(x - 20, y - 90, 400, 300);
			
			TextNoteViewController *vc = [TextNoteViewController new];
			[vc.view setFrame:frame];
			[vc fixPosition];
            [self addNewComponentView:vc.view];
            
            [m_ArrayNewComponents addObject:vc];
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
		[self addNewComponentView:paintnote_vc.view];
        
        [m_ArrayNewComponents addObject:paintnote_vc];
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
    
    self.view.frame = FRAME(0, 0, HEIGHT_IPAD, WIDTH_IPAD - HEIGHT_STATUS_BAR);
    [self loadViewWithOldArray];
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

- (void)dealloc {
	if (paintnote_vc) [self deletePaintview];
    
    [m_ArrayNewComponents removeAllObjects];
    [m_ArrayOldComponents removeAllObjects];
    RELEASE_SAFE(m_ArrayOldComponents);
    RELEASE_SAFE(m_ArrayNewComponents);
    RELEASE_SAFE(m_IndexPath);
    RELEASE_SAFE(m_Title);
    
	[super dealloc];
}

- (void)loadViewWithOldArray {
    [m_ArrayNewComponents removeAllObjects];
    
    for (UIViewController *mem in m_ArrayOldComponents) {
        NSLog(@"mem: %@", [[mem class] description]);
        LOG_RETAIN_COUNT(mem);
        
        if ([[[mem class] description] isEqualToString:[ARRAY_STRING_COMPONENTS objectAtIndex:ENUM_INDEX_REFLECTION_DATA_COMPONENTS_MEMBER_PAINT_NOTE]]) {
            RELEASE_SAFE(paintnote_vc);
            paintnote_vc = [[PaintNoteViewController alloc] initWithImageView:[(PaintNoteViewController *)mem getImageViewDrawing]];
            [paintnote_vc setMyDelegate:self];
            [viewFreeEditor addSubview:paintnote_vc.view];
            
            [m_ArrayNewComponents addObject:paintnote_vc];
        }
        else if ([[mem.class description] isEqualToString:[ARRAY_STRING_COMPONENTS objectAtIndex:ENUM_INDEX_REFLECTION_DATA_COMPONENTS_MEMBER_BACKGROUND_NOTE]]) {
            BackgroundNoteViewController *bgNoteVC = [[BackgroundNoteViewController alloc] initWithImage:[(BackgroundNoteViewController *)mem getImageInit]];
            [viewFreeEditor addSubview:bgNoteVC.view];
            [viewFreeEditor sendSubviewToBack:bgNoteVC.view];
            
            [m_ArrayNewComponents addObject:bgNoteVC];
            
            RELEASE_SAFE(bgNoteVC)
        }
        else if ([[[mem class] description] isEqualToString:[ARRAY_STRING_COMPONENTS objectAtIndex:ENUM_INDEX_REFLECTION_DATA_COMPONENTS_MEMBER_PHOTO_NOTE]]) {
            PhotoNoteViewController *photoNoteVC = [PhotoNoteViewController new];
            photoNoteVC.view.frame = mem.view.frame;
            [viewFreeEditor addSubview:photoNoteVC.view];
            [photoNoteVC setSource:[(PhotoNoteViewController *)mem getSource]];
            
            [m_ArrayNewComponents addObject:photoNoteVC];
            
            RELEASE_SAFE(photoNoteVC);
        }
        else if ([[[mem class] description] isEqualToString:[ARRAY_STRING_COMPONENTS objectAtIndex:ENUM_INDEX_REFLECTION_DATA_COMPONENTS_MEMBER_POST_IT]]) {
            PostItViewController *postItVC = [[PostItViewController alloc] initWithText:[(PostItViewController *)mem getText]];
            postItVC.view.frame = mem.view.frame;
            [viewFreeEditor addSubview:postItVC.view];
            
            [m_ArrayNewComponents addObject:postItVC];
            
            [viewFreeEditor addSubview:postItVC.view];
            RELEASE_SAFE(postItVC);
        }
        else if ([[[mem class] description] isEqualToString:[ARRAY_STRING_COMPONENTS objectAtIndex:ENUM_INDEX_REFLECTION_DATA_COMPONENTS_MEMBER_TEXT_NOTE]]) {
            TextNoteViewController *textNoteVC = [[TextNoteViewController alloc] initWithTextView:((TextNoteViewController *)mem).txtContent];
            [textNoteVC.view setFrame:mem.view.frame];
            
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadViewWithOldArray];
    txtTitle.text = m_Title;
}

- (void)viewDidUnload {
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
	PhotoNoteViewController *vc = [PhotoNoteViewController new];
	[vc.view setTag:vIndex];
	[self addNewComponentView:vc.view];
	[vc setSource:imgSource];
	
    [m_ArrayNewComponents addObject:vc];
    
    RELEASE_SAFE(vc);
}

- (void)deleteBackground
{
	for (UIViewController *viewController in m_ArrayNewComponents)
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
        [self addNewComponentView:photoNoteVC.view];
        [photoNoteVC setSource:[info objectForKey:UIImagePickerControllerOriginalImage]];
        
        [m_ArrayNewComponents addObject:photoNoteVC];
        
        RELEASE_SAFE(photoNoteVC);
	}
	else if(sourceType == 4)
	{
        [self deleteBackground];
        
        BackgroundNoteViewController *bgNoteVC = [[BackgroundNoteViewController alloc] initWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        [self addNewComponentView:bgNoteVC.view];
        [viewFreeEditor sendSubviewToBack:bgNoteVC.view];
        
        [m_ArrayNewComponents addObject:bgNoteVC];
        
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
