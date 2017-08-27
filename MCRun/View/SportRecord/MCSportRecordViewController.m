//
//  MCSportRecordViewController.m
//  MCRun
//
//  Created by moshuqi on 16/1/21.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "MCSportRecordViewController.h"
#import "HTHorizontalSelectionList.h"
#import "MCNavigationBarView.h"
#import "MCAppMacro.h"
#import "MCDetailDataView.h"
#import "MCHeartRateDataView.h"
#import "MCLocusView.h"
#import "MCPaceView.h"
#import "MCDataRecordModel.h"
#import "MCNoHeartRateDataView.h"
#import "MCShareViewController.h"
#import "MCMapAnnotation.h"
#import "MCShareFunc.h"

typedef NS_ENUM(NSInteger, MCSportRecordType)
{
    MCSportRecordTypeLocus = 0,
    MCSportRecordTypeDetail = 1,
    MCSportRecordTypePace = 2,
    MCSportRecordTypeHeartRate = 3
};

@interface MCSportRecordViewController () <HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource>

@property (nonatomic, weak) IBOutlet HTHorizontalSelectionList *selectionList;
@property (nonatomic, weak) IBOutlet MCNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, strong) NSArray *contentList;
@property (nonatomic, assign) MCSportRecordType *currentType;
@property (nonatomic, strong) MCDataRecordModel *dataRecordModel;

@property (nonatomic, strong) MCLocusView *locusView;
@property (nonatomic, strong) MCDetailDataView *detailDataView;
@property (nonatomic, strong) MCPaceView *paceView;

@property (nonatomic, strong) UIView *heartRateView;    // 根据是否有心率数据显示对应视图

@end

@implementation MCSportRecordViewController

- (id)initWithDataRecordModel:(MCDataRecordModel *)dataRecordModel
{
    self = [super init];
    if (self)
    {
        self.dataRecordModel = dataRecordModel;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES; 
    
    [self.navigationBarView setupWithTitle:@"运动记录" target:self action:@selector(viewBack)];
    
    // 本地安装有对应客户端才显示分享按钮
    if ([MCShareFunc hasClientInstalled])
    {
        UIImage *shareImage = [UIImage imageNamed:@"heart_rate_share"];
        [self.navigationBarView setRightButtonWithImage:shareImage target:self action:@selector(shareButtonClicked:)];
    }
    
    self.selectionList.delegate = self;
    self.selectionList.dataSource = self;
    self.selectionList.selectionIndicatorColor = GreenBackgroundColor;

    self.contentList = @[@(MCSportRecordTypeLocus), @(MCSportRecordTypeDetail),
                         @(MCSportRecordTypePace), @(MCSportRecordTypeHeartRate)];
    
    [self setupViews];
    
    // 第一次进入时默认显示路径视图
    [self showContentViewWithType:MCSportRecordTypeLocus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    if ([self.heartRateView isKindOfClass:[MCHeartRateDataView class]])
//    {
//        [(MCHeartRateDataView *)self.heartRateView showPercentValue];
//    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewBack
{
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)shareButtonClicked:(id)sender
{
    UIImage *mapImage = [self.locusView getMapScreenShot];
    MCShareViewController *shareViewController = [[MCShareViewController alloc] initWithDataRecordModel:self.dataRecordModel mapImage:mapImage];
    
    [self presentViewController:shareViewController animated:YES completion:nil];
}

- (void)setupViews
{
    // 初始化每个视图
    self.locusView = [[[UINib nibWithNibName:@"MCLocusView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self.locusView setupWithDataRecordModel:self.dataRecordModel];
    
    self.detailDataView = [[[UINib nibWithNibName:@"MCDetailDataView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self.detailDataView setupWithDataRecordModel:self.dataRecordModel];
    
    self.paceView = [[[UINib nibWithNibName:@"MCPaceView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self.paceView setupWithDataRecordModel:self.dataRecordModel];
    
    // 心率界面
    if ([self.dataRecordModel.heartRateArray count] > 0)
    {
        self.heartRateView = [[[UINib nibWithNibName:@"MCHeartRateDataView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        [(MCHeartRateDataView *)self.heartRateView setupWithDataRecordModel:self.dataRecordModel];
    }
    else
    {
        self.heartRateView = [[[UINib nibWithNibName:@"MCNoHeartRateDataView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    
    [self.contentView addSubview:self.locusView];
    [self.contentView addSubview:self.detailDataView];
    [self.contentView addSubview:self.paceView];
    [self.contentView addSubview:self.heartRateView];
}

- (NSString *)getStringWithSportRecordType:(MCSportRecordType)type
{
    NSString *string = nil;
    switch (type)
    {
        case MCSportRecordTypeLocus: // 轨迹
            string = @"轨迹";
            break;
            
        case MCSportRecordTypeDetail: // 详情
            string = @"详情";
            break;
            
        case MCSportRecordTypePace: // 配速
            string = @"配速";
            break;
            
        case MCSportRecordTypeHeartRate: // 心率
            string = @"心率";
            break;
            
        default:
            break;
    }
    
    return string;
}

- (void)showContentViewWithType:(MCSportRecordType)type
{
    UIView *view = nil;
    switch (type)
    {
        case MCSportRecordTypeLocus: // 轨迹
            view = self.locusView;
            break;
            
        case MCSportRecordTypeDetail: // 详情
            view = self.detailDataView;
            break;
            
        case MCSportRecordTypePace: // 配速
            view = self.paceView;
            break;
            
        case MCSportRecordTypeHeartRate: // 心率
            view = self.heartRateView;
            break;
            
        default:
            break;
    }
    
    view.frame = self.contentView.bounds;
    [self.contentView bringSubviewToFront:view];
}

- (void)didSelectedViewType:(MCSportRecordType)type
{
    [self showContentViewWithType:type];
}

#pragma mark - HTHorizontalSelectionListDataSource

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList
{
    return self.contentList.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index
{
    MCSportRecordType type = (MCSportRecordType)[self.contentList[index] integerValue];
    NSString *title = [self getStringWithSportRecordType:type];
    
    return title;
}

#pragma mark - HTHorizontalSelectionListDelegate

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index
{
    MCSportRecordType type = (MCSportRecordType)[self.contentList[index] integerValue];
    [self didSelectedViewType:type];
}

@end
