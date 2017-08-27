//
//  MCCalendarTitleBarView.m
//  MCRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCCalendarTitleBarView.h"
#import "MCCalendarTitleDateView.h"
#import "NSDate+MCDateLogic.h"
#import "MCCalendarWeekdayView.h"

@interface MCCalendarTitleBarView () <MCCalendarTitleDateViewDelegate>

@property (nonatomic, weak) IBOutlet MCCalendarTitleDateView *titleDateView;
@property (nonatomic, weak) IBOutlet MCCalendarWeekdayView *weekdayView;

@end

@implementation MCCalendarTitleBarView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleDateView.delegate = self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"MCCalendarTitleBarView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)setupWithDate:(NSDate *)date
{
    NSInteger year = [date yearValue];
    NSInteger month = [date monthValue];
    
    [self.titleDateView setLabelWithYear:year month:month];
}

- (void)setTitleFontSize:(CGFloat)titleFontSize weekdayFontSize:(CGFloat)weekdayFontSize
{
    [self.titleDateView setTitleLabelFontSize:titleFontSize];
    [self.weekdayView setLabelsFontSize:weekdayFontSize];
}

#pragma mark - MCCalendarTitleDateViewDelegate

- (void)calendarTitleLeftButtonClicked
{
    [self.delegate titleBarLeftButtonClicked];
}

- (void)calendarTitleRightButtonClicked
{
    [self.delegate titleBarRightButtonClicked];
}

@end
