//
//  MCCalendarRecordView.h
//  MCRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCCalendarRecordViewDelegate <NSObject>

@required
- (void)calendarRecordDidSelectedDate:(NSDate *)date;

@end

@interface MCCalendarRecordView : UIView

@property (nonatomic, weak) id<MCCalendarRecordViewDelegate> delegate;

- (void)resetCalendarWithDate:(NSDate *)date;
- (void)resetCalendarFrame;

@end
