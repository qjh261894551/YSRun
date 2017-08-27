//
//  MCCalendarRecordView.m
//  MCRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCCalendarRecordView.h"
#import "MCCalendarTitleBarView.h"
#import "NSDate+MCDateLogic.h"
#import "MCAppMacro.h"
#import "MCCalendar.h"
#import "MCDevice.h"

#define CalendarReuseIdentifier @"CalendarReuseIdentifier"

@interface MCCalendarRecordView () <MCCalendarTitleBarViewDelegate, MCCalendarDelegate>

@property (nonatomic, weak) IBOutlet MCCalendarTitleBarView *titleBarView;
@property (nonatomic, weak) IBOutlet MCCalendar *calendar;

@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *titleBarHeightContraint;

@end

const CGFloat kMinimumInteritemSpacing = 0;
const CGFloat kMinimumLineSpacing = 1;

@implementation MCCalendarRecordView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleBarView.delegate = self;
    
    self.calendar.delegate = self;
    [self.titleBarView setupWithDate:[NSDate date]];
    
    if ([MCDevice isPhone6Plus])
    {
        // 6p尺寸适配
        self.titleBarHeightContraint.constant = 68;
        [self.titleBarView setTitleFontSize:24 weekdayFontSize:15];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"MCCalendarRecordView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = GreenBackgroundColor;
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)resetCalendarFrame
{
    [self.calendar resetSubviewFrame];
//    [self bringSubviewToFront:self.calendar];
}

- (void)toLastMonth
{
    // 日历跳到上一个月
    
    [self.calendar slideToLastMonth];
}

- (void)toNextMonth
{
    // 日历跳到下一个月
    
    [self.calendar slideToNextMonth];
}

- (void)resetCalendarWithDate:(NSDate *)date
{
    self.currentDate = date;
    
    [self.calendar resetCalanderWithDate:date];
    [self.titleBarView setupWithDate:date];
}

#pragma mark - MCCalendarTitleBarViewDelegate

- (void)titleBarLeftButtonClicked
{
    [self toLastMonth];
}

- (void)titleBarRightButtonClicked
{
    [self toNextMonth];
}

#pragma mark - MCCalendarDelegate

- (void)calendarSlideFinishWithDisplayDate:(NSDate *)displayDate
{
    [self.titleBarView setupWithDate:displayDate];
}

- (void)calendarDidSelectedDate:(NSDate *)date
{
    [self.delegate calendarRecordDidSelectedDate:date];
}

@end
