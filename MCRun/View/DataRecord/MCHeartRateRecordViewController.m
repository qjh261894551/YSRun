//
//  MCHeartRateRecordViewController.m
//  MCRun
//
//  Created by moshuqi on 15/11/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCHeartRateRecordViewController.h"
#import "MCDataRecordBar.h"
#import "MCBarChart.h"
#import "MCAppMacro.h"
#import "MCHeartRateRecordCommentView.h"
//#import "MCGraphData.h"
#import "MCStatisticsDefine.h"
#import "MCHeartRateGraphView.h"
#import "MCMarkLabelsView.h"
#import "MCDataRecordModel.h"
#import "MCTimeFunc.h"
#import "NSDate+MCDateLogic.h"
#import "MCMapPaintFunc.h"
#import "MCDevice.h"
#import <MAMapKit/MAMapKit.h>

@interface MCHeartRateRecordViewController () <MCDataRecordBarDelegate>

@property (nonatomic, weak) IBOutlet MCDataRecordBar *bar;
//@property (nonatomic, weak) IBOutlet UIImageView *mapImageView;     // 地图路径截图
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;            // 地图左下角日期标签
@property (nonatomic, weak) IBOutlet MAMapView *mapView;

@property (nonatomic, weak) IBOutlet MCMarkLabelsView *dataMarkLabels;
@property (nonatomic, weak) IBOutlet MCMarkLabelsView *heartRateMarkLabels;

@property (nonatomic, weak) IBOutlet MCHeartRateRecordCommentView *commentView;
@property (nonatomic, weak) IBOutlet MCBarChart *barChart;
@property (nonatomic, weak) IBOutlet MCHeartRateGraphView *heartRateGraphView;
@property (nonatomic, weak) IBOutlet UIView *line;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *dataLabelsHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *heartRateLabelsHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *dataLabelsTopToMapContentConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *dataLabelsBottomToHeartRatLabelsConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *heartRateLabelsBottomToBarChartConstraint;

@property (nonatomic, strong) MCDataRecordModel *dataRecordModel;
@property (nonatomic, strong) MCMapPaintFunc *mapPaintFunc;

@end

@implementation MCHeartRateRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.line.backgroundColor = RGB(235, 235, 235);
    self.bar.delegate = self;
    
    [self setupMarkLabelsView];
    [self setupDateLabel];
    
    [self setupCommentView];
    [self resetWithDataModel:self.dataRecordModel];
    
    [self.bar setBarTitle:@"心率数据"];
    
}

- (id)initWithDataRecordModel:(MCDataRecordModel *)dataRecordModel
{
    self = [super init];
    if (self)
    {
        self.dataRecordModel = dataRecordModel;
        self.mapPaintFunc = [MCMapPaintFunc new];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self resetWithDataModel:self.dataRecordModel];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.barChart setChartElementVisible:NO percentVisible:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupMarkLabelsView
{
    [self.dataMarkLabels setLeftLabelMarkText:@"距离(公里)"];
    [self.dataMarkLabels setCenterLabelMarkText:@"时长"];
    [self.dataMarkLabels setRightLabelMarkText:@"大卡"];
    
    [self.heartRateMarkLabels setLeftLabelMarkText:@"高效减脂"];
    [self.heartRateMarkLabels setCenterLabelMarkText:@"简单慢跑"];
    [self.heartRateMarkLabels setRightLabelMarkText:@"无氧运动"];
    
    CGFloat contentFontSize = 16;
    CGFloat markFontSize = 10;
    UIColor *contentColor = RGB(38, 38, 38);
    UIColor *markColor = RGB(136, 136, 136);
    
    if ([MCDevice isPhone6Plus])
    {
        contentFontSize = 18;
        markFontSize = 12;
        
        CGFloat labelsHeight = 48;
        self.dataLabelsHeightConstraint.constant = labelsHeight;
        self.heartRateLabelsHeightConstraint.constant = labelsHeight;
        
        CGFloat distance = 15;
        self.dataLabelsTopToMapContentConstraint.constant = distance;
        self.dataLabelsBottomToHeartRatLabelsConstraint.constant = distance;
        self.heartRateLabelsBottomToBarChartConstraint.constant = distance;
    }
    
    [self.dataMarkLabels setContentTextBoldWithFontSize:contentFontSize];
    [self.dataMarkLabels setMarkTextFontSize:markFontSize];
    [self.dataMarkLabels setContentTextColor:contentColor];
    [self.dataMarkLabels setMarkTextColor:markColor];
    
    [self.heartRateMarkLabels setContentTextBoldWithFontSize:contentFontSize];
    [self.heartRateMarkLabels setMarkTextFontSize:markFontSize];
    [self.heartRateMarkLabels setContentTextColor:contentColor];
    [self.heartRateMarkLabels setMarkTextColor:markColor];
}

- (void)setupDateLabel
{
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    
    self.dateLabel.backgroundColor = RGBA(4, 181, 108, 0.25);
    self.dateLabel.layer.cornerRadius = 3;
    self.dateLabel.clipsToBounds = YES;
}

- (void)setupCommentView
{
    [self.commentView setLeftCommentElementColor:JoggingColor text:@"<140"];
    [self.commentView setCenterCommentElementColor:EfficientReduceFatColor text:@"140~160"];
    [self.commentView setRightCommentElementColor:AnaerobicExerciseColor text:@">160"];
    
    [self.commentView setFontSize:12];
}

- (MCChartData *)chartDataWithDictDataArray:(NSArray *)dataArray
{
    NSInteger topQuantity = 0;
    NSInteger middleQuantity = 0;
    NSInteger bottomQuantity = 0;
    
    for (NSDictionary *dict in dataArray)
    {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSInteger heartRate = [[dict valueForKey:MCGraphDataHeartRateKey] integerValue];
            if (heartRate > MCGraphDataMiddleSectionMax)
            {
                topQuantity++;
            }
            else if (heartRate < MCGraphDataMiddleSectionMin)
            {
                bottomQuantity++;
            }
            else
            {
                middleQuantity++;
            }
        }
    }
    
    MCChartElement *element1 = [MCChartElement new];
    element1.elementName = @"简单慢跑";
    element1.color = JoggingColor;
    element1.quantity = bottomQuantity;
    
    MCChartElement *element2 = [MCChartElement new];
    element2.elementName = @"高效减脂";
    element2.color = EfficientReduceFatColor;
    element2.quantity = middleQuantity;
    
    MCChartElement *element3 = [MCChartElement new];
    element3.elementName = @"无氧运动";
    element3.color = AnaerobicExerciseColor;
    element3.quantity = topQuantity;
    
    NSArray *elementArray = @[element1, element2, element3];
    MCChartData *chartData = [[MCChartData alloc] initWithElementArray:elementArray];
    
    return chartData;
}

//- (MCDataRecordModel *)testHeartRateDataModel
//{
//    MCDataRecordModel *dataModel = [MCDataRecordModel new];
//    dataModel.startTime = 1448525595;
//    dataModel.endTime = 1448526595;
//    
//    dataModel.calorie = 999;
//    dataModel.distance = 9.09;
//    
//    dataModel.heartRateArray = [self testHeartRateArray];
//    dataModel.mapImage = [UIImage imageNamed:@"backgound_image1"];
//    
//    return dataModel;
//}
//
//- (NSArray *)testHeartRateArray
//{
//    // 测试数据
//    NSMutableArray *testHeartRateArray = [NSMutableArray array];
//    NSInteger count = 50;
//    for (NSInteger i = 0; i < count; i++)
//    {
//        NSInteger heartRate = (arc4random() % (MCGraphDataOrdinateMax - MCGraphDataOrdinateMin)) + MCGraphDataOrdinateMin;
//        [testHeartRateArray addObject:[NSNumber numberWithInteger:heartRate]];
//    }
//    
//    return testHeartRateArray;
//}

- (void)resetWithDataModel:(MCDataRecordModel *)dataModel
{
    // 地图图片，时间标签
//    [self setMapScreenshotWithLocationArray:dataModel.locationArray];
    
    [self.mapPaintFunc drawPathWithAnnotationArray:dataModel.locationArray inMapView:self.mapView];
    
    self.dateLabel.text = [MCTimeFunc dateStrFromTimestamp:dataModel.endTime];
    
    [self setupMarkLabelsWith:dataModel];
    
    // 必须保证一定存在心率数据
    if ([dataModel.heartRateArray count] > 0)
    {
        MCChartData *chartData = [self getChartData];
        [self.barChart setupWithChartData:chartData];
        self.barChart.layer.cornerRadius = 5;
        self.barChart.clipsToBounds = YES;
    }
    
    // 必须保证一定存在心率数据
    NSArray *dictDataArray = [self dictDataArrayWithHeartRates:dataModel.heartRateArray];
    if ([dictDataArray count] > 0)
    {
        [self.heartRateGraphView setupWithStartTime:dataModel.startTime endTime:dataModel.endTime dictDataArray:dictDataArray];
    }
}

//- (void)setMapScreenshotWithLocationArray:(NSArray *)locationArray
//{
////    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
////        CGSize size = self.mapImageView.bounds.size;
////        self.screenshotPaint = [MCMapPaintFunc new];
////        
////        UIImage *image = [self.screenshotPaint screenshotWithAnnotationArray:locationArray size:size];
////        dispatch_async(dispatch_get_main_queue(), ^(){
////            self.mapImageView.image = image;
////        });
////        
////    });
//    
//    // 会卡，后续优化。
//    CGSize size = self.mapImageView.bounds.size;
//    self.screenshotPaint = [MCMapPaintFunc new];
//    
//    UIImage *image = [self.screenshotPaint screenshotWithAnnotationArray:locationArray size:size];
//    self.mapImageView.image = image;
//}

- (void)setupMarkLabelsWith:(MCDataRecordModel *)dataModel
{
    NSInteger useTime = dataModel.endTime - dataModel.startTime;
    MCChartData *chartData = [self getChartData];
    
    // 距离、时间、卡路里消耗数据
    [self.dataMarkLabels setLeftLabelContentText:[NSString stringWithFormat:@"%.2f", dataModel.distance / 1000]];
    NSString *timeStr = [MCTimeFunc timeStrFromUseTime:useTime];
    [self.dataMarkLabels setCenterLabelContentText:timeStr];
    [self.dataMarkLabels setRightLabelContentText:[NSString stringWithFormat:@"%@", @(dataModel.calorie)]];
    
    // 各个心率区间所占时间数据
    CGFloat joggingPercent = [chartData getElementPercentAtIndex:0];
    CGFloat efficientReduceFatPercent = [chartData getElementPercentAtIndex:1];
    CGFloat anaerobicExercisePercent = [chartData getElementPercentAtIndex:2];
    
    NSInteger joggingTime = (NSInteger)(useTime * joggingPercent);
    NSInteger efficientReduceFatTime = (NSInteger)(useTime * efficientReduceFatPercent);
    NSInteger anaerobicExerciseTime = (NSInteger)(useTime * anaerobicExercisePercent);
    
    [self.heartRateMarkLabels setLeftLabelContentText:[MCTimeFunc timeStrFromUseTime:joggingTime]];
    [self.heartRateMarkLabels setCenterLabelContentText:[MCTimeFunc timeStrFromUseTime:efficientReduceFatTime]];
    [self.heartRateMarkLabels setRightLabelContentText:[MCTimeFunc timeStrFromUseTime:anaerobicExerciseTime]];
}

- (NSArray *)dictDataArrayWithHeartRates:(NSArray *)heartRates
{
    // heartRates里包含记录的心率数据
    
    NSMutableArray *chartDataArray = [NSMutableArray array];
    NSInteger count = [heartRates count];
    for (NSInteger i = 0; i < count; i++)
    {
        NSInteger timestamp = i;    //
        
        NSDictionary *dict = @{MCGraphDataHeartRateKey : heartRates[i],
                               MCGraphDataTimestampKey : [NSNumber numberWithInteger:timestamp]};
        [chartDataArray addObject:dict];
    }
    
    return chartDataArray;
}

- (MCChartData *)getChartData
{
    return [self getChartDataWithHeartRateArray:self.dataRecordModel.heartRateArray];
}

- (MCChartData *)getChartDataWithHeartRateArray:(NSArray *)heartRateArray
{
    NSArray *dictDataArray = [self dictDataArrayWithHeartRates:heartRateArray];
    MCChartData *chartData = [self chartDataWithDictDataArray:dictDataArray];
    
    return chartData;
}

#pragma mark - MCDataRecordBarDelegate

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

@end
