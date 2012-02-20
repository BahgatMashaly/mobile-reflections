//
//  GroupPopoverTableDelegate.h
//  MobileJabber
//
//  Created by jigar shah on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GroupPopoverTableDelegate : NSObject <UITableViewDelegate> {
	NSArray *aryFields;
}
- (id)initWithArray:(NSArray*)ary;
@end
