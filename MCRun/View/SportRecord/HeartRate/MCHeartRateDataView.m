//
//  MCHeartRateDataView.m
//  MCRun
//
//  Created by moshuqi on 16/1/25.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "MCHeartRateDataView.h"
#import "MCMarkLabelsView.h"
#import "MCHeartRateRecordCommentView.h"
#import "MCBarChart.h"
#import "MCHeartRateGraphView.h"
#import "MCAppMacro.h"
#import "MCStatisticsDefine.h"
#import "MCDataRecordModel.h"
#import "MCTimeFunc.h"
#import "MCPopView.h"
#import "MCContentHelpView.h"

@interface MCHeartRateDataView () <MCHeartRateGraphViewDelegate>

@property (nonatomic, weak) IBOutlet MCMarkLabelsView *labelsView;
@property (nonatomic, weak) IBOutlet MCHeartRateRecordCommentView *commentView;
@property (nonatomic, weak) IBOutlet MCBarChart *barChart;
@property (nonatomic, weak) IBOutlet MCHeartRateGraphView *graphView;
@property (nonatomic, weak) IBOutlet UIView *line;
@property (nonatomic, weak) IBOutlet UILabel *label;    // “心率达标率”标签

@property (nonatomic, weak) IBOutlet UIView *contentView;   // labelsView的父视图

@property (nonatomic, strong) MCDataRecordModel *dataRecordModel;

@end

@implementation MCHeartRateDataView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupMarkLabelsView];
    [self setupCommentView];
    
    self.label.text = @"心率达标率";
    self.label.textColor = [self textColor];
    self.label.font = [UIFont systemFontOfSize:12];
    
    self.line.backgroundColor = LightgrayBackgroundColor;
}

- (void)setupMarkLabelsView
{
    // 设置字体大小、颜色
    [self.labelsView setLeftLabelMarkText:@"高效减脂"];
    [self.labelsView setCenterLabelMarkText:@"简单慢跑"];
    [self.labelsView setRightLabelMarkText:@"无氧运动"];
    
    CGFloat contentFontSize = 16;
    CGFloat markFontSize = 10;
    UIColor *contentColor = RGB(80, 80, 80);
    UIColor *markColor = RGB(121, 121, 121);
    
    [self.labelsView setContentTextBoldWithFontSize:contentFontSize];
    [self.labelsView setMarkTextFontSize:markFontSize];
    [self.labelsView setContentTextColor:contentColor];
    [self.labelsView setMarkTextColor:markColor];
    
    // 数据标签的背景色设置
    self.contentView.backgroundColor = LightgrayBackgroundColor;
}

- (void)setupCommentView
{
    [self.commentView setLeftCommentElementColor:JoggingColor text:@"<140"];
    [self.commentView setCenterCommentElementColor:EfficientReduceFatColor text:@"140~160"];
    [self.commentView setRightCommentElementColor:AnaerobicExerciseColor text:@">160"];
    
    [self.commentView setFontSize:12];
}

- (void)setupWithDataRecordModel:(MCDataRecordModel *)dataRecordModel
{
    self.dataRecordModel = dataRecordModel;
    
    [self setupLabelsWith:dataRecordModel];
    
    // 必须保证一定存在心率数据
    if ([dataRecordModel.heartRateArray count] > 0)
    {
        MCChartData *chartData = [self getChartData];
        [self.barChart setupWithChartData:chartData];
        self.barChart.layer.cornerRadius = 5;
        self.barChart.clipsToBounds = YES;
    }
    
    // 必须保证一定存在心率数据
    NSArray *dictDataArray = [self dictDataArrayWithHeartRates:dataRecordModel.heartRateArray];
    if ([dictDataArray count] > 0)
    {
        [self.graphView setupWithStartTime:dataRecordModel.startTime endTime:dataRecordModel.endTime dictDataArray:dictDataArray];
        self.graphView.delegate = self;
    }
}

- (void)setupLabelsWith:(MCDataRecordModel *)dataModel
{
    NSInteger useTime = dataModel.endTime - dataModel.startTime;
    MCChartData *chartData = [self getChartData];
    
    // 各个心率区间所占时间数据
    CGFloat joggingPercent = [chartData getElementPercentAtIndex:0];
    CGFloat efficientReduceFatPercent = [chartData getElementPercentAtIndex:1];
    CGFloat anaerobicExercisePercent = [chartData getElementPercentAtIndex:2];
    
    NSInteger joggingTime = (NSInteger)(useTime * joggingPercent);
    NSInteger efficientReduceFatTime = (NSInteger)(useTime * efficientReduceFatPercent);
    NSInteger anaerobicExerciseTime = (NSInteger)(useTime * anaerobicExercisePercent);
    
    [self.labelsView setLeftLabelContentText:[MCTimeFunc timeStrFromUseTime:joggingTime]];
    [self.labelsView setCenterLabelContentText:[MCTimeFunc timeStrFromUseTime:efficientReduceFatTime]];
    [self.labelsView setRightLabelContentText:[MCTimeFunc timeStrFromUseTime:anaerobicExerciseTime]];
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

- (void)showPercentValue
{
    // 显示百分比标签，必须在视图布局完成之后调用。
    [self.barChart setChartElementVisible:NO percentVisible:YES];
}

- (UIColor *)textColor
{
    UIColor *color = RGB(81, 81, 81);
    return color;
}

#pragma mark - MCHeartRateGraphViewDelegate

- (void)tapHelpFromPoint:(CGPoint)point
{
    CGPoint p = [self convertPoint:point fromView:self.graphView];
    p = CGPointMake(p.x, p.y + 5);
    
    MCPopView *popView = [[[UINib nibWithNibName:@"MCPopView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    CGFloat popViewWidth = 260;
    CGFloat popViewHeight = 200;
    
    CGRect popViewFrame = CGRectMake(CGRectGetWidth(self.frame) - popViewWidth - 10, p.y, popViewWidth, popViewHeight);
    
    CGFloat d = p.x - popViewFrame.origin.x;
    CGPoint atPoint = CGPointMake(popViewWidth * (d / popViewWidth), 0);
    
    [popView setColor:RGB(245, 245, 245)];
    [popView setArrowHeight:10];
    [popView showPopViewWithFrame:popViewFrame fromView:self atPoint:atPoint];
    
    MCContentHelpView *helpView = [[[UINib nibWithNibName:@"MCContentHelpView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    [helpView setupComponents];
    
    CGRect helpViewFrame = CGRectMake(0, 0, popViewWidth - 20, popViewHeight - 32);
    helpView.frame = helpViewFrame;
    
    [popView addContentView:helpView];
}

@end
