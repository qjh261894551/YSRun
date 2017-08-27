//
//  MCUserRecordView.h
//  MCRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MCBLEContentViewState) {
    MCBLEContentViewStateNone = -1,
    MCBLEContentViewStateDeviceConnect = 0,
    MCBLEContentViewStateConnecting = 1,
    MCBLEContentViewStateHeartRateCounting = 2,
};

@protocol MCUserRecordViewDelegate <NSObject>

@required
- (void)tapUserHead;
- (void)touchBLEConnectButton;

@end

@interface MCUserRecordView : UIView

@property (nonatomic, weak) id<MCUserRecordViewDelegate> delegate;

- (void)setUserName:(NSString *)userName
          headPhoto:(UIImage *)headPhoto
      totalDistance:(CGFloat)distance
      totalRunTimes:(NSInteger)runTimes
          totalTime:(NSInteger)time;

- (void)updateHeartRateWithValue:(NSInteger)heartRate;
- (void)setBLEContentWithState:(MCBLEContentViewState)state;
- (void)setBLEContentViewHidden:(BOOL)hidden;

@end
