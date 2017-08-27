//
//  MCBLEConnectHintView.h
//  MCRun
//
//  Created by moshuqi on 15/11/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCBLEConnectHintViewDelegate <NSObject>

- (void)connectHintClose;
- (void)connectDevice;
- (void)startRun;
- (void)setConnectHintHidden:(BOOL)hidden;

@end

@interface MCBLEConnectHintView : UIView

@property (nonatomic, weak) id<MCBLEConnectHintViewDelegate> delegate;

@end
