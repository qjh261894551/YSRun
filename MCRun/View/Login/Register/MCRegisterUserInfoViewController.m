//
//  MCRegisterUserInfoViewController.m
//  MCRun
//
//  Created by moshuqi on 15/10/29.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCRegisterUserInfoViewController.h"
#import "MCNavigationBarView.h"
#import "MCTextFieldTableView.h"
#import "MCAppMacro.h"
#import "MCUtilsMacro.h"
#import "MCTipLabelHUD.h"
#import "MCNetworkManager.h"
#import "MCRegisterInfoRequestModel.h"
#import "MCPhotoPicker.h"
#import "MCUserDatabaseModel.h"
#import "MCDatabaseManager.h"
#import "MCLoginViewController.h"
#import "MCLoadingHUD.h"
#import "MCTextFieldComponentCreator.h"
#import "MCDevice.h"

#import "MCTextFieldDelegateObj.h"
#import "MCContentCheckIconChange.h"

@interface MCRegisterUserInfoViewController () <MCPhotoPickerDelegate, MCNetworkManagerDelegate, MCContentCheckIconChangeDelegate, MCTextFieldDelegateObjCallBack>

@property (nonatomic, weak) IBOutlet MCNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet UIButton *photoButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;

@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, copy) NSString *account;

@property (nonatomic, strong) MCPhotoPicker *photoPicker;

@property (nonatomic, weak) IBOutlet UITextField *nicknameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *textFieldHeightConstraint;

@property (nonatomic, strong) MCTextFieldDelegateObj *nicknameTextFieldDelegateObj;
@property (nonatomic, strong) MCTextFieldDelegateObj *passwordTextFieldDelegateObj;

@end

@implementation MCRegisterUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationBarView setupWithTitle:@"注 册" barBackgroundColor:[UIColor clearColor] target:self action:@selector(registerViewBack)];
    
    if ([MCDevice isPhone6Plus])
    {
        self.textFieldHeightConstraint.constant = 52;
    }
    
    [self setupButtons];
//    [self setupTextFieldTable];
    [self setupTextFields];
    [self setupBackgroundImage];
    [self addBackgroundTapGesture];
}

- (id)initWithAccount:(NSString *)account
{
    self = [super init];
    if (self)
    {
        self.account = account;
    }
    
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupButtons
{
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    CGFloat btnHeight = self.textFieldHeightConstraint.constant;
    self.registerButton.layer.cornerRadius = ButtonCornerRadius;
    
    self.registerButton.backgroundColor = GreenBackgroundColor;
    self.registerButton.clipsToBounds = YES;
    
    CGFloat width = CGRectGetWidth(self.photoButton.frame);
    self.photoButton.layer.cornerRadius = width / 2;
    self.photoButton.clipsToBounds = YES;
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

- (void)setupTextFields
{
    CGFloat textFieldHeight = self.textFieldHeightConstraint.constant;
    
    [MCTextFieldComponentCreator setupTextField:self.nicknameTextField height:textFieldHeight];
    [MCTextFieldComponentCreator setupTextField:self.passwordTextField height:textFieldHeight];
    
    // 设置文本框左边图标
    UIImage *accountImage = [MCTextFieldComponentCreator getAccountIconWithContentEmptyState:YES];
    UIImage *passwordImage = [MCTextFieldComponentCreator getPasswordIconWithContentEmptyState:YES];
    
    self.nicknameTextField.leftView = [MCTextFieldComponentCreator getViewWithImage:accountImage textFieldHeight:textFieldHeight];
    self.nicknameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTextField.leftView = [MCTextFieldComponentCreator getViewWithImage:passwordImage textFieldHeight:textFieldHeight];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    // 占位符
    [MCTextFieldComponentCreator setupTextField:self.nicknameTextField withPlaceholder:@"请输入昵称"];
    [MCTextFieldComponentCreator setupTextField:self.passwordTextField withPlaceholder:@"请输入密码"];
    
    self.passwordTextField.secureTextEntry = YES;
    UIButton *secureTextButton = [self getSecureTextButton];
    self.passwordTextField.rightView = [MCTextFieldComponentCreator getViewWithPasswordSecureButton:secureTextButton buttonWidth:56 textFieldHeight:textFieldHeight];
    self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    self.nicknameTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    
    self.nicknameTextField.enablesReturnKeyAutomatically = YES;
    self.passwordTextField.enablesReturnKeyAutomatically = YES;
    
    [self setupTextFieldDelegate];
}

- (void)setupTextFieldDelegate
{
    // 给文本框设置代理，有输入字符时文本框左边图标改变
    
    MCContentCheckIconChange *contentCheck1 = [[MCContentCheckIconChange alloc] initWithDelegate:self];
    NSArray *contentCheckArray1 = @[contentCheck1];
    
    self.nicknameTextFieldDelegateObj = [[MCTextFieldDelegateObj alloc] initWithEditingCheckArray:nil contentCheckArray:contentCheckArray1];
    self.nicknameTextField.delegate = self.nicknameTextFieldDelegateObj;
    
    MCContentCheckIconChange *contentCheck2 = [[MCContentCheckIconChange alloc] initWithDelegate:self];
    NSArray *contentCheckArray2 = @[contentCheck2];
    
    self.passwordTextFieldDelegateObj = [[MCTextFieldDelegateObj alloc] initWithEditingCheckArray:nil contentCheckArray:contentCheckArray2];
    self.passwordTextField.delegate = self.passwordTextFieldDelegateObj;
    
    self.nicknameTextFieldDelegateObj.delegate = self;
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

- (void)registerViewBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)photoButtonClicked:(id)sender
{
    [self showPhotoSourceChoice];
}

- (IBAction)registerButtonClicked:(id)sender
{
    [self registerUserInfo];
}

- (void)registerUserInfo
{
    NSString *nickName = self.nicknameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    // 检查输入不允许为空
    if (([nickName length] < 1) || ([password length] < 1))
    {
        NSString *type = ([nickName length] < 1) ? @"昵称" : @"密码";
        NSString *tip = [NSString stringWithFormat:@"请输入%@", type];
        [[MCTipLabelHUD shareTipLabelHUD] showTipWithText:tip];
        return;
    }
    
    MCRegisterInfoRequestModel *requestModel = [MCRegisterInfoRequestModel new];
    requestModel.nickname = nickName;
    requestModel.phone = self.account;
    requestModel.pwd = password;
    requestModel.photoData = UIImageJPEGRepresentation(self.photoImage, 1.0);
    
    MCNetworkManager *networkManager = [MCNetworkManager new];
    networkManager.delegate = self;
    [networkManager userRegister:requestModel];
    
    // 加载等待界面
    [[MCLoadingHUD shareLoadingHUD] show];
}


- (void)showPhotoSourceChoice
{
    self.photoPicker = [[MCPhotoPicker alloc] initWithViewController:self];
    self.photoPicker.delegate = self;
    
    [self.photoPicker showPickerChoice];
}


#pragma mark - MCPhotoPickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didSelectImage:(UIImage *)image
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.photoImage = image;
    [self.photoButton setImage:image forState:UIControlStateNormal];
}

#pragma mark - MCNetworkManagerDelegate

- (void)registerSuccessWithUid:(NSString *)uid
{
    // 注册成功之后用返回的uid向服务器请求用户数据并保存到本地。
    
    MCNetworkManager *networkManager = [MCNetworkManager new];
    networkManager.delegate = self;
    [networkManager getUserInfoWithUid:uid];
}

- (void)registerSuccessFailureWithMessage:(NSString *)message
{
    [[MCLoadingHUD shareLoadingHUD] dismiss];
    
    [[MCTipLabelHUD shareTipLabelHUD] showTipWithText:message];
}

- (void)getUserInfoSuccessWithModel:(MCUserDatabaseModel *)model
{
    // 注册成功之后用uid请求用户数据成功。
    
    [[MCLoadingHUD shareLoadingHUD] dismiss];
    
    // 通过这种方式来取LoginViewController了。
    NSArray *viewControllers = [self.navigationController viewControllers];
    MCLoginViewController *loginViewController = nil;
    
    for (UIViewController *viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[MCLoginViewController class]])
        {
            loginViewController = (MCLoginViewController *)viewController;
            break;
        }
    }
    
    if (loginViewController)
    {
        [loginViewController.delegate loginViewController:loginViewController registerFinishWithResponseUserInfo:model];
    }
    else
    {
        MCLog(@"navigation栈里木有loginViewController！！");
    }
}

- (void)getUserInfoFailureWithMessage:(NSString *)message
{
    [[MCLoadingHUD shareLoadingHUD] dismiss];
    
    [[MCTipLabelHUD shareTipLabelHUD] showTipWithText:message];
}

#pragma mark - MCContentCheckIconChangeDelegate

- (void)needChangeTextField:(UITextField *)textField textEmpty:(BOOL)isEmpty
{
    CGFloat textFieldHeight = CGRectGetHeight(textField.frame);
    UIImage *image = nil;
    
    if (textField == self.nicknameTextField)
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
    if (textField == self.nicknameTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField)
    {
        [self registerUserInfo];
    }
}

@end
