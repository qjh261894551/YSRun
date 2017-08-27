//
//  MCDataManager.h
//  MCRun
//
//  Created by moshuqi on 15/10/26.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCUserInfoModel;

@interface MCDataManager : NSObject

+ (instancetype)shareDataManager;

- (void)resetData;
- (BOOL)isLogin;
- (BOOL)isThirdPartLogin;
- (MCUserInfoModel *)getUserInfo;

- (NSString *)getUserName;
- (NSString *)getUid;
- (NSString *)getUserPhone;

@end
