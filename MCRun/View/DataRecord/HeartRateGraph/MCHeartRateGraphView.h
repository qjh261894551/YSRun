//
//  MCHeartRateGraphView.h
//  MCRun
//
//  Created by moshuqi on 15/11/25.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCHeartRateGraphViewDelegate <NSObject>

@optional
- (void)tapHelpFromPoint:(CGPoint)point;

@end

@interface MCHeartRateGraphView : UIView

@property (nonatomic, weak) id<MCHeartRateGraphViewDelegate> delegate;

- (void)setupWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime dictDataArray:(NSArray *)dictDataArray;

@end
