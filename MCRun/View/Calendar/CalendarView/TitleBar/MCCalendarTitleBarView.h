//
//  MCCalendarTitleBarView.h
//  MCRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCCalendarTitleBarViewDelegate <NSObject>

@required
- (void)titleBarLeftButtonClicked;
- (void)titleBarRightButtonClicked;

@end

@interface MCCalendarTitleBarView : UIView

@property (nonatomic, weak) id<MCCalendarTitleBarViewDelegate> delegate;

- (void)setupWithDate:(NSDate *)date;
- (void)setTitleFontSize:(CGFloat)titleFontSize weekdayFontSize:(CGFloat)weekdayFontSize;

@end
