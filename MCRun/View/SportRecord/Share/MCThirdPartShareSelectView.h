//
//  MCThirdPartShareSelectView.h
//  MCRun
//
//  Created by moshuqi on 16/1/29.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MCShareSelectType)
{
    MCShareSelectTypeWXCircleOfFriends = 1,     // 微信朋友圈
    MCShareSelectTypeWXFriends,                 // 微信好友
    MCShareSelectTypeSinaWeibo,                 // 新浪微博
    MCShareSelectTypeQQZone,                    // QQ空间
    MCShareSelectTypeQQFriends                  // QQ好友
};

@protocol MCThirdPartShareSelectViewDelegate <NSObject>

@required
- (void)shareType:(MCShareSelectType)type;

@end

@interface MCThirdPartShareSelectView : UIView

@property (nonatomic, weak) id<MCThirdPartShareSelectViewDelegate> delegate;

@end
