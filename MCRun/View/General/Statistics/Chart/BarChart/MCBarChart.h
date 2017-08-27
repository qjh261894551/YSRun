//
//  MCBarChart.h
//  PieChartDemo
//
//  Created by moshuqi on 15/11/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCChart.h"

@class MCChartData;

@interface MCBarChart : MCChart

- (id)initWithFrame:(CGRect)frame charData:(MCChartData *)chartData;
- (void)setupWithChartData:(MCChartData *)chartData;

@end
