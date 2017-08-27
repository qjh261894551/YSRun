//
//  MCUserSettingView.h
//  MCRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCUserSetCell.h"

@protocol MCUserSettingViewDelegate <NSObject>

@required
- (void)modifyNickame:(NSString *)nickname;
- (void)userSettingViewDidSelectedType:(MCSettingsType)type;

@end

@interface MCUserSettingView : UIView

@property (nonatomic, weak) id<MCUserSettingViewDelegate> delegate;

- (void)reloadTableView;

@end
