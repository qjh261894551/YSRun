//
//  MCRunningResultViewController.m
//  MCRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCRunningResultViewController.h"
#import "MCResultRecordView.h"
#import "MCAppMacro.h"
#import "MCMapManager.h"
#import "MCRunInfoModel.h"
#import "MCShareFunc.h"
#import "MCMapPaintFunc.h"
#import "MCDataRecordModel.h"
#import "MCHeartRateRecordViewController.h"
#import "MCRunDataRecordViewController.h"
#import "MCModelReformer.h"
#import <MAMapKit/MAMapKit.h>
#import "MCSportRecordViewController.h"

@interface MCRunningResultViewController () <MCResultRecordViewDelegate>

@property (nonatomic, weak) IBOutlet MCResultRecordView *resultRecordView;
//@property (nonatomic, weak) IBOutlet UIButton *returnButton;
//@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIView *mapContentView;
@property (nonatomic, weak) IBOutlet MAMapView *mapView;

@property (nonatomic, strong) MCMapManager *mapManager;
@property (nonatomic, strong) MCRunInfoModel *runInfoModel;

@property (nonatomic, strong) MCMapPaintFunc *mapPaintFunc;
@property (nonatomic, strong) UIImage *screenshotImage;

@end

@implementation MCRunningResultViewController

- (id)initWithRunData:(MCRunInfoModel *)runInfoModel
{
    self = [super init];
    if (self)
    {
        self.runInfoModel = runInfoModel;
        self.mapPaintFunc = [MCMapPaintFunc new];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupButtons];
    
    [self.resultRecordView setupRecordWith:self.runInfoModel];
    self.resultRecordView.delegate = self;
    
    [self.mapPaintFunc drawPathWithAnnotationArray:self.runInfoModel.locationArray inMapView:self.mapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.mapPaintFunc drawPathWithAnnotationArray:self.runInfoModel.locationArray inMapView:self.mapView];
//    [self addMapBackgroundImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupButtons
{
//    self.returnButton.backgroundColor = GreenBackgroundColor;
//    self.returnButton.layer.cornerRadius = ButtonCornerRadius;
//    self.returnButton.clipsToBounds = YES;
    
//    self.shareButton.backgroundColor = GreenBackgroundColor;
//    self.shareButton.layer.cornerRadius = ButtonCornerRadius;
//    self.shareButton.clipsToBounds = YES;
}

//- (void)addMapBackgroundImageView
//{
//    CGSize size = self.mapContentView.bounds.size;
//    
//    self.paint = [MCMapPaintFunc new];
//    self.screenshotImage = [self.paint screenshotWithAnnotationArray:self.runInfoModel.locationArray size:size];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.screenshotImage];
//    imageView.frame = self.mapContentView.bounds;
//    
//    [self.mapContentView addSubview:imageView];
//    [self.mapContentView sendSubviewToBack:imageView];
//}

- (IBAction)returnButtonClicked:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButtonClicked:(id)sender
{
    // 分享的回调处理
    ShareFuncCallbackBlock callbackBlock = ^(MCShareFuncResponseState state)
    {
        // 分享成功则返回到主界面
        if (state == MCShareFuncResponseStateSuccess)
        {
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        }
    };
    
    MCShareInfo *shareInfo = [MCShareInfo defaultShareInfoWithImages:@[self.screenshotImage]];
    [MCShareFunc shareInfo:shareInfo fromView:self.view callbackBlock:callbackBlock];
}

- (IBAction)showDetail:(id)sender
{
    MCSportRecordViewController *sportRecordViewController = [[MCSportRecordViewController alloc] initWithDataRecordModel:[self getRecordModel]];
    [self.navigationController pushViewController:sportRecordViewController animated:YES];
}

- (MCDataRecordModel *)getRecordModel
{
    MCDataRecordModel *recordModel = [MCModelReformer dataRecordModelFromRunInfoModel:self.runInfoModel];
    return recordModel;
}

#pragma mark - MCResultRecordViewDelegate

- (void)showRunDataDetail
{
    MCRunDataRecordViewController *viewController = [[MCRunDataRecordViewController alloc] initWithDataRecordModel:[self getRecordModel]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showHeartRateDataDetail
{
    MCHeartRateRecordViewController *viewController = [[MCHeartRateRecordViewController alloc] initWithDataRecordModel:[self getRecordModel]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)resultRecordViewBack
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
