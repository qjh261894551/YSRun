//
//  MCRunningModeView.h
//  MCRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCTimeLabel.h"
#import "MCSubscriptLabel.h"
#import "MCRunningModeStatusView.h"
#import "MCPulldownView.h"
#import "MCRunningModeDataView.h"

@protocol MCRunningModeViewDelegate <NSObject>

- (void)changeMode;
- (void)runningPause;
- (void)runningContinue;
- (void)runningFinish;

@optional
- (void)resetDistanceLabel:(CGFloat)distance;

@end

@interface MCRunningModeView : UIView

@property (nonatomic, strong) MCTimeLabel *timeLabel;
@property (nonatomic, strong) MCSubscriptLabel *distanceLabel;
@property (nonatomic, strong) MCSubscriptLabel *paceLabel;
@property (nonatomic, strong) MCSubscriptLabel *heartRateLabel;
@property (nonatomic, strong) MCRunningModeStatusView *modeStatusView;

@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) MCPulldownView *pulldownView;

@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) id<MCRunningModeViewDelegate> delegate;

@property (nonatomic, strong) MCRunningModeDataView *dataView;

- (void)resetLayoutWithFrame:(CGRect)frame;
- (void)resetButtonsPositionWithPauseStatus;
- (void)resetTimeLabelWithTime:(NSUInteger)time;

- (void)setDistance:(CGFloat)distance;
- (void)setPace:(CGFloat)pace;
- (void)setHeartRate:(NSInteger)heartRate;

- (void)setContentFontSize:(CGFloat)contentSize subscriptFontSize:(CGFloat)subscriptSize;
- (CGRect)timeLabelFrame;

- (void)setupLabelsAppearance;
- (void)setupButtonsAppearance;

@end
