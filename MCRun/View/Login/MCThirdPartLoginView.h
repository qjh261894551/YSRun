//
//  MCThirdPartLoginView.h
//  MCRun
//
//  Created by moshuqi on 16/1/5.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCThirdPartLoginResponseModel;

@protocol MCThirdPartLoginViewDelegate <NSObject>

- (void)thirdPartLoginSuccessWithResponseModel:(MCThirdPartLoginResponseModel *)respondeModel;
- (void)thirdPartLoginFailureWithMessage:(NSString *)message;

@end

@interface MCThirdPartLoginView : UIView

@property (nonatomic, weak) id<MCThirdPartLoginViewDelegate> delegate;

- (void)setupSubViews;

@end
