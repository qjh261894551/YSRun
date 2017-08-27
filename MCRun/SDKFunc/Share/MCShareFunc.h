//
//  MCShareFunc.h
//  MCRun
//
//  Created by moshuqi on 15/12/5.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCShareInfo.h"
#import "MCThirdPartLoginResponseModel.h"
#import <ShareSDK/ShareSDK.h>

@class UIView;
@class UIViewController;

typedef NS_ENUM(NSInteger, MCShareFuncResponseState) {
    MCShareFuncResponseStateBegin = 0,
    MCShareFuncResponseStateSuccess,
    MCShareFuncResponseStateFail,
    MCShareFuncResponseStateCancel
};

typedef void(^ShareFuncCallbackBlock)(MCShareFuncResponseState);
typedef void(^ThirdPartLoginCallbackBlock)(MCShareFuncResponseState, MCThirdPartLoginResponseModel*);

@interface MCShareFunc : NSObject

+ (void)shareConfig;

+ (void)shareInfo:(MCShareInfo *)shareInfo
         fromView:(UIView *)view
    callbackBlock:(ShareFuncCallbackBlock)callbackBlock;
+ (void)shareInfo:(MCShareInfo *)shareInfo
       byPlatform:(SSDKPlatformType)platform
    callbackBlock:(ShareFuncCallbackBlock)callbackBlock;

+ (void)showLoginActionSheetFromViewController:(UIViewController *)viewController
                                 callbackBlock:(ThirdPartLoginCallbackBlock)callbackBlock;
+ (void)thirdPartLoginByPlatform:(SSDKPlatformType)platform
                   callbackBlock:(ThirdPartLoginCallbackBlock)callbackBlock;

+ (BOOL)hasAuthorized;
+ (void)cancelAuthorized;
+ (BOOL)hasClientInstalled;

@end
