
#import "GTHeaderView.h"


@implementation GTHeaderView

@synthesize btnShowHideAnimation, lblGroupName, btnShowGroupPopover,Rowstatus,mainView;

+ (id)headerViewWithTitle:(NSString*)title section:(NSInteger)Section Expanded:(NSString *)rowstatus{
	GTHeaderView *headerView = [[GTHeaderView alloc] init];
	[headerView.lblGroupName setText:title];
    @try {
        NSMutableArray *ary = ((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactListExpandValue;
        if ([[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactListExpandValue objectAtIndex:Section] isEqualToString:@"YES"]) {
            [headerView.btnShowHideAnimation setImage:[UIImage imageNamed:@"arrow down.png"] forState:UIControlStateNormal];
        }
        else {
            [headerView.btnShowHideAnimation setImage:[UIImage imageNamed:@"arrow up.png"] forState:UIControlStateNormal];
        }
    }
    @catch (NSException *exc) {
        [headerView.btnShowHideAnimation setImage:[UIImage imageNamed:@"arrow up.png"] forState:UIControlStateNormal];        
    }
	[headerView.btnShowHideAnimation setTag:Section];
	[headerView.btnShowHideAnimation addTarget:self action:@selector(btnShowHideAnimationTapped:) forControlEvents:UIControlEventTouchUpInside];
	headerView.Rowstatus=rowstatus;
	[headerView.btnShowGroupPopover setTag:Section];
	[headerView.btnShowGroupPopover addTarget:self action:@selector(btnShowGroupPopoverTapped:) forControlEvents:UIControlEventTouchUpInside];
	return [headerView autorelease];
}
- (id) init {
	self = [super initWithFrame:CGRectMake(0.0, 0.0, 285.0, 25.0)];
	if (self != nil) {
		[[NSBundle mainBundle] loadNibNamed:@"WTHeaderView" owner:self options:nil];
		[self addSubview:mainView];
	}
	return self;
}

+ (void)btnShowGroupPopoverTapped:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_SHOW_GROUP_OPTIONS object:sender];
}

+ (void)btnShowHideAnimationTapped:(UIButton*)sender {
	if ([[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactListExpandValue objectAtIndex:sender.tag] isEqualToString:@"NO"]) {
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactListExpandValue replaceObjectAtIndex:sender.tag withObject:@"YES"];
		[sender setImage:[UIImage imageNamed:@"arrow down.png"] forState:UIControlStateNormal];
	}
	else {
		[((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactListExpandValue replaceObjectAtIndex:sender.tag withObject:@"NO"];
		[sender setImage:[UIImage imageNamed:@"arrow up.png"] forState:UIControlStateNormal];
	}
	//NSLog(@"%@", [((MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate]).aryContactListExpandValue description]);
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CONTACTS object:nil];
}

@end
