//
//  MCCalendarDayItem.h
//  MCRun
//
//  Created by moshuqi on 15/11/2.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCCalendarDayItemDelegate <NSObject>

- (void)touchDayItemWithDay:(NSInteger)day;

@end

@class MCDayItemModel;

@interface MCCalendarDayItem : UIView

@property (nonatomic, weak) id<MCCalendarDayItemDelegate> delegate;

- (void)setupWithDayItemModel:(MCDayItemModel *)dayItemModel;

@end
