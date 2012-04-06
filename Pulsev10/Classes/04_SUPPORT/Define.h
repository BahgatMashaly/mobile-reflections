/*
 * $URL: https://kidbaw@subversion.assembla.com/svn/mmobiledev/trunk/SwypeKeyboard/JSC_SWYPE/04_SUPPORT/Define.h $
 * $Author: kidbaw $
 * $Revision: 79 $
 * $Date: 2012-03-28 17:07:08 +0700 (Wed, 28 Mar 2012) $
 *
 * ====================================================================
 *
 * Copyright (C) 2012 by MMobileDev.com
 *
 * Minh Nguyen PROPRIETARY/CONFIDENTIAL PROPERTIES. Use is subject to license terms.
 * You CANNOT use this software unless you receive a written permission from MMobileDev.com
 */

#import "SupportFunction.h"

#define TIMER_DISPLAY_TITLE_SCREEN                                          3.5
#define TIMER_MAIN_LOOP                                                     0.1
#define TIMER_COUNT_DOWN_UNIT                                               1
#define TIMER_SEC_PER_MINUTE                                                60
#define TIMER_REQUEST_TIMEOUT                                               10
#define TIMER_CHANGING_VIEW                                                 0.4

#define RGBCOLOR(r, g, b)             [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)         [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)/255.0f]

#define RELEASE_SAFE(p)                                 { if (p) { [(p) release]; (p) = nil;  } }

#define LOG_RETAIN_COUNT(a)                             NSLog(@"LOG_RETAIN_COUNT: %i", [a retainCount]);
#define LOG(a)                                          NSLog(@"LOG: %@", a);


#define IS_IPAD                                         [SupportFunction deviceIsIPad]

#define HEIGHT_IPHONE                                                       480
#define WIDTH_IPHONE                                                        320
#define HEIGHT_IPAD                                                         1024 
#define WIDTH_IPAD                                                          768
#define HEIGHT_STATUS_BAR                                                   20
#define HEIGHT_TOOL_BAR                                                     44
#define HEIGHT_AD_BANNER                                                    49
#define HEIGHT_TAB_BAR                                                      49

#define HEIGHT_IPHONE_KEYBOARD                                              216
#define HEIGHT_IPHONE_KEYBOARD_LANDSCAPE                                    162
#define HEIGHT_IPAD_KEYBOARD                                                264
#define HEIGHT_IPAD_KEYBOARD_LANDSCAPE                                      352

#define FRAME(a,b,c,d)                          CGRectMake(a, b, c, d)
#define FRAME_MAIN(view)                        FRAME(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
#define FRAME_RIGHT(view, dis)                  FRAME(dis, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
#define FRAME_LEFT(view, dis)                   FRAME(-dis, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
#define FRAME_TOP(view, dis)                    FRAME(view.frame.origin.x, -dis, view.frame.size.width, view.frame.size.height)
#define FRAME_BOTTOM(view, dis)                 FRAME(view.frame.origin.x, dis, view.frame.size.width, view.frame.size.height)
#define FRAME_REFLECTION_TEXT_NOTE              FRAME(100, 100, 330, 250)
typedef enum 
{
    ENUM_INDEX_REFLECTION_DATA_MAX,
    ENUM_INDEX_REFLECTION_DATA_TITILE,
    ENUM_INDEX_REFLECTION_DATA_IMAGE,
    ENUM_INDEX_REFLECTION_DATA_IS_PRIVATE,
    ENUM_INDEX_REFLECTION_DATA_DATE,
    ENUM_INDEX_REFLECTION_DATA_USER_NAME,
    ENUM_INDEX_REFLECTION_DATA_COMPONENTS
}ENUM_INDEX_REFLECTION_DATA;

#define ARRAY_STRING_COMPONENTS                 [NSArray arrayWithObjects:@"PostItViewController", @"TextNoteViewController", @"PaintNoteViewController", @"PhotoNoteViewController", @"BackgroundNoteViewController", nil]
typedef enum 
{
    ENUM_INDEX_REFLECTION_DATA_COMPONENTS_MEMBER_POST_IT,
    ENUM_INDEX_REFLECTION_DATA_COMPONENTS_MEMBER_TEXT_NOTE,
    ENUM_INDEX_REFLECTION_DATA_COMPONENTS_MEMBER_PAINT_NOTE,
    ENUM_INDEX_REFLECTION_DATA_COMPONENTS_MEMBER_PHOTO_NOTE,
    ENUM_INDEX_REFLECTION_DATA_COMPONENTS_MEMBER_BACKGROUND_NOTE
}ENUM_INDEX_REFLECTION_DATA_COMPONENTS_MEMBER;

@protocol AppViewControllerProtocol <NSObject>
- (void)update;
@end
