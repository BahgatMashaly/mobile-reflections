//
//  ReflectionPopoverViewController.h
//  MobileJabber
//
//  Created by Phan Ba Minh on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEIGHT_REFLECTION_POPOVER_CELL                  50
@protocol ReflectionPopoverViewControllerProtocol <NSObject>
- (void)didSelectReflectionPopoeverCellOfArray:(NSMutableArray *)arrayData atIndex:(NSIndexPath *)indexPath;
@end

@interface ReflectionPopoverViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView                    *m_TableView;
    
    NSMutableArray                          *m_ArrayData;
    id<ReflectionPopoverViewControllerProtocol>                                      m_Delegate;
}
- (id)initWithData:(NSMutableArray *)arrayData andDelegate:(id)delegate;
@end
