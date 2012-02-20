

#import <UIKit/UIKit.h>


@interface GTHeaderView : UIView {
	IBOutlet UIView * mainView;
	IBOutlet UIButton * btnShowHideAnimation;
	IBOutlet UILabel * lblGroupName;
	IBOutlet UIButton * btnShowGroupPopover;
	NSString *Rowstatus;
}
@property (assign) UIView * mainView;
@property (assign) UIButton * btnShowHideAnimation;
@property (assign) UILabel * lblGroupName;
@property (assign) UIButton * btnShowGroupPopover;
@property (nonatomic,retain) NSString * Rowstatus;

+ (id)headerViewWithTitle:(NSString*)title section:(NSInteger)Section Expanded:(NSString *)Rowstatus;


@end
