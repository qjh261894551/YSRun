//
//  MCResetPasswordViewController.m
//  MCRun
//
//  Created by moshuqi on 15/10/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCResetPasswordViewController.h"
#import "MCNavigationBarView.h"
#import "MCAppMacro.h"
#import "MCNetworkManager.h"
#import "MCTipLabelHUD.h"
#import "MCLoginViewController.h"
#import "MCUtilsMacro.h"
#import "MCLoadingHUD.h"
#import "MCDevice.h"
#import "MCTextFieldComponentCreator.h"

#import "MCTextFieldDelegateObj.h"
#import "MCContentCheckIconChange.h"

@interface MCResetPasswordViewController () <MCNetworkManagerDelegate, MCContentCheckIconChangeDelegate, MCTextFieldDelegateObjCallBack>

@property (nonatomic, weak) IBOutlet MCNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *sumbitButton;

@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *textFieldHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *textFieldTopToBarViewBottomConstraint;

@property (nonatomic, strong) MCTextFieldDelegateObj *textFieldDelegateObj;

@end

@implementation MCResetPasswordViewController

- (id)initWithPhoneNumber:(NSString *)phoneNumber
{
    self = [super init];
    if (self)
    {
        self.phoneNumber = phoneNumber;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationBarView setupWithTitle:@"重置密码" barBackgroundColor:[UIColor clearColor] target:self action:@selector(resetPasswordViewBack)];
    
    // 在此处改变constant并不会导致对应控件的高度立即变化，所以setup方法中需要控件高度的地方直接取constant的值
    self.textFieldTopToBarViewBottomConstraint.constant = [self constraintConstant];
    if ([MCDevice isPhone6Plus])
    {
        self.textFieldHeightConstraint.constant = 52;
    }
    
    [self setupButton];
    [self setupTextField];
    [self setupBackgroundImage];
    [self addBackgroundTapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupButton
{
    [self.sumbitButton setTitle:@"提  交" forState:UIControlStateNormal];
    [self.sumbitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    CGFloat btnHeight = self.textFieldHeightConstraint.constant;
    self.sumbitButton.layer.cornerRadius = ButtonCornerRadius;
    
    self.sumbitButton.backgroundColor = GreenBackgroundColor;
    self.sumbitButton.clipsToBounds = YES;
}

- (void)setupBackgroundImage
{
    // 设置背景图片
    UIImage *image = [UIImage imageNamed:@"login_background"];
    self.view.layer.contents = (id)image.CGImage;
}

- (void)addBackgroundTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapBackground:(id)tapGesture
{
    // 点击背景处时收起键盘。
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)setupTextField
{
    CGFloat textFieldHeight = CGRectGetHeight(self.textField.frame);
    [MCTextFieldComponentCreator setupTextField:self.textField height:textFieldHeight];
    
    UIImage *image = [MCTextFieldComponentCreator getPasswordIconWithContentEmptyState:YES];
    self.textField.leftView = [MCTextFieldComponentCreator getViewWithImage:image textFieldHeight:textFieldHeight];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    
    [MCTextFieldComponentCreator setupTextField:self.textField withPlaceholder:@"请设置新密码"];
    
    self.textField.secureTextEntry = YES;
    
    UIButton *secureTextButton = [self getSecureTextButton];
    self.textField.rightView = [MCTextFieldComponentCreator getViewWithPasswordSecureButton:secureTextButton buttonWidth:56 textFieldHeight:textFieldHeight];
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.enablesReturnKeyAutomatically = YES;
    
    [self setupTextFieldDelegate];
}

- (void)setupTextFieldDelegate
{
    // 给文本框设置代理，有输入字符时文本框左边图标改变
    
    MCContentCheckIconChange *contentCheck = [[MCContentCheckIconChange alloc] initWithDelegate:self];
    NSArray *contentCheckArray = @[contentCheck];
    
    self.textFieldDelegateObj = [[MCTextFieldDelegateObj alloc] initWithEditingCheckArray:nil contentCheckArray:contentCheckArray];
    self.textField.delegate = self.textFieldDelegateObj;
    
    self.textFieldDelegateObj.delegate = self;
}

- (UIButton *)getSecureTextButton
{
    UIButton *secureTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [secureTextButton addTarget:self action:@selector(secureTextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"password_eye_close"];
    [secureTextButton setImage:image forState:UIControlStateNormal];
    
    return secureTextButton;
}

- (void)secureTextButtonClicked:(UIButton *)button
{
    self.textField.secureTextEntry = !self.textField.secureTextEntry;
    
    UIImage *image = self.textField.secureTextEntry ? [UIImage imageNamed:@"password_eye_close"] : [UIImage imageNamed:@"password_eye_open"];
    [button setImage:image forState:UIControlStateNormal];
}

- (CGFloat)constraintConstant
{
    // 根据实际情况计算的constant值，既第一个文本框与导航栏的距离
    
    CGFloat distance = 5;   // 控件间的间距
    CGFloat height = self.textFieldHeightConstraint.constant;   // 控件的高度，文本框和按钮的高度相同
    CGFloat barViewHeight = CGRectGetHeight(self.navigationBarView.frame);
    
    CGFloat screenHeight = [UIApplication sharedApplication].keyWindow.frame.size.height;
    // 按钮距底边的间距为第一个文本框距导航栏的间距的2倍
    CGFloat constant = (screenHeight - barViewHeight - height * 2 - distance) / 3;
    
    return constant;
}

- (IBAction)submitButtonClicked:(id)sender
{
    [self resetPassword];
}

- (void)resetPassword
{
    NSString *newPassword = self.textField.text;
    
    if ([newPassword length] < 1)
    {
        NSString *tip = @"密码不能为空";
        [self showTipLabelWithText:tip];
        return;
    }
    
    [[MCLoadingHUD shareLoadingHUD] show];
    
    MCNetworkManager *networkManager = [MCNetworkManager new];
    networkManager.delegate = self;
    
    [networkManager resetPassword:newPassword phoneNumber:self.phoneNumber];
}

- (void)showTipLabelWithText:(NSString *)text
{
    [[MCTipLabelHUD shareTipLabelHUD] showTipWithText:text];
}

- (void)resetPasswordViewBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MCNetworkManagerDelegate

- (void)resetPasswordSuccess
{
    // 重置密码成功后跳转到登录界面
    
    [[MCLoadingHUD shareLoadingHUD] dismiss];
    
    [[MCTipLabelHUD shareTipLabelHUD] showTipWithText:@"密码重置成功"];
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    UIViewController *popToViewController = nil;
    
    for (UIViewController *viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[MCLoginViewController class]])
        {
            popToViewController = viewController;
            break;
        }
    }
    
    [self.navigationController popToViewController:popToViewController animated:YES];
}

- (void)resetPasswordFailureWithMessage:(NSString *)message
{
    [[MCLoadingHUD shareLoadingHUD] dismiss];
    
    [[MCTipLabelHUD shareTipLabelHUD] showTipWithText:message];
}

- (void)needChangeTextField:(UITextField *)textField textEmpty:(BOOL)isEmpty
{
    CGFloat textFieldHeight = CGRectGetHeight(textField.frame);
    textField.leftView = [MCTextFieldComponentCreator getViewWithImage:[MCTextFieldComponentCreator getPasswordIconWithContentEmptyState:isEmpty] textFieldHeight:textFieldHeight];
}

#pragma mark - MCTextFieldDelegateObjCallBack

- (void)textFieldDidReturn:(UITextField *)textField
{
    if (textField == self.textField)
    {
        [self resetPassword];
    }
}

@end
