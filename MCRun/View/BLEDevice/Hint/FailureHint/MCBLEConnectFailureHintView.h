//
//  MCBLEConnectFailureHintView.h
//  MCRun
//
//  Created by moshuqi on 15/11/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCBLEConnectFailureHintViewDelegate <NSObject>

- (void)connectFailureHintBack;
- (void)connectFailureHintClose;
- (void)reConnect;

@end

@interface MCBLEConnectFailureHintView : UIView

@property (nonatomic, weak) id<MCBLEConnectFailureHintViewDelegate> delegate;

@end
