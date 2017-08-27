//
//  MCDataHandler.h
//  MCRun
//
//  Created by moshuqi on 15/11/18.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MCRunDataHandlerDelegate <NSObject>

@optional
- (void)runDataHandleFinish;   // 在回调中处理完数据后通知界面的更新。

@end

@class MCRunDatabaseModel;
@class MCUserInfoResponseModel;
@class MCUserDatabaseModel;

@interface MCDataHandler : NSObject

@property (nonatomic, weak) id<MCRunDataHandlerDelegate> delegate;

- (void)synchronizeRunData;
- (void)uploadNotLoginRunData;
- (void)recordSingleRunData:(MCRunDatabaseModel *)runDatabaseModel;

- (void)loginSuccessWithUserInfoResponseModel:(MCUserInfoResponseModel *)userInfoResponseModel
;
- (void)registerSuccessWithResponseUserInfo:(MCUserDatabaseModel *)userInfo;

@end
