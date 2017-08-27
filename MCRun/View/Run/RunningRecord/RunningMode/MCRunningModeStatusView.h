//
//  MCRunningModeStatusView.h
//  MCRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, MCRunningModeType)
//{
//    MCRunningModeTypeGeneral = 1,   // 地图模式
//    MCRunningModeTypeMap            // 普通模式
//};

@protocol MCRunningModeStatusViewDelegate <NSObject>

- (void)modeStatusChange;

@end

@interface MCRunningModeStatusView : UIView

@property (nonatomic, weak) id<MCRunningModeStatusViewDelegate> delegate;

- (void)setModeIconWithImage:(UIImage *)image modeName:(NSString *)name;

@end
