//
//  MCRunViewController.m
//  MCRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCRunViewController.h"
#import "MCAppMacro.h"
#import "MCRunningRecordViewController.h"
#import "MCUserRecordView.h"
#import "MCDatabaseManager.h"
#import "MCUserInfoModel.h"
#import "MCDataManager.h"
#import "MCNetworkManager.h"
#import "MCRunDatabaseModel.h"
#import "MCBluetoothConnect.h"
#import "MCLoginViewController.h"
#import "MCModelReformer.h"
#import "MCUserInfoResponseModel.h"
#import "MCPhotoPicker.h"
#import "MCRunDataHandler.h"
#import "MCBLEHint.h"
#import "MCAppSettingsDefine.h"
#import "MCConfigManager.h"
#import "MCUserDataHandler.h"
#import "MCIconActionSheet.h"
#import "MCDevice.h"

@interface MCRunViewController () <MCNetworkManagerDelegate, MCUserRecordViewDelegate, MCLoginViewControllerDelegate, MCPhotoPickerDelegate, MCRunDataHandlerDelegate, MCBLEHintDelegate, MCUserDataHandlerDelegate, MCRunningRecordViewControllerDelegate>

@property (nonatomic, weak) IBOutlet MCUserRecordView *userRecordView;

@property (nonatomic, weak) IBOutlet UIButton *startRunningButton;
@property (nonatomic, weak) IBOutlet UIView *methodTipView;

@property (nonatomic, weak) IBOutlet UILabel *tipLabel1;
@property (nonatomic, weak) IBOutlet UILabel *tipLabel2;
@property (nonatomic, weak) IBOutlet UILabel *tipTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *greenLabel;

@property (nonatomic, strong) MCPhotoPicker *photoPicker;
@property (nonatomic, strong) MCRunDataHandler *runDataHandler;
@property (nonatomic, strong) MCUserDataHandler *userDataHandler;

@property (nonatomic, strong) MCBLEHint *hint;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *runningButtonHeightConstraint;

@end

@implementation MCRunViewController

- (void)dealloc
{
    [[MCBluetoothConnect shareBluetoothConnect] removeHeartRateObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.startRunningButton.backgroundColor = GreenBackgroundColor;
    self.view.backgroundColor = LightgrayBackgroundColor;
    self.methodTipView.backgroundColor = RGB(231, 231, 231);
    
    [self setupTipLabel];
    self.navigationController.navigationBarHidden = YES;
    
    self.startRunningButton.layer.cornerRadius = ButtonCornerRadius;
    self.startRunningButton.clipsToBounds = YES;
    
    self.runDataHandler = [MCRunDataHandler new];
    self.runDataHandler.delegate = self;
    
    self.userDataHandler = [MCUserDataHandler new];
    self.userDataHandler.delegate = self;
    
    self.userRecordView.delegate = self;
    
    // 每次进入应用同步跑步数据
    // 数据库操作换成队列执行之后，这些操作可以放到子线程里执行。    2015.12.31
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.runDataHandler synchronizeRunData];
    });
    
    self.hint = [MCBLEHint new];
    self.hint.delegate = self;
    
    if ([MCDevice isPhone6Plus])
    {
        self.runningButtonHeightConstraint.constant = 52;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 每次显示时从数据库取一次数据。后续优化
//    [self setupUserRecord];
    
    // setupUserRecord的第一次初始化会导致阻塞主线程，放子线程里执行。  2016-01-13
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        MCUserInfoModel *userInfo = [[MCDataManager shareDataManager] getUserInfo];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.userRecordView setUserName:userInfo.nickname
                                   headPhoto:userInfo.headImage
                               totalDistance:userInfo.totalDistance
                               totalRunTimes:userInfo.totalRunTimes
                                   totalTime:userInfo.totalUseTime];
        });
        
    });
}

- (void)viewDidLayoutSubviews
{
    // 是否显示蓝牙连接面板，视图控制器每次显示时更新一次
    [self.userRecordView setBLEContentViewHidden:[MCConfigManager heartRatePanelHidden]];
    
    // 放在这里进行调整
    self.greenLabel.layer.cornerRadius = CGRectGetHeight(self.greenLabel.frame) / 2;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupUserRecord
{
    MCUserInfoModel *userInfo = [[MCDataManager shareDataManager] getUserInfo];
    
    [self.userRecordView setUserName:userInfo.nickname
                           headPhoto:userInfo.headImage
                       totalDistance:userInfo.totalDistance
                       totalRunTimes:userInfo.totalRunTimes
                           totalTime:userInfo.totalUseTime];
}

- (void)setupTipLabel
{
    UIColor *textColor = RGB(79, 79, 79);
    
    self.tipLabel1.text = @" 1.请保持40分钟以上的运动时间";
    self.tipLabel1.textColor = textColor;
    self.tipLabel1.adjustsFontSizeToFitWidth = YES;
    
    self.tipLabel2.text = @" 2.不要跑太快，心率保持在140-160之间";
    self.tipLabel2.textColor = textColor;
    self.tipLabel2.adjustsFontSizeToFitWidth = YES;
    
    self.tipTitleLabel.text = @"跑步减肥方法 ";
    self.tipTitleLabel.textColor = textColor;
    self.tipTitleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.greenLabel.text = @" 基于MAF180训练法>  ";
    self.greenLabel.textColor = GreenBackgroundColor;
    
    self.greenLabel.layer.borderWidth = 1;
    self.greenLabel.layer.borderColor = GreenBackgroundColor.CGColor;
    self.greenLabel.layer.cornerRadius = CGRectGetHeight(self.greenLabel.frame) / 2;
    self.greenLabel.backgroundColor = RGB(211, 230, 221);
    self.greenLabel.clipsToBounds = YES;
    
    // 绿色标签点击跳转到网页
    self.greenLabel.adjustsFontSizeToFitWidth = YES;
    self.greenLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGreenLabel:)];
    tap.numberOfTapsRequired = 1;
    [self.greenLabel addGestureRecognizer:tap];
    
    // 根据屏幕尺寸调节标签字体大小
    CGFloat tipTitleLabelFontSize = 12;
    CGFloat greenLabelFontSize = 9;
    CGFloat tipLabelFontSize = 11;
    if ([MCDevice isPhone6Plus])
    {
        tipTitleLabelFontSize = 18;
        greenLabelFontSize = 15;
        tipLabelFontSize = 17;
    }
    
    self.tipTitleLabel.font = [UIFont systemFontOfSize:tipTitleLabelFontSize];
    self.greenLabel.font = [UIFont systemFontOfSize:greenLabelFontSize];
    self.tipLabel2.font = [UIFont systemFontOfSize:tipLabelFontSize];
    self.tipLabel1.font = [UIFont systemFontOfSize:tipLabelFontSize];
}

- (void)tapGreenLabel:(UITapGestureRecognizer *)gesture
{
    NSURL *url = [NSURL URLWithString:@"http://s.p.qq.com/pub/jump?d=AAAWBM4B"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)startRunning:(id)sender
{    
    if ([self needShowConnectPrompt])
    {
        [self.hint showConnectHint];
    }
    else
    {
        [self run];
    }
}

- (void)run
{
    // 开始跑步
    MCRunningRecordViewController *runningRecordViewController = [MCRunningRecordViewController new];
    runningRecordViewController.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:runningRecordViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (BOOL)needShowConnectPrompt
{
    BOOL need = ![MCConfigManager BLEConnectPromptHidden] && ![[MCBluetoothConnect shareBluetoothConnect] hasConnectPeripheral];
    return need;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:MCBluetoothConnectHeartRateKey])
    {
        // 监听心率
        NSInteger heartRate = [[change valueForKey:@"new"] integerValue];
        [self.userRecordView updateHeartRateWithValue:heartRate];
    }
}

- (void)login
{
    MCLoginViewController *loginViewController = [MCLoginViewController new];
    loginViewController.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    loginViewController.navigationController.navigationBarHidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)changeHeadPhoto
{
    self.photoPicker = [[MCPhotoPicker alloc] initWithViewController:self];
    self.photoPicker.delegate = self;
    
    [self.photoPicker showPickerChoice];
}

- (void)connectHeartRatePeripherals
{
    // 连接心率外设
    
    // 外设扫描超结果回调
    MCBLEConnectPeripheralStateBlock connectStateCallback = ^(BOOL connectState){
        if (connectState)
        {
            // 连接成功
            dispatch_async(dispatch_get_main_queue(), ^(){
                [self.userRecordView setBLEContentWithState:MCBLEContentViewStateHeartRateCounting];
            });
        }
        else
        {
            // 扫描设备超时,显示连接失败提示
            [self.hint showConnectFailureHint];
            [self.userRecordView setBLEContentWithState:MCBLEContentViewStateDeviceConnect];
        }
    };
    
    MCExameBluetoothStateBlock examCallback = ^(BOOL powerOn){
        // 未打开蓝牙连接
        if (!powerOn)
        {
            dispatch_async(dispatch_get_main_queue(), ^(){
                [self.userRecordView setBLEContentWithState:MCBLEContentViewStateDeviceConnect];
            });
        }
    };
    
    MCBluetoothConnect *bluetoothConnect = [MCBluetoothConnect shareBluetoothConnect];
    [bluetoothConnect addHeartRateObserver:self];
    [bluetoothConnect connectPeripheralWithStateCallback:connectStateCallback examBLECallback:examCallback];
}

#pragma mark - MCNetworkManagerDelegate

//- (void)uploadHeadImageSuccessWithPath:(NSString *)path
//{
//    // 头像上传成功，修改数据库用户头像的路径，并更新界面。
//    NSString *uid = [[MCDataManager shareDataManager] getUid];
//    
//    MCDatabaseManager *databaseManager = [MCDatabaseManager new];
//    [databaseManager setUser:uid withHeadImagePath:path];
//    
//    [[MCDataManager shareDataManager] resetData];
//    [self setupUserRecord];
//}

#pragma mark - MCUserRecordViewDelegate

- (void)tapUserHead
{
    BOOL isLogin = [[MCDataManager shareDataManager] isLogin];
    if (isLogin)
    {
        [self changeHeadPhoto];
    }
    else
    {
        [self login];
    }
}

- (void)touchBLEConnectButton
{
    [self connectHeartRatePeripherals];
    [self.userRecordView setBLEContentWithState:MCBLEContentViewStateConnecting];
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(){
        [self.runDataHandler registerSuccessWithResponseUserInfo:userInfo];
    });
    
    [loginViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MCRunDataHandlerDelegate

- (void)runDataHandleFinish
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self setupUserRecord];
        
        // 用户登录注册成功之后，跑步数据处理完成之后的回调，此时刷新一下日历界面的跑步数据，保证日历正确显示数据
        [self.delegate runViewUserStateChanged];
    });
}

#pragma mark - MCUserDataHandlerDelegate

- (void)uploadHeadImageFinish
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self setupUserRecord];
    });
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

#pragma mark - MCBLEHintDelegate

- (void)BLEConnect
{
    [self connectHeartRatePeripherals];
    [self.userRecordView setBLEContentWithState:MCBLEContentViewStateConnecting];
}

- (void)runDirectly
{
    [self run];
}

#pragma mark - MCRunningRecordViewControllerDelegate

- (void)runningRecordFinish
{
    [self.delegate runningFinish];
}

@end
