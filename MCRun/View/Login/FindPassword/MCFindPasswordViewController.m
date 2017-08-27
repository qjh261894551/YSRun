//
//  MCFindPasswordViewController.m
//  MCRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCFindPasswordViewController.h"
#import "MCNavigationBarView.h"
#import "MCTextFieldTableView.h"
#import "MCAppMacro.h"
#import "MCPhoneTextFieldLimitDelegate.h"
#import "MCTipLabelHUD.h"
#import "MCNetworkManager.h"
#import "MCResetPasswordViewController.h"
#import "MCCaptchaTimer.h"
#import "MCLoadingHUD.h"
#import "MCTextFieldComponentCreator.h"
#import "MCDevice.h"

#import "MCTextFieldDelegateObj.h"
#import "MCContentCheckIconChange.h"
#import "MCEditingCheckLengthLimit.h"
#import "MCEditingCheckPhoneNumber.h"

@interface MCFindPasswordViewController () <MCPhoneTextFieldLimitDelegateCallback, MCNetworkManagerDelegate, MCContentCheckIconChangeDelegate, MCEditingCheckLengthLimitDelegate, MCTextFieldDelegateObjCallBack>

@property (nonatomic, weak) IBOutlet MCNavigationBarView *navigationBarView;
//@property (nonatomic, weak) IBOutlet MCTextFieldTableView *textFieldTable;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) MCPhoneTextFieldLimitDelegate *phoneTextFieldDelegate;

@property (nonatomic, weak) IBOutlet UITextField *accountTextField;
@property (nonatomic, weak) IBOutlet UITextField *captchaTextField;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *textFieldHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *firstTextFieldTopToBarViewBottomConstraint;

@property (nonatomic, strong) UIButton *captchaButton;      // 发送验证码按钮

@property (nonatomic, strong) MCTextFieldDelegateObj *accountTextFieldDelegateObj;
@property (nonatomic, strong) MCTextFieldDelegateObj *captchaTextFieldDelegateObj;

@end

@implementation MCFindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationBarView setupWithTitle:@"找回密码" barBackgroundColor:[UIColor clearColor] target:self action:@selector(findPasswordViewBack)];
    
    // 在此处改变constant并不会导致对应控件的高度立即变化，所以setup方法中需要控件高度的地方直接取constant的值
    self.firstTextFieldTopToBarViewBottomConstraint.constant = [self constraintConstant];
    if ([MCDevice isPhone6Plus])
    {
        self.textFieldHeightConstraint.constant = 52;
    }
    
    [self setupButton];
    [self setupTextFields];
    [self setupBackgroundImage];
    [self addBackgroundTapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self resetCaptchaButtonState];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupButton
{
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    CGFloat btnHeight = self.textFieldHeightConstraint.constant;
    self.nextButton.layer.cornerRadius = ButtonCornerRadius;
    
    self.nextButton.backgroundColor = GreenBackgroundColor;
    self.nextButton.clipsToBounds = YES;
}

- (void)setupTextFields
{
    CGFloat textFieldHeight = self.textFieldHeightConstraint.constant;
    
    [MCTextFieldComponentCreator setupTextField:self.accountTextField height:textFieldHeight];
    [MCTextFieldComponentCreator setupTextField:self.captchaTextField height:textFieldHeight];
    
    // 设置文本框左边图标
    UIImage *accountImage = [MCTextFieldComponentCreator getAccountIconWithContentEmptyState:YES];
    UIImage *captchaImage = [MCTextFieldComponentCreator getPasswordIconWithContentEmptyState:YES];
    
    self.accountTextField.leftView = [MCTextFieldComponentCreator getViewWithImage:accountImage textFieldHeight:textFieldHeight];
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.captchaTextField.leftView = [MCTextFieldComponentCreator getViewWithImage:captchaImage textFieldHeight:textFieldHeight];
    self.captchaTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.accountTextField.keyboardType = UIKeyboardTypePhonePad;
    
    // 占位符
    [MCTextFieldComponentCreator setupTextField:self.accountTextField withPlaceholder:@"请输入手机号"];
    [MCTextFieldComponentCreator setupTextField:self.captchaTextField withPlaceholder:@"请输入验证码"];
    
    // 发送验证码按钮
    self.captchaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.captchaButton addTarget:self action:@selector(captchaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat buttonWidth = [MCDevice isPhone6Plus] ? 96 : 76;
    self.accountTextField.rightView = [MCTextFieldComponentCreator getViewWithCaptchaButton:self.captchaButton buttonWidth:buttonWidth textFieldHeight:textFieldHeight];
    self.accountTextField.rightViewMode = UITextFieldViewModeAlways;
    
    // 输入手机号码的文本框有规则约束
//    self.phoneTextFieldDelegate = [MCPhoneTextFieldLimitDelegate new];
//    self.phoneTextFieldDelegate.delegate = self;
//    self.accountTextField.delegate = self.phoneTextFieldDelegate;
    
    self.accountTextField.returnKeyType = UIReturnKeyNext;
    self.captchaTextField.returnKeyType = UIReturnKeyDone;
    
    self.accountTextField.enablesReturnKeyAutomatically = YES;
    self.captchaTextField.enablesReturnKeyAutomatically = YES;
    
    [self setupTextFieldDelegate];
}

- (void)setupTextFieldDelegate
{
    // 给文本框设置代理，有输入字符时文本框左边图标改变
    
    NSInteger maxLimit = 11;    // 手机号码位数
    MCEditingCheckLengthLimit *checkLengthLimit = [[MCEditingCheckLengthLimit alloc] initWithMaxLimit:maxLimit delegate:self];
    MCEditingCheckPhoneNumber *checkPhoneNumber = [[MCEditingCheckPhoneNumber alloc] init];
    
    NSArray *editingCheckArray = @[checkLengthLimit, checkPhoneNumber];
    
    MCContentCheckIconChange *contentCheck1 = [[MCContentCheckIconChange alloc] initWithDelegate:self];
    NSArray *contentCheckArray1 = @[contentCheck1];
    
    self.accountTextFieldDelegateObj = [[MCTextFieldDelegateObj alloc] initWithEditingCheckArray:editingCheckArray contentCheckArray:contentCheckArray1];
    self.accountTextField.delegate = self.accountTextFieldDelegateObj;
    
    MCContentCheckIconChange *contentCheck2 = [[MCContentCheckIconChange alloc] initWithDelegate:self];
    NSArray *contentCheckArray2 = @[contentCheck2];
    
    self.captchaTextFieldDelegateObj = [[MCTextFieldDelegateObj alloc] initWithEditingCheckArray:nil contentCheckArray:contentCheckArray2];
    self.captchaTextField.delegate = self.captchaTextFieldDelegateObj;
    
    self.accountTextFieldDelegateObj.delegate = self;
    self.captchaTextFieldDelegateObj.delegate = self;
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

- (CGFloat)constraintConstant
{
    // 根据实际情况计算的constant值，既第一个文本框与导航栏的距离
    
    CGFloat distance = 5;   // 控件间的间距
    CGFloat height = self.textFieldHeightConstraint.constant;   // 控件的高度，文本框和按钮的高度相同
    CGFloat barViewHeight = CGRectGetHeight(self.navigationBarView.frame);
    
    CGFloat screenHeight = [UIApplication sharedApplication].keyWindow.frame.size.height;
    // 按钮距底边的间距为第一个文本框距导航栏的间距的2倍
    CGFloat constant = (screenHeight - barViewHeight - height * 3 - distance * 2) / 3;
    
    return constant;
}

- (void)captchaButtonClicked:(UIButton *)button
{
    NSString *phoneNumber = self.accountTextField.text;
    BOOL isValid = [self checkPhoneNumberValid:phoneNumber];
    
    if (isValid)
    {
        MCNetworkManager *networkManager = [MCNetworkManager new];
        networkManager.delegate = self;
        [networkManager resetPasswordCaptchaWithPhoneNumber:phoneNumber];
        
        [self sendCaptchaSuccess];
    }
    else
    {
        NSString *tipText = @"手机号不正确";
        [[MCTipLabelHUD shareTipLabelHUD] showTipWithText:tipText];
    }
}

- (BOOL)checkPhoneNumberValid:(NSString *)phoneNumber
{
    NSInteger length = [phoneNumber length];
    NSInteger requireLength = 11;
    return (length == requireLength);
}

//- (void)setupTextFieldTable
//{
//    UIView *firstLeftView = [self.textFieldTable getFirstTextFieldLeftView];
//    NSString *firstPlaceholder = @"请输入手机号";
//    [self.textFieldTable setupFirstTextFieldWithPlaceholder:firstPlaceholder leftView:firstLeftView rightView:[self.textFieldTable getCaptchaButtonView]];
//    
//    UIView *secondLeftView = [self.textFieldTable getSecondTextFieldLeftView];
//    NSString *secondPlaceholder = @"请输入验证码";
//    [self.textFieldTable setupSecondTextFieldWithPlaceholder:secondPlaceholder leftView:secondLeftView rightView:nil];
//    
//    self.phoneTextFieldDelegate = [MCPhoneTextFieldLimitDelegate new];
//    self.phoneTextFieldDelegate.delegate = self;
//    [self.textFieldTable setFirstTextFieldDelegate:self.phoneTextFieldDelegate];
//    
//    self.textFieldTable.delegate = self;
//}

- (void)findPasswordViewBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetCaptchaButtonState
{
    // 根据单例里保存的数据来设置发送验证码按钮的状态
    
    MCCaptchaTimer *captchaTimer = [MCCaptchaTimer shareCaptchaTimer];
    
    if ([captchaTimer isCountdownState])
    {
        [self setCaptchaButtonDisabled];
        
        CallbackBlock block = [self getCaptchaTimerCallBackBlock];
        [captchaTimer setCallbackWithBlock:block];
    }
}

- (void)sendCaptchaSuccess
{
    // 发送验证码按钮置灰，倒计时完成后才能点击。
    
    [[MCCaptchaTimer shareCaptchaTimer] startWithBlock:[self getCaptchaTimerCallBackBlock]];
    
    [self setCaptchaButtonDisabled];
}

- (void)setCaptchaButtonDisabled
{
//    UIButton *captchaButton = [self.textFieldTable getButton];
//    captchaButton.enabled = NO;
//    captchaButton.backgroundColor = RGB(215, 215, 215);
    
    self.captchaButton.enabled = NO;
}

- (CallbackBlock)getCaptchaTimerCallBackBlock
{
    CallbackBlock block = ^(NSInteger remainTime, BOOL finished)
    {
        UIButton *captchaButton = self.captchaButton;
        if (finished)
        {
            captchaButton.enabled = YES;
//            captchaButton.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            NSString *text = [NSString stringWithFormat:@"%@s", @(remainTime)];
            
            // 需同时设置，，并且保证captchaButton.titleLabel.text在setTitle:forState:之前，否则按钮的字在NSTimer调用时会闪。
            captchaButton.titleLabel.text = text;
            [captchaButton setTitle:text forState:UIControlStateDisabled];
            [captchaButton setTitleColor:GreenBackgroundColor forState:UIControlStateDisabled];
        }
    };
    
    return block;
}

- (IBAction)nextButtonClicked:(id)sender
{
//    MCResetPasswordViewController *resetPasswordViewController = [MCResetPasswordViewController new];
//    [self.navigationController pushViewController:resetPasswordViewController animated:YES];
//    
//    return;
    
    [self findPassword];
}

- (void)findPassword
{
    NSString *phoneNumber = self.accountTextField.text;
    NSString *captcha = self.captchaTextField.text;
    
    // 保证两个文本框的输入不为空。
    if (([phoneNumber length] < 1) || ([captcha length] < 1))
    {
        NSString *type = ([phoneNumber length] < 1) ? @"手机号" : @"验证码";
        NSString *tip = [NSString stringWithFormat:@"%@不能为空", type];
        [self showTipLabelWithText:tip];
        return;
    }
    
    if (![self checkPhoneNumberValid:phoneNumber])
    {
        NSString *tip = [NSString stringWithFormat:@"手机号格式不正确"];
        [self showTipLabelWithText:tip];
        return;
    }
    
    [[MCLoadingHUD shareLoadingHUD] show];
    
    MCNetworkManager *networkManager = [MCNetworkManager new];
    networkManager.delegate = self;
    [networkManager checkCaptcha:captcha phoneNumber:phoneNumber];
}

- (void)showTipLabelWithText:(NSString *)text
{
    [[MCTipLabelHUD shareTipLabelHUD] showTipWithText:text];
}

#pragma mark - MCPhoneTextFieldLimitDelegateCallback

- (void)phoneLengthMoreThanLimit
{
    [[MCTipLabelHUD shareTipLabelHUD] showTipWithText:@"长度超过限制"];
}

//#pragma mark - MCTextFieldTableViewDelegate
//
//- (void)sendCaptchaWithPhoneNumber:(NSString *)phoneNumber
//{
//    BOOL isValid = [self checkPhoneNumberValid:phoneNumber];
//    
//    if (isValid)
//    {
//        MCNetworkManager *networkManager = [MCNetworkManager new];
//        networkManager.delegate = self;
//        [networkManager resetPasswordCaptchaWithPhoneNumber:phoneNumber];
//        
//        [self sendCaptchaSuccess];
//    }
//    else
//    {
//        NSString *tipText = @"手机号不正确";
//        [[MCTipLabelHUD shareTipLabelHUD] showTipWithText:tipText];
//    }
//}

#pragma mark - MCNetworkManagerDelegate

//- (void)showAcquireCaptchaResultTip:(NSString *)tip
//{
//    [self showTipLabelWithText:tip];
//}
//
//- (void)acquireCaptchaSuccess
//{
//    [self showTipLabelWithText:@"验证码已发送至手机短信"];
//    [self sendCaptchaSuccess];
//}

- (void)acquireResetPasswordCaptchaSuccess
{
    [self showTipLabelWithText:@"验证码已发送至手机短信"];
}

- (void)acquireResetPasswordCaptchaFailureWithMessage:(NSString *)message
{
    [self showTipLabelWithText:message];
}

- (void)checkCaptchaSuccessWithPhoneNumber:(NSString *)phoneNumber
{
    // 验证成功，跳转到重置密码页面
    
    [[MCLoadingHUD shareLoadingHUD] dismiss];
    
    MCResetPasswordViewController *resetPasswordViewController = [[MCResetPasswordViewController alloc] initWithPhoneNumber:phoneNumber];
    [self.navigationController pushViewController:resetPasswordViewController animated:YES];
}

- (void)checkCaptchaFailureWithMessage:(NSString *)message
{
    [[MCLoadingHUD shareLoadingHUD] dismiss];
    
    [self showTipLabelWithText:message];
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
    else if (textField == self.captchaTextField)
    {
        image = [MCTextFieldComponentCreator getPasswordIconWithContentEmptyState:isEmpty];
    }
    
    textField.leftView = [MCTextFieldComponentCreator getViewWithImage:image textFieldHeight:textFieldHeight];
}

#pragma mark - MCEditingCheckLengthLimitDelegate

- (void)beyondMaxLimit
{
    [[MCTipLabelHUD shareTipLabelHUD] showTipWithText:@"长度超过限制"];
}

#pragma mark - MCTextFieldDelegateObjCallBack

- (void)textFieldDidReturn:(UITextField *)textField
{
    if (textField == self.accountTextField)
    {
        [self.captchaTextField becomeFirstResponder];
    }
    else if (textField == self.captchaTextField)
    {
        [self findPassword];
    }
}

@end
