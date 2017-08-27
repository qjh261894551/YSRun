//
//  MCBLEDeviceConnectView.h
//  MCRun
//
//  Created by moshuqi on 15/11/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCBLEDeviceConnectViewDelegate <NSObject>

@required
- (void)BLEDeviceConnect;

@end

@interface MCBLEDeviceConnectView : UIView

@property (nonatomic, weak) id<MCBLEDeviceConnectViewDelegate> delegate;

@end
