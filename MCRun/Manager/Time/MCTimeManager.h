//
//  MCTimeManager.h
//  MCRun
//
//  Created by moshuqi on 15/10/20.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MCTimeManagerDelegate <NSObject>

- (void)tickWithAccumulatedTime:(NSUInteger)time;

@end

@interface MCTimeManager : NSObject

@property (nonatomic, weak) id<MCTimeManagerDelegate> delegate;

- (void)start;
- (void)pause;
//- (void)stop;
- (NSUInteger)getTotalTime;
- (NSUInteger)currentAccumulatedTime;

@end
