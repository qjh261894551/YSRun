//
//  MCVoicePrompt.h
//  MCRun
//
//  Created by moshuqi on 15/12/2.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MCAppSettingsDefine.h"

@interface MCVoicePrompt : NSObject

- (void)setVoicePromptType:(MCVoicePromptType)type;
- (void)setPeripheralsConnectState:(BOOL)state;
- (void)updateWithHeartRate:(NSInteger)heartRate distance:(CGFloat)distance time:(NSInteger)time;

@end
