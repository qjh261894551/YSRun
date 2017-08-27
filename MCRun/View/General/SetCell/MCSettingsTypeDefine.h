//
//  MCSettingsTypeDefine.h
//  MCRun
//
//  Created by moshuqi on 15/12/7.
//  Copyright © 2015年 msq. All rights reserved.
//

#ifndef MCSettingsTypeDefine_h
#define MCSettingsTypeDefine_h

typedef NS_ENUM(NSInteger, MCSettingsType) {
    MCSettingsTypeNone = 0,
    MCSettingsTypeHeartRatePanel = 1,       // 心率面板
    MCSettingsTypeVoicePrompt,              // 语音提示
    MCSettingsTypeModifyPassword,           // 修改密码
    MCSettingsTypeFeedback,                 // 用户反馈
    MCSettingsTypeLogout,                   // 退出登录
    MCSettingsTypeMeasure,                  // 单位计量
    MCSettingsTypeNickname,                 // 用户昵称
    MCSettingsTypeSet                       // 设置
};

#endif /* MCSettingsTypeDefine_h */
