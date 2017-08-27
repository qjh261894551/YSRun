//
//  MCTextFieldTableView.h
//  MCRun
//
//  Created by moshuqi on 15/10/17.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCTextFieldTableViewDelegate <NSObject>

- (void)sendCaptchaWithPhoneNumber:(NSString *)phoneNumber;

@end


@interface MCTextFieldTableView : UIView

@property (nonatomic, weak) id<MCTextFieldTableViewDelegate> delegate;

- (void)setupFirstTextFieldWithPlaceholder:(NSString *)placeholder
                                  leftView:(UIView *)leftView
                                 rightView:(UIView *)rightView;
- (void)setupSecondTextFieldWithPlaceholder:(NSString *)placeholder
                                  leftView:(UIView *)leftView
                                 rightView:(UIView *)rightView;

- (UIView *)getFirstTextFieldLeftView;
- (UIView *)getSecondTextFieldLeftView;
- (UIView *)getCaptchaButtonView;

- (void)setFirstTextFieldDelegate:(id<UITextFieldDelegate>)delegate;

- (NSString *)firstText;
- (NSString *)secondText;

- (UIButton *)getButton;
- (UIView *)getPasswordTextFieldRightButtonView;

- (void)setFirstTextFieldSecureTextEntry:(BOOL)secureTextEntry;
- (void)setSecondTextFieldSecureTextEntry:(BOOL)secureTextEntry;

@end
