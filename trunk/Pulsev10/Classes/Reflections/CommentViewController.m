//
//  CommentViewController.m
//  MobileJabber
//
//  Created by SonNT on 12/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CommentViewController.h"

@implementation CommentViewController
@synthesize arrComment;

- (IBAction)clickBack:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)clickAdd:(id)sender
{
	AddCommentViewController *vc = [[AddCommentViewController alloc] initWithNibName:@"AddCommentViewController" bundle:nil];
	[self presentModalViewController:vc animated:YES];
	[vc setReflectionID:reflection_id];
	[vc release];
}

- (IBAction)clickEdit:(id)sender
{
	
}

- (void)setReflectionID:(int)aValue
{
	reflection_id = aValue;
}

- (void)getCommentList
{
	if (reflection_id > 0)
	{
		int count = [[[appDelegate objOutput] arrCommentList] count];
		if (count > 0)
		{
			[arrComment removeAllObjects];

			for (int i = 0; i < count; i++)
			{
				NSArray *item = [[[appDelegate objOutput] arrCommentList] objectAtIndex:i];
				if ([[item objectAtIndex:4] intValue] == reflection_id)
				{
					[arrComment addObject:item];
				}
			}
			
			[tblCommentList reloadData];
		}
		else [common alertCommentNotFound];
	}
	else [common alertChooseReflection];
}

#pragma mark - View lifecycle

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

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:NO];

	[self getCommentList];
	[tblCommentList reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	appDelegate = (MobileJabberAppDelegate *)[[UIApplication sharedApplication] delegate];
	arrComment = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	[arrComment release];
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return(interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

#pragma mark -
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Comments List";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [arrComment count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (UIImage *)getUserImage:(NSString *)userid
{
	XMPPJID *jid = [XMPPJID jidWithString:userid];
	NSData *photoData = [[appDelegate xmppvCardAvatarModule] photoDataForJID:jid];
	
	if(photoData != nil)
	{
		if([photoData length] > 0)
		{
			return [UIImage imageWithData:photoData];
		}
	}
	
	// If nothing then
	NSString *role = [appDelegate findUserRole:userid];
	if ([role isEqualToString:@"Teacher"] || [role isEqualToString:@"Instructor"])
	{
		return INSTRUCTOR_IMAGE;            
	}
	else
	{
		return STUDENT_IMAGE;                        
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
		cell = [[[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	//save to arrCommentList : id, title, content, date, reflection_id, user_id
	
	NSArray *item = [arrComment objectAtIndex:[indexPath row]];
    
	//[cell.imgUserPicture setImage:[self getUserImage:[[[item objectAtIndex:5] componentsSeparatedByString:@"@"] objectAtIndex:0]]];
	[cell.imgUserPicture setImage:[self getUserImage:[item objectAtIndex:5]]];
	[cell.lblTitle setText:[item objectAtIndex:1]];
	[cell.lblDate setText:[item objectAtIndex:3]];
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *item = [arrComment objectAtIndex:[indexPath row]];
	comment_id = [[item objectAtIndex:0] intValue];
	
	[lblTitleOfComment setText:[item objectAtIndex:1]];
	[lblDateOfComment setText:[item objectAtIndex:3]];
	[txtCommentContent setText:[item objectAtIndex:2]];
}

@end
