//
//  MCGraphData.m
//  MCRun
//
//  Created by moshuqi on 15/11/17.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCGraphData.h"
#import "MCGraphPoint.h"
#import "MCUtilsMacro.h"
#import "MCStatisticsDefine.h"

@interface MCGraphData ()

@property (nonatomic, strong) NSMutableArray *graphData;

// 分3个区域，每个区域的颜色不一致
@property (nonatomic, strong) UIColor *topColor;
@property (nonatomic, strong) UIColor *middleColor;
@property (nonatomic, strong) UIColor *bottomColor;

@end

@implementation MCGraphData

- (id)initWithDataArray:(NSArray *)dataArray
{
    self = [super init];
    if (self)
    {
        [self setGraphDataWithArray:dataArray];
        [self config];
    }
    
    return self;
}

- (void)setGraphDataWithArray:(NSArray *)dataArray
{
    // dataArray为存储dict的数组，每个dict包含心率和时间戳信息。
    
    self.graphData = [NSMutableArray array];
    for (NSDictionary *dict in dataArray)
    {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSInteger heartRate = [[dict valueForKey:MCGraphDataHeartRateKey] integerValue];
            NSInteger timestamp = [[dict valueForKey:MCGraphDataTimestampKey] integerValue];
            
            // 横坐标为时间轴
            MCGraphPoint *graphPoint = [MCGraphPoint new];
            graphPoint.abscissaValue = timestamp;
            graphPoint.ordinateValue = heartRate;
            
            [self.graphData addObject:graphPoint];
        }
    }
}

- (void)config
{
    // 根据数据内容设定各项值
    
    if (([self.graphData count] < 1) || !self.graphData)
    {
        MCLog(@"self.graphData数值有误。");
        return;
    }
    
    // 横坐标为时间戳，纵坐标为心率，心率范围设为60~200，其中140~160为高效燃脂区间
    self.ordinateMin = MCGraphDataOrdinateMin;
    self.ordinateMax = MCGraphDataOrdinateMax;
    
    self.middleSectionMax = MCGraphDataMiddleSectionMax;
    self.middleSectionMin = MCGraphDataMiddleSectionMin;
    
    // 数组中的数据以时间递增的方式存储，固第一个元素为开始时间，最后一个为结束时间
    MCGraphPoint *firstGraphPoint = [self.graphData firstObject];
    self.abscissaMin = firstGraphPoint.abscissaValue;
    
    MCGraphPoint *lastGraphPoint = [self.graphData lastObject];
    self.abscissaMax = lastGraphPoint.abscissaValue;
    
    
}

- (void)setBackgroundWithTopColor:(UIColor *)topColor middleColor:(UIColor *)middleColor bottomColor:(UIColor *)bottomColor
{
    self.topColor = topColor;
    self.middleColor = middleColor;
    self.bottomColor = bottomColor;
}

- (UIColor *)getTopColor
{
    return self.topColor;
}

- (UIColor *)getMiddleColor
{
    return self.middleColor;
}

- (UIColor *)getBottomColor
{
    return self.bottomColor;
}

- (NSInteger)dataCount
{
    return [self.graphData count];
}

- (MCGraphPoint *)graphPointAtIndex:(NSInteger)index
{
    if (index > [self.graphData count])
    {
        MCLog(@"数组访问越界。");
        return nil;
    }
    
    MCGraphPoint *graphPoint = self.graphData[index];
    return graphPoint;
}

@end
