//
//  MCAppSettingsDefine.h
//  MCRun
//
//  Created by moshuqi on 15/12/8.
//  Copyright © 2015年 msq. All rights reserved.
//

#ifndef MCAppSettingsDefine_h
#define MCAppSettingsDefine_h

// 语音提示类型，暂时只有男声和女声，关闭
typedef NS_ENUM(NSInteger, MCVoicePromptType) {
    MCVoicePromptTypeMan = 1,
    MCVoicePromptTypeGirl = 2,
    MCVoicePromptClose
};

#define MCBLEConnectPromptHiddenKey         @"MCBLEConnectPromptHiddenKey"      // 蓝牙设备连接的不再提示
#define MCHeartRatePanelShowStateKey        @"MCHeartRatePanelShowStateKey"     // 心率面板显示是否需要显示
#define MCVoicePromptTypeKey                @"MCVoicePromptTypeKey"             // 语音提示类型

#define MCDatabaseVersionKey                @"MCDatabaseVersionKey"             // 数据库的版本号

#endif /* MCAppSettingsDefine_h */
