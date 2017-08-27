//
//  MCUserViewController.m
//  MCRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCUserViewController.h"
#import "MCUserLevelView.h"
#import "MCUserSettingView.h"
#import "MCUserNoLoginView.h"
#import "MCLoginViewController.h"
#import "MCDataManager.h"
#import "MCUserInfoModel.h"
#import "MCUserInfoResponseModel.h"
#import "MCDatabaseManager.h"
#import "MCNetworkManager.h"
#import "MCRunDatabaseModel.h"
#import "MCUtilsMacro.h"
#import "MCModifyPasswordViewController.h"
#import "MCPhotoPicker.h"
#import "MCUserDatabaseModel.h"
#import "MCModelReformer.h"
#import "MCSetUserRequestModel.h"
#import "MCRunDataHandler.h"
#import "MCSettingsViewController.h"
#import "MCShareFunc.h"
#import "MCUserDataHandler.h"

@interface MCUserViewController () <MCUserNoLoginViewDelegate, MCLoginViewControllerDelegate, MCNetworkManagerDelegate, MCUserSettingViewDelegate, MCUserLevelViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MCPhotoPickerDelegate, MCRunDataHandlerDelegate, MCSettingsViewControllerDelegate, MCUserDataHandlerDelegate>

@property (nonatomic, weak) IBOutlet MCUserLevelView *userLevelView;
@property (nonatomic, weak) IBOutlet UIView *settingContentView;

@property (nonatomic, strong) MCUserSettingView *userSettingView;
@property (nonatomic, strong) MCUserNoLoginView *userNoLoginView;

@property (nonatomic, strong) MCPhotoPicker *photoPicker;
@property (nonatomic, strong) MCRunDataHandler *runDataHandler;
@property (nonatomic, strong) MCUserDataHandler *userDataHandler;

@end

@implementation MCUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    [self setupContentView];
    
    self.userLevelView.delegate = self;
    
    self.runDataHandler = [MCRunDataHandler new];
    self.runDataHandler.delegate = self;
    
    self.userDataHandler = [MCUserDataHandler new];
    self.userDataHandler.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 显示用户界面时设置用户数据
    [self setupUserLevel];
    [self changeViewWithLoginState:[self hasLogin]];
    
    [self.userSettingView reloadTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self resizeContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupContentView
{
    // 用户登录显示的界面
    NSArray *nibViews1 = [[NSBundle mainBundle] loadNibNamed:@"MCUserSettingView" owner:self options:nil];
    self.userSettingView = [nibViews1 objectAtIndex:0];
    self.userSettingView.delegate = self;
    
    [self.settingContentView addSubview:self.userSettingView];
    
    // 用户未登录时显示的界面
    NSArray *nibViews2 = [[NSBundle mainBundle] loadNibNamed:@"MCUserNoLoginView" owner:self options:nil];
    self.userNoLoginView = [nibViews2 objectAtIndex:0];
    self.userNoLoginView.delegate = self;
    
    [self.settingContentView addSubview:self.userNoLoginView];
}

- (void)resizeContentView
{
    CGRect frame = self.settingContentView.bounds;
    
    self.userSettingView.frame = frame;
    self.userNoLoginView.frame = frame;
}

- (void)resetUserLevel
{
    [[MCDataManager shareDataManager] resetData];
    [self setupUserLevel];
}

- (void)setupUserLevel
{
    // 放子线程执行了，否则开启APP时有可能会在这卡死。 2016.01.29
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        MCUserInfoModel *userInfo = [[MCDataManager shareDataManager] getUserInfo];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.userLevelView setUserName:userInfo.nickname
                                  headPhoto:userInfo.headImage
                                      grade:userInfo.grade
                               achieveTitle:userInfo.achieveTitle
                                   progress:userInfo.progress
                        upgradeRequireTimes:userInfo.upgradeRequireTimes];
        });
    });
}

- (BOOL)hasLogin
{
    return [[MCDataManager shareDataManager] isLogin];
}

- (void)enterLoginView
{
    MCLoginViewController *loginViewController = [MCLoginViewController new];
    loginViewController.delegate = self;
//    [self.navigationController pushViewController:loginViewController animated:YES];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    loginViewController.navigationController.navigationBarHidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)changeViewWithLoginState:(BOOL)isLogin
{
    if (isLogin)
    {
        [self.settingContentView bringSubviewToFront:self.userSettingView];
    }
    else
    {
        [self.settingContentView bringSubviewToFront:self.userNoLoginView];
    }
}

- (void)showPhotoSourceChoice
{
    self.photoPicker = [[MCPhotoPicker alloc] initWithViewController:self];
    self.photoPicker.delegate = self;
    
    [self.photoPicker showPickerChoice];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 接受点击事件，当在编辑用户昵称时，点击其他地方退出编辑转台收起键盘
    [super touchesBegan:touches withEvent:event];
    
    if ([self hasLogin])
    {
        // 登录情况下才能编辑用户昵称
        [self.view endEditing:YES];
    }
}

- (void)logout
{
    // 用户注销时，删除数据库用户数据，和用户所对应的跑步数据。
    MCDataManager *manager = [MCDataManager shareDataManager];
    
    MCDatabaseManager *databaseManager = [MCDatabaseManager new];
    [databaseManager deleteUserAndRelatedRunDataWithUid:[manager getUid]];
    
    // 数据库更新后重置数据。
    [self resetUserLevel];
    [self changeViewWithLoginState:NO];
    
    // 退出登录后取消第三方的授权
    [MCShareFunc cancelAuthorized];
    
    // 用户退出时日历界面的跑步数据需要刷新一次
    [self.delegate userViewUserStateChanged];
}

- (void)modifyPassword
{
    // 修改密码
    NSString *phoneNumber = [[MCDataManager shareDataManager] getUserPhone];
    
    MCModifyPasswordViewController *modifyPasswordViewController = [[MCModifyPasswordViewController alloc] initWithPhoneNumber:phoneNumber];
    
    [self presentViewController:modifyPasswordViewController animated:YES completion:nil];
}

- (void)showSettingsView
{
    // 跳转到设置界面
    MCSettingsViewController *settingViewController = [MCSettingsViewController new];
    settingViewController.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - MCUserNoLoginViewDelegate

- (void)login
{
    [self enterLoginView];
}

- (void)userNoLoginViewDidSelectedType:(MCSettingsType)type
{
    switch (type) {
        case MCSettingsTypeSet:
            [self showSettingsView];
            break;
            
        default:
            break;
    }
}

#pragma mark - MCLoginViewControllerDelegate

- (void)loginViewController:(MCLoginViewController *)loginViewController loginFinishWithUserInfoResponseModel:(MCUserInfoResponseModel *)userInfoResponseModel
{
    // 用户登录成功
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.runDataHandler loginSuccessWithUserInfoResponseModel:userInfoResponseModel];
    });
    
    [loginViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginViewController:(MCLoginViewController *)loginViewController registerFinishWithResponseUserInfo:(MCUserDatabaseModel *)userInfo
{
    // 用户注册成功，请求并返回用户信息，将用户保存到本地数据库，并上传未登录时的跑步数据。
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.runDataHandler registerSuccessWithResponseUserInfo:userInfo];
    });
    
    [loginViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MCNetworkManagerDelegate

// 设置信息
- (void)setInfoSuccess
{
    
}

- (void)setInfoFailureWithMessage:(NSString *)message
{
    MCLog(@"%@", message);
}

#pragma mark - MCRunDataHandlerDelegate

- (void)runDataHandleFinish
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self setupUserLevel];
        [self changeViewWithLoginState:[self hasLogin]];
        
        // 登录成功后刷新一下，否则昵称会因为时机上的问题仍然显示“未登录”
        if ([self hasLogin])
        {
            [self.userSettingView reloadTableView];
        }
        
        // 用户登录注册成功之后，跑步数据处理完成之后的回调，此时刷新一下日历界面的跑步数据，保证日历正确显示数据
        [self.delegate userViewUserStateChanged];
    });
}

#pragma mark - MCUserDataHandlerDelegate

- (void)uploadHeadImageFinish
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        MCUserInfoModel *userInfo = [[MCDataManager shareDataManager] getUserInfo];
        [self.userLevelView setHeadPhoto:userInfo.headImage];
    });
}

#pragma mark - MCUserSettingViewDelegate

- (void)userSettingViewDidSelectedType:(MCSettingsType)type
{
    switch (type) {
        case MCSettingsTypeSet:
            [self showSettingsView];
            break;
            
        default:
            break;
    }
}

- (void)modifyNickame:(NSString *)nickname
{
    // 修改用户昵称
    NSString *uid = [[MCDataManager shareDataManager] getUid];
    
    // 修改本地数据库数据
    MCDatabaseManager *databaseManager = [MCDatabaseManager new];
    [databaseManager setUser:uid withNickname:nickname];
    
    // 修改服务器数据
    MCSetUserRequestModel *setUserRequestModel = [MCSetUserRequestModel new];
    setUserRequestModel.uid = uid;
    setUserRequestModel.nickname = nickname;
    
    MCNetworkManager *networkManager = [MCNetworkManager new];
    networkManager.delegate = self;
    [networkManager setUserWithRequestModel:setUserRequestModel];
    
    [self resetUserLevel];
}

#pragma mark - MCUserLevelViewDelegate

- (void)headPhotoChange
{
    [self showPhotoSourceChoice];
}

- (void)toLogin
{
    [self login];
}

- (BOOL)loginState
{
    return [self hasLogin];
}

#pragma mark - MCPhotoPickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didSelectImage:(UIImage *)image
{
//    MCNetworkManager *networkManager = [MCNetworkManager new];
//    networkManager.delegate = self;
//    
//    NSString *uid = [[MCDataManager shareDataManager] getUid];
//    [networkManager uploadHeadImage:image uid:uid];
    
    if (image)
    {
        [self.userDataHandler uploadHeadImage:image];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MCSettingsViewControllerDelegate

- (void)settingsViewDidSelectedLogout
{
    [self logout];
}

@end
