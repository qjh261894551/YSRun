//
//  MCNetworkRequest.h
//  MCRun
//
//  Created by moshuqi on 15/10/21.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCUserInfoResponseModel;
@class MCRegisterInfoRequestModel;
@class MCModifyPasswordRequestModel;
@class MCSetUserRequestModel;
@class MCUploadRunDataRequestModel;
@class MCUserDatabaseModel;
@class UIImage;
@class MCThirdPartLoginResponseModel;

@protocol MCNetworkRequestDelegate <NSObject>

// 获取验证码
- (void)acquireCaptchaSuccess;
- (void)acquireCaptchaFailure;
- (void)registerPhoneNumberHasExsist;   // 号码已经存在

// 判断验证码
- (void)captchaCorrectWithPhoneNumber:(NSString *)phoneNumber;
- (void)captchaWrong;
- (void)captchaOvertime;    // 验证码30分钟超时
- (void)captchaInvalid;

// 用户注册
- (void)userRegisterSuccessWithUid:(NSString *)uid;
- (void)userRegisterFailureWithMessage:(NSString *)message;
- (void)userRegisterPhoneNumberCaptchaCorrect;  // 手机号码未通过验证码验证

// 用户登录
- (void)userLoginSuccessWithUserInfoResponseModel:(MCUserInfoResponseModel *)userInfoResponseModel;
- (void)userLoginFailure;

// 重置密码前的验证码
- (void)acquireResetPasswordCaptchaSuccess;
- (void)acquireResetPasswordCaptchaFailureWithMessage:(NSString *)message;

// 密码重置
- (void)userResetPasswordSuccess;
- (void)userResetPasswordFailureWithMessage:(NSString *)message;

// 修改密码
- (void)userModifyPasswordSuccess;
- (void)userModifyPasswordFailureWithMessage:(NSString *)message;

// 设置用户基本信息
- (void)userSetInfoSuccess;
- (void)userSetInfoFailureWithMessage:(NSString *)message;

// 获取用户基本信息
- (void)requestUserInfoSuccessWithModel:(MCUserDatabaseModel *)model;
- (void)requestUserInfoFailureWithMessage:(NSString *)message;

// 上传跑步数据
//- (void)uploadRunDataResult:(BOOL)isSuccess localRowid:(NSInteger)rowid;
- (void)uploadUserRunDataSuccessWithlocalRowid:(NSInteger)rowid lasttime:(NSString *)lasttime;
- (void)uploadUserRunDataFailureWithMessage:(NSString *)message;

// 获取服务端跑步数据
- (void)synchronizeLocalRunData:(NSArray *)runDataArray lastTime:(NSInteger)lastTime;
- (void)notRequiredSynchronized;
- (void)getRunDataEmpty;

// 上传头像
- (void)userUploadHeadImageSuccessWithPath:(NSString *)imagePath;
- (void)userUploadHeadImageFailureWithMessage:(NSString *)message;

// 网络请求失败
- (void)networkRequestFailureWithError:(NSError *)error;

@end

@interface MCNetworkRequest : NSObject

@property (nonatomic, weak) id<MCNetworkRequestDelegate> delegate;

+ (instancetype)shareNetworkRequest;

// 获取验证码
- (void)acquireCaptchaWithPhoneNumber:(NSString *)phoneNumber delegate:(id<MCNetworkRequestDelegate>)delegate;

// 检验验证码
- (void)checkCaptcha:(NSString *)captcha phoneNumber:(NSString *)phoneNumber delegate:(id<MCNetworkRequestDelegate>)delegate;

// 用户登录
- (void)userLoginWithAccount:(NSString *)account password:(NSString *)password delegate:(id<MCNetworkRequestDelegate>)delegate;

// 用户注册
- (void)userRegisterWithRequestModel:(MCRegisterInfoRequestModel *)requestModel delegate:(id<MCNetworkRequestDelegate>)delegate;

// 重置密码前获取验证码
- (void)resetPasswordCaptchaWithPhoneNumber:(NSString *)phoneNumber delegate:(id<MCNetworkRequestDelegate>)delegate;

// 重置密码
- (void)resetPasswordWithAccount:(NSString *)account password:(NSString *)password delegate:(id<MCNetworkRequestDelegate>)delegate;

// 修改密码
- (void)modiyPasswordWithRequestModel:(MCModifyPasswordRequestModel *)requestModel  delegate:(id<MCNetworkRequestDelegate>)delegate;

// 用户设置
- (void)setUserWithRequestModel:(MCSetUserRequestModel *)requestModel delegate:(id<MCNetworkRequestDelegate>)delegate;

// 获取用户信息
- (void)getUserInfoWithUserID:(NSString *)uid delegate:(id<MCNetworkRequestDelegate>)delegate;

// 获取跑步数据
- (void)getRunDataWithUid:(NSString *)uid lastTime:(NSInteger)lastTime delegate:(id<MCNetworkRequestDelegate>)delegate;

// 上传跑步数据
- (void)uploadRunData:(MCUploadRunDataRequestModel *)runData delegate:(id<MCNetworkRequestDelegate>)delegate;

// 上传头像
- (void)uploadHeadImage:(UIImage *)headImage uid:(NSString *)uid delegate:(id<MCNetworkRequestDelegate>)delegate;

// 第三方登录，拿统一的字段对服务器进行请求，返回之后和登录的流程一致
- (void)thirdPartLoginWithModel:(MCThirdPartLoginResponseModel *)model delegate:(id<MCNetworkRequestDelegate>)delegate;

- (void)test;

@end
