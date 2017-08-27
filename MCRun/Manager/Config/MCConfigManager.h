//
//  MCConfigManager.h
//  MCRun
//
//  Created by moshuqi on 15/12/8.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCAppSettingsDefine.h"

@interface MCConfigManager : NSObject

+ (instancetype)shareConfigManager;

+ (BOOL)BLEConnectPromptHidden;
+ (void)setBLEConnectHintHidden:(BOOL)hidden;

+ (BOOL)heartRatePanelHidden;
+ (void)setHeartRatePanelHidden:(BOOL)hidden;

+ (MCVoicePromptType)voicePromptType;
+ (void)setVoicePromptType:(MCVoicePromptType)type;
+ (NSString *)getVoiceTypeNameStringWithType:(MCVoicePromptType)type;

@end
