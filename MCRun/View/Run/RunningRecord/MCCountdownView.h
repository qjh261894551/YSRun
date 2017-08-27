//
//  MCCountdownView.h
//  MCRun
//
//  Created by moshuqi on 15/10/23.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCCountdownViewDelegate <NSObject>

- (void)countdownFinish;

@end

@interface MCCountdownView : UIView

@property (nonatomic, weak) id<MCCountdownViewDelegate> delegate;

- (void)startCountdownWithTime:(NSInteger)time;
- (void)startAnimationCountdownWithTime:(NSInteger)time;

@end
