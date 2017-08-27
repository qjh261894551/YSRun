//
//  MCThirdPartLoginFunc.h
//  MCRun
//
//  Created by moshuqi on 15/12/10.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCThirdPartLoginResponseModel;

@protocol MCThirdPartLoginFuncDelegate <NSObject>

@required
- (void)thirdPartLoginSuccessWithResponseModel:(MCThirdPartLoginResponseModel *)respondeModel;
- (void)thirdPartLoginFailureWithMessage:(NSString *)message;

@end

@interface MCThirdPartLoginFunc : NSObject

@property (nonatomic, weak) id<MCThirdPartLoginFuncDelegate> delegate;

- (void)showActionSheet;

@end
