//
//  MCLoginViewController.m
//  MCRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCLoginViewController.h"
#import "MCNavigationBarView.h"
#import "MCRegisterViewController.h"
#import "MCFindPasswordViewController.h"
#import "MCAppMacro.h"
#import "MCTextFieldTableView.h"
#import "MCNetworkManager.h"
#import "MCTipLabelHUD.h"
#import "MCShareFunc.h"
//#import "MCThirdPartLoginFunc.h"
#import "MCLoadingHUD.h"
#import "MCDevice.h"
#import "MCTextFieldComponentCreator.h"
#import "MCThirdPartLoginView.h"

#import "MCTextFieldDelegateObj.h"
#import "MCContentCheckIconChange.h"

@interface MCLoginViewController () <MCNetworkManagerDelegate, MCThirdPartLoginViewDelegate, MCContentCheckIconChangeDelegate, MCTextFieldDelegateObjCallBack>

@property (nonatomic, weak) IBOutlet MCNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;
@property (nonatomic, weak) IBOutlet UIButton *forgetPasswordButton;

@property (nonatomic, weak) IBOutlet UIView *line;  // 按钮之间的线

//@property (nonatomic, weak) IBOutlet UIButton *thirdPartLogin;  // 第三方登录
//@property (nonatomic, weak) IBOutlet MCTextFieldTableView *textFieldTable;

@property (nonatomic, strong) MCNetworkManager *networkManager;
//@property (nonatomic, strong) MCThirdPartLoginFunc *thirdPartLoginFunc;

@property (nonatomic, weak) IBOutlet UITextField *accountTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet MCThirdPartLoginView *thirdPartLoginView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *textFieldHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *firstTextFieldTopToBarViewBottomConstraint;

@property (nonatomic, strong) MCTextFieldDelegateObj *accountTextFieldDelegateObj;
@property (nonatomic, strong) MCTextFieldDelegateObj *passwordTextFieldDelegateObj;

@end

@implementation MCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationBarView setupWithTitle:@"登录" barBackgroundColor:[UIColor clearColor] target:self action:@selector(loginViewBack)];
    
    // 在此处改变constant并不会导致对应控件的高度立即变化，所以setup方法中需要控件高度的地方直接取constant的值
    self.firstTextFieldTopToBarViewBottomConstraint.constant = [self constraintConstant];
    if ([MCDevice isPhone6Plus])
    {
        self.textFieldHeightConstraint.constant = 52;
    }
    
    [self setupButtons];
    [self setupTextFields];
    [self setupBackgroundImage];
    [self addBackgroundTapGesture];
    
    self.networkManager = [MCNetworkManager new];
    self.networkManager.delegate = self;
    
    self.thirdPartLoginView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.thirdPartLoginView setupSubViews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // 在viewDidLayoutSubviews里添加视图会导致函数被无限调用，放到viewDidAppear里执行 --2016.2.21
//    [self.thirdPartLoginView setupSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupButtons
{
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.backgroundColor = GreenBackgroundColor;
    
//    CGFloat btnHeight = self.textFieldHeightConstraint.constant;
    self.loginButton.layer.cornerRadius = ButtonCornerRadius;
    self.loginButton.clipsToBounds = YES;
    
//    [self.thirdPartLogin setTitle:@"其他账号登录" forState:UIControlStateNormal];
//    [self.thirdPartLogin setTitleColor:GreenBackgroundColor forState:UIControlStateNormal];
//    self.thirdPartLogin.backgroundColor = [UIColor clearColor];
//    
//    // 是否安装有客户端，若无则不显示第三方登录按钮
//    self.thirdPartLogin.hidden = ![MCShareFunc hasClientInstalled];
    
    [self.registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:GreenBackgroundColor forState:UIControlStateNormal];
    self.registerButton.backgroundColor = [UIColor clearColor];
    
    [self.forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetPasswordButton setTitleColor:GreenBackgroundColor forState:UIControlStateNormal];
    self.forgetPasswordButton.backgroundColor = [UIColor clearColor];
    
    self.line.backgroundColor = GreenBackgroundColor;
}

- (CGFloat)constraintConstant
{
    // 根据实际情况计算的constant值，既第一个文本框与导航栏的距离
    CGFloat constant = 64;
    if ([MCDevice isPhone6Plus])
    {
        constant = 88;
    }
    return constant;
    
//    CGFloat distance = 5;   // 控件间的间距
//    CGFloat height = self.textFieldHeightConstraint.constant;   // 控件的高度，文本框和按钮的高度相同
//    CGFloat barViewHeight = CGRectGetHeight(self.navigationBarView.frame);
//    
//    CGFloat screenHeight = [UIApplication sharedApplication].keyWindow.frame.size.height;
//    // 按钮距底边的间距为第一个文本框距导航栏的间距的2倍
//    CGFloat constant = (screenHeight - barViewHeight - height * 2 - distance) / 3;
//    
//    return constant;
}

- (void)setupTextFields
{
    CGFloat textFieldHeight = self.textFieldHeightConstraint.constant;
    
    [MCTextFieldComponentCreator setupTextField:self.accountTextField height:textFieldHeight];
    [MCTextFieldComponentCreator setupTextField:self.passwordTextField height:textFieldHeight];
    
    // 设置文本框左边图标
    UIImage *accountImage = [MCTextFieldComponentCreator getAccountIconWithContentEmptyState:YES];
    UIImage *passwordImage = [MCTextFieldComponentCreator getPasswordIconWithContentEmptyState:YES];
    
    self.accountTextField.leftView = [MCTextFieldComponentCreator getViewWithImage:accountImage textFieldHeight:textFieldHeight];
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTextField.leftView = [MCTextFieldComponentCreator getViewWithImage:passwordImage textFieldHeight:textFieldHeight];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    // 占位符
    [MCTextFieldComponentCreator setupTextField:self.accountTextField withPlaceholder:@"请输入用户名/手机号"];
    [MCTextFieldComponentCreator setupTextField:self.passwordTextField withPlaceholder:@"请输入密码"];
    
    self.passwordTextField.secureTextEntry = YES;
    UIButton *secureTextButton = [self getSecureTextButton];
    self.passwordTextField.rightView = [MCTextFieldComponentCreator getViewWithPasswordSecureButton:secureTextButton buttonWidth:56 textFieldHeight:textFieldHeight];
    self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    // 设置软键盘return键
    self.accountTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    
    self.accountTextField.enablesReturnKeyAutomatically = YES;
    self.passwordTextField.enablesReturnKeyAutomatically = YES;
    
    [self setupTextFieldDelegate];
}

- (void)setupTextFieldDelegate
{
    // 给文本框设置代理，有输入字符时文本框左边图标改变
    
    MCContentCheckIconChange *contentCheck1 = [[MCContentCheckIconChange alloc] initWithDelegate:self];
    NSArray *contentCheckArray1 = @[contentCheck1];
    
    self.accountTextFieldDelegateObj = [[MCTextFieldDelegateObj alloc] initWithEditingCheckArray:nil contentCheckArray:contentCheckArray1];
    self.accountTextField.delegate = self.accountTextFieldDelegateObj;
    
    MCContentCheckIconChange *contentCheck2 = [[MCContentCheckIconChange alloc] initWithDelegate:self];
    NSArray *contentCheckArray2 = @[contentCheck2];
    
    self.passwordTextFieldDelegateObj = [[MCTextFieldDelegateObj alloc] initWithEditingCheckArray:nil contentCheckArray:contentCheckArray2];
    self.passwordTextField.delegate = self.passwordTextFieldDelegateObj;
    
    self.accountTextFieldDelegateObj.delegate = self;
    self.passwordTextFieldDelegateObj.delegate = self;
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
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    
    UIImage *image = self.passwordTextField.secureTextEntry ? [UIImage imageNamed:@"password_eye_close"] : [UIImage imageNamed:@"password_eye_open"];
    [button setImage:image forState:UIControlStateNormal];
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

- (void)loginViewBack
{
    // 收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginButtonClicked:(id)sender
{
    [self login];
}

- (void)login
{
    // 临时代码
//    [self.networkManager loginWithAccount:@"13790714674" password:@"chelsea123"];
//    [[MCLoadingHUD shareLoadingHUD] show];
//    return;
    
    NSString *account = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (([account length] < 1) || ([password length] < 1))
    {
        NSString *type = ([account length] < 1) ? @"用户名" : @"密码";
        NSString *tip = [NSString stringWithFormat:@"请输入%@", type];
        [[MCTipLabelHUD shareTipLabelHUD] showTipWithText:tip];
        return;
    }
    
    [self.networkManager loginWithAccount:account password:password];
    
    // 加载界面
    [[MCLoadingHUD shareLoadingHUD] show];
}

- (IBAction)registerButtonClicked:(id)sender
{
    MCRegisterViewController *registerViewController = [MCRegisterViewController new];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (IBAction)forgetPasswordButtonClicked:(id)sender
{
    MCFindPasswordViewController *findPasswordViewController = [MCFindPasswordViewController new];
    [self.navigationController pushViewController:findPasswordViewController animated:YES];
}

//- (IBAction)thirdPartLoginButtonClicked:(id)sender
//{
//    self.thirdPartLoginFunc = [MCThirdPartLoginFunc new];
//    self.thirdPartLoginFunc.delegate = self;
//    
//    [self.thirdPartLoginFunc showActionSheet];
//}

#pragma mark - MCNetworkManagerDelegate

- (void)loginSuccessWithUserInfoResponseModel:(MCUserInfoResponseModel *)userInfoResponseModel
{
    [[MCLoadingHUD shareLoadingHUD] dismiss];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [self.delegate loginViewController:self loginFinishWithUserInfoResponseModel:userInfoResponseModel];
}

- (void)loginFailure
{
    [[MCLoadingHUD shareLoadingHUD] dismiss];
    
    [[MCTipLabelHUD shareTipLabelHUD] showTipWithText:@"登录失败，请检查用户名密码是否正确"];
}

#pragma mark - MCThirdPartLoginViewDelegate

- (void)thirdPartLoginSuccessWithResponseModel:(MCThirdPartLoginResponseModel *)respondeModel
{
    // 第三方登录成功返回到App，此时用第三方返回的数据向服务器请求，之后流程和正常登录一致。请求过程先显示加载界面
    [[MCLoadingHUD shareLoadingHUD] show];
    
    [self.networkManager thirdPartLoginWithThirdPartLoginResponseModel:respondeModel];
}

- (void)thirdPartLoginFailureWithMessage:(NSString *)message
{
    [[MCTipLabelHUD shareTipLabelHUD] showTipWithText:@"登录失败"];
}

#pragma mark - MCContentCheckIconChangeDelegate

- (void)needChangeTextField:(UITextField *)textField textEmpty:(BOOL)isEmpty
{
    CGFloat textFieldHeight = CGRectGetHeight(textField.frame);
    UIImage *image = nil;
    
    if (textField == self.accountTextField)
    {
        image = [MCTextFieldComponentCreator getAccountIconWithContentEmptyState:isEmpty];
    }
    else if (textField == self.passwordTextField)
    {
        image = [MCTextFieldComponentCreator getPasswordIconWithContentEmptyState:isEmpty];
    }
    
    textField.leftView = [MCTextFieldComponentCreator getViewWithImage:image textFieldHeight:textFieldHeight];
}

#pragma mark - MCTextFieldDelegateObjCallBack

- (void)textFieldDidReturn:(UITextField *)textField
{
    if (textField == self.accountTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField)
    {
        [self login];
    }
}

@end
