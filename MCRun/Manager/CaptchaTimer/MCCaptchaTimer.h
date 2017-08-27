//
//  MCCaptchaTimer.h
//  MCRun
//
//  Created by moshuqi on 15/11/3.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CallbackBlock)(NSInteger remainTime, BOOL finished);

@interface MCCaptchaTimer : NSObject

+ (instancetype)shareCaptchaTimer;
- (void)startWithBlock:(CallbackBlock)block;
- (BOOL)isCountdownState;
- (void)setCallbackWithBlock:(CallbackBlock)block;

@end
