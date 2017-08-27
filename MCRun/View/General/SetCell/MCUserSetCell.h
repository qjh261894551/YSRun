//
//  MCUserSetCell.h
//  MCRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSettingsTypeDefine.h"

//typedef NS_ENUM(NSInteger, MCUserSetCellType)
//{
//    MCUserSetCellTypeNickname = 0,
//    MCUserSetCellTypeModifyPassword,
//    MCUserSetCellTypeMeasure,
//    MCUserSetCellTypeLogout,
//    MCUserSetCellTypeFeedback,
//    MCUserSetCellTypeHeartRateSwitch
//};

@protocol MCUserSetCellDelegate <NSObject>

@optional
- (void)textFieldTextChange:(NSString *)text;
- (void)switchStateChanged:(UISwitch *)switchControl;

@end

@interface MCUserSetCell : UITableViewCell

//@property (nonatomic, assign) MCSettingsType type;
@property (nonatomic, weak) id<MCUserSetCellDelegate> delegate;

//- (void)setupWithType:(MCSettingsType)type;

- (void)setupCellWithLeftText:(NSString *)leftText
                   centerText:(NSString *)centerText
                    rightText:(NSString *)rightText
                textFieldText:(NSString *)fieldText
                switchVisible:(BOOL)switchVisible;
- (void)setSwitchOn:(BOOL)isOn;

@end
